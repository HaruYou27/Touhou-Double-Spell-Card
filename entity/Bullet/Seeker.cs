using Godot;

public class Seeker : BulletBasic {
    [Export] protected float mass = 2;
    [Export] protected float seekRadius {
        set {Physics2DServer.ShapeSetData(seekShape, value);}
        get {return (float)Physics2DServer.ShapeGetData(seekShape);}
    }
    [Export(PropertyHint.Layers2dPhysics)] uint seekLayer {
        set {seekQuery.CollisionLayer = value;}
        get {return seekQuery.CollisionLayer;}
    }
    [Export] bool seekAreas {
        set {seekQuery.CollideWithAreas = value;}
        get {return seekQuery.CollideWithAreas;}
    }
    [Export] bool seekBodies {
        set {seekQuery.CollideWithBodies = value;}
        get {return seekQuery.CollideWithBodies;}
    }

    private Bullet[] bullets;
    protected Physics2DShapeQueryParameters seekQuery = new Physics2DShapeQueryParameters();
    private RID seekShape = Physics2DServer.CircleShapeCreate();
    private struct Bullet {
        public Transform2D transform;
        public Vector2 velocity;
        public Node2D target;
        public readonly RID sprite;
        public Bullet(in float speed, in Transform2D trans, in RID canvas) {
            transform = trans;
            sprite = canvas;
            velocity = new Vector2(speed, 0).Rotated(trans.Rotation);
            target = null;
        }
    }

    public override void _EnterTree()
    {
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

        for (uint i = 0; i != index; i++) {
            Bullet bullet = bullets[i];
            if (bullet.target == null) {
                seekQuery.Transform = bullet.transform;
                Godot.Collections.Dictionary seekResult = world.DirectSpaceState.GetRestInfo(seekQuery);
                if (seekResult.Count > 0) {
                    bullet.target = (Node2D)GD.InstanceFromId((ulong) (int)seekResult["collider_id"]);
                }
            } else {
                Vector2 desiredV = (bullet.target.GlobalPosition - bullet.transform.origin).Normalized() * speed;
                bullet.velocity += (desiredV - bullet.velocity) / mass;
                bullet.transform.Rotation = bullet.velocity.Angle();
            }
            bullet.transform.origin += bullet.velocity * delta;
            VisualServer.CanvasItemSetTransform(bullet.sprite, bullet.transform);


            //Collision checking
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