#include "seeker.hpp"

void Seeker::_bind_methods()
{
    BIND_SETGET(turn_speed, Seeker)
    BIND_SETGET(seek_shape, Seeker)

    ADD_PROPERTY_FLOAT(turn_speed)
    ADD_PROPERTY_OBJECT(seek_shape, Shape2D)
}

Seeker::Seeker()
{
    seek_query.instantiate();
    seek_query->set_collide_with_areas(true);
    seek_query->set_collide_with_bodies(false);
}

SETTER_GETTER(seek_shape, Ref<Shape2D>, Seeker)
SETTER_GETTER(turn_speed, float, Seeker)

void Seeker::_ready()
{
    Bullet::_ready();

    seek_query->set_shape(seek_shape);
    seek_query->set_collision_mask(get_collision_layer());
}

void Seeker::reset_bullet()
{
    targets[count_bullet] = nullptr;
    Bullet::reset_bullet();
}

void Seeker::sort_bullet(const int index)
{
    FILL_ARRAY_HOLE(targets);
    Bullet::sort_bullet(index);
}

void Seeker::move_bullet(const int index)
{
    Area2D* target = targets[index];
    if (target == nullptr)
    {
        return Bullet::move_bullet(index);
    }

    Transform2D& transform = transforms[index];
    Vector2& velocity = velocities[index];
    velocity += (target->get_global_position() - transform.get_origin()).normalized() * turn_speed * delta32;
    velocity.normalize();
    velocity *= get_speed();
    transform.set_rotation(velocity.angle() + PI_2);
    return Bullet::move_bullet(index);
}

bool Seeker::collision_check(const int index)
{
    if (targets[index] == nullptr)
    {
        Dictionary result = space->get_rest_info(seek_query);
        if (result.is_empty())
        {
            return false;
        }
        result.make_read_only();
        targets[index] = dynamic_cast<Area2D*>(get_collider(result));
        return false;
    }
    if (targets[index]->is_monitorable())
    {
        return Bullet::collision_check(index);

    }
    targets[index] = nullptr;
    return Bullet::collision_check(index);
}