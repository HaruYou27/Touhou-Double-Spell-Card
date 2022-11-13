using Godot;

public class ItemManager : BulletBasic
{
	protected Node2D target;
	public bool autoCollect;
	public bool keepCollect;

	public override void _Ready()
	{
		Grazable = false;
		query.CollisionLayer = 9;
		texture = GD.Load<Texture>("res://autoload/item/point.png");
		material = GD.Load<ShaderMaterial>("res://autoload/item/random-rotate.material");
		maxBullet = 4727;

		base._Ready();
	}
	public override void SpawnBullet() {}
	public virtual void SpawnItem(in uint point, Transform2D transform)
	{
		bool tick = false;
		for (uint i = 0; i != point; i++)
		{
			if (activeIndex == maxBullet) {return;}

			transform.Rotation = GD.Randf() * Mathf.Tau;
			transforms[activeIndex] = transform;
			velocities[activeIndex] = new Vector2(GD.Randf() * 17, 0).Rotated(transform.Rotation);
			
			RID sprite = sprites[activeIndex];
			VisualServer.CanvasItemSetVisible(sprite, true);
			if (tick)
			{
				VisualServer.CanvasItemSetModulate(sprite, Color.ColorN("white"));
				tick = false;
			}
			else
			{
				VisualServer.CanvasItemSetModulate(sprite, Color.ColorN("white", (float)0.4));
				tick = true;
			}
			activeIndex++;
		}
	}
	protected override void Move(in float delta)
	{
		if (autoCollect)
		{
			velocities[index] = 727 * (target.GlobalPosition - transforms[index].origin).Normalized();
		}
		else
		{
			//Fake gravity acceleratetion.
			velocities[index].y += 27 * delta;
		}
		base.Move(delta);
	}
	protected override bool Collide(in Godot.Collections.Dictionary result)
	{
		if (((Vector2)result["linear_velocity"]).x == 4)
		{
			Global.EmitSignal("collect");
		}
		return false;
	}
    public override void _PhysicsProcess(float delta)
    {
		if (activeIndex == 0)
		{
			//Ensure all remaining items has to be collected before turning autoCollect off.
			autoCollect = keepCollect;
			return;
		}
        base._PhysicsProcess(delta);
    }
}
