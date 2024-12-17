using Godot;
using System;

public partial class AcceleratorSine : BulletSharp
{
    protected class BulletCounter : Bullet
    {
        public float count = 0;
    }
    [Export] protected float duration = 1;

    public override void _Ready()
    {
        Array.Resize(ref actions, 5);
        actions[4] = AccelerateBullets;
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
    protected virtual void Accelerate(BulletCounter bullet)
    {
        bullet.count += delta32 * duration;
        bullet.velocity = bullet.velocity.Normalized() * speed * MathF.Abs(MathF.Sin(bullet.count));
    }
    private void AccelerateBullets()
    {
        for (nint index = 0; index < indexTail; index++)
        {
            Accelerate((BulletCounter) bullets[index]);
            
        }
    }
}
