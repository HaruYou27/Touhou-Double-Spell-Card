using Godot;
//Bullet that bounce off wall.
public partial class Ricochet : BulletBasic 
{
	[Export] long ricochet = 1;
	protected RicochetBullet[] ricochetBullets;

	protected class RicochetBullet : Bullet
	{
		public long ricochet;

		public RicochetBullet(in long times)
		{
			ricochet = times;
		}
	}
	protected override void BulletConstructor() 
	{
		ricochetBullets = new RicochetBullet[maxBullet];
		for (nint i = 0; i < maxBullet; i++)
		{
			ricochetBullets[i] = new RicochetBullet(ricochet);
		}
		bullets = ricochetBullets;
	}
	protected override bool Collide(in Godot.Collections.Dictionary result) 
	{
		RicochetBullet bullet = ricochetBullets[index];
		if (bullet.ricochet > 0) {
			bullet.velocity = bullet.velocity.Bounce((Vector2)result["normal"]);
			bullet.transform = new Transform2D(bullet.velocity.Angle() + Mathf.Pi / 2, bullet.transform.Origin);
			bullet.ricochet--;
			return true;
		}
		return base.Collide(result);
	}
}

