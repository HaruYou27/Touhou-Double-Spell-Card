using Godot;

public partial class SineSpeed : BulletBasic 
{
	//Bullet that speed up and down by sine wave.
	[Export] double frequency = 1;
	protected double[] ages;

	protected override void SortBullet()
	{
		ages[index] = ages[lastIndex];
		base.SortBullet();
	}
	protected override void Move(in double delta)
	{
		ages[index] += delta * frequency;
		velocities[index] = velocities[index].Normalized() * speed * (float) Mathf.Abs(Mathf.Sin(ages[index]));
		
		base.Move(delta);
	}
}
