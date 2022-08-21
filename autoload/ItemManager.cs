using Godot;

public class ItemManager : BulletBatched
{
	protected struct Item {
		public Transform2D transform;
		public readonly int point;
		public Vector2 velocity;
		public Item(in Transform2D trans, in Vector2 gravity, in int p) {
			transform = trans;
			point = p;
			velocity = gravity;
		}
	}
	[Export] public new float speed {
		set {
			gravity = new Vector2(0, value);
		} get {
			return gravity.y;
		}
	}
	protected Vector2 gravity;
	protected Item[] items;
	public Node2D target;
	public bool freeze;

	public override void _EnterTree() {
		items = new Item[poolSize];
	}
	public virtual void SpawnItem(in Vector2 origin, in int point) {
		if (index < poolSize) {
			//Item item = new Item(transform, gravity, value, power);
			//items[index] = item;
			index++;
		}
	}
	public override void _PhysicsProcess(float delta) {
		if (index == 0) {
			target = null;
			return;
		}
		if (freeze && target != null) {
			freeze = false;
			return;
		}

		VisualServer.CanvasItemClear(canvas);
		uint newIndex = 0;

		for (uint i = 0; i != index; i++) {
			Item item = items[i];
			if (target != null) {
				item.velocity = new Vector2(speed * 3, 0).Rotated(item.transform.origin.AngleToPoint(target.GlobalPosition));
			}
			item.transform.origin += item.velocity * delta;
			VisualServer.CanvasItemAddTextureRect(canvas, new Rect2(offset + item.transform.origin, textureSize), textureRID, false, null, false, textureRID);

			//Collision check.
			query.Transform = item.transform;
			Godot.Collections.Dictionary result = world.DirectSpaceState.GetRestInfo(query);
			if (result.Count == 0) {
				items[newIndex] = item;
				newIndex++;
				continue;
			}
			Object collider = GD.InstanceFromId((ulong) (int)result["collider_id"]);
			if (collider.HasMethod("_collect")) {
				collider.Call("_collect", item.point);
			}
		}
		index = newIndex;
	}
}
