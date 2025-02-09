#include "ricochet_target.hpp"

void RicochetTarget::_bind_methods()
{
}

void RicochetTarget::_ready()
{
    Bullet::_ready();
    global_item = Object::cast_to<ItemManager>(item_manager);
}

void RicochetTarget::collide_wall(const int index)
{
    if (ricocheted[index])
    {
        Bullet::collide_wall(index);
    }
    ricocheted[index] = true;
    Vector2 &velocity = velocities[index];
    Transform2D &transform = transforms[index];

    velocity = global_item->get_nearest_player(transform.get_origin());
    velocity.normalize();
    velocity *= get_speed();
    transform.set_rotation(velocity.angle() + PI_2);
}