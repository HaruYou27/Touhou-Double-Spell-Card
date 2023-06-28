using Godot;

public partial class RandAlpha : BulletBasic
{
    //Bullet that spawn with a random alpha value (For shader use). 
    protected override void ResetCanvasItem()
    {
		  RenderingServer.CanvasItemSetModulate(bullets[activeIndex].sprite, new Color(1, 1, 1, GD.Randf()));
    }
}
