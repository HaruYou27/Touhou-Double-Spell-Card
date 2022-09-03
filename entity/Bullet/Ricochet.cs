using Godot;
using Godot.Collections;

public class Ricochet : BulletBasic
{
    [Export] uint ricochet = 1;
    private struct Bullet {
        public Transform2D transform;
        public readonly RID sprite;
        public bool grazable;
        public Vector2 velocity;
        public uint ricochet;
        public Bullet(in float speed, in Transform2D trans, in RID canvas, in uint r, in bool graze) {
            sprite = canvas;
            grazable = graze;
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
    public override void Flush() {
        if (index == 0) {return;}
        
        for (uint i = 0; i != index; i++) {
            RID sprite = bullets[i].sprite;
            fx.SpawnItem(bullets[i].transform.origin);
            sprites.Push(sprite);
            VisualServer.CanvasItemSetVisible(sprite, false);
        }
        index = 0;
    }
    public override void _ExitTree() {
        foreach (RID sprite in sprites) {
            VisualServer.FreeRid(sprite);
        }
		Physics2DServer.FreeRid(hitbox);
    
        if (index == 0) {return;}
        for (uint i = 0; i != index; i++) {
            VisualServer.FreeRid(bullets[i].sprite);
        }
    }
    public override void _PhysicsProcess(float delta) {
        if (shooting) {
            if (heat == 0) {
                heat = cooldown;
                foreach (Node2D barrel in barrels) {
			    if (index == maxBullet) {break;}
			    Bullet bullet = new Bullet(speed, barrel.GlobalTransform, sprites.Pop(), ricochet, grazable);
                VisualServer.CanvasItemSetVisible(bullet.sprite, true);
			    bullets[index] = bullet;
			    index++;
		        }
            } else {heat--;}}
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
            Godot.Collections.Dictionary result;
            if (bullet.grazable) {
                query.CollisionLayer = mask + 8;
                result = world.DirectSpaceState.GetRestInfo(query);
                if (result.Count == 0) {
                    bullets[newIndex] = bullet;
                    newIndex++;
                    continue;
                }
                float colliderLayer = ((Vector2)result["linear_velocity"]).x;
                if (colliderLayer == 1.0) {
                    sprites.Push(bullet.sprite);
                    VisualServer.CanvasItemSetVisible(bullet.sprite, false);
                    continue;
                }
                bullet.grazable = false;
                grazefx.SpawnItem(bullet.transform.origin);
                bullets[newIndex] = bullet;
                newIndex++;
                continue;
            } else {
                query.CollisionLayer = mask;
                result = world.DirectSpaceState.GetRestInfo(query);
                if (result.Count == 0) {
                    bullets[newIndex] = bullet;
                    newIndex++;
                    continue;
                }
                if (bullet.ricochet > 0) {
                    bullet.velocity = bullet.velocity.Bounce((Vector2)result["normal"]);
                    bullet.ricochet--;
                    bullets[newIndex] = bullet;
                    newIndex++;
                } else {
                    sprites.Push(bullet.sprite);
                    VisualServer.CanvasItemSetVisible(bullet.sprite, false);
                }
                float colliderLayer = ((Vector2)result["linear_velocity"]).x;
                if (colliderLayer == 1.0) {continue;}
                
                Object collider = GD.InstanceFromId(((ulong) (int)result["collider_id"]));
                collider.Call("_hit");
                fx.hit((Vector2)result["point"]);
            }
        }
        index = newIndex;
    }
}
