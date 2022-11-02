using Godot;
//Bullet that bounce off wall.
public class Ricochet : BulletBasic {
    [Export] uint ricochet = 1;
    protected uint[] ricochets;

    public override void _Ready()
    {
        base._Ready();
        ricochets = new uint[maxBullet];
    }
    protected override void BulletConstructor() {
        ricochets[activeIndex] = ricochet;
    }
    protected override void Overwrite(in uint i)
    {
        base.Overwrite(i);
        ricochets[newIndex] = ricochets[i];
    }
    protected override bool Collide(in Godot.Collections.Dictionary result, in uint i) {
        if (ricochets[i] > 0) {
            velocities[i] = velocities[i].Bounce((Vector2)result["normal"]);
            ricochets[i]--;
            Overwrite(i);
            
            newIndex++;
            return true;
        }
        return false;
}
}
