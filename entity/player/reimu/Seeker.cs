using Godot;
using Godot.Collections;

public partial class Seeker : BulletSharp
{
	[Export(PropertyHint.Layers2DPhysics)] private uint seekMask = 2;
	[Export] Shape2D seekShape;

	private PhysicsShapeQueryParameters2D seekQuery = new();
	public override void _Ready()
	{
		seekQuery.Shape = seekShape;
		seekQuery.CollideWithAreas = collideAreas;
		seekQuery.CollideWithBodies = collideBodies;
		seekQuery.CollisionMask = seekMask;
		
		base._Ready();
	}
	protected override bool Collide(Bullet bullet, Dictionary result)
	{
		float mask = GetCollisionMask(result);
		if (mask < 0)
		{
			return false;
		}
		GetCollider(result).CallDeferred("hit");

		return false;
	}
    protected override Dictionary CollisionCheck(Bullet bullet)
    {
		seekQuery.Transform = bullet.transform;
		Dictionary result = space.GetRestInfo(seekQuery);
		if (result.Count == 0)
		{
			return base.CollisionCheck(bullet);
		}
		Vector2 target = (Vector2) result["point"];
		bullet.velocity = (target - bullet.transform.Origin).Normalized() * speed;
		bullet.transform = new Transform2D(bullet.velocity.Angle() + PIhalf, bullet.transform.Origin);
		
		return base.CollisionCheck(bullet);
	}
}
