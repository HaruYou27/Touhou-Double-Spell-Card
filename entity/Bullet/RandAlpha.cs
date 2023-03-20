using Godot;

public partial class RandAlpha : BulletBasic
{
    //Bullet that spawn with a random alpha value (For shader use). 
    public override void SpawnBullet()
    {
        base.SpawnBullet();
		RenderingServer.CanvasItemSetModulate(bullets[activeIndex-1].sprite, new Color(1, 1, 1, GD.Randf()));
    }
}
