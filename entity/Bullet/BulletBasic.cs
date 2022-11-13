using Godot;
//The base class of all bullets.
public class BulletBasic : Node2D 
{
	[Export] public int maxBullet = 127; //Exceed the limit and no more bullet will be shoot out.
	[Export] public float speed;
	[Export] public bool localRotation = true;
	[Export] public Vector2 shapeSize 
	{
		set 
		{
			shapesize = value;
			CreateCollisionShape(value);
		}
		get {return shapesize;}
	}
	[Export] public bool CollideWithAreas 
	{
		set {query.CollideWithAreas = value;}
		get {return query.CollideWithAreas;	}
	}
	[Export] public bool CollideWithBodies 
	{
		set {query.CollideWithBodies = value;}
		get {return query.CollideWithBodies;}
	}
	[Export(PropertyHint.Layers2dPhysics)] public uint CollisionLayer 
	{
		set 
		{
			query.CollisionLayer = value;
			mask = value;
		} get {return mask;}
	}
	[Export] public bool Grazable = true;
	protected Physics2DShapeQueryParameters query = new Physics2DShapeQueryParameters();
	protected RID hitbox;
	private Vector2 shapesize;
	protected uint mask = 1;

	//Visual.
	[Export] public Texture texture 
	{
		set 
		{
			tex = value;
			textureRID = value.GetRid();
			textureSize = value.GetSize();
			if (shapeSize.x == 0.0) 
			{
				CreateCollisionShape(textureSize - new Vector2(4, 4));
			}
		}
		get {return tex;}
	}
	[Export] public Material material;
	[Export(PropertyHint.Range, "-4096, 4096")]	public int zIndex;
	private Texture tex;
	protected Vector2 textureSize;
	protected RID textureRID;

	protected uint activeIndex = 0; //Current empty index, also bullet count.
	protected Node2D[] barrels;
	protected static Node Global;
	protected static BulletFx fx;
	protected static World2D world;


//Bullets properties.
	protected Transform2D[] transforms;
	protected bool[] grazable;
	protected Vector2[] velocities;
	protected RID[] sprites;

	public override void _Ready() 
	{
		world = GetWorld2d();
		Global = GetNode("/root/Global");
		fx = GetNode<BulletFx>("/root/BulletFx");

		transforms = new Transform2D[maxBullet];
		velocities = new Vector2[maxBullet];
		sprites = new RID[maxBullet];

		if (Grazable) {
			grazable = new bool[maxBullet];
			Global.Connect("impact", this, "Flush");
		}

		//Convert into type-safe C# native array.
		Godot.Collections.Array Barrels = GetChildren();
		int size = Barrels.Count;
		barrels = new Node2D[size];
		for (int i = 0; i != size; i++) {
			barrels[i] = (Node2D)Barrels[i];
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
	private void CreateCollisionShape(in Vector2 size) 
	{
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
	public override void _ExitTree() 
	{
        foreach (RID sprite in sprites) {
            VisualServer.FreeRid(sprite);
        }
		Physics2DServer.FreeRid(hitbox);
    }
	public virtual void SpawnBullet() 
	{
		foreach (Node2D barrel in barrels) {
			if (activeIndex == maxBullet) {return;}
			VisualServer.CanvasItemSetVisible(sprites[activeIndex], true);

			if (localRotation) {
				velocities[activeIndex] = new Vector2(speed, 0).Rotated(barrel.Rotation);
			} else {
				velocities[activeIndex] = new Vector2(speed, 0).Rotated(barrel.GlobalRotation);
			}
			transforms[activeIndex] = barrel.GlobalTransform;
			transforms[activeIndex].Rotation += Mathf.Pi / 2;
			if (Grazable) {grazable[activeIndex] = true;}
			
			BulletConstructor();
			
			activeIndex++;
		}
	}
	protected virtual void BulletConstructor() {}
	public virtual void Flush() 
	{
        if (activeIndex == 0) {return;}
        
        for (uint i = 0; i != activeIndex; i++) {
            fx.SpawnItem(transforms[i].origin);
            VisualServer.CanvasItemSetVisible(sprites[i], false);
        }
        activeIndex = 0;
    }
	protected virtual void ArraySort(in uint i) 
	{
		transforms[i] = transforms[activeIndex];
		velocities[i] = velocities[activeIndex];
		grazable[i] = grazable[activeIndex];
		RID sprite = sprites[i];
		sprites[i] = sprites[activeIndex];
		sprites[activeIndex] = sprite;
	}
	protected virtual void Move(in uint i, in float delta) 
	{
		transforms[i].origin += velocities[i] * delta;
		VisualServer.CanvasItemSetTransform(sprites[i], transforms[i]);
	}
	protected virtual bool Collide(in Godot.Collections.Dictionary result, in uint i) 
	{
		if (((Vector2)result["linear_velocity"]).x == 1.0) {return true;}

		if (query.CollisionLayer == mask) {
				Object collider = GD.InstanceFromId(((ulong) (int)result["collider_id"]));
				collider.Call("_hit");
				fx.hit((Vector2)result["point"]);
			} else {
    	    	grazable[i] = false;
	    	    Global.EmitSignal("graze");
			}

		return false;
	}
	public override void _PhysicsProcess(float delta)
	{
        if (activeIndex == 0) {return;}
        
        for (uint i = 0;i != activeIndex; i++) {
			uint gap = activeIndex;

			while (true) {
				Move(i, delta);
	        	
				//Collision checking.
    	        query.Transform = transforms[i];
	           	if (Grazable && grazable[i]) {query.CollisionLayer = mask + 8;} 
				else {query.CollisionLayer = mask;}

				Godot.Collections.Dictionary result = world.DirectSpaceState.GetRestInfo(query);
		        if (result.Count == 0) {
	    	    	if (gap == activeIndex) {break;}
					i = gap;
					ArraySort(i);
					break;
				}
    		    if (Collide(result, i)) {
					i = gap;
					ArraySort(i);
					break;
				}
				if (gap != activeIndex) {break;}

				gap = i;
				activeIndex--;
				i = activeIndex;
				VisualServer.CanvasItemSetVisible(sprites[i], false);
	        }
		}
    }
}
