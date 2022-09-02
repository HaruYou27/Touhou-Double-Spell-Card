using Godot;

public class GrazeFx : Node2D {
	private Vector2[] items = new Vector2[maxItem];
	
	protected Physics2DShapeQueryParameters query = new Physics2DShapeQueryParameters();
	protected RID hitbox = Physics2DServer.CircleShapeCreate();
	private const uint maxItem = 57;
	protected uint index;

	protected Texture texture = GD.Load<Texture>("res://autoload/bulletFx/grazefx.png");
	protected RID textureRID;
	protected Vector2 offset;
	protected Vector2 textureSize;
	protected RID canvas;

	protected Node2D target;
	protected World2D world;
	protected Node Global;

	public override void _Ready() {
		Global = GetNode("/root/Global");
		query.CollisionLayer = 4;
		query.ShapeRid = hitbox;
		world = GetWorld2d();

		textureRID = texture.GetRid();
		textureSize = texture.GetSize();
		Physics2DServer.ShapeSetData(hitbox, textureSize.x / 2);
		offset = -textureSize / 2;
		ZIndex = -10;
		canvas = GetCanvasItem();
	}
	public virtual void SpawnItem(in Vector2 position) {
		if (index == maxItem) {return;}
		items[index] = position - target.GlobalPosition;
		index++;
	}
	public override void _PhysicsProcess(float delta) {
		VisualServer.CanvasItemClear(canvas);
		if (index == 0) {return;}
		uint newIndex = 0;

		for (uint i = 0; i != index; i++) {
			Vector2 item = items[i];
			item += item.Rotated(Mathf.Pi).Normalized() * 72 * delta;
			Vector2 Gposition = item + target.GlobalPosition;
			VisualServer.CanvasItemAddTextureRect(canvas, new Rect2(offset + Gposition, textureSize), textureRID, false, null, false, textureRID);

			//Collision check.
			query.Transform = new Transform2D(0, Gposition);
			Godot.Collections.Dictionary result = world.DirectSpaceState.GetRestInfo(query);
			if (result.Count == 0) {
				items[newIndex] = item;
				newIndex++;
				continue;
			}
			Global.EmitSignal("graze");
		}
		index = newIndex;
	}
}
