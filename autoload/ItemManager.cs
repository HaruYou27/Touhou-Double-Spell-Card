using Godot;

public class ItemManager : BulletBatched
{
    private struct Item {
        public Transform2D transform;
        public float power;
        public int value;
        public float live;
        public float bomb;
        public Item(Transform2D trans, int v, float p, float l, float b) {
            transform = trans;
            power = p;
            value = v;
            live = l;
            bomb = b;
        }
    }
    [Export] public new Vector2 speed;
    private Item[] items;

    public override void _EnterTree()
    {
        items = new Item[poolSize];
    }
    public virtual void SpawnItem(Transform2D transform, int value, float power = 0, float live = 0, float bomb = 0)
    {
        if (index < poolSize) {
            Item item = new Item(transform, value, power, live, bomb);
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
    public virtual void CollectAll(Node2D who) {
        foreach (Item item in items) {
            
        }
    }
}
