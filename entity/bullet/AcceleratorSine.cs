using Godot;
using System;

[GlobalClass]
public partial class AcceleratorSine : BulletSharp
{
	protected class BulletCounter : Bullet
	{
		public float count = 0;
	}
	[Export] protected float duration = 1;

	public override void _Ready()
	{
		base._Ready();
	}
	protected override Bullet CreateBullet()
	{
		return new BulletCounter();
	}
	protected override void ResetBullet(Node2D barrel, Bullet bullet)
	{
		BulletCounter bulletCounter = (BulletCounter) bullet;
		bulletCounter.count = 0;
		base.ResetBullet(barrel, bullet);
	}
    protected override void Move(Bullet bullet)
    {
		BulletCounter bulletCounter = (BulletCounter) bullet;
		bulletCounter.count += delta32 * duration;
		bullet.velocity = bullet.velocity.Normalized() * speed * MathF.Abs(MathF.Sin(bulletCounter.count));
        base.Move(bullet);
    }
}
