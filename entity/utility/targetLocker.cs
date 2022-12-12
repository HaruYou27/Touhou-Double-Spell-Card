using Godot;

public class TargetLocker : Position2D
{
    [Export] public float mass;
    protected Node2D target;

    public override void _Ready()
    {
        target = (Node2D) GetNode("/root/Global").Get("player");
    }
    public override void _PhysicsProcess(float delta)
    {
        var desiredAngle = GlobalPosition.AngleToPoint(target.GlobalPosition);
	    Rotation += (desiredAngle - Rotation) / mass;
    }
}