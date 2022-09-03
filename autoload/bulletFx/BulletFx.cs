using Godot;

public class BulletFx : GrazeFx {
	private Vector2[] items = new Vector2[maxItem];
	private const uint maxItem = 4727;

	private Texture hitFx = GD.Load<Texture>("res://autoload/bulletFx/hitfx.png");
	private ShaderMaterial fxMaterial = GD.Load<ShaderMaterial>("res://autoload/bulletFx/hitFx.material");
	protected RID fxRID;
	protected Vector2 fxSize;
	protected Vector2 fxOffset;
	protected RID fxCanvas;
	protected bool tick;

	public override void _Ready() {
		base._Ready();

		fxCanvas = VisualServer.CanvasItemCreate();
		VisualServer.CanvasItemSetMaterial(fxCanvas, fxMaterial.GetRid());
		VisualServer.CanvasItemSetParent(fxCanvas, world.Canvas);
		VisualServer.CanvasItemSetZIndex(fxCanvas, 3000);
		fxSize = hitFx.GetSize();
		fxOffset = -fxSize / 2;
		fxRID = hitFx.GetRid();
	}
	public override void SpawnItem(in Vector2 position) {
		if (index == maxItem) {return;}
		items[index] = position;
		index++;
	}
	public virtual void hit(in Vector2 position) {
		VisualServer.CanvasItemAddTextureRect(fxCanvas, new Rect2(fxOffset + position, fxSize), fxRID, false, null, false, fxRID);
	}
	public override void _PhysicsProcess(float delta) {
		if (tick) {
			tick = false;
			VisualServer.CanvasItemClear(fxCanvas);
		} else {tick = true;}
		VisualServer.CanvasItemClear(canvas);

		if (index == 0) {return;}
		uint newIndex = 0;

		for (uint i = 0; i != index; i++) {
			Vector2 item = items[i];
			item += (target.GlobalPosition - item).Normalized() * 727 * delta;
			VisualServer.CanvasItemAddTextureRect(canvas, new Rect2(offset + item, textureSize), textureRID, false, null, false, textureRID);

			//Collision check.
			query.Transform = new Transform2D(0, item);
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
