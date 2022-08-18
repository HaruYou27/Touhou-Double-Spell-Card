using Godot;

public class ItemManager : BulletBatched
{
    protected struct Item {
        public Transform2D transform;
        public readonly int value;
        public readonly int power;
        public readonly RID texture;
        public Vector2 velocity;
        public Item(in Transform2D trans, in Vector2 gravity, in RID tex, in int v, in int p) {
            transform = trans;
            texture = tex;
            power = p;
            value = v;
            velocity = gravity;
        }
    }
    [Export]public new float speed {
        set {
            gravity = new Vector2(0, value);
        } get {
            return gravity.y;
        }
    }
    protected Vector2 gravity;
    protected Item[] items;
    public Node2D target;
    public bool freeze;

    public override void _Ready()
    {
        items = new Item[poolSize];
        InitCanvas();
    }
    public virtual void SpawnItem(in Vector2 position, in int value, in int power = 0)
    {

        if (index < poolSize) {
            //Item item = new Item(transform, gravity, value, power);
            //items[index] = item;
            index++;
        }
    }
    public override void Shoot(Godot.Collections.Array<Node2D> barrels) {}
    public override void _PhysicsProcess(float delta)
    {
        if (index == 0) {
            target = null;
            return;
        }
        if (freeze) {
            freeze = false;
            return;
        }

        VisualServer.CanvasItemClear(canvas);
        uint newIndex = 0;

        for (uint i = 0; i != index; i++) {
            Item item = items[i];
            if (target != null) {
                item.velocity = new Vector2(speed * 3, 0).Rotated(item.transform.origin.AngleToPoint(target.GlobalPosition));
            }
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
                collider.Call("_collect", item.value);
            }
        }
        index = newIndex;
    }
}
