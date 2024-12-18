using Godot;
using Godot.Collections;

public partial class Ricochetor : BulletSharp
{
    protected class BulletBool : Bullet
    {
        public bool count;
    }
    protected override Bullet CreateBullet()
    {
        return new BulletBool();
    }
    protected override bool Collide(Dictionary result, Bullet bullet)
    {
        BulletBool richochet = (BulletBool) bullet;
        if (richochet.count)
        {
            float mask = GetCollisionMask(result);
            if (mask > -10 && mask < 0)
            {
                richochet.velocity = richochet.velocity.Bounce((Vector2) result["normal"]);
                richochet.transform = new Transform2D(richochet.velocity.Angle() + PIhalf, bullet.transform.Origin);
                richochet.count = false;
                return true;
            }
        }
        return base.Collide(result, bullet);
    }
}
