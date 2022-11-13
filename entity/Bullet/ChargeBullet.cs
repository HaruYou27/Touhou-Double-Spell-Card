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
    protected override void ArraySort(in uint i)
    {
        base.ArraySort(i);
        deltaVes[i] = deltaVes[activeIndex];
    }
    protected override void Move(in uint i, in float delta) 
    {
        if (deltaVes[i] > 0.0) {
            deltaVes[i] -= Mathf.Abs(acceleration * delta);
            velocities[i] = velocities[i].Normalized() * speed * deltaVes[i] / deltaV;
        }
        base.Move(i, delta);
    }
}
