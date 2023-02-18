using Godot;
//The base class of all bullets.
public class BulletBasic : Node2D 
{
//Shared properties.
	//Physics.
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
		get {return query.CollideWithAreas;}
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
	protected readonly Physics2DShapeQueryParameters query = new Physics2DShapeQueryParameters();
	protected RID hitbox;
	private Vector2 shapesize;
	protected uint mask = 1;

	//Visual.
	private void CreateCollisionShape(in Vector2 size) 
	{
			if (hitbox != null)
			{
				Physics2DServer.FreeRid(hitbox);
			}
			if (size.x == size.y) 
			{
				hitbox = Physics2DServer.CircleShapeCreate();
				Physics2DServer.ShapeSetData(hitbox, size.x / 2);
			} 
			else 
			{
				hitbox = Physics2DServer.CapsuleShapeCreate();
				Physics2DServer.ShapeSetData(hitbox, new Vector2(size.x / 2, size.y - size.x));
			}
			query.ShapeRid = hitbox;
	}
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

	protected int activeIndex = 0; //Current empty index, also bullet count.
	protected int lastIndex; //Last bullet index.
	protected int index;
	protected Node2D[] barrels;
	protected static Node Global;
	protected static World2D world;


//Bullets properties.
	//Why don't I encapsule all these in a subclass? Good question.
	//In fact, I tried. However, this seems to be the case where OOP and static typing suck.
	//So I declared a Bullet{} sub class to store all these data below.
	//And an Bullet[] array to store all the instances.
	//And everything works fine. Until I want to make another one that can ricochet...
	//So I have to add new variables and functions into Bullet{} subclass.
	//I declare a RicochetBullet{} subclass inhernit from Bullet{} class.
	//And that's when I realize that the array in root base class is Bullet[] not RicochetBullet[]...
	//I could just cast (aka Boxing and Unboxing) the RicochetBullet into Bullet,
	//but I also have to cast it into RicochetBullet again everytime I need to access new data and function.
	//There're many other problems arise too, but that's enough to stop using OOP.

	//Reject human, return to monkee.
	//By just get rid of OOP, all the problems just go away.
	//The only issue which this design is Array Sorting.
	//If we use object, we only need to move the memory address. (which is 4 bytes pointer)
	//But here we have to move the whole data (same as using struct), 
	//which get more expensive with more data. (O(n) operation)
	//Since the order is not important, we can just process and sort the bullet in the same
	//for loop from tail to head to minimize array access and iteration.

	protected Transform2D[] transforms;
	protected bool[] grazable;
	protected Vector2[] velocities;
	protected RID[] sprites;

	public override void _Ready() 
	{
		world = GetWorld2d();
		Global = GetNode("/root/Global");
		Global.Connect("bomb_impact", this, "Clear");

		transforms = new Transform2D[maxBullet];
		velocities = new Vector2[maxBullet];
		sprites = new RID[maxBullet];

		Godot.Collections.Array Barrels = GetChildren();
		for (int i = 0; i < Barrels.Count; i++) 
		{
			if (!(Barrels[i] is Node2D)) 
			{
				Barrels.RemoveAt(i);
			}
		}
		barrels = new Node2D[Barrels.Count];
		Barrels.CopyTo(barrels, 0);

		if (Grazable)
		{
			grazable = new bool[maxBullet];
		}

		Rect2 texRect = new Rect2(-textureSize / 2, textureSize);
		for (uint i = 0; i != maxBullet; i++) 
		{
			RID sprite = VisualServer.CanvasItemCreate();
			sprites[i] = sprite;

			VisualServer.CanvasItemSetVisible(sprite, false);
			VisualServer.CanvasItemSetZIndex(sprite, zIndex);
			VisualServer.CanvasItemSetParent(sprite, world.Canvas);
			VisualServer.CanvasItemSetLightMask(sprite, 0);
			//Due to a bug in C# visual server, normal map rid can not be null, which is, null by default.
			VisualServer.CanvasItemAddTextureRect(sprite, texRect, textureRID, false, null, false, textureRID);
			if (material != null)
			{
				VisualServer.CanvasItemSetMaterial(sprite, material.GetRid());
			}
		}
	}
	public override void _ExitTree() 
	{
		//RID is actually an memory address to get the object in Godot server.
		//Since these CanvasItem are created directly using VisualServer (not reference counted),
		//it must be freed manually.
		foreach (RID sprite in sprites) 
		{
			VisualServer.FreeRid(sprite);
		}
		Physics2DServer.FreeRid(hitbox);
	}	
	public virtual void SpawnBullet() 
	{
		foreach (Node2D barrel in barrels) 
		{
			if (activeIndex == maxBullet) {return;}
			VisualServer.CanvasItemSetVisible(sprites[activeIndex], true);

			if (localRotation) 
			{
				velocities[activeIndex] = new Vector2(speed, 0).Rotated(barrel.Rotation);
			} 
			else 
			{
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
	public virtual void Clear() 
	{
		if (activeIndex == 0) {return;}
		
		for (uint i = 0; i < activeIndex; i++) {
			VisualServer.CanvasItemSetVisible(sprites[i], false);
		}
		activeIndex = 0;
	}
	protected virtual void SortBullet()
	{
		//Sort from tail to head to minimize array access.
		transforms[index] = transforms[lastIndex];
		velocities[index] = velocities[lastIndex];
		if (Grazable) {grazable[index] = grazable[lastIndex];}

		//Avoid memory leak in Godot server.
		RID sprite = sprites[index];
		sprites[index] = sprites[lastIndex];
		sprites[lastIndex] = sprite;

		activeIndex--;
		lastIndex--;
	}
	protected virtual void Move(in float delta) 
	{
		transforms[index].origin += velocities[index] * delta;
		VisualServer.CanvasItemSetTransform(sprites[index], transforms[index]);
	}
	protected virtual bool Collide(in Godot.Collections.Dictionary result) 
	{
		//Return true means the bullet will still alive.
		if (((Vector2)result["linear_velocity"]).x == 1.0) {return false;}

		if (query.CollisionLayer == mask) 
		{
			Object collider = GD.InstanceFromId(((ulong) (int)result["collider_id"]));
			collider.Call("_hit");
		} 
		else 
		{
			grazable[index] = false;
			Global.EmitSignal("bullet_graze");
			return true;
		}

		return false;
	}
	public override void _PhysicsProcess(float delta)
	{
		if (activeIndex == 0) {return;}
		lastIndex = activeIndex - 1;
		
		for (index = lastIndex; index >= 0; index--) 
		{
			Move(delta);
				
			//Collision checking.
			query.Transform = transforms[index];
			if (Grazable && grazable[index]) {query.CollisionLayer = mask + 8;} 
			else {query.CollisionLayer = mask;}

			Godot.Collections.Dictionary result = world.DirectSpaceState.GetRestInfo(query);
			if (result.Count == 0 || Collide(result)) {continue;}

			VisualServer.CanvasItemSetVisible(sprites[index], false);
			if (index == lastIndex) {continue;}
			SortBullet();
}
		}
	}
