using Godot;
using System;

public class DynamicSpeed : BulletBasic {
    [Export] public float finalSpeed {
        set {
            deltaV = value - speed;
            absDeltaV = Math.Abs(deltaV);
        }
        get {return speed + deltaV;}
    }
    [Export] public float time {
        set {acceleration = deltaV / value;}
        get {return deltaV / acceleration;}
    }

    private struct Bullet {
        public Transform2D transform;
        public readonly RID sprite;
        public float velocity;
        public float deltaV;
        public Bullet(in float speed, in Transform2D trans, in RID canvas, in float deltav) {
            sprite = canvas;
            deltaV = deltav;
            transform = trans;
            transform.Rotation += (float)1.57;
            velocity = speed;
        }   
    }
    private Bullet[] bullets;
    private float deltaV;
    protected float absDeltaV;
    protected float acceleration;

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
    public override void _EnterTree() {
        bullets = new Bullet[maxBullet];
    }
    public override void _PhysicsProcess(float delta) {
        if (shoting && heat == 0) {
            heat = cooldown;
            foreach (Node2D barrel in barrels) {
			if (index == maxBullet) {break;}

			Bullet bullet = new Bullet(speed, barrel.GlobalTransform, sprites.Pop(), absDeltaV);
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
            if (bullet.deltaV > 0.0) {
                float a = acceleration * delta;
                bullet.deltaV -= Math.Abs(a);
                bullet.velocity += a;
            }
            bullet.transform.origin += new Vector2(bullet.velocity * delta, 0).Rotated(bullet.transform.Rotation - (float)1.57);
            VisualServer.CanvasItemSetTransform(bullet.sprite, bullet.transform);

            //Collision check.
            query.Transform = bullet.transform;
            Godot.Collections.Dictionary result = world.DirectSpaceState.GetRestInfo(query);
            if (result.Count == 0) {
                bullets[newIndex] = bullet;
                newIndex++;
                continue;
            }
            Godot.Object collider = GD.InstanceFromId(((ulong) (int)result["collider_id"]));
            if (collider.HasMethod("_hit")) {
                if ((bool)collider.Call("_hit")) {
                    bullets[newIndex] = bullet;
                    newIndex++;
                    continue;
                }
            }
            sprites.Push(bullet.sprite);
            VisualServer.CanvasItemSetVisible(bullet.sprite, false);
        }
        index = newIndex;
    }
}
