using Godot;

public class SineSpeed : BulletBasic 
{
    //Bullet that speed up and down by sine wave.
    [Export] float timeSpeed;
    protected float[] ages;

    protected override void SortBullet()
    {
        ages[index] = ages[activeIndex];
        base.SortBullet();
    }
    protected override void Move(in float delta)
    {
        ages[index] += delta * timeSpeed;
        velocities[index] = velocities[index].Normalized() * speed * Mathf.Abs(Mathf.Sin(ages[index]));
        
        base.Move(delta);
    }
}
