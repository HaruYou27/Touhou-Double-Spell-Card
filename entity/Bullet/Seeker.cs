using Godot;

public class Seeker : BulletBasic {
    //Bullets that chase nearby target.
    [Export] protected float mass = 10;
    [Export] protected float seekRadius {
        set {Physics2DServer.ShapeSetData(seekShape, value);}
        get {return (float)Physics2DServer.ShapeGetData(seekShape);}
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
        public bool grazable;
        public Bullet(in float speed, in Transform2D trans, in RID canvas, in bool graze) {
            transform = trans;
            sprite = canvas;
            grazable = graze;
            transform.Rotation += (float)1.57;
            velocity = new Vector2(speed, 0).Rotated(trans.Rotation);
            target = null;
        }
    }

    public override void _EnterTree() {
        bullets = new Bullet[maxBullet];
        seekQuery.ShapeRid = seekShape;
        seekQuery.CollisionLayer = mask;
    }
    public override void Flush() {
        if (index == 0) {return;}
        
        for (uint i = 0; i != index; i++) {
            RID sprite = bullets[i].sprite;
            fx.SpawnItem(bullets[i].transform.origin, 727);
            sprites.Push(sprite);
            VisualServer.CanvasItemSetVisible(sprite, false);
        }
        index = 0;
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
        Physics2DServer.FreeRid(seekShape);
    }
    public override void _PhysicsProcess(float delta) {
        if (shooting) {
            if (heat == 0) {
                heat = cooldown;
                foreach (Node2D barrel in barrels) {
			    if (index == maxBullet) {break;}
			    Bullet bullet = new Bullet(speed, barrel.GlobalTransform, sprites.Pop(), grazable);
                VisualServer.CanvasItemSetVisible(bullet.sprite, true);
			    bullets[index] = bullet;
			    index++;
		        }
            } else {heat--;}}
        if (index == 0) {
            return;
        }
        uint newIndex = 0;

        for (uint i = 0; i != index; i++) {
            Bullet bullet = bullets[i];
            if (bullet.target == null) {
                seekQuery.Transform = bullet.transform;
                Godot.Collections.Dictionary seekResult = world.DirectSpaceState.GetRestInfo(seekQuery);
                if (seekResult.Count != 0) {
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
                fx.SpawnItem(bullet.transform.origin, 72);
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
                float colliderLayer = ((Vector2)result["linear_velocity"]).x;
                sprites.Push(bullet.sprite);
                VisualServer.CanvasItemSetVisible(bullet.sprite, false);
                if (colliderLayer == 1.0) {continue;}
                
                Object collider = GD.InstanceFromId(((ulong) (int)result["collider_id"]));
                collider.Call("_hit");
                fx.hit((Vector2)result["point"]);
            }
        }
        index = newIndex;
    }
}