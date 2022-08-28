using Godot;

public class BulletFx : Node {
	private Vector2[] items = new Vector2[maxItem];
	
	protected Physics2DShapeQueryParameters query = new Physics2DShapeQueryParameters();
	private RID hitbox = Physics2DServer.CircleShapeCreate();
	const uint maxItem = 2727;
	protected uint index;

	protected Texture texture = GD.Load<Texture>("res://autoload/point.png");
	protected RID textureRID;
	protected Vector2 offset;
	protected Vector2 textureSize;
	protected RID canvas;

	protected Node2D target;
	protected World2D world;

	public override void _Ready() {
		target = (Node2D)GetNode<Node>("root/Global").Get("player");
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
	}
	public virtual void SpawnItem(in Vector2[] positions) {
		foreach (Vector2 position in positions) {
			if (index == maxItem) {return;}
			items[index] = position;
			index++;
		}
	}
	public override void _PhysicsProcess(float delta) {
		if (index == 0) {return;}

		VisualServer.CanvasItemClear(canvas);
		uint newIndex = 0;

		for (uint i = 0; i != index; i++) {
			Vector2 item = items[i];
			item += (target.GlobalPosition - item).Normalized() * 727 * delta;
			VisualServer.CanvasItemAddTextureRect(canvas, new Rect2(offset + item, textureSize), textureRID, false, null, false, textureRID);

			//Collision check.
			query.Transform = new Transform2D((float)0.0, item);
			Godot.Collections.Dictionary result = world.DirectSpaceState.GetRestInfo(query);
			if (result.Count == 0) {
				items[newIndex] = item;
				newIndex++;
				continue;
			}
			Object collider = GD.InstanceFromId((ulong) (int)result["collider_id"]);
			collider.Call("_collect", 27);
		}
		index = newIndex;
	}
    public override void _ExitTree() {Physics2DServer.FreeRid(hitbox);}
}
