using Godot;

public class BulletFx : Node2D {
	private Vector2[] items = new Vector2[maxItem];
	private const uint maxItem = 4727;

	[Export] public Texture fxTexure;
	[Export] public ShaderMaterial fxMaterial;
	protected RID[] fxSprites = new RID[maxFx];
	protected const uint maxFx = 72;
	protected uint fxIndex = 0;

	protected readonly Physics2DShapeQueryParameters query = new Physics2DShapeQueryParameters();
	protected readonly RID hitbox = Physics2DServer.CircleShapeCreate();
	protected uint index;

	[Export] public Texture grazeTexture;
	protected RID textureRID;
	protected Vector2 offset;
	protected Vector2 textureSize;
	protected RID canvas;

	protected Node2D target;
	protected static World2D world;
	protected static Node Global;
	protected static SceneTree tree;

	public override void _Ready()
	{
		Global = GetNode("/root/Global");
		Global.Connect("impact", this, "_PlayerBombImpact");
		tree = GetTree();
		world = GetWorld2d();

		query.CollisionLayer = 4;
		query.ShapeRid = hitbox;

		textureRID = grazeTexture.GetRid();
		textureSize = grazeTexture.GetSize();
		Physics2DServer.ShapeSetData(hitbox, textureSize.x / 2);
		offset = -textureSize / 2;
		ZIndex = 1;
		canvas = GetCanvasItem();

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
	public virtual void SpawnItem(in Transform2D[] positions)
	{
		foreach (Transform2D position in positions)
		{
			if (index == maxItem) {return;}
			items[index] = position.origin;
			index++;
		}
	}
	public virtual void Hit(in Transform2D transform)
	{
		if (fxIndex == maxFx) {return;}

		RID sprite = fxSprites[fxIndex];
		VisualServer.CanvasItemSetVisible(sprite, true);
		VisualServer.CanvasItemSetTransform(sprite, transform);
		//Random alpha value to feed into shader.
		VisualServer.CanvasItemSetModulate(sprite, Color.ColorN("white", Mathf.Sin(Time.GetTicksMsec())));
		fxIndex++;
	}
	public virtual void ClearFx()
	{
		for (uint i = 0; i != fxIndex; i++) {
			VisualServer.CanvasItemSetVisible(fxSprites[i], false);
		}
		fxIndex = 0;
	}
	public override void _PhysicsProcess(float delta)
	{
		VisualServer.CanvasItemClear(canvas);
		if (index == 0) {return;}

		for (uint i = index; i != 0; i--) {
			Vector2 item = items[i];
			item += (target.GlobalPosition - item).Normalized() * 727 * delta;
			VisualServer.CanvasItemAddTextureRect(canvas, new Rect2(offset + item, textureSize), textureRID, false, null, false, textureRID);

			//Collision check.
			query.Transform = new Transform2D(0, item);
			Godot.Collections.Dictionary result = world.DirectSpaceState.GetRestInfo(query);
			if (result.Count == 0) {
				items[i] = item;
				continue;
			}
			Global.EmitSignal("graze");

			//Sort from tail to head to minize array access.
			items[i] = items[index];
			index--;
		}
	}
}
