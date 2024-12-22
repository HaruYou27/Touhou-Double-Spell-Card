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
		
		System.Array.Resize(ref actions, 5);
		actions[4] = SeekTarget;
		base._Ready();
	}
	protected override bool Collide(Bullet bullet)
	{
		float mask = GetCollisionMask(bullet.result);
		if (mask < 0)
		{
			return false;
		}
		GetCollider(bullet.result).CallDeferred("hit");

		return false;
	}
	private void SeekTarget()
	{
		nint indexStop;
		nint index = 0;
		
		if (tick)
		{
			indexStop = Mathf.RoundToInt(indexTail / 2);
		}
		else
		{
			index = Mathf.RoundToInt(indexTail / 2);
			indexStop = indexTail;
		}
		while (index < indexStop)
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
			bullet.velocity = (target - bullet.transform.Origin).Normalized() * speed;
			bullet.transform = new Transform2D(bullet.velocity.Angle() + PIhalf, bullet.transform.Origin);
		}
	}
}
