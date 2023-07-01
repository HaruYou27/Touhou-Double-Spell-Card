using Godot;

public partial class SineAlpha : BulletBasic 
{
	//Bullet that change it's alpha value by sine wave (For shader use).
	protected override void ResetCanvasItem()
	{
		base.ResetCanvasItem();
		RenderingServer.CanvasItemSetModulate(bullets[activeIndex].sprite, new Color(1, 1, 1, Mathf.Abs(Mathf.Sin(Time.GetTicksMsec()))));
	}
}
