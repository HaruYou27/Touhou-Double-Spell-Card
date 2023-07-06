using Godot;

public partial class SineSpeed : BulletBasic 
{
	//Bullet that speed up and down by sine wave.
	[Export] float frequency = 1;

	protected SineBullet[] sineBullets;
	protected class SineBullet : Bullet
	{
		public float age;
	}
	protected override void BulletConstructor()
	{
		sineBullets = new SineBullet[maxBullet];
		for (nint i = 0; i < maxBullet; i++)
		{
			bullets[i] = new SineBullet();
		}
		bullets = sineBullets;
	}
	protected override Transform2D Move(in float delta)
	{
		SineBullet bullet = sineBullets[index];
		bullet.age += delta * frequency;
		bullet.velocity = bullet.velocity.Normalized() * speed * Mathf.Abs(Mathf.Sin(bullet.age));
		
		return base.Move(delta);
	}
}
