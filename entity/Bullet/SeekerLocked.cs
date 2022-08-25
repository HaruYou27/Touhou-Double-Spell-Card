using Godot;

public class SeekerLocked : BulletBasic {
    //Bullets which only target 1 entity at a time.
    [Export] public float mass;

    private struct Bullet {
        public Transform2D transform;
        public readonly RID sprite;
        public Vector2 velocity;
        public Bullet(in float speed, in Transform2D trans, in RID canvas) {
            sprite = canvas;
            transform = trans;
            velocity = new Vector2(speed, 0).Rotated(transform.Rotation);
        }   
    }
    public Node2D target;
    private Bullet[] bullets;

    public override void _EnterTree()
    {
        bullets = new Bullet[maxBullet];
    }
    public override void _PhysicsProcess(float delta)
    {
        if (shoting && heat == 0) {
            heat = cooldown;
            foreach (Node2D barrel in barrels) {
			if (index == maxBullet) {break;}

			Bullet bullet = new Bullet(speed, barrel.GlobalTransform, sprites.Pop());
			bullets[index] = bullet;
			index++;
		    }
        } else {heat--;}
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

            //Collision checking.
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
