using Godot;

public class ItemManager : Node2D {
	private struct Item {
		public Transform2D transform;
		public Vector2 velocity;
		public Item(in Transform2D trans, in Vector2 initV) {
			transform = trans;
			velocity = initV;
		}
	}
	private Item[] items = new Item[maxItem];
	
	protected Physics2DShapeQueryParameters query = new Physics2DShapeQueryParameters();
	private RID hitbox = Physics2DServer.CircleShapeCreate();
	const float gravity = (float)9.8;
	const uint maxItem = 2727;
	const float maxVelocity = 272;
	protected uint index;

	protected Texture texture = GD.Load<Texture>("res://autoload/point.png");
	protected RID textureRID;
	protected Vector2 offset;
	protected Vector2 textureSize;
	protected RID canvas;

	public Node2D target;
	public bool freeze;
	protected World2D world;
	protected Node Global;

	public override void _Ready() {
		query.CollisionLayer = 9;
		query.ShapeRid = hitbox;

		textureRID = texture.GetRid();
		textureSize = texture.GetSize();
		Physics2DServer.ShapeSetData(hitbox, textureSize.x);
		offset = -textureSize / 2;

		world = GetWorld2d();
		Global = GetNode("root/Global");
		canvas = GetCanvasItem();
		Material = GD.Load<Material>("res://shader/position-rotate.gdshader");
		ZIndex = -10;
	}
	public virtual void SpawnItem(in Vector2 origin, int itemCount) {
		Item item;
		GD.Randomize();
		Vector2 velocity = new Vector2(GD.Randf() * maxVelocity, 0).Rotated(GD.Randf() * Mathf.Tau);
		Transform2D transform = new Transform2D((float)0.0, origin);
		for (int i = 0; i != itemCount; i++) {
			GD.Randomize();
			item = new Item(transform, velocity);
			velocity = new Vector2(GD.Randf() * maxVelocity, 0).Rotated(GD.Randf() * Mathf.Tau);
			items[index] = item;
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
				item.velocity = new Vector2(gravity * 3, 0).Rotated(item.transform.origin.AngleToPoint(target.GlobalPosition));
			} else {item.velocity.y += gravity * delta;}
			item.transform.origin += item.velocity * delta;
			VisualServer.CanvasItemAddTextureRect(canvas, new Rect2(offset + item.transform.origin, textureSize), textureRID, false, null, false, textureRID);

			//Collision check.
			query.Transform = item.transform;
			Godot.Collections.Dictionary result = world.DirectSpaceState.GetRestInfo(query);
			if (result.Count == 0) {
				items[newIndex] = item;
				newIndex++;
				continue;
			} else if (((Vector2)result["linear_velocity"]).x == 4) {Global.EmitSignal("collect");}
		}
		index = newIndex;
	}
}
