using Godot;

public class ChargeBullet : BulletBasic {
    //Bullet that shoot out fast and slow down over time.
    [Export] public float finalSpeed {
        set {
            deltaV = value - speed;
            absDeltaV = Mathf.Abs(deltaV);
        }
        get {return speed + deltaV;}
    }
    [Export] public float time {
        set {acceleration = deltaV / value;}
        get {return deltaV / acceleration;}
    }
    protected float absDeltaV;
    protected float acceleration;
    private float deltaV;

    protected float[]deltaVs;

    public override void _Ready()
    {
        base._Ready();
        deltaVs = new float[maxBullet];
    }
    protected override void BulletConstructor() {
        deltaVs[activeIndex] = absDeltaV;
    }
    protected override void Overwrite(in uint i) {
        base.Overwrite(i);
        deltaVs[newIndex] = deltaVs[i];
    }
    protected override void Move(in uint i, in float delta) {
        if (deltaVs[i] > 0.0) {
            deltaVs[i] -= Mathf.Abs(acceleration * delta);
            velocities[i] = velocities[i].Normalized() * speed * deltaVs[i] / deltaV;
        }
        base.Move(i, delta);
    }
}
