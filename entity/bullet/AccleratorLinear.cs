using Godot;

[GlobalClass]
public partial class AccleratorLinear : AcceleratorSine
{
	[Export] protected float speedFinal = 527;

	protected virtual float CalulateSpeed(float lifeTime)
	{
		return Mathf.Lerp(speed, speedFinal, lifeTime / duration);
	}
	    protected override void Move(Bullet bullet)
    {
		BulletCounter bulletCounter = (BulletCounter) bullet;
		bulletCounter.count += delta32;
		bullet.velocity = new Vector2(CalulateSpeed(bulletCounter.count), 0).Rotated(bullet.transform.Rotation - PIhalf);
        base.Move(bullet);
    }
}
