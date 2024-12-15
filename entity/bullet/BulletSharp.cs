using Godot;
using System;
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
	[Export] private int maxBullet = 3000;

	[ExportCategory("Barrel")]
	[Export] private StringName barrelGroup;
	[Export] protected float speed = 525;
	[Export] private bool localRotation;
	protected Node2D[] barrels;

	[ExportCategory("Physics")]
	[Export] private Shape2D hitBox;
	[Export] private bool grazable = true;
	[Export] private bool collideAreas;
	[Export] private bool collideBodies = true;
	[Export(PropertyHint.Layers2DPhysics)] private uint collisionMask = 1;
	private PhysicsShapeQueryParameters2D query = new();

	
	private PhysicsDirectSpaceState2D space;
	private SceneTree tree;
	private uint collisionGraze;
	protected Rid canvasItem;
	// Avoid garbage collector.
	private Stack<Bullet> bulletPool;
	private Bullet[] bullets;
	private nint tailIndex = 0;
	public override void _Ready()
	{
		tree = GetTree();
		space = GetWorld2D().DirectSpaceState;
		canvasItem = GetCanvasItem();
		collisionGraze = collisionMask + 8;
		TopLevel = true;
		// Avoid Bullet get culled.
		RenderingServer.CanvasItemSetCustomRect(canvasItem, true);

		Godot.Collections.Array<Node> nodes = tree.GetNodesInGroup(barrelGroup);
		barrels = new Node2D[nodes.Count];
		nint index = 0;
		foreach (Node node in nodes)
		{
			if (node.IsClass("Node2D"))
			{
				barrels[index] = (Node2D) node;
				index++;
			}
		}
		query.Shape = hitBox;
		query.CollideWithAreas = collideAreas;
		query.CollideWithBodies = collideBodies;

		bulletPool = new Stack<Bullet>(maxBullet);
		bullets = new Bullet[maxBullet];
	}
	protected const float halfPI = MathF.PI / 2;
	protected virtual void ResetBullet(Node2D barrel, Bullet bullet)
	{
		bullet.grazable = grazable;
		float angle = 0;
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
		bullet.transform = new Transform2D(angle + halfPI, Scale, 0, barrel.GlobalPosition);
	}
	protected virtual Bullet CreateBullet()
	{
		return new Bullet();
	}
	public void SpawnBullet()
	{
		if (tailIndex == maxBullet)
		{
			return;
		}

		foreach (Node2D barrel in barrels)
		{
			if (tailIndex == maxBullet)
			{
				return;
			}
			if (!barrel.IsVisibleInTree())
			{
				continue;
			}
			Bullet bullet;
			if (bulletPool.Count == 0)
			{
				bullet = CreateBullet();
			}
			else
			{
				bullet = bulletPool.Pop();
			}
			ResetBullet(barrel, bullet);
			bullets[tailIndex] = bullet;
			tailIndex++;
		}
	}
	public void Clear()
	{
		if (tailIndex == 0)
		{
			return;
		}
		for (nint index = 0; index < tailIndex; index++)
		{
			Bullet bullet = bullets[index];
			bulletPool.Push(bullet);
		}
		tailIndex = 0;
		RenderingServer.CanvasItemClear(canvasItem);
	}
	protected virtual bool Collide(Godot.Collections.Dictionary result, Bullet bullet)
	{
		if (result.Count == 0)
		{
			return true;
		}
		float mask = ((Vector2) result["linear_velocity"]).X;
		if (mask < -700)
		{
			//itemmanager
			return false;
		}
		else if (mask < 0)
		{
			return false;
		}
		Node collider = (Node) InstanceFromId((ulong) result["collider_id"]);
		if (bullet.grazable)
		{
			bullet.grazable = false;
			if (collider.IsMultiplayerAuthority())
			{
				// Bullet Global
			}
			return true;
		}
		collider.CallDeferred("hit");
		return true;
	}
	protected virtual void Move(float delta, Bullet bullet)
	{
		bullet.transform.Origin += bullet.velocity * delta;
	}
	protected virtual void DrawBullet(Bullet bullet, Color bulletModulate)
	{
		float bulletRotation = bullet.transform.Rotation;
		bulletModulate.R = bulletRotation;
		texture.Draw(canvasItem, bullet.transform.Origin.Rotated(-bulletRotation) / bullet.transform.Scale, bulletModulate);
	}
	private bool tick;
	public override void _PhysicsProcess(double delta)
	{
		if (tailIndex == 0)
		{
			return;
		}
		void DrawBullets()
		{
			RenderingServer.CanvasItemClear(canvasItem);
			for (nint index = 0; index < tailIndex; index++)
			{
				DrawBullet(bullets[index], new Color());
			}
		}
		void MoveBullets()
		{
			float delta32 = (float)delta;
			for (nint index = 0; index < tailIndex; index++)
			{
				Move(delta32, bullets[index]);
			}
		}
		nint newIndex = 0;
		Bullet[] newBullets = new Bullet[maxBullet];
		void CollisionCheck()
		{
			nint stopIndex = tailIndex;
			nint index = 0;
			nint indexCopy = 0;
			nint stopCopy;
			
			tick = !tick;
			if (tick)
			{
				index = tailIndex / 2;
				stopIndex = tailIndex;
				stopCopy = index;
				//Console.WriteLine(tailIndex);
			}
			else
			{
				stopIndex = tailIndex / 2;
				stopCopy = tailIndex;
				indexCopy = stopIndex;
			}
			while (indexCopy < stopCopy)
			{
				newBullets[newIndex] = bullets[indexCopy];
				newIndex++;
				indexCopy++;
			}
			while (index < stopIndex)
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
				Godot.Collections.Dictionary result = space.GetRestInfo(query);
				if (Collide(result, bullet))
				{
					newBullets[newIndex] = bullet;
					newIndex++;
					continue;
				}
				bulletPool.Push(bullet);
			}
		}
		Parallel.Invoke(DrawBullets, MoveBullets, CollisionCheck);
		bullets = newBullets;
		tailIndex = newIndex;
	}
}
