using Godot;

public class ItemManager : BulletBatched
{
    private struct Item {
        public Transform2D transform;
        public float power;
        public int value;
        public Item(Transform2D trans, int v, float p) {
            transform = trans;
            power = p;
            value = v;
        }
    }
    [Export] public new Vector2 speed;
    private Item[] items;

    public override void _Ready()
    {
        items = new Item[poolSize];
		world = GetWorld2d();

        canvas = VisualServer.CanvasItemCreate();	
		VisualServer.CanvasItemSetZIndex(canvas, zIndex);
		VisualServer.CanvasItemSetParent(canvas, world.Canvas);
		if (material != null) {
			canvas = world.Canvas;
            VisualServer.CanvasItemSetMaterial(canvas, material.GetRid());
        }
    }
    public virtual void SpawnItem(Transform2D transform, int value, float power = 0)
    {
        if (index < poolSize) {
            Item item = new Item(transform, value, power);
            items[index] = item;
            index++;
        }
    }
    public override void SpawnBullet(Transform2D transform) {}
    public override void _PhysicsProcess(float delta)
    {
        if (index == 0) {
            return;
        }

        VisualServer.CanvasItemClear(canvas);
        Item[] newItems = new Item[poolSize];
        uint newIndex = 0;

        for (uint i = 0; i != index; i++) {
            Item item = items[i];
            item.transform.origin += speed * delta;
            VisualServer.CanvasItemAddTextureRect(canvas, new Rect2(posOffset + item.transform.origin, textureSize), textureRID, false, null, false, textureRID);

            //Collision check.
            Godot.Collections.Array result = world.DirectSpaceState.IntersectShape(query, 1);
            if (result.Count == 0) {
                newItems[newIndex] = item;
                newIndex++;
                continue;
            }
            Godot.Collections.Dictionary result1 = (Godot.Collections.Dictionary)result[0];
            Object collider = (Object)result1["collider"];
            collider.Call("_collect", item.value, item.power);
        }
    items = newItems;
    index = newIndex;
    }
}
