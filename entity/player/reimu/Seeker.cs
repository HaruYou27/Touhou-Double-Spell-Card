using Godot;
using Godot.Collections;

public partial class Seeker : BulletSharp
{
    [Export(PropertyHint.Layers2DPhysics)] private uint seekMask = 2;
    [Export] Shape2D seekShape;
    [Export] float turnSpeed = 7272;

    private PhysicsShapeQueryParameters2D seekQuery = new();
    public override void _Ready()
    {
        seekQuery.Shape = seekShape;
        seekQuery.CollideWithAreas = collideAreas;
        seekQuery.CollideWithBodies = collideBodies;
        seekQuery.CollisionMask = seekMask;
        
        System.Array.Resize(ref actions, 5);
        actions[4] = SeekTarget;
        base._Ready();
    }
    protected override bool Collide(Dictionary result, Bullet bullet)
    {
        float mask = GetCollisionMask(result);
        if (mask < 0)
        {
            return false;
        }
        GetCollider(result).CallDeferred("hit");

        return false;
    }
    private void SeekTarget()
    {
        nint indexHalt;
		nint index = 0;
		
		if (tick)
		{
			index = indexTail / 2;
			indexHalt = indexTail;
		}
		else
		{
			indexHalt = indexTail / 2;
		}
		while (index < indexHalt)
		{
            Bullet bullet = bullets[index];
            index++;
            seekQuery.Transform = bullet.transform;
            Dictionary result = space.GetRestInfo(seekQuery);
            if (result.Count == 0)
            {
                continue;
            }
            Vector2 target = (Vector2) result["point"];
            bullet.velocity += (target - bullet.transform.Origin).Normalized() * turnSpeed * delta32;
            bullet.velocity = bullet.velocity.Normalized() * speed;
            bullet.transform = new Transform2D(bullet.velocity.Angle() + halfPI, bullet.transform.Origin);
	    }
    }
}
