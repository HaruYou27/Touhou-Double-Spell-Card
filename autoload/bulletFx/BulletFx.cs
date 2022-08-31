using Godot;

public class BulletFx : Node2D {
	private Vector2[] items = new Vector2[maxItem];
	
	protected Physics2DShapeQueryParameters query = new Physics2DShapeQueryParameters();
	private RID hitbox = Physics2DServer.CircleShapeCreate();
	const uint maxItem = 2727;
	protected uint index;

	private Texture texture = GD.Load<Texture>("res://autoload/item/point.png");
	protected RID textureRID;
	protected Vector2 offset;
	protected Vector2 textureSize;
	protected RID canvas;

	private Texture hitFx = GD.Load<Texture>("res://autoload/item/point.png");
	private Material fxMaterial = GD.Load<Material>("res://autoload/bulletFx/hitFx.material");
	protected RID fxRID;
	protected Vector2 fxSize;
	protected Vector2 fxOffset;
	protected RID fxCanvas;

	protected Node2D target;
	protected World2D world;
	protected Node Global;

	public override void _Ready() {
		Global = GetNode("/root/Global");
		query.CollisionLayer = 8;
		query.ShapeRid = hitbox;
		world = GetWorld2d();

		textureRID = texture.GetRid();
		textureSize = texture.GetSize();
		Physics2DServer.ShapeSetData(hitbox, textureSize.x);
		offset = -textureSize / 2;
		ZIndex = -10;
		canvas = GetCanvasItem();

		fxCanvas = VisualServer.CanvasItemCreate();
		VisualServer.CanvasItemSetMaterial(fxCanvas, fxMaterial.GetRid());
		VisualServer.CanvasItemSetParent(fxCanvas, world.Canvas);
		VisualServer.CanvasItemSetZIndex(fxCanvas, 4096);
		fxSize = hitFx.GetSize();
		fxOffset = -fxSize / 2;
		fxRID = hitFx.GetRid();
	}
	public virtual void SpawnItem(in Vector2[] positions) {
		foreach (Vector2 position in positions) {
			if (index == maxItem) {return;}
			items[index] = position;
			index++;
		}
	}
	public virtual void hit(in Vector2 position) {
		VisualServer.CanvasItemAddTextureRect(fxCanvas, new Rect2(fxOffset + position, fxSize), fxRID, false, null, false, fxRID);
	}
	public override void _PhysicsProcess(float delta) {
		if (index == 0) {return;}

		VisualServer.CanvasItemClear(canvas);
		VisualServer.CanvasItemClear(fxCanvas);
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
			Global.EmitSignal("collect_bullet");
		}
		index = newIndex;
	}
}
