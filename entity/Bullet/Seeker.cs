using Godot;

public class Seeker : BulletBasic {
    //Bullets that chase nearby target.
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
            transform.Rotation += (float)1.57;
            velocity = new Vector2(speed, 0).Rotated(trans.Rotation);
            target = null;
        }
    }

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
                bullet.transform.Rotation = bullet.velocity.Angle() + (float)1.57;
            }
            bullet.transform.origin += bullet.velocity * delta;
            VisualServer.CanvasItemSetTransform(bullet.sprite, bullet.transform);


            //Collision checking
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