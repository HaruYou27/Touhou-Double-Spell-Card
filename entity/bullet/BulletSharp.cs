using Godot;
using System;
using Godot.Collections;
using System.Collections.Generic;
using System.Threading.Tasks;

public partial class BulletSharp : Node2D
{
	protected class Bullet
	{
		public Vector2 velocity;
		public Transform2D transform;
		public bool grazable;
	}
	[Export] protected Texture2D texture;
	[Export] protected int maxBullet = 727;

	[ExportCategory("Barrel")]
	[Export] private StringName barrelGroup;
	[Export] protected float speed = 227;
	[Export] private bool localRotation;
	protected Node2D[] barrels;

	[ExportCategory("Physics")]
	[Export] private Shape2D hitBox;
	[Export] private bool grazable = true;
	[Export] protected bool collideAreas;
	[Export] protected bool collideBodies = true;
	[Export(PropertyHint.Layers2DPhysics)] private uint collisionMask = 1;
	
	private PhysicsShapeQueryParameters2D query = new();

	private uint collisionGraze;
	protected Rid canvasItem;
	// Avoid garbage collector.
	private Stack<Bullet> bulletPool;
	protected Bullet[] bullets;
	protected int indexTail = 0;

	protected static GlobalBullet globalBullet;
	protected static PhysicsDirectSpaceState2D space;
	protected static SceneTree tree;

	protected const float PIhalf = MathF.PI / 2;
	public override void _Ready()
	{
		canvasItem = GetCanvasItem();
		collisionGraze = collisionMask + 8;
		TopLevel = true;
		// Avoid Bullet get culled.
		RenderingServer.CanvasItemSetCustomRect(canvasItem, true, new Rect2(0, 960, 540, 960));

		Array<Node> nodes = tree.GetNodesInGroup(barrelGroup);
		barrels = new Node2D[nodes.Count];
		int index = 0;
		foreach (Node node in nodes)
		{
			if (node.IsClass("Node2D"))
			{
				barrels[index] = (Node2D) node;
			}
			index++;
		}
		query.Shape = hitBox;
		query.CollideWithAreas = collideAreas;
		query.CollideWithBodies = collideBodies;

		bulletPool = new Stack<Bullet>(maxBullet);
		bullets = new Bullet[maxBullet];
	}
	protected virtual void ResetBullet(Node2D barrel, Bullet bullet)
	{
		bullet.grazable = grazable;
		float angle;
		if (localRotation)
		{
			angle = barrel.Rotation;
		} 
		else 
		{
			angle = barrel.GlobalRotation;
		}
		// Capsule collision shape in Godot is vertical. However, Vector2.RIGHT is the root angle.
		bullet.velocity = new Vector2(speed, 0).Rotated(angle);
		bullet.transform = new Transform2D(angle + PIhalf, Scale, 0, barrel.GlobalPosition);
	}
	// Override to introduce custom bullet type.
	// Call GetBulletPool() to get a bullet.
	protected virtual Bullet CreateBullet()
	{
		return new Bullet();
	}
	protected Bullet GetBulletPool()
	{
		if (bulletPool.Count == 0)
		{
			return CreateBullet();
		}
		else
		{
			return bulletPool.Pop();
		}
	}
	public void SpawnBullet()
	{
		if (indexTail == maxBullet)
		{
			return;
		}

		foreach (Node2D barrel in barrels)
		{
			if (indexTail == maxBullet)
			{
				return;
			}
			if (!barrel.IsVisibleInTree())
			{
				continue;
			}
			Bullet bullet = GetBulletPool();
			
			ResetBullet(barrel, bullet);
			bullets[indexTail] = bullet;
			indexTail++;
		}
	}
	public virtual void SpawnCircle(long count, Vector2 position)
	{
		if (indexTail == maxBullet)
		{
			return;
		}
		Bullet bullet = GetBulletPool();

		bullet.grazable = grazable;
		float deltaRotation = MathF.Tau / count;
		float rotation = 0;
		for (int index = 0; index < count; index++)
		{
			bullet.velocity = new Vector2(speed, 0).Rotated(rotation);
			bullet.transform = new Transform2D(rotation + PIhalf, position);
			rotation += deltaRotation;
			bullets[indexTail] = bullet;
			indexTail++;
		}
	}
	public void Clear()
	{
		if (indexTail == 0)
		{
			return;
		}
		for (int index = 0; index < indexTail; index++)
		{
			Bullet bullet = bullets[index];
			bulletPool.Push(bullet);
		}
		indexTail = 0;
		RenderingServer.CanvasItemClear(canvasItem);
	}
	protected static float GetCollisionMask(Dictionary result)
	{
		return ((Vector2) result["linear_velocity"]).X;
	}
	protected static GodotObject GetCollider(Dictionary result)
	{
		return InstanceFromId((ulong) result["collider_id"]);
	}
	protected virtual bool Collide(Bullet bullet, Dictionary result)
	{
		float mask = GetCollisionMask(result);
		if (mask < -700)
		{
			globalBullet.CallDeferred("SpawnItem", bullet.transform.Origin);
			return false;
		}
		else if (mask < 0)
		{
			return false;
		}
		if (bullet.grazable)
		{
			bullet.grazable = false;
		}
		GetCollider(result).CallDeferred("hit");
		return true;
	}
	protected virtual void Move(Bullet bullet)
	{
		bullet.transform.Origin += bullet.velocity * delta32;
	}
	protected virtual void DrawBullet(Transform2D transform, Color bulletModulate)
	{
		bulletModulate.R = transform.Rotation;
		texture.Draw(canvasItem, transform.Origin.Rotated(-transform.Rotation) / transform.Scale, bulletModulate);
	}
	protected bool tick;
	protected float delta32;
	protected Action[] actions = new Action[3];
	public override void _PhysicsProcess(double delta)
	{
		RenderingServer.CanvasItemClear(canvasItem);
		if (indexTail == 0)
		{
			return;
		}

		delta32 = (float) delta;
		Bullet[] newBullets = new Bullet[maxBullet];
		int newIndex = 0;
		int indexStart = 0;
        tick = !tick;
        int indexHalt;
        if (tick)
        {
            indexHalt = Mathf.RoundToInt(indexTail / 2);
        }
        else
        {
            indexStart = Mathf.RoundToInt(indexTail / 2);
            indexHalt = indexTail;
        }
		void DrawBullets()
		{
        	for (int index = 0; index < indexTail; index++)
			{
				Bullet bullet = bullets[index];
				Move(bullet);
				DrawBullet(bullet.transform, new Color());
			}
		}
		Task draw_task = Task.Factory.StartNew(DrawBullets);
		for (int index = 0; index < indexTail; index++)
		{
			Bullet bullet = bullets[index];
			if (index < indexStart && index >= indexHalt)
			{
				newBullets[newIndex] = bullet;
				newIndex++;
				continue;
			}
			
			query.Transform = bullet.transform;
			if (bullet.grazable)
			{
				query.CollisionMask = collisionGraze;
			}
			else
			{
				query.CollisionMask = collisionMask;
			}
			Dictionary result = space.GetRestInfo(query);
			if (result.Count == 0 || Collide(bullet, result))
			{
				newBullets[newIndex] = bullet;
				newIndex++;
				continue;
			}
			bulletPool.Push(bullet);
		}
		draw_task.Wait();
		bullets = newBullets;
		indexTail = newIndex;
	}
}
