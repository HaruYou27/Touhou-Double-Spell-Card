#include <ricochetor.hpp>

void Ricochetor::_bind_methods()
{
}

void Ricochetor::reset_bullet()
{
    ricocheted[count_bullet] = false;
    Bullet::reset_bullet();
}

void Ricochetor::sort_bullet(const int index)
{
    FILL_ARRAY_HOLE(ricocheted)
}

void Ricochetor::collide_wall(const int index)
{
    if (ricocheted[index])
    {
        Bullet::collide_wall(index);
    }
    ricocheted[index] = true;
    Vector2 &velocity = velocities[index];
    Transform2D &transform = transforms[index];
    Vector2 position = transform.get_origin();
    
    Vector2 normal = Vector2(0, 0);
    if (position.x < -100)
    {
        normal += Vector2(-1, 0);
    }
    else
    {
        normal += Vector2(1, 0);
    }

    if (position.y < -100)
    {
        normal += Vector2(0, -1);
    }
    else
    {
        normal += Vector2(0, 1);
    }

    velocity.bounce(normal);
    transform.set_rotation(velocity.angle() + PI_2);
}