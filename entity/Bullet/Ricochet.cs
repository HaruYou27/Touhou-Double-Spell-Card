using Godot;
//Bullet that bounce off wall.
public partial class Ricochet : BulletBasic 
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
    protected override void SortBullet()
    {
        ricochets[index] = ricochets[lastIndex];
        base.SortBullet();
    }
    protected override bool Collide(in Godot.Collections.Dictionary result) 
    {
        if (ricochets[index] > 0) {
            velocities[index] = velocities[index].Bounce((Vector2)result["normal"]);
            ricochets[index]--;
            return true;
        }
        return base.Collide(result);
    }
}
