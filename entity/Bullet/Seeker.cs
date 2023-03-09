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
	private Rid seekShape = PhysicsServer2D.CircleShapeCreate();

	public override void _Ready() 
	{
		base._Ready();
		seekQuery.ShapeRid = seekShape;
		seekQuery.CollisionMask = mask;
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
	protected override void Move(in double delta) 
	{
		if (targets[index] == null || !GodotObject.IsInstanceValid(targets[index]))
		{
			seekQuery.Transform = transforms[index];
			Godot.Collections.Dictionary seekResult = world.DirectSpaceState.GetRestInfo(seekQuery);
			if (seekResult.Count != 0)
			{
				targets[index] = (Node2D) GodotObject.InstanceFromId( (ulong) seekResult["collider_id"]);
			}
			base.Move(delta);
		}
		else
		{
			Vector2 origin = transforms[index].Origin;
			Vector2 velocity = velocities[index];

			velocities[index] += ((targets[index].GlobalPosition - origin).Normalized() * speed - velocity) / mass;
			transforms[index] = new Transform2D(velocity.Angle() + Mathf.Pi / 2,
												origin + velocity * (float)delta);
			RenderingServer.CanvasItemSetTransform(sprites[index], transforms[index]);
		}
	}
}
