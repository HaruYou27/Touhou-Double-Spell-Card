using Godot;

public class Seeker : BulletBasic {
    //Bullets that chase nearby target.
    [Export] protected float mass = 10;
    [Export] protected float seekRadius {
        set {Physics2DServer.ShapeSetData(seekShape, value);}
        get {return (float)Physics2DServer.ShapeGetData(seekShape);}
    }
    [Export] bool seekAreas {
        set {seekQuery.CollideWithAreas = value;}
        get {return seekQuery.CollideWithAreas;}
    }
    [Export] bool seekBodies {
        set {seekQuery.CollideWithBodies = value;}
        get {return seekQuery.CollideWithBodies;}
    }

    protected Node2D[] targets;
    protected Physics2DShapeQueryParameters seekQuery = new Physics2DShapeQueryParameters();
    private RID seekShape = Physics2DServer.CircleShapeCreate();

    public override void _Ready() {
        base._Ready();
        seekQuery.ShapeRid = seekShape;
        seekQuery.CollisionLayer = mask;
        targets = new Node2D[maxBullet];
    }
    protected override void Overwrite(in uint i) {
        base.Overwrite(i);
        targets[newIndex] = targets[i];
    }
    protected override void BulletConstructor() {
        base.BulletConstructor();
        targets[activeIndex] = null;
    }
    public override void _ExitTree() {
        base._ExitTree();
        Physics2DServer.FreeRid(seekShape);
    }
    protected override void Move(in uint i, in float delta) {
        if (targets[i] == null || !Object.IsInstanceValid(targets[i])) {
            seekQuery.Transform = transforms[i];
            Godot.Collections.Dictionary seekResult = world.DirectSpaceState.GetRestInfo(seekQuery);
            if (seekResult.Count != 0) {
                targets[i] = (Node2D)GD.InstanceFromId((ulong) (int)seekResult["collider_id"]);
            }
        } else {
            Vector2 desiredV = (targets[i].GlobalPosition - transforms[i].origin).Normalized() * speed;
            velocities[i] += (desiredV - velocities[i]) / mass;
            transforms[i].Rotation = velocities[i].Angle() + Mathf.Pi / 2;
        }
        base.Move(i, delta);
    }
}