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
            velocity = new Vector2(speed, 0).Rotated(transform.Rotation);
        }   
    }
    protected Stack<RID> sprites;
    private Bullet[] bullets;
        
    public override void _EnterTree()
    {
        bullets = new Bullet[poolSize];
    }
    public override void _Ready()
    {
        base._Ready();
        sprites = new Stack<RID>(poolSize);
        Rect2 texRect = new Rect2(-textureSize / 2, textureSize);
        for (uint i = 0; i != poolSize; i++) {
            RID sprite = VisualServer.CanvasItemCreate();
            VisualServer.CanvasItemSetZIndex(sprite, zIndex);
            VisualServer.CanvasItemSetParent(sprite, world.Canvas);
            VisualServer.CanvasItemSetLightMask(sprite, 0);
            //Due to a bug in visual server, normal map rid can not be null, which is, null by default.
            VisualServer.CanvasItemAddTextureRect(sprite, texRect, textureRID, false, null, false, textureRID);
            if (material != null) {
                VisualServer.CanvasItemSetMaterial(sprite, material.GetRid());
            }
            sprites.Push(sprite);
        }
    }
    public override void _ExitTree()
    {
        foreach (RID sprite in sprites) {
            VisualServer.FreeRid(sprite);
        }
        base._ExitTree();
    }
    public override void _PhysicsProcess(float delta)
    {
        if (heat > 0) {heat--;}
        if (shoting) {
            heat = cooldown;
            foreach (Node2D barrel in barrels) {
			if (index == poolSize) {break;}

			Bullet bullet = new Bullet(speed, barrel.GlobalTransform, sprites.Pop());
			bullets[index] = bullet;
			index++;
		    }
        }
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
                collider.Call("_hit");
            }
            sprites.Push(bullet.sprite);
            VisualServer.CanvasItemSetTransform(bullet.sprite, new Transform2D());
        }
        index = newIndex;
    }
}