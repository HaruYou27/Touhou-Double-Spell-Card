using Godot;

public partial class Charger : BulletBasic
{
	//Shoot out fast and slow down over time.
	[Export] public float finalSpeed;
	[Export]
	public float time
	{
		set { acceleration = (finalSpeed - speed) / value; }
		get { return (finalSpeed - speed) / acceleration; }
	}
	protected float acceleration;

	protected override Transform2D Move(in float delta)
		{
			Bullet bullet = bullets[index];
			if (bullet.velocity.Length() <= finalSpeed)
			{
				bullet.velocity = bullet.velocity.LimitLength(bullet.velocity.Length() - acceleration * delta);
			}
			return base.Move(delta);
		}
}
