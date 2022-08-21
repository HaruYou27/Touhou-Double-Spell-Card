using Godot;
public class SineWave : BulletBasic
{
    [Export] float amplitude = 5;
    [Export] float frequency = 5;
    private struct  Bullet
    {
        public Transform2D transform;
        public Vector2 velocity;
        public float age;
        public readonly RID sprite;
        public Bullet(in float speed, in Transform2D trans, in RID canvas) {
            age = 0;
            transform = trans;
            sprite = canvas;
            velocity = new Vector2(speed, 0).Rotated(trans.Rotation);
        }
    }
    private Bullet[] bullets;

    public override void _EnterTree() {
        bullets = new Bullet[maxBullet];
    }
    public override void _PhysicsProcess(float delta) {
        if (heat > 0) {heat--;}
        if (shoting) {
            heat = cooldown;
            foreach (Node2D barrel in barrels) {
			if (index == maxBullet) {break;}

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
            Object collider = GD.InstanceFromId((ulong) (int)result["collider_id"]);
            if (collider.HasMethod("_hit")) {
                collider.Call("_hit");
            }
            sprites.Push(bullet.sprite);
        }
        index = newIndex;
    }
}
