using Godot;

public class ItemManager : Node {
	private struct Item {
		public Transform2D transform;
		public readonly int point;
		public Vector2 velocity;
		public Item(in Transform2D trans, in Vector2 initV, in int p) {
			transform = trans;
			point = p;
			velocity = initV;
		}
	}
	private Item[] items = new Item[maxItem];
	
	protected Physics2DShapeQueryParameters query = new Physics2DShapeQueryParameters();
	private RID hitbox = Physics2DServer.CircleShapeCreate();
	const float gravity = (float)9.8;
	const uint maxItem = 2727;
	const double maxVelocity = 272;
	const int maxPoint = 127;
	protected uint index;

	protected Texture texture = GD.Load<Texture>("res://autoload/point.png");
	protected RID textureRID;
	protected Vector2 offset;
	protected Vector2 textureSize;
	protected RID canvas;
	public Material material = GD.Load<Material>("res://shader/position-rotate.gdshader");

	public Node2D target;
	public bool freeze;
	protected World2D world;

	public override void _Ready() {
		query.CollisionLayer = 16;
		query.ShapeRid = hitbox;

		textureRID = texture.GetRid();
		textureSize = texture.GetSize();
		Physics2DServer.ShapeSetData(hitbox, textureSize.x);
		offset = -textureSize / 2;

		world = GetViewport().World2d;
		base._Ready();
		
		canvas = VisualServer.CanvasItemCreate();
		VisualServer.CanvasItemSetZIndex(canvas, -10);
		VisualServer.CanvasItemSetParent(canvas, world.Canvas);
        VisualServer.CanvasItemSetMaterial(canvas, material.GetRid());
	}
	public virtual void SpawnItem(in Vector2 origin, int point) {
		point -= maxPoint;
		Item item;
		GD.Randomize();
		Vector2 velocity = new Vector2((float)GD.RandRange(0.0, maxVelocity), 0).Rotated((float)GD.RandRange(0.0, Mathf.Tau));
		Transform2D transform = new Transform2D((float)0.0, origin);
		while (point > 0) {
			GD.Randomize();
			item = new Item(transform, velocity, maxPoint);
			velocity = new Vector2((float)GD.RandRange(0.0, maxVelocity), 0).Rotated((float)GD.RandRange(0.0, Mathf.Tau));
			items[index] = item;
			index++;
			point -= maxPoint;
		}			
		item = new Item(transform, velocity, point + maxPoint);
		items[index] = item;
		index++;
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
			}
			Object collider = GD.InstanceFromId((ulong) (int)result["collider_id"]);
			if (collider.HasMethod("_collect")) {
				collider.Call("_collect", item.point);
			}
		}
		index = newIndex;
	}
    public override void _ExitTree() {Physics2DServer.FreeRid(hitbox);}
}
