using Godot;

public class SineSpeed : BulletBasic 
{
	//Bullet that speed up and down by sine wave.
	[Export] float frequency;
	protected float[] ages;

	protected override void SortBullet()
	{
		ages[index] = ages[lastIndex];
		base.SortBullet();
	}
	protected override void Move(in float delta)
	{
		ages[index] += delta * frequency;
		velocities[index] = velocities[index].Normalized() * speed * Mathf.Abs(Mathf.Sin(ages[index]));
		
		base.Move(delta);
	}
}
