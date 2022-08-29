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
            transform.Rotation += (float)1.57;
            velocity = new Vector2(speed, 0).Rotated(trans.Rotation);
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
        if (shooting && heat == 0) {
            heat = cooldown;
            foreach (Node2D barrel in barrels) {
			if (index == maxBullet) {break;}

			Bullet bullet = new Bullet(speed, barrel.GlobalTransform, sprites.Pop());
            VisualServer.CanvasItemSetVisible(bullet.sprite, true);
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
                bullet.transform.Rotation = bullet.velocity.Angle() + (float)1.57;
            }
            bullet.transform.origin += bullet.velocity * delta;
            VisualServer.CanvasItemSetTransform(bullet.sprite, bullet.transform);

            //Collision checking.
            query.Transform = bullet.transform;
            Godot.Collections.Dictionary result = world.DirectSpaceState.GetRestInfo(query);
            float colliderLayer = ((Vector2)result["linear_velocity"]).x;
            if (result.Count == 0 || colliderLayer > 1.0) {
                bullets[newIndex] = bullet;
                newIndex++;
                if (colliderLayer == 4.0) {Global.Call("graze");}
                continue;
            }
            if (colliderLayer == 3.0) {
                Object collider = GD.InstanceFromId(((ulong) (int)result["collider_id"]));
                collider.Call("_hit");
                fx.hit((Vector2)result["point"]);
            }
            sprites.Push(bullet.sprite);
            VisualServer.CanvasItemSetVisible(bullet.sprite, false);
        }
        index = newIndex;
    }
    public override void _ExitTree() {
        foreach (RID sprite in sprites) {
            VisualServer.FreeRid(sprite);
        }
        if (index != 0) {
            for (uint i = 0; i != index; i++) {
                VisualServer.FreeRid(bullets[i].sprite);
            }
        }
        Physics2DServer.FreeRid(hitbox);
    }
}
