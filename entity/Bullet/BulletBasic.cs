using Godot;
//The base class of all bullets.
public partial class BulletBasic : Node2D 
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
	[Export(PropertyHint.Layers2DPhysics)] public uint CollisionMask 
	{
		set 
		{
			query.CollisionMask = value;
			mask = value;
		} get {return mask;}
	}
	[Export] public bool Grazable = true;
	protected readonly PhysicsShapeQueryParameters2D query = new PhysicsShapeQueryParameters2D();
	protected Rid hitbox;
	private Vector2 shapesize;
	protected uint mask = 1;

	//Visual.
	private void CreateCollisionShape(in Vector2 size) 
	{
			if (hitbox != null)
			{
				PhysicsServer2D.FreeRid(hitbox);
			}
			if (size.X == size.Y) 
			{
				hitbox = PhysicsServer2D.CircleShapeCreate();
				PhysicsServer2D.ShapeSetData(hitbox, size.X / 2);
			} 
			else 
			{
				hitbox = PhysicsServer2D.CapsuleShapeCreate();
				PhysicsServer2D.ShapeSetData(hitbox, new Vector2(size.X / 2, size.Y - size.X));
			}
			query.ShapeRid = hitbox;
	}
	[Export] public Texture2D texture 
	{
		set 
		{
			tex = value;
			textureRid = value.GetRid();
			textureSize = value.GetSize();
			if (shapeSize.X == 0.0) 
			{
				CreateCollisionShape(textureSize - new Vector2(4, 4));
			}
		}
		get {return tex;}
	}
	private Texture2D tex;
	protected Vector2 textureSize;
	protected Rid textureRid;

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
	//And this is the greatest downfall of inheritance.

	//Prefer Composition over Inheritance
	//With composition, I can declare new variable and behavior without interfer the old stuff.
	//In other words, I just jam everything into Array.
	//The only issue which this design is Array Sorting.
	//If we use object, we only need to move the memory address. (which is 4 bytes pointer)
	//But here we have to move the whole data (same as using struct), 
	//which get more expensive with more data. (O(n) operation)
	//Lucky that there aren't much data for a bullet.
	//Since the order is not important, we can just process and sort the bullet in the same for loop from tail to head to minimize array access and iteration.

	//The OOP may sounds more elegant, but I have seen nothing but boilerpate.
	//Just keep it simple and do.

	protected Transform2D[] transforms;
	protected bool[] grazable;
	protected Vector2[] velocities;
	protected Rid[] sprites;

	public override void _Ready() 
	{
		world = GetWorld2D();
		Global = GetNode("/root/Global");
		Global.Connect("bomb_impact",new Callable(this,"Clear"));

		transforms = new Transform2D[maxBullet];
		velocities = new Vector2[maxBullet];
		sprites = new Rid[maxBullet];

		Godot.Collections.Array<Node> Barrels = GetChildren();
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
		for (int i = 0; i != maxBullet; i++) 
		{
			Rid sprite = RenderingServer.CanvasItemCreate();
			sprites[i] = sprite;

			RenderingServer.CanvasItemSetVisible(sprite, false);
			RenderingServer.CanvasItemSetZIndex(sprite, ZIndex);
			RenderingServer.CanvasItemSetParent(sprite, world.Canvas);
			RenderingServer.CanvasItemSetLightMask(sprite, 0);
			RenderingServer.CanvasItemAddTextureRect(sprite, texRect, textureRid);
			if (Material != null)
			{
				RenderingServer.CanvasItemSetMaterial(sprite, Material.GetRid());
			}
		}
	}

	public override void _ExitTree() 
	{
		//Rid is actually an memory address to get the object in Godot server.
		//Since these CanvasItem are created directly using RenderingServer (not reference counted),
		//it must be freed manually.
		foreach (Rid sprite in sprites) 
		{
			RenderingServer.FreeRid(sprite);
		}
		PhysicsServer2D.FreeRid(hitbox);
	}	
	public virtual void SpawnBullet() 
	{
		foreach (Node2D barrel in barrels) 
		{
			if (activeIndex == maxBullet) {return;}
			RenderingServer.CanvasItemSetVisible(sprites[activeIndex], true);

			if (localRotation) 
			{
				velocities[activeIndex] = new Vector2(speed, 0).Rotated(barrel.Rotation);
			} 
			else 
			{
				velocities[activeIndex] = new Vector2(speed, 0).Rotated(barrel.GlobalRotation);
			}
			transforms[activeIndex] = barrel.GlobalTransform.Rotated(Mathf.Pi / 2);
			if (Grazable) {grazable[activeIndex] = true;}
			
			BulletConstructor();
			
			activeIndex++;
		}
	}
	protected virtual void BulletConstructor() {}
	public virtual void Clear() 
	{
		if (activeIndex == 0) {return;}
		
		Vector2[] bullets = new Vector2[maxBullet];
		for (int i = 0; i < activeIndex; i++) {
			RenderingServer.CanvasItemSetVisible(sprites[i], false);
			bullets[i] = transforms[i].Origin;
		}
		activeIndex = 0;
		((ItemManager) Global.Get("leveler.item_manager")).ConvertBullet(bullets);
	}
	protected virtual void SortBullet()
	{
		//Sort from tail to head to minimize array access.
		transforms[index] = transforms[lastIndex];
		velocities[index] = velocities[lastIndex];
		if (Grazable) {grazable[index] = grazable[lastIndex];}

		//Avoid memory leak in Godot server.
		Rid sprite = sprites[index];
		sprites[index] = sprites[lastIndex];
		sprites[lastIndex] = sprite;

		activeIndex--;
		lastIndex--;
	}
	protected virtual void Move(in double delta) 
	{
		transforms[index].Origin += velocities[index] * (float)delta;
		RenderingServer.CanvasItemSetTransform(sprites[index], transforms[index]);
	}
	protected virtual bool Collide(in Godot.Collections.Dictionary result) 
	{
		//Return true means the bullet will still alive.
		if (((Vector2)result["linear_velocity"]).X == 1.0) {return false;}

		if (query.CollisionMask == mask) 
		{
			GodotObject collider = (GodotObject) GodotObject.InstanceFromId( (ulong) result["collider_id"]);
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
	public override void _PhysicsProcess(double delta)
	{
		if (activeIndex == 0) {return;}
		lastIndex = activeIndex - 1;
		
		for (index = lastIndex; index >= 0; index--) 
		{
			Move(delta);
				
			//Collision checking.
			query.Transform = transforms[index];
			if (Grazable && grazable[index]) {query.CollisionMask = mask + 8;} 
			else {query.CollisionMask = mask;}

			Godot.Collections.Dictionary result = world.DirectSpaceState.GetRestInfo(query);
			if (result.Count == 0 || Collide(result)) {continue;}

			RenderingServer.CanvasItemSetVisible(sprites[index], false);
			if (index == lastIndex) {continue;}
			SortBullet();
}
		}
	}
