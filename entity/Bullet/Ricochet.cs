using Godot;
//Bullet that bounce off wall.
public class Ricochet : BulletBasic 
{
    [Export] uint ricochet = 1;
    protected uint[] ricochets;

    public override void _Ready()
    {
        base._Ready();
        ricochets = new uint[maxBullet];
    }
    protected override void BulletConstructor() 
    {
        ricochets[activeIndex] = ricochet;
    }
    protected override void ArraySort(in uint i)
    {
        base.ArraySort(i);
        ricochets[i] = ricochets[activeIndex];
    }
    protected override bool Collide(in Godot.Collections.Dictionary result, in uint i) 
    {
        if (ricochets[i] > 0) {
            velocities[i] = velocities[i].Bounce((Vector2)result["normal"]);
            ricochets[i]--;
            return true;
        }
        return base.Collide(result, i);
    }
}
