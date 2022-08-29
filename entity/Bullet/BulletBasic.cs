using Godot;
using System.Collections.Generic;
public class BulletBasic : BulletBase {
    //The most simplist bullet.
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
    protected Stack<RID> sprites;
    private Bullet[] bullets;
        
    public override void _EnterTree()
    {
        bullets = new Bullet[maxBullet];
    }
    public override void _Ready()
    {
        base._Ready();
        sprites = new Stack<RID>(maxBullet);
        Rect2 texRect = new Rect2(-textureSize / 2, textureSize);
        for (uint i = 0; i != maxBullet; i++) {
            RID sprite = VisualServer.CanvasItemCreate();
            VisualServer.CanvasItemSetZIndex(sprite, zIndex);
            VisualServer.CanvasItemSetParent(sprite, world.Canvas);
            VisualServer.CanvasItemSetLightMask(sprite, lightLayer);
            //Due to a bug in visual server, normal map rid can not be null, which is, null by default.
            VisualServer.CanvasItemAddTextureRect(sprite, texRect, textureRID, false, null, false, textureRID);
            if (material != null) {
                VisualServer.CanvasItemSetMaterial(sprite, material.GetRid());
            }
            VisualServer.CanvasItemSetVisible(sprite, false);
            sprites.Push(sprite);
        }
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
    public virtual void Flush() {
        if (index == 0) {return;}
        shooting = false;
        Vector2[] positions = new Vector2[index];
        for (uint i = 0; i != index; i++) {
            RID sprite = bullets[i].sprite;
            positions[i] = bullets[i].transform.origin;
            sprites.Push(sprite);
            VisualServer.CanvasItemSetVisible(sprite, false);
        }
        fx.SpawnItem(positions);
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
        if (index == 0) {return;}

        uint newIndex = 0;
        for (uint i = 0;i != index; i++) {
            Bullet bullet = bullets[i];
            bullet.transform.origin += bullet.velocity * delta;
            VisualServer.CanvasItemSetTransform(bullet.sprite, bullet.transform);

            //Collision check.
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
}