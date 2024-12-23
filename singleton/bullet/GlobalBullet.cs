using Godot;
using Godot.Collections;
using System;

public partial class GlobalBullet : BulletSharp
{
	[Export] private float gravity = 98;
	[Export] private float speedAngular = MathF.PI;

	public override void _Ready()
	{
		space = GetWorld2D().DirectSpaceState;
		globalBullet = this;
		tree = GetTree();
		base._Ready();
	}
	private void CreateItem(float random, Vector2 position)
	{
		Bullet item = GetBulletPool();
		float rotation = MathF.Tau * random;
		item.velocity = new Vector2(speed * random, 0).Rotated(rotation);
		item.transform = new Transform2D(rotation, position);
	
		bullets[indexTail] = item;
		indexTail++;
	}
	// For optimization.
	public void SpawnItem(Vector2 position)
	{
		if (indexTail == maxBullet)
		{
			return;
		}
		//Console.WriteLine(indexTail);
		CreateItem(MathF.Sin(position.X * position.Y), position);
	}
	public void SpawnItems(long count, Vector2 position)
	{
		if (indexTail == maxBullet)
		{
			return;
		}
		//Console.WriteLine(indexTail);
		for (long index = 1; index <= count; index++)
		{
			if (indexTail == maxBullet)
			{
				return;
			}
			CreateItem(MathF.Sin(position.X * position.Y * index), position);
		}
	}
	protected override void Move(Bullet item)
	{
		item.velocity.Y += gravity * delta32;
		item.transform = item.transform.RotatedLocal(speedAngular * delta32);
		base.Move(item);
	}
	protected override bool Collide(Bullet bullet, Dictionary result)
	{
		float mask = GetCollisionMask(bullet.result);
		if (mask < 10)
		{
			return false;
		}
		GetCollider(bullet.result).CallDeferred("item_collect");
		return false;
	}
}
