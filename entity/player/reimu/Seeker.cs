using Godot;

public partial class Seeker : BulletBasic
{
	//Bullets that chase nearby target.
	[Export] protected float mass = 10;
	[Export(PropertyHint.Layers2DPhysics)] public uint SeekMask;
	[Export] protected float seekRadius;
	protected readonly PhysicsShapeQueryParameters2D seekQuery = new PhysicsShapeQueryParameters2D();
	private readonly Rid seekShape = PhysicsServer2D.CircleShapeCreate();

	SeekBullet[] seekBullets;
	protected class SeekBullet : Bullet
	{
		public Node2D target;
	}

	public override void _Ready()
	{
		seekQuery.ShapeRid = seekShape;
		PhysicsServer2D.ShapeSetData(seekShape, seekRadius);
		seekQuery.CollideWithAreas = CollideWithAreas;
		seekQuery.CollideWithBodies = CollideWithBodies;
		seekQuery.CollisionMask = SeekMask;

		base._Ready();
	}
	protected override bool Collide(in Godot.Collections.Dictionary result)
	{
		//Return true means the bullet will still alive.
		Bullet bullet = bullets[index];
		if ((int) ((Vector2)result["linear_velocity"]).X == 1)
		{
			//Hit the wall.
			return false;
		}
		else
		{
			GodotObject collider = (GodotObject)GodotObject.InstanceFromId((ulong)result["collider_id"]);
			collider.Call("_hit");
		}
		return false;
	}
	protected override void BulletConstructor()
	{
		seekBullets = new SeekBullet[maxBullet];
		for (nint i = 0; i < maxBullet; i++)
		{
			seekBullets[i] = new SeekBullet();
		}
		bullets = seekBullets;
	}
	public override void _ExitTree()
	{
		base._ExitTree();
		PhysicsServer2D.FreeRid(seekShape);
	}
	protected override Transform2D Move(in float delta)
	{
		SeekBullet bullet = seekBullets[index];
		if (!GodotObject.IsInstanceValid(bullet.target))
		{
			seekQuery.Transform = new Transform2D(0, bullet.transform.Origin);
			Godot.Collections.Dictionary seekResult = world.DirectSpaceState.GetRestInfo(seekQuery);
			if (seekResult.Count != 0)
			{
				bullet.target = (Node2D)GodotObject.InstanceFromId((ulong)seekResult["collider_id"]);
			}
			return base.Move(delta);
		}
		float direction = bullet.transform.Origin.AngleTo(bullet.target.GlobalPosition);
		bullet.velocity = bullet.velocity.Rotated(direction / mass);
		bullet.transform.Origin += bullet.velocity * delta;
		bullet.transform = bullet.transform.Rotated(direction);
		return bullet.transform;
	}
}
