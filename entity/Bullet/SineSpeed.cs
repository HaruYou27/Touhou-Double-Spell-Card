using Godot;

public class SineSpeed : BulletBasic 
{
    //Bullet that speed up and down by sine wave.
    [Export] float timeSpeed;
    protected float[] ages;

    protected override void ArraySort(in uint i)
    {
        ages[i] = ages[activeIndex];
        base.ArraySort(i);
    }
    protected override void Move(in uint i, in float delta)
    {
        ages[i] += delta * timeSpeed;
        velocities[i] = velocities[i].Normalized() * speed * Mathf.Abs(Mathf.Sin(ages[i]));
        
        base.Move(i, delta);
    }
}
