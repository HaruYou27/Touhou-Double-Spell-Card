using Godot;

//Abstract class of all bullet, mostly just export variable.
public class BulletBase : Node2D {
	//Physics properties.
	[Export] protected int maxBullet = 127;
	[Export] public float speed = 727;
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
		set {query.CollisionLayer = value;}
		get {return query.CollisionLayer;}
	}
	protected Physics2DShapeQueryParameters query = new Physics2DShapeQueryParameters();
	private RID hitbox;
	private Vector2 shapesize;

	//Visual properties.
	[Export] protected Texture texture {
		set {
			tex = value;
			textureRID = value.GetRid();
			textureSize = value.GetSize();
			if (shapeSize.x == 0.0) {CreateCollisionShape(textureSize);}
		}
		get {return tex;}
	}
	[Export] public Material material;
	[Export(PropertyHint.Range, "-4096, 4096")]	public int zIndex;
	private Texture tex;
	protected Vector2 textureSize;
	protected RID textureRID;
	
	[Export] public bool shoting;
	[Export] public uint firerate {
		set {
			if (value > 0) {
				cooldown = (60 - value) / value;
			}
		}
		get {return cooldown;}
	}
	[Export] public Godot.Collections.Array Barrels = new Godot.Collections.Array();

	protected uint heat;
	protected uint cooldown;
	protected World2D world;
	protected uint index;
	protected Node2D[] barrels;

	public override void _Ready() {
		world = GetWorld2d();
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

	}
	private void CreateCollisionShape(in Vector2 size) {
			if (hitbox != null) {
				Physics2DServer.FreeRid(hitbox);
			}
			if (size.x == size.y) {
				hitbox = Physics2DServer.CircleShapeCreate();
				Physics2DServer.ShapeSetData(hitbox, size.x);
			} else {
				hitbox = Physics2DServer.CapsuleShapeCreate();
				Physics2DServer.ShapeSetData(hitbox, size);
			}
			query.ShapeRid = hitbox;
	}
    public override void _ExitTree()
    {
        Physics2DServer.FreeRid(hitbox);
    }
}
