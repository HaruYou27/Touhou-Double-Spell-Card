using Godot;
public class BulletBatched : BulletBase
{//Bullet that draw in a single drawcall 
	private struct Bullet{
	    public Vector2 velocity;
	    public Transform2D transform;
	    public Bullet(in float speed, in Transform2D trans) {
		    transform = trans;
		    velocity = new Vector2(speed, 0).Rotated(trans.Rotation);
	    }
	}

	protected RID canvas;
	protected Vector2 offset;
	private Bullet[] bullets;

	protected virtual void InitCanvas() {
		world = GetViewport().World2d;
		canvas = VisualServer.CanvasItemCreate();
		VisualServer.CanvasItemSetZIndex(canvas, zIndex);
		VisualServer.CanvasItemSetParent(canvas, world.Canvas);
		if (material != null) {
			canvas = world.Canvas;
            VisualServer.CanvasItemSetMaterial(canvas, material.GetRid());
        }	
	}
	public override void _Ready()
	{
		bullets = new Bullet[poolSize];
		InitCanvas();
	}
	public virtual void Shoot(Godot.Collections.Array<Node2D> barrels) {
		for (int i = 0; i != barrels.Count; i++) {
			if (index == poolSize) {return;}

			Bullet bullet = new Bullet(speed, barrels[i].GlobalTransform);
			bullets[index] = bullet;
			index++;
		}
	}
	public override void _PhysicsProcess(float delta)
	{
		if (index == 0) {
			return;
		}

		uint newIndex = 0;
        VisualServer.CanvasItemClear(canvas);

		for (uint i = 0; i != index; i++) {
			Bullet bullet = bullets[i];
			bullet.transform.origin += bullet.velocity * delta;
			//Due to a bug in visual server, normal map rid can not be null, which is, null by default.
			VisualServer.CanvasItemAddTextureRect(canvas, new Rect2(offset + bullet.transform.origin, textureSize), textureRID, false, null, false, textureRID);

			//Collision checking.
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
