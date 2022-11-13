using Godot;

public class RandAlpha : BulletBasic
{
	//Bullet that spawn with a random alpha value (For shader use). 
	protected override void BulletConstructor()
	{
		VisualServer.CanvasItemSetModulate(sprites[activeIndex], new Color(1, 1, 1, GD.Randf()));
	}
}
