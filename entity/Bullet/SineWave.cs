using Godot;
public partial class SineWave : BulletBasic {
    //Bullet that offset y coord by sine wave.
    [Export] float amplitude = 5;
    [Export] float frequency = 5;

    protected override void Move(in float delta)
    {
        transforms[index].Rotation = delta * frequency;
        //Offset bullet local y position to create wave-like effect.
        transforms[index].origin.y += Mathf.Sin(transforms[index].Rotation) * amplitude;
        base.Move(delta);
    }
    protected override void BulletConstructor()
    {
        transforms[activeIndex].Rotation = 0;
    }
}
