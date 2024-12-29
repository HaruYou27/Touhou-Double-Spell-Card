using Godot;

[GlobalClass]
public partial class AccleratorSmooth : AccleratorLinear
{
	protected float acceleration;
	public override void _Ready()
	{
		acceleration = speedFinal - speed;
		base._Ready();
	}
	protected override float CalulateSpeed(float lifeTime)
	{
		return Mathf.SmoothStep(0, duration, lifeTime) * acceleration + speed;
	}
}
