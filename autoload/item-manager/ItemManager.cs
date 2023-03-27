using Godot;

public partial class ItemManager : BulletBasic
{
    protected Node2D target;
    protected bool tick = false;

    public override void _Ready()
    {
        world = GetWorld2D();
        Global = GetNode("/root/Global");
        itemManager = this;
        texture = GD.Load<Texture2D>("res://autoload/item-manager/point.png");
		Material = GD.Load<ShaderMaterial>("res://autoload/item-manager/random-rotate.material");
        maxBullet = 2727;
        Grazable = false;
		CollisionMask = 9;

        base._Ready();
    }
    public override void SpawnBullet()
    {
        //Prevents crash if for any reason something accidently call this function.
        //Use SpawnItem() instead.
        //The Greatest downfall of inhernitence btw.
    }
    public override void Clear()
    {
        if (activeIndex == 0) { return; }

        for (nint i = 0; i < activeIndex; i++)
        {
            RenderingServer.CanvasItemSetVisible(bullets[i].sprite, false);
        }
        activeIndex = 0;
    }
    public virtual void ConvertBullet(Vector2[] bullets)
    {
        foreach (Vector2 bullet in bullets)
        {
            if (activeIndex == maxBullet) { return; }
            CreateItem(bullet);
        }
    }
    public virtual void SpawnItem(in uint point, Vector2 transform)
    {
        for (uint i = 0; i != point; i++)
        {
            if (activeIndex == maxBullet) { return; }
            CreateItem(transform);
        }
    }
    public virtual void CreateItem(in Vector2 transform)
    {
        Bullet item = bullets[activeIndex];
        float randf = GD.Randf();
        item.transform = new Transform2D(randf * Mathf.Tau, transform);
        item.velocity = new Vector2(randf * 17, 0).Rotated(item.transform.Rotation);

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
        bullets[index].velocity.Y += 27 * delta;
        return base.Move(delta);
    }
    protected override bool Collide(in Godot.Collections.Dictionary result)
    {
        int mask = (int)((Vector2)result["linear_velocity"]).X;
        if (mask == 1) {return false;}
        else
        {
            Global.EmitSignal("item_collect", 904 - bullets[index].transform.Origin.Y);
        }
        return false;
    }
}
