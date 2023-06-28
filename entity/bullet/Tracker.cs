using Godot;

public partial class Tracker : BulletBasic
{
    protected Node2D target1;
    protected Node2D target2;
    public override void _Ready()
    {
        base._Ready();
        if (Multiplayer.MultiplayerPeer.IsClass("OfflineMultiplayerPeer"))
        {
            target1 = (Node2D) Global.Get("player1");
            return;
        }
        target2 = (Node2D) Global.Get("player2");
    }
    protected override void ResetBulletTransform(in Node2D barrel)
    {
        Vector2 direction1 = target1.GlobalPosition - barrel.GlobalPosition;
        float rotation;
        if (target2 != null)
        {
            Vector2 direction2 = target2.GlobalPosition - barrel.GlobalPosition;
            if (direction2.Length() < direction1.Length())
            {
                rotation = direction2.Angle();
            }
            else
            {
                rotation = direction1.Angle();
            }
        }
        else
        {
                rotation = direction1.Angle();
        }
        Bullet bullet = bullets[activeIndex];
        bullet.velocity = new Vector2(speed, 0).Rotated(rotation);
		bullet.transform = new Transform2D(rotation - Mathf.Pi/2, bulletScale, 0, barrel.GlobalPosition);
    }
}
