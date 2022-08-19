using Godot;
public class SineWaveBatched : BulletBatched
{
    [Export] float amplitude = 5;
    [Export] float frequency = 50;
    private struct Bullet
    {
        public Transform2D transform;
        public Vector2 velocity;
        public float age;
        public Bullet(in float speed, in Transform2D trans) {
            age = 0;
            transform = trans;
            velocity = new Vector2(speed, 0).Rotated(trans.Rotation);
        }
    }
    private Bullet[] bullets;

    public override void _Ready()
    {
        bullets = new Bullet[poolSize];
        InitCanvas();
    }
	public override void Shoot(Godot.Collections.Array<Node2D> barrels) {
		for (int i = 0; i != barrels.Count; i++) {
			if (index == poolSize) {return;}

			Bullet bullet = new Bullet(speed, barrels[i].GlobalTransform);
			bullets[index] = bullet;
			index++;
		}
	}
    public override void _PhysicsProcess(float delta) {
         if (index == 0) {
            return;
        }
        uint newIndex = 0;
        
        for (uint i = 0;i != index; i++) {
            Bullet bullet = bullets[i];
            bullet.age += delta * frequency;
            //Offset bullet local y position to create wave-like effect.
            bullet.transform.origin += bullet.velocity * delta + new Vector2(0, Mathf.Sin(bullet.age) * amplitude).Rotated(bullet.transform.Rotation);;
            //Due to a bug in visual server, normal map rid can not be null, which is, null by default.
            VisualServer.CanvasItemAddTextureRect(canvas, new Rect2(offset + bullet.transform.origin, textureSize), textureRID, false, null, false, textureRID);

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
        }
        index = newIndex;
    }
}
