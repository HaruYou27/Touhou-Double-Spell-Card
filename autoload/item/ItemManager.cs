using Godot;
using System.Collections.Generic;

public class ItemManager : Node {
	private struct Item {
		public Transform2D transform;
		public Vector2 velocity;
		public readonly RID sprite;
		public Item(in Vector2 position, in RID canvas) {
			transform = new Transform2D(GD.Randf() * Mathf.Tau, position);
			sprite = canvas;
			velocity = new Vector2(GD.Randf() * 17, 0).Rotated(GD.Randf() * Mathf.Tau);
		}
	}
	private Item[] items = new Item[maxItem];
	protected Physics2DShapeQueryParameters query = new Physics2DShapeQueryParameters();
	private RID hitbox = Physics2DServer.CircleShapeCreate();
	protected const int maxItem = 4727;
	protected uint index;

	private Texture texture = GD.Load<Texture>("res://autoload/item/point.png");
	private ShaderMaterial forward = GD.Load<ShaderMaterial>("res://autoload/item/forward.material");
	private ShaderMaterial backward = GD.Load<ShaderMaterial>("res://autoload/item/forward.material");
	protected Stack<RID> sprites = new Stack<RID>(maxItem);

	protected World2D world;
	protected Node Global;
	protected Node2D target;
	protected bool autoCollect;

	public override void _Ready() {
		query.ShapeRid = hitbox;

		RID texRID = texture.GetRid();
		Vector2 texSize = texture.GetSize();
		Physics2DServer.ShapeSetData(hitbox, texSize.x);
		Rect2 texRect = new Rect2(-texSize / 2, texSize);
		RID forwardRID = forward.GetRid();
		RID backwardRID = backward.GetRid();

		world = GetViewport().World2d;
		Global = GetNode("/root/Global");
		RID canvas = world.Canvas;

		for (int i = 0; i != maxItem; i++) {
			RID sprite = VisualServer.CanvasItemCreate();
			VisualServer.CanvasItemSetParent(sprite, canvas);
			VisualServer.CanvasItemAddTextureRect(sprite, texRect, texRID, false, null, false, texRID);
			VisualServer.CanvasItemSetZIndex(sprite, 100);
			VisualServer.CanvasItemSetLightMask(sprite, 0);
			if (GD.Randf() >= 0.5) {VisualServer.CanvasItemSetMaterial(sprite, forwardRID);}
			else {VisualServer.CanvasItemSetMaterial(sprite, backwardRID);}

			VisualServer.CanvasItemSetVisible(sprite, false);
			sprites.Push(sprite);
		}
	}
	public virtual void SpawnItem(in Vector2 position, int itemCount) {
		Item item;
		for (int i = 0; i != itemCount; i++) {
			RID sprite = sprites.Pop();
			VisualServer.CanvasItemSetVisible(sprite, true);
			item = new Item(position, sprite);
			items[index] = item;
			index++;
		}			
	}
	public virtual void Flush() {
		for (uint i = 0; i != index; i++) {
			RID sprite = items[i].sprite;
			VisualServer.CanvasItemSetVisible(sprite, false);
			sprites.Push(sprite);
		}
		index = 0;
	}
	public override void _PhysicsProcess(float delta) {
		if (index == 0) {
			autoCollect = false;
			return;
		}
		uint newIndex = 0;

		for (uint i = 0; i != index; i++) {
			Item item = items[i];
			if (autoCollect) {
				query.CollisionLayer = 5;
				item.velocity = 727 * (target.GlobalPosition - item.transform.origin).Normalized();
			} else {
				query.CollisionLayer = 9;
				item.velocity.y += 27 * delta;
			}
			item.transform.origin += item.velocity * delta;
			
			VisualServer.CanvasItemSetTransform(item.sprite, item.transform);

			//Collision check.
			query.Transform = item.transform;
			Godot.Collections.Dictionary result = world.DirectSpaceState.GetRestInfo(query);
			if (result.Count == 0) {
				items[newIndex] = item;
				newIndex++;
				continue;
			}
			else if (((Vector2)result["linear_velocity"]).x == 4) {Global.EmitSignal("collect");}
			sprites.Push(item.sprite);
			VisualServer.CanvasItemSetVisible(item.sprite, false);
		}
		index = newIndex;
	}
}
