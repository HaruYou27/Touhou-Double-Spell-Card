using Godot;

public class ItemManager : Node2D {
	private struct Item {
		public Vector2 position;
		public Vector2 velocity;
		public Node2D target;
		public Item(in Vector2 pos) {
			position = pos;
			velocity = new Vector2(GD.Randf() * 72, 0).Rotated(GD.Randf() * Mathf.Tau);
			target = null;
		}
	}
	private Item[] items = new Item[maxItem];
	protected Physics2DShapeQueryParameters query = new Physics2DShapeQueryParameters();
	private RID hitbox = Physics2DServer.CircleShapeCreate();
	protected const uint maxItem = 2727;
	protected Vector2 fast = new Vector2(727, 0);
	protected Vector2 slow = new Vector2(27, 0);
	protected uint index;

	protected Texture texture = GD.Load<Texture>("res://autoload/item/point.png");
	protected RID textureRID;
	protected Vector2 offset;
	protected Vector2 textureSize;
	protected RID canvas;

	protected World2D world;
	protected Node Global;
	protected Node2D target;

	public override void _Ready() {
		query.ShapeRid = hitbox;

		textureRID = texture.GetRid();
		textureSize = texture.GetSize();
		Physics2DServer.ShapeSetData(hitbox, textureSize.x);
		offset = -textureSize / 2;

		world = GetWorld2d();
		Global = GetNode("/root/Global");
		canvas = GetCanvasItem();
		Material = GD.Load<Material>("res://autoload/item/item.material");
		ZIndex = -10;
	}
	public virtual void SpawnItem(in Vector2 position, int itemCount) {
		Item item;
		for (int i = 0; i != itemCount; i++) {
			item = new Item(position);
			items[index] = item;
			index++;
		}			
	}
	public override void _PhysicsProcess(float delta) {
		if (index == 0) {
			return;
		}

		VisualServer.CanvasItemClear(canvas);
		uint newIndex = 0;

		for (uint i = 0; i != index; i++) {
			Item item = items[i];
			if (target != null) {
				query.CollisionLayer = 5;
				item.velocity = fast.Rotated(item.position.AngleToPoint(item.target.GlobalPosition));
			} else if (item.target != null) {
				query.CollisionLayer = 5;
				item.velocity = slow.Rotated(item.position.AngleToPoint(item.target.GlobalPosition));
			} else {
				item.velocity.y += 98 * delta;
				query.CollisionLayer = 9;
			}
			item.position += item.velocity * delta;
			VisualServer.CanvasItemAddTextureRect(canvas, new Rect2(offset + item.position, textureSize), textureRID, false, null, false, textureRID);

			//Collision check.
			query.Transform = new Transform2D(0, item.position);
			Godot.Collections.Dictionary result = world.DirectSpaceState.GetRestInfo(query);
			if (result.Count == 0) {
				items[newIndex] = item;
				newIndex++;
				continue;
			} else if (item.target == null) {
				item.target = (Node2D)GD.InstanceFromId((ulong) (int)result["collider_id"]);
			} 
			else if (((Vector2)result["linear_velocity"]).x == 3) {Global.EmitSignal("collect");}
		}
		index = newIndex;
	}
}
