using Godot;
//The base class of all bullets.
public partial class BulletBasic : Node2D
{
	//Bullet shared properties.
	[Export] public bool dynamicBarrel;
	[Export] public long maxBullet = 127; //Exceed the limit and no more bullet will be shoot out.
	[Export] public float speed = 525;
	[Export] public bool localRotation;
	[Export] public bool Grazable = true;

	//Query properties
	[Export] public Shape2D hitbox;
	[Export] public bool CollideWithAreas = false;
	[Export] public bool CollideWithBodies = true;
	[Export(PropertyHint.Layers2DPhysics)] public uint CollisionMask = 1;
	protected readonly PhysicsShapeQueryParameters2D query = new PhysicsShapeQueryParameters2D();

	//Visual.
	[Export]
	public Texture2D texture;

	protected nint activeIndex = 0; //Current empty index, also bullet count.
	protected nint index;
	protected Node2D[] barrels;
	protected static Node Global;
	protected static ItemManager itemManager;
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
		query.Shape = hitbox;
		query.CollideWithAreas = CollideWithAreas;
		query.CollideWithBodies = CollideWithBodies;
		query.CollisionMask = CollisionMask;

		if (!dynamicBarrel)
		{
			barrels = new Node2D[GetChildCount()];
			GetChildren().CopyTo(barrels, 0);
		}
		BulletConstructor();

		Rect2 texRect = new Rect2(-texture.GetSize() / 2, texture.GetSize());
		Rid textureRid = texture.GetRid();
		Rid canvas = GetWorld2D().Canvas;
		foreach (Bullet bullet in bullets)
		{
			Rid sprite = bullet.sprite;

			RenderingServer.CanvasItemSetVisible(sprite, false);
			RenderingServer.CanvasItemSetDefaultTextureFilter(sprite, RenderingServer.CanvasItemTextureFilter.Nearest);
			RenderingServer.CanvasItemSetZIndex(sprite, ZIndex);
			RenderingServer.CanvasItemSetParent(sprite, canvas);
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
	}
	public virtual void SpawnBullet()
	{
		if (dynamicBarrel)
		{
			barrels = new Node2D[GetChildCount()];
			GetChildren().CopyTo(barrels, 0);
		}
		foreach (Node2D barrel in barrels)
		{
			if (activeIndex == maxBullet) { return; }
			Bullet bullet = bullets[activeIndex];
			RenderingServer.CanvasItemSetVisible(bullet.sprite, true);

			if (localRotation)
			{
				bullet.velocity = new Vector2(speed, 0).Rotated(barrel.Rotation);
				bullet.transform = new Transform2D(barrel.Rotation - Mathf.Pi/2, barrel.GlobalPosition);
			}
			else
			{
				bullet.velocity = new Vector2(speed, 0).Rotated(barrel.GlobalRotation);
				bullet.transform = barrel.GlobalTransform.RotatedLocal(Mathf.Pi/2);
			}
			bullet.grazable = Grazable;

			activeIndex++;
		}
	}
	public virtual void Clear()
	{
		if (activeIndex == 0) { return; }

		for (nint i = 0; i < activeIndex; i++)
		{
			RenderingServer.CanvasItemSetVisible(bullets[i].sprite, false);
		}
		activeIndex = 0;
	}
	protected virtual Transform2D Move(in float delta)
	{
		Bullet bullet = bullets[index];
		bullet.transform.Origin += bullet.velocity * delta;
		return bullet.transform;
	}
	protected virtual bool Collide(in Godot.Collections.Dictionary result)
	{
		//Return true means the bullet will still alive.
		Bullet bullet = bullets[index];
		switch ((int) ((Vector2)result["linear_velocity"]).X)
		{
			case 1:
				//Hit the wall.
				return false;
			case 2:
				//Hit Reimu's Kishin Orb.
				//Turn into an item.
				itemManager.SpawnItem(1, bullet.transform.Origin);
				return false;
		}

		if (bullet.grazable)
		{
			bullet.grazable = false;
			Global.EmitSignal("bullet_graze");
			return true;
		}
		else
		{
			GodotObject collider = (GodotObject)GodotObject.InstanceFromId((ulong)result["collider_id"]);
			collider.Call("_hit");
		}

		return false;
	}
	public override void _PhysicsProcess(double delta)
	{
		if (activeIndex == 0) { return; }
		nint lastIndex = activeIndex - 1;

		float delta32 = (float)delta;
		for (index = lastIndex; index >= 0; index--)
		{
			Bullet bullet = bullets[index];
			//Collision checking.
			query.Transform = Move(delta32);
			RenderingServer.CanvasItemSetTransform(bullet.sprite, query.Transform);
			if (bullet.grazable) { query.CollisionMask = CollisionMask + 8;}
			else { query.CollisionMask = CollisionMask; }

			Godot.Collections.Dictionary result = world.DirectSpaceState.GetRestInfo(query);
			if (result.Count == 0 || Collide(result)) {continue;}

			RenderingServer.CanvasItemSetVisible(bullet.sprite, false);
			if (index == lastIndex) {continue;}
			//Sort from tail to head to minimize array access.
			//Avoid memory leak in Godot server.
			bullets[index] = bullets[lastIndex];
			bullets[lastIndex] = bullet;

			activeIndex--;
			lastIndex--;
		}
	}
}

