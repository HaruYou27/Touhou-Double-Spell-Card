using Godot;
public class SineWave : BulletBasic {
    [Export] float amplitude = 5;
    [Export] float frequency = 5;
    private struct  Bullet {
        public Transform2D transform;
        public Vector2 velocity;
        public float age;
        public readonly RID sprite;
        public bool grazed;
        public Bullet(in float speed, in Transform2D trans, in RID canvas) {
            age = 0;
            transform = trans;
            sprite = canvas;
            grazed = true;
            velocity = new Vector2(speed, 0).Rotated(trans.Rotation);
        }
    }
    private Bullet[] bullets;

    public override void _EnterTree() {
        bullets = new Bullet[maxBullet];
    }
    public override void _PhysicsProcess(float delta) {
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
        
        for (uint i = 0;i != index; i++) {
            Bullet bullet = bullets[i];
            bullet.age += delta * frequency;
            //Offset bullet local y position to create wave-like effect.
            bullet.transform.origin += bullet.velocity * delta + new Vector2(0, Mathf.Sin(bullet.age) * amplitude).Rotated(bullet.transform.Rotation);;
            Transform2D transform = bullet.transform;
            transform.Rotation = bullet.age;
            VisualServer.CanvasItemSetTransform(bullet.sprite, transform);

            //Collision check.
            query.Transform = bullet.transform;
            Godot.Collections.Dictionary result = world.DirectSpaceState.GetRestInfo(query);
            if (result.Count == 0) {
                bullets[newIndex] = bullet;
                newIndex++;
                continue;
            }
            float colliderLayer = ((Vector2)result["linear_velocity"]).x;
            if (colliderLayer == 4.0) {
                    if (bullet.grazed) {
                    Global.EmitSignal("graze");
                    bullet.grazed = false;
                    }
                bullets[newIndex] = bullet;
                newIndex++;
                continue;
            } else if (colliderLayer == 3.0) {
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
