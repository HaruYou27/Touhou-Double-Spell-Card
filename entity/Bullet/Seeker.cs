using Godot;

public partial class Seeker : BulletBasic
{
	//Bullets that chase nearby target.
	[Export] protected float mass = 10;
	[Export]
	protected float seekRadius
	{
		set { PhysicsServer2D.ShapeSetData(seekShape, value); }
		get { return (float)PhysicsServer2D.ShapeGetData(seekShape); }
	}
	[Export]
	bool seekAreas
	{
		set { seekQuery.CollideWithAreas = value; }
		get { return seekQuery.CollideWithAreas; }
	}
	[Export]
	bool seekBodies
	{
		set { seekQuery.CollideWithBodies = value; }
		get { return seekQuery.CollideWithBodies; }
	}

	protected PhysicsShapeQueryParameters2D seekQuery = new PhysicsShapeQueryParameters2D();
	private Rid seekShape = PhysicsServer2D.CircleShapeCreate();

	SeekBullet[] seekBullets;
	protected class SeekBullet : Bullet
	{
		public Node2D target;
	}

	public override void _Ready()
	{
		base._Ready();
		seekQuery.ShapeRid = seekShape;
		seekQuery.CollisionMask = mask;
	}
	protected override void BulletConstructor()
	{
		seekBullets = new SeekBullet[maxBullet];
		for (nint i = 0; i < maxBullet; i++)
		{
			bullets[i] = new SeekBullet();
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
		if (bullet.target == null || !GodotObject.IsInstanceValid(bullet.target))
		{
			seekQuery.Transform = bullet.transform;
			Godot.Collections.Dictionary seekResult = world.DirectSpaceState.GetRestInfo(seekQuery);
			if (seekResult.Count != 0)
			{
				bullet.target = (Node2D)GodotObject.InstanceFromId((ulong)seekResult["collider_id"]);
			}
			return base.Move(delta);
		}
		bullet.velocity += ((bullet.target.GlobalPosition - bullet.transform.Origin).Normalized() * speed - bullet.velocity) / mass;
		bullet.transform = new Transform2D(bullet.velocity.Angle() + Mathf.Pi / 2,
										   bullet.transform.Origin + bullet.velocity * delta);
		RenderingServer.CanvasItemSetTransform(bullet.sprite, bullet.transform);
		return bullet.transform;
	}
}
