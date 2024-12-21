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
	protected nint indexTail = 0;

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
		nint index = 0;
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

		actions[0] = DrawBullets;
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
		for (nint index = 0; index < count; index++)
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
		for (nint index = 0; index < indexTail; index++)
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
	protected virtual bool Collide(Dictionary result, Bullet bullet)
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
	protected Action[] actions = new Action[4];
	private void DrawBullets()
	{
		RenderingServer.CanvasItemClear(canvasItem);
		for (nint index = 0; index < indexTail; index++)
		{
			DrawBullet(bullets[index].transform, new Color());
		}
	}
	public override void _PhysicsProcess(double delta)
	{
		if (indexTail == 0)
		{
			return;
		}

		void MoveBullets()
		{
			delta32 = (float) delta;
			for (nint index = 0; index < indexTail; index++)
			{
				Move(bullets[index]);
			}
		}

		Bullet[] newBullets = new Bullet[maxBullet];
		tick = !tick;
		nint indexHalf = Mathf.RoundToInt(indexTail / 2);
		nint newIndex = indexHalf;
		void CollisionCheck()
		{
			nint indexStop;
			nint index = 0;
			
			if (tick)
			{
				index = indexHalf;
				indexStop = indexTail;
			}
			else
			{
				indexStop = indexHalf;
			}
			while (index < indexStop)
			{
				Bullet bullet = bullets[index];
				index++;
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
				if (result.Count == 0 || Collide(result, bullet))
				{
					newBullets[newIndex] = bullet;
					newIndex++;
					continue;
				}
				bulletPool.Push(bullet);
			}
		}
		void CopyBullet()
		{
			nint index = 0;
			nint indexStop;
			nint newI = 0;
			if (tick)
			{
				indexStop = indexHalf;
				//Console.WriteLine(indexTail);
			}
			else
			{
				index = indexHalf;
				indexStop = indexTail;
			}
			while (index < indexStop)
			{
				newBullets[newI] = bullets[index];
				newI++;
				index++;
			}
		}
		actions[1] = MoveBullets;
		actions[2] = CopyBullet;
		actions[3] = CollisionCheck;
		Parallel.Invoke(actions);
		bullets = newBullets;
		indexTail = newIndex;
	}
}
