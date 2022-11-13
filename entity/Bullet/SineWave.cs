using Godot;
public class SineWave : BulletBasic {
    //Bullet that offset y coord by sine wave.
    [Export] float amplitude = 5;
    [Export] float frequency = 5;

    protected override void Move(in uint i, in float delta)
    {
        transforms[i].Rotation = delta * frequency;
        //Offset bullet local y position to create wave-like effect.
        transforms[i].origin.y += Mathf.Sin(transforms[i].Rotation) * amplitude;
        base.Move(i, delta);
    }
    protected override void BulletConstructor()
    {
        transforms[activeIndex].Rotation = 0;
    }
}
