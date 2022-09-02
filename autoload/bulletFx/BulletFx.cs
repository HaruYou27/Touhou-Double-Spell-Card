using Godot;

public class BulletFx : Node2D {
	private struct Item {
		public Vector2 position;
		public float speed;
		public Item(in Vector2 pos, in int s) {
			position = pos;
			speed = s;
		}
	}
	private Item[] items = new Item[maxItem];
	
	protected Physics2DShapeQueryParameters query = new Physics2DShapeQueryParameters();
	private RID hitbox = Physics2DServer.CircleShapeCreate();
	const uint maxItem = 4727;
	protected uint index;

	private Texture texture = GD.Load<Texture>("res://autoload/bulletFx/grazefx.png");
	protected RID textureRID;
	protected Vector2 offset;
	protected Vector2 textureSize;
	protected RID canvas;

	private Texture hitFx = GD.Load<Texture>("res://autoload/bulletFx/hitfx.png");
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
		query.CollisionLayer = 4;
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
	public virtual void SpawnItem(in Vector2 position, in int speed) {
		if (index == maxItem) {return;}
		items[index] = new Item(position, speed);
		index++;
	}
	public virtual void hit(in Vector2 position) {
		VisualServer.CanvasItemAddTextureRect(fxCanvas, new Rect2(fxOffset + position, fxSize), fxRID, false, null, false, fxRID);
	}
	public override void _PhysicsProcess(float delta) {
		VisualServer.CanvasItemClear(canvas);
		VisualServer.CanvasItemClear(fxCanvas);

		if (index == 0) {return;}
		uint newIndex = 0;

		for (uint i = 0; i != index; i++) {
			Item item = items[i];
			item.position += (target.GlobalPosition - item.position).Normalized() * item.speed * delta;
			VisualServer.CanvasItemAddTextureRect(canvas, new Rect2(offset + item.position, textureSize), textureRID, false, null, false, textureRID);

			//Collision check.
			query.Transform = new Transform2D(0, item.position);
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
