using Godot;

public partial class AccleratorLinear : AcceleratorSine
{
    [Export] protected float speedFinal = 527;

    protected virtual float CalulateSpeed(float lifeTime)
    {
        return Mathf.Lerp(speed, speedFinal, lifeTime / duration);
    }
    protected override void Accelerate(BulletCounter bullet)
    {
        bullet.count += delta32;
        bullet.velocity = new Vector2(CalulateSpeed(bullet.count), 0).Rotated(bullet.transform.Rotation - PIhalf);
    }
}
