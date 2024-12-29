using Godot;

[GlobalClass]
public partial class AccleratorEase : AccleratorSmooth
{
	[Export] protected float easeCurve = 1;

	protected override float CalulateSpeed(float lifeTime)
	{
		return Mathf.Ease(lifeTime, easeCurve) * acceleration + speed;
	}
}
