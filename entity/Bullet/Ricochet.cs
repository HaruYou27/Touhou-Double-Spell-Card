using Godot;
using Godot.Collections;

public class Ricochet : BulletBasic
{
    [Export] uint ricochet = 1;
    private struct Bullet {
        public Transform2D transform;
        public readonly RID sprite;
        public Vector2 velocity;
        public uint ricochet;
        public Bullet(in float speed, in Transform2D trans, in RID canvas, in uint r) {
            sprite = canvas;
            transform = trans;
            transform.Rotation += (float)1.57;
            ricochet = r;
            velocity = new Vector2(speed, 0).Rotated(trans.Rotation);
        } 
    }
    private Bullet[] bullets;

    public override void _EnterTree() {
        bullets = new Bullet[maxBullet];
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
    public override void _PhysicsProcess(float delta)
    {
        if (shoting && heat == 0) {
            heat = cooldown;
            foreach (Node2D barrel in barrels) {
			if (index == maxBullet) {break;}

			Bullet bullet = new Bullet(speed, barrel.GlobalTransform, sprites.Pop(), ricochet);
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
            bullet.transform.origin += bullet.velocity * delta;
            VisualServer.CanvasItemSetTransform(bullet.sprite, bullet.transform);

            //Collision check.
            query.Transform = bullet.transform;
            Godot.Collections.Dictionary result = world.DirectSpaceState.GetRestInfo(query);
            if (result.Count == 0) {
                bullets[newIndex] = bullet;
                newIndex++;
                continue;
            }
            Object collider = GD.InstanceFromId(((ulong) (int)result["collider_id"]));
            if (collider.HasMethod("_hit")) {
                if ((bool)collider.Call("_hit")) {
                    bullets[newIndex] = bullet;
                    newIndex++;
                    continue;
                }
            } else if (ricochet != 0) {
                bullet.velocity = bullet.velocity.Bounce((Vector2)result["normal"]);
                bullet.ricochet -= 1;
                bullets[newIndex] = bullet;
                newIndex++;
                continue;
                }
            sprites.Push(bullet.sprite);
            VisualServer.CanvasItemSetVisible(bullet.sprite, false);
        }
        index = newIndex;
    }
}
