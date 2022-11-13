using Godot;

public class ChargeBullet : BulletBasic 
{
    //Bullet that shoot out fast and slow down over time.
    [Export] public float finalSpeed 
    {
        set {
            deltaV = value - speed;
            absDeltaV = Mathf.Abs(deltaV);
        }
        get {return speed + deltaV;}
    }
    [Export] public float time 
    {
        set {acceleration = deltaV / value;}
        get {return deltaV / acceleration;}
    }
    protected float absDeltaV;
    protected float acceleration;
    private float deltaV;

    protected float[]deltaVes;

    public override void _Ready()
    {
        base._Ready();
        deltaVes = new float[maxBullet];
    }
    protected override void BulletConstructor() 
    {
        deltaVes[activeIndex] = absDeltaV;
    }
    protected override void SortBullet()
    {
        base.SortBullet();
        deltaVes[index] = deltaVes[activeIndex];
    }
    protected override void Move(in float delta) 
    {
        if (deltaVes[index] > 0.0) {
            deltaVes[index] -= Mathf.Abs(acceleration * delta);
            velocities[index] = velocities[index].Normalized() * speed * deltaVes[index] / deltaV;
        }
        base.Move(delta);
    }
}
