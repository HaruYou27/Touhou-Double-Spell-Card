using Godot;

public partial class Seeker : BulletBasic 
{
	//Bullets that chase nearby target.
	[Export] protected float mass = 10;
	[Export] protected float seekRadius 
	{
		set {PhysicsServer2D.ShapeSetData(seekShape, value);}
		get {return (float)PhysicsServer2D.ShapeGetData(seekShape);}
	}
	[Export] bool seekAreas 
	{
		set {seekQuery.CollideWithAreas = value;}
		get {return seekQuery.CollideWithAreas;}
	}
	[Export] bool seekBodies 
	{
		set {seekQuery.CollideWithBodies = value;}
		get {return seekQuery.CollideWithBodies;}
	}

	protected Node2D[] targets;
	protected PhysicsShapeQueryParameters2D seekQuery = new PhysicsShapeQueryParameters2D();
	private RID seekShape = PhysicsServer2D.CircleShapeCreate();

	public override void _Ready() 
	{
		base._Ready();
		seekQuery.ShapeRid = seekShape;
		seekQuery.CollisionLayer = mask;
		targets = new Node2D[maxBullet];
	}
	protected override void SortBullet()
	{
		targets[index] = targets[lastIndex];
		base.SortBullet();
	}
	protected override void BulletConstructor() 
	{
		targets[activeIndex] = null;
	}
	public override void _ExitTree() 
	{
		base._ExitTree();
		PhysicsServer2D.FreeRid(seekShape);
	}
	protected override void Move(in float delta) 
	{
		if (targets[index] == null || !Object.IsInstanceValid(targets[index]))
		{
			seekQuery.Transform3D = transforms[index];
			Godot.Collections.Dictionary seekResult = world.DirectSpaceState.GetRestInfo(seekQuery);
			if (seekResult.Count != 0)
			{
				targets[index] = (Node2D)GD.InstanceFromId((ulong) (int)seekResult["collider_id"]);
			}
		}
		else
		{
			Vector2 desiredV = (targets[index].GlobalPosition - transforms[index].origin).Normalized() * speed;
			velocities[index] += (desiredV - velocities[index]) / mass;
			transforms[index].Rotation = velocities[index].Angle() + Mathf.Pi / 2;
		}
		base.Move(delta);
	}
}
