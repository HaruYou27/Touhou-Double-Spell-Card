using Godot;

public partial class ItemManager : BulletBasic
{
    protected Node2D target;
    protected bool tick = false;

    public override void _Ready()
    {
        base._Ready();
        target = (Node2D)Global.Get("player");
    }
    public override void SpawnBullet()
    {
        //Prevents crash if for any reason something accidently call this function.
        //Use SpawnItem() instead.
        //The Greatest downfall of inhernitence btw.
    }
    public virtual void ConvertBullet(Vector2[] bullets)
    {
        foreach (Vector2 bullet in bullets)
        {
            if (activeIndex == maxBullet) { return; }
            CreateItem(new Transform2D(0, bullet));
        }
    }
    public virtual void SpawnItem(in uint point, Transform2D transform)
    {
        for (uint i = 0; i != point; i++)
        {
            if (activeIndex == maxBullet) { return; }
            CreateItem(transform);
        }
    }
    public virtual void CreateItem(in Transform2D transform)
    {
		Bullet item = bullets[activeIndex];
        item.transform = transform.Rotated(GD.Randf() * Mathf.Tau);
        item.velocity = new Vector2(GD.Randf() * 17, 0).Rotated(transform.Rotation);
        item.grazable = false;

        RenderingServer.CanvasItemSetVisible(item.sprite, true);
        if (tick)
        {
            //Ensure that 50% of the items will rotate clockwise and vice versa.
            //This is better than rng in my opinion, both in term of performance and visual.
            RenderingServer.CanvasItemSetModulate(item.sprite, new Color(1, 1, 1, 1));
            tick = false;
        }
        else
        {
            RenderingServer.CanvasItemSetModulate(item.sprite, new Color(1, 1, 1, (float)0.4));
            tick = true;
        }
        activeIndex++;
    }
    protected override Transform2D Move(in float delta)
    {
        Bullet item = bullets[index];
        if (item.grazable)
        {
            Vector2 localPos = target.ToLocal(item.transform.Origin);
            localPos -= localPos.Normalized() * (float)delta * 72;
            item.transform.Origin = target.ToGlobal(localPos);
            RenderingServer.CanvasItemSetTransform(item.sprite, item.transform);
        }
        //Fake gravity acceleratetion.
        //Or fake the player movement.
        //It's just an illusion.
        item.velocity.Y += 27 * delta;
        return base.Move(delta);
    }
    protected override bool Collide(in Godot.Collections.Dictionary result)
    {
		Bullet item = bullets[index];
        int mask = (int)((Vector2)result["linear_velocity"]).X;
        if (mask == 4)
        {
            Global.EmitSignal("item_collect", (int)904 - item.transform.Origin.Y);
        }
        else if (mask == 8)
        {
            item.grazable = true;
            return true;
        }
        return false;
    }
}
