using Godot;
//The base class of all bullets.
public partial class BulletBasic : Node2D
{
	//Shared properties.
	//Physics.
	[Export] public long maxBullet = 127; //Exceed the limit and no more bullet will be shoot out.
	[Export] public float speed;
	[Export] public bool localRotation = true;
	[Export]
	public Vector2 shapeSize
	{
		set
		{
			shapesize = value;
			CreateCollisionShape(value);
		}
		get { return shapesize; }
	}
	[Export]
	public bool CollideWithAreas
	{
		set { query.CollideWithAreas = value; }
		get { return query.CollideWithAreas; }
	}
	[Export]
	public bool CollideWithBodies
	{
		set { query.CollideWithBodies = value; }
		get { return query.CollideWithBodies; }
	}
	[Export(PropertyHint.Layers2DPhysics)]
	public uint CollisionMask
	{
		set
		{
			query.CollisionMask = value;
			mask = value;
		}
		get { return mask; }
	}
	[Export] public bool Grazable = true;
	protected readonly PhysicsShapeQueryParameters2D query = new PhysicsShapeQueryParameters2D();
	protected Rid hitbox;
	private Vector2 shapesize;
	protected uint mask = 1;

	//Visual.
	private void CreateCollisionShape(in Vector2 size)
	{
		if (hitbox != null)
		{
			PhysicsServer2D.FreeRid(hitbox);
		}
		if (size.X == size.Y)
		{
			hitbox = PhysicsServer2D.CircleShapeCreate();
			PhysicsServer2D.ShapeSetData(hitbox, size.X / 2);
		}
		else
		{
			hitbox = PhysicsServer2D.CapsuleShapeCreate();
			PhysicsServer2D.ShapeSetData(hitbox, new Vector2(size.X / 2, size.Y - size.X));
		}
		query.ShapeRid = hitbox;
	}
	[Export]
	public Texture2D texture
	{
		set
		{
			tex = value;
			textureRid = value.GetRid();
			textureSize = value.GetSize();
			if (shapeSize.X == 0.0)
			{
				CreateCollisionShape(textureSize - new Vector2(4, 4));
			}
		}
		get { return tex; }
	}
	private Texture2D tex;
	protected Vector2 textureSize;
	protected Rid textureRid;

	protected nint activeIndex = 0; //Current empty index, also bullet count.
	protected nint lastIndex; //Last bullet index.
	protected nint index;
	protected Node2D[] barrels;
	protected static Node Global;
	protected static World2D world;

	protected Bullet[] bullets;
	protected class Bullet
	{
		public Transform2D transform;
		public bool grazable;
		public Vector2 velocity;
		public readonly Rid sprite = RenderingServer.CanvasItemCreate();
	}

	protected virtual void BulletConstructor()
	{
		bullets = new Bullet[maxBullet];
		for (nint i = 0; i < maxBullet; i++)
		{
			bullets[i] = new Bullet();
		}
	}
	public override void _Ready()
	{
		world = GetWorld2D();
		Global = GetNode("/root/Global");
		Global.Connect("bomb_impact", new Callable(this, "Clear"));

		Godot.Collections.Array<Node> Barrels = GetChildren();
		for (int i = 0; i < Barrels.Count; i++)
		{
			if (!(Barrels[i] is Node2D))
			{
				Barrels.RemoveAt(i);
			}
		}
		barrels = new Node2D[Barrels.Count];
		Barrels.CopyTo(barrels, 0);
		BulletConstructor();

		Rect2 texRect = new Rect2(-textureSize / 2, textureSize);
		foreach (Bullet bullet in bullets)
		{
			Rid sprite = bullet.sprite;

			RenderingServer.CanvasItemSetVisible(sprite, false);
			RenderingServer.CanvasItemSetZIndex(sprite, ZIndex);
			RenderingServer.CanvasItemSetParent(sprite, world.Canvas);
			RenderingServer.CanvasItemSetLightMask(sprite, 0);
			RenderingServer.CanvasItemAddTextureRect(sprite, texRect, textureRid);
			if (Material != null)
			{
				RenderingServer.CanvasItemSetMaterial(sprite, Material.GetRid());
			}
		}
	}
	public override void _ExitTree()
	{
		//Rid is actually an memory address to get the object in Godot server.
		//Since these CanvasItem are created directly using RenderingServer (not reference counted),
		//it must be freed manually.
		foreach (Bullet bullet in bullets)
		{
			RenderingServer.FreeRid(bullet.sprite);
		}
		PhysicsServer2D.FreeRid(hitbox);
	}
	public virtual void SpawnBullet()
	{
		foreach (Node2D barrel in barrels)
		{
			if (activeIndex == maxBullet) { return; }
			Bullet bullet = bullets[activeIndex];
			RenderingServer.CanvasItemSetVisible(bullet.sprite, true);

			if (localRotation)
			{
				bullet.velocity = new Vector2(speed, 0).Rotated(barrel.Rotation);
			}
			else
			{
				bullet.velocity = new Vector2(speed, 0).Rotated(barrel.GlobalRotation);
			}
			bullet.transform = barrel.GlobalTransform.Rotated(Mathf.Pi / 2);
			bullet.grazable = Grazable;

			activeIndex++;
		}
	}
	public virtual void Clear()
	{
		if (activeIndex == 0) { return; }

		Vector2[] positions = new Vector2[maxBullet];
		for (nint i = 0; i < activeIndex; i++)
		{
			Bullet bullet = bullets[i];
			RenderingServer.CanvasItemSetVisible(bullet.sprite, false);
			positions[i] = bullet.transform.Origin;
		}
		activeIndex = 0;
		((ItemManager)Global.Get("leveler.item_manager")).ConvertBullet(positions);
	}
	protected virtual Transform2D Move(in float delta)
	{
		Bullet bullet = bullets[index];
		bullet.transform.Origin += bullet.velocity * delta;
		RenderingServer.CanvasItemSetTransform(bullet.sprite, bullet.transform);
		return bullet.transform;
	}
	protected virtual bool Collide(in Godot.Collections.Dictionary result)
	{
		//Return true means the bullet will still alive.
		if (((Vector2)result["linear_velocity"]).X == 1.0) { return false; }

		if (query.CollisionMask == mask)
		{
			GodotObject collider = (GodotObject)GodotObject.InstanceFromId((ulong)result["collider_id"]);
			collider.Call("_hit");
		}
		else
		{
			bullets[index].grazable = false;
			Global.EmitSignal("bullet_graze");
			return true;
		}

		return false;
	}
	public override void _PhysicsProcess(double delta)
	{
		if (activeIndex == 0) { return; }
		lastIndex = activeIndex - 1;

		float delta32 = (float)delta;
		for (index = lastIndex; index >= 0; index--)
		{
			Bullet bullet = bullets[index];
			//Collision checking.
			query.Transform = Move(delta32);
			if (bullet.grazable) { query.CollisionMask = mask + 8; }
			else { query.CollisionMask = mask; }

			Godot.Collections.Dictionary result = world.DirectSpaceState.GetRestInfo(query);
			if (result.Count == 0 || Collide(result)) { continue; }

			RenderingServer.CanvasItemSetVisible(bullet.sprite, false);
			if (index == lastIndex) { continue; }
			//Sort from tail to head to minimize array access.
			//Avoid memory leak in Godot server.
			bullets[index] = bullets[lastIndex];
			bullets[lastIndex] = bullet;

			activeIndex--;
			lastIndex--;
		}
	}
}
