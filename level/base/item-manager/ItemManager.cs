using Godot;

public partial class ItemManager : BulletBasic
{
	protected Node2D target;
	protected bool tick = false;

	public override void _Ready()
	{
		base._Ready();
		CallDeferred("SetTarget");
	}
	public void SetTarget()
	{
		target = (Node2D) Global.Get("player");
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
			if (activeIndex == maxBullet) {return;}
			CreateItem(new Transform2D(0, bullet));
		}
	}
	public virtual void SpawnItem(in uint point, Transform2D transform)
	{
		for (uint i = 0; i != point; i++)
		{
			if (activeIndex == maxBullet) {return;}
			CreateItem(transform);
		}
	}
	public virtual void CreateItem(Transform2D transform)
	{
		transform.Rotation = GD.Randf() * Mathf.Tau;
		transforms[activeIndex] = transform;
		velocities[activeIndex] = new Vector2(GD.Randf() * 17, 0).Rotated(transform.Rotation);
		grazable[activeIndex] = false;
		
		RID sprite = sprites[activeIndex];
		RenderingServer.CanvasItemSetVisible(sprite, true);
		if (tick)
		{
			//Ensure that 50% of the items will rotate clockwise and vice versa.
			//This is better than rng in my opinion, both in term of performance and visual.
			RenderingServer.CanvasItemSetModulate(sprite, Color.ColorN("white"));
			tick = false;
		}
		else
		{
			RenderingServer.CanvasItemSetModulate(sprite, Color.ColorN("white", (float)0.4));
			tick = true;
		}
		activeIndex++;
	}
	protected override void Move(in double delta)
	{
		if (grazable[index])
		{
			Vector2 localPos = target.ToLocal(transforms[index].origin);
			localPos -= localPos.Normalized() * delta * 72;
			transforms[index].origin = target.ToGlobal(localPos);
			RenderingServer.CanvasItemSetTransform(sprites[index], transforms[index]);
		}
		else
		{
			//Fake gravity acceleratetion.
			//Or fake the player movement.
			//It's just an illusion.
			velocities[index].y += 27 * delta;
			base.Move(delta);
		}
	}
	protected override bool Collide(in Godot.Collections.Dictionary result)
	{
		int mask = (int) ((Vector2)result["linear_velocity"]).x;
		if (mask == 4)
		{
			Global.EmitSignal("item_collect", (int) 904 - transforms[index].origin.y);
		}
		else if (mask == 8) 
		{
			grazable[index] = true;
			return true;
		}
		return false;
	}
}
