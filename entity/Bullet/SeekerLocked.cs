using Godot;

public class Seeker : BulletBasic {
    [Export] protected float mass = 2;
    public Node2D target;
    
    public virtual void FindNearestNode(in Node2D[] list, in Vector2 relativeNode) {
        float minDistance = float.PositiveInfinity;
        Node2D theChosenOne = null;
        foreach (Node2D node in list) {
            float distance = (node.GlobalPosition - relativeNode).Length();
            if (minDistance > distance) {
                minDistance = distance;
                theChosenOne = node;
            }
        }
        target = theChosenOne;
    }
    public override void _PhysicsProcess(float delta)
    {
        if (index == 0) {
            return;
        }
        uint newIndex = 0;

        for (uint i = 0; i != index; i++) {
            Bullet bullet = bullets[i];
            if (target != null) {
                Vector2 desiredV = (target.GlobalPosition - bullet.transform.origin).Normalized() * speed;
                bullet.velocity += (desiredV - bullet.velocity) / mass;
                bullet.transform.Rotation = bullet.velocity.Angle();
            }
            bullet.transform.origin += bullet.velocity * delta;
            VisualServer.CanvasItemSetTransform(bullet.sprite, bullet.transform);

            //Collision checking
            query.Transform = bullet.transform;
            Godot.Collections.Dictionary result = world.DirectSpaceState.GetRestInfo(query);
			if (result.Count == 0) {
				bullets[newIndex] = bullet;
				newIndex++;
				continue;
			}
            Object collider = GD.InstanceFromId((ulong) (int)result["collider_id"]);
            if (collider.HasMethod("_hit")) {
                collider.Call("_hit");
            }
            sprites.Push(bullet.sprite);
        }
        index = newIndex;
    }
}