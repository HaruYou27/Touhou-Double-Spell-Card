using Godot;

public class ChargeBullet : BulletBasic 
{
	//Bullet that shoot out fast and slow down over time.
	//Or fake friction.
	[Export] public float finalSpeed;
	[Export] public float time 
	{
		set {acceleration = (finalSpeed - speed) / value;}
		get {return (finalSpeed - speed) / acceleration;}
	}
	protected float acceleration;

	protected override void Move(in float delta) 
	{
		Vector2 velocity = velocities[index];
		float length = velocity.Length();
		if (length <= finalSpeed)
		{
			velocities[index] = velocity.LimitLength(length - acceleration * delta);
		}
		base.Move(delta);
	}
}
