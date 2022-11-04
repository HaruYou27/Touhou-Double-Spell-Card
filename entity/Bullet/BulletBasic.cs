using Godot;
//The base class of all bullets.
public class BulletBasic : Node2D {
//Read-only properties
	//Physics properties.
	[Export] protected int maxBullet = 127;
	[Export] public float speed;
	[Export] public Vector2 shapeSize {
		set {
			shapesize = value;
			CreateCollisionShape(value);
		}
		get {return shapesize;}
	}
	[Export] public bool CollideWithAreas {
		set {query.CollideWithAreas = value;}
		get {return query.CollideWithAreas;	}
	}
	[Export] public bool CollideWithBodies {
		set {query.CollideWithBodies = value;}
		get {return query.CollideWithBodies;}
	}
	[Export(PropertyHint.Layers2dPhysics)] public uint CollisionLayer {
		set {
			query.CollisionLayer = value;
			mask = value;
		} get {return mask;}
	}
	[Export] public bool Grazable = true;
	[Export] public Godot.Collections.Array Barrels = new Godot.Collections.Array();
	protected Physics2DShapeQueryParameters query = new Physics2DShapeQueryParameters();
	protected RID hitbox;
	private Vector2 shapesize;
	protected uint mask = 1;

	//Visual properties.
	[Export] protected Texture texture {
		set {
			tex = value;
			textureRID = value.GetRid();
			textureSize = value.GetSize();
			if (shapeSize.x == 0.0) {CreateCollisionShape(textureSize - new Vector2(4, 4));}
		}
		get {return tex;}
	}
	[Export] public Material material;
	[Export(PropertyHint.Range, "-4096, 4096")]	public int zIndex;
	private Texture tex;
	protected Vector2 textureSize;
	protected RID textureRID;

	protected World2D world;
	protected uint activeIndex = 0;
	protected uint newIndex = 0;
	protected Node2D[] barrels;
	protected Node Global;
	protected BulletFx fx;

	//Bullets properties.
	protected Transform2D[] transforms;
	protected bool[] grazable;
	protected Vector2[] velocities;
	protected RID[] sprites;

	public override void _Ready() {
		world = GetWorld2d();
		Global = GetNode("/root/Global");
		fx = GetNode<BulletFx>("/root/BulletFx");

		transforms = new Transform2D[maxBullet];
		grazable = new bool[maxBullet];
		velocities = new Vector2[maxBullet];
		sprites = new RID[maxBullet];

		int size = Barrels.Count;
		if (size == 0) {
			Barrels = GetChildren();
			size = Barrels.Count;
			barrels = new Node2D[size];
			for (int i = 0; i != size; i++) {
				barrels[i] = (Node2D)Barrels[i];
			}
		} else {
			Node parent = GetParent();
			barrels = new Node2D[size];
			for (int i = 0; i != size; i++) {
				barrels[i] = parent.GetNode<Node2D>((NodePath)Barrels[i]);
			}
		}

        Rect2 texRect = new Rect2(-textureSize / 2, textureSize);
        for (uint i = 0; i != maxBullet; i++) {
            RID sprite = VisualServer.CanvasItemCreate();
            VisualServer.CanvasItemSetZIndex(sprite, zIndex);
            VisualServer.CanvasItemSetParent(sprite, world.Canvas);
            VisualServer.CanvasItemSetLightMask(sprite, 0);
            //Due to a bug in visual server, normal map rid can not be null, which is, null by default.
            VisualServer.CanvasItemAddTextureRect(sprite, texRect, textureRID, false, null, false, textureRID);
            if (material != null) {
                VisualServer.CanvasItemSetMaterial(sprite, material.GetRid());
            }
            VisualServer.CanvasItemSetVisible(sprite, false);
            sprites[i] = sprite;
		}
	}
	private void CreateCollisionShape(in Vector2 size) {
			if (hitbox != null) {
				Physics2DServer.FreeRid(hitbox);
			}
			if (size.x == size.y) {
				hitbox = Physics2DServer.CircleShapeCreate();
				Physics2DServer.ShapeSetData(hitbox, size.x / 2);
			} else {
				hitbox = Physics2DServer.CapsuleShapeCreate();
				Physics2DServer.ShapeSetData(hitbox, new Vector2(size.x / 2, size.y - size.x));
			}
			query.ShapeRid = hitbox;
	}
	public override void _ExitTree() {
        foreach (RID sprite in sprites) {
            VisualServer.FreeRid(sprite);
        }
		Physics2DServer.FreeRid(hitbox);
    }
	public void SpawnBullet() {
        foreach (Node2D barrel in barrels) {
            if (activeIndex == maxBullet) {return;}
            VisualServer.CanvasItemSetVisible(sprites[activeIndex], true);
			velocities[activeIndex] = new Vector2(speed, 0).Rotated(barrel.Rotation);
			transforms[activeIndex] = barrel.GlobalTransform;
			transforms[activeIndex].Rotation += Mathf.Pi / 2;
			grazable[activeIndex] = Grazable;
			BulletConstructor();
            
            activeIndex++;
        }
    }
	protected virtual void BulletConstructor() {}
	public virtual void Flush() {
        if (activeIndex == 0) {return;}
        
        for (uint i = 0; i != activeIndex; i++) {
            fx.SpawnItem(transforms[i].origin);
            VisualServer.CanvasItemSetVisible(sprites[i], false);
        }
        activeIndex = 0;
    }
	protected virtual void Move(in uint i, in float delta) {
		transforms[i].origin += velocities[i] * delta;
	}
	protected virtual void Overwrite(in uint i) {
		//Fill in the gap aka reindexing.
		transforms[newIndex] = transforms[i];
		velocities[newIndex] = velocities[i];
		grazable[newIndex] = grazable[i];
	}
	protected virtual bool Collide(in Godot.Collections.Dictionary result, in uint i) {
		if (((Vector2)result["linear_velocity"]).x == 1.0) {return true;}
		
		return false;
	}
	public override void _PhysicsProcess(float delta) {
        if (activeIndex == 0) {return;}
		newIndex = 0;
        
        for (uint i = 0; i != activeIndex; i++) {
			Move(i, delta);
        	VisualServer.CanvasItemSetTransform(sprites[i], transforms[i]);

            query.Transform = transforms[i];
            if (grazable[i]) {query.CollisionLayer = mask + 8;} 
			else {query.CollisionLayer = mask;}
            
			//Collision checking.
			Godot.Collections.Dictionary result = world.DirectSpaceState.GetRestInfo(query);
	        if (result.Count == 0) {
    	    	if (newIndex != activeIndex) {Overwrite(i);}
				newIndex++;
				continue;
			}
    	    if (Collide(result, i)) {continue;}

			if (query.CollisionLayer == mask) {
				Object collider = GD.InstanceFromId(((ulong) (int)result["collider_id"]));
            	collider.Call("_hit");
            	fx.hit((Vector2)result["point"]);
			} else {
    	    	grazable[i] = false;
	    	    Global.EmitSignal("graze");
    	    	Overwrite(i);
        		newIndex++;
			}
        }
		for (uint i = newIndex; i != activeIndex; i++) {
			VisualServer.CanvasItemSetVisible(sprites[i], false);
		}
        activeIndex = newIndex;

    }
}
