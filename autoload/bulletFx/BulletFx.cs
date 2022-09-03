using Godot;

public class BulletFx : GrazeFx {
	private Vector2[] items = new Vector2[maxItem];
	private const uint maxItem = 4727;

	private Texture fxTexure = GD.Load<Texture>("res://autoload/bulletFx/hitfx.png");
	private ShaderMaterial fxMaterial = GD.Load<ShaderMaterial>("res://autoload/bulletFx/hitFx.material");
	protected RID[] fxSprites = new RID[maxFx];
	protected const uint maxFx = 72;
	protected uint tick;
	protected uint fxIndex = 0;

	public override void _Ready() {
		base._Ready();
		Vector2 texSize = fxTexure.GetSize();
		RID texRID = fxTexure.GetRid();
		Rect2 texRect = new Rect2(-texSize / 2, texSize);
		RID Canvas = world.Canvas;
		RID matRID = fxMaterial.GetRid();

		for (uint i = 0; i != maxFx; i++) {
			RID sprite = VisualServer.CanvasItemCreate();
			VisualServer.CanvasItemAddTextureRect(sprite, texRect, texRID, false, null, false, texRID);
			VisualServer.CanvasItemSetMaterial(sprite, matRID);
			VisualServer.CanvasItemSetParent(sprite, Canvas);
			VisualServer.CanvasItemSetZIndex(sprite, 3000);
			VisualServer.CanvasItemSetLightMask(sprite, 0);
			VisualServer.CanvasItemSetVisible(sprite, false);

			fxSprites[i] = sprite;
		}
	}
	public override void SpawnItem(in Vector2 position) {
		if (index == maxItem) {return;}
		items[index] = position;
		index++;
	}
	public virtual void hit(in Vector2 position) {
		if (fxIndex == maxFx) {return;}

		RID sprite = fxSprites[fxIndex];
		VisualServer.CanvasItemSetVisible(sprite, true);
		VisualServer.CanvasItemSetTransform(sprite, new Transform2D(GD.Randf() * Mathf.Tau, position));
		fxIndex++;
	}
	public override void _Process(float delta) {
		if (tick != fxIndex) {
			for (uint i = 0; i != fxIndex; i++) {
				VisualServer.CanvasItemSetVisible(fxSprites[i], false);
			}
			fxIndex = 0;
			tick = 7;
		} else if (tick > 0) {tick--;}
	}
	public override void _PhysicsProcess(float delta) {
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
