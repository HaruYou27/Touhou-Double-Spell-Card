#include <seeker.hpp>

using namespace godot;

void Seeker::_bind_methods()
{
    BIND_SETGET(turn_speed, Seeker)
    BIND_SETGET(seek_shape, Seeker)
    BIND_SETGET(texture_vfx, Seeker)

    ADD_PROPERTY_FLOAT(turn_speed)
    ADD_PROPERTY_OBJECT(seek_shape, Shape2D)
    ADD_PROPERTY_OBJECT(texture_vfx, Texture2D)
}

Seeker::Seeker()
{
    seek_query = NEW_OBJECT(PhysicsShapeQueryParameters2D)
    seek_query->set_collide_with_areas(true);
    seek_query->set_collide_with_bodies(false);
    seek_query->set_collision_mask(2);
}

SETTER_GETTER(seek_shape, Ref<Shape2D>, Seeker)
SETTER_GETTER(texture_vfx, Ref<Texture2D>, Seeker)
SETTER_GETTER(turn_speed, float, Seeker)


bool Seeker::collide(const Dictionary& result, const short index)
{
    get_collider(result)->call_deferred("hit");
    return true;
}

void Seeker::_ready()
{
    Bullet::set_collide_areas(true);
    Bullet::set_collide_bodies(false);
    Bullet::set_collision_layer(2);
    Bullet::set_local_rotation(true);
    Bullet::_ready();

    seek_query->set_shape(seek_shape);
}

void Seeker::move_bullet(const short index)
{
    Area2D* target = targets[index];
    targets[index] = (target->is_monitorable()) ? target : nullptr;
    if (targets[index] == nullptr)
    {
        Transform2D& transform = transforms[index];
        Vector2& velocity = velocities[index];
        velocity += (target->get_global_position() - transform.get_origin()).normalized() * turn_speed * delta32;
        velocity.normalize();
        velocity *= get_speed();
        transform.set_rotation(velocity.angle());
    }
    Bullet::move_bullet(index);
}

bool Seeker::collision_check(const short index)
{
    if (targets[index] == nullptr)
    {
        Dictionary result = space->get_rest_info(seek_query);
        targets[index] = (result.is_empty()) ? nullptr : dynamic_cast<Area2D*>(get_collider(result));
        return false;
    }
    return Bullet::collision_check(index);
}

void Seeker::sort_bullets(short index)
{
    transforms_vfx[index_vfx] = transforms[index];
    grazes[index_vfx] = false;
    index_vfx++;
    Bullet::sort_bullets(index);
}

void Seeker::expire_bullet()
{
    if (index_vfx == 0)
    {
        return;
    }
    for (short index = index_vfx - 1; index >= 0; index--)
    {
        Transform2D& transform = transforms_vfx[index];
        texture_vfx->draw(canvas_item, transform.get_origin().rotated(-transform.get_rotation()) / transform.get_scale(), Color(transform.get_rotation(), 1, 1));

        if (grazes[index])
        {
            index_vfx--;
            if (index == index_vfx)
            {
                continue;
            }
            transform = transforms_vfx[index_vfx];
        }
        grazes[index] = true;
    }
}