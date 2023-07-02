using Godot;

public partial class ItemManager : BulletBasic
{
	protected bool tick = false;

	public override void _Ready()
	{
		Global = GetNode("/root/Global");
		Global.Set("ItemManager", this);
		itemManager = this;

		base._Ready();
	}
	public void SpawnItem(int point, Vector2 position)
	{
		for (nint i = 0; i < point; i++)
		{
			if (activeIndex == maxBullet) { return; }
			Bullet item = bullets[activeIndex];
			float randf = GD.Randf();
			item.transform = new Transform2D(randf * Mathf.Tau, position);
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
	}
	protected override Transform2D Move(in float delta)
	{
		bullets[index].velocity.Y += 98 * delta;
		return base.Move(delta);
	}
	protected override bool Collide(in Godot.Collections.Dictionary result)
	{
		int mask = (int)((Vector2)result["linear_velocity"]).X;
		if (mask == 1) { return false; }
		else
		{
			Global.EmitSignal("item_collect");
		}
		return false;
	}
	public void ConvertBullet()
	{
		Godot.Collections.Array<Node> bullets = tree.GetNodesInGroup("Enemy Bullet");
		foreach (BulletBasic bullet in bullets)
		{
			Vector2[] positions = bullet.Clear();
			if (positions == null) { continue; }

			foreach (Vector2 pos in positions)
			{
				SpawnItem(1, pos);
			}
		}
	}
}
