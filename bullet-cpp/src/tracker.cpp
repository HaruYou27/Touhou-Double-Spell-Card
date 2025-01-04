#include <tracker.hpp>

using namespace godot;

void Tracker::_bind_methods()
{
    BIND_SETGET(turn_speed, Tracker)
    BIND_SETGET(seek_shape, Tracker)
    BIND_SETGET(offset, Tracker)

    ADD_PROPERTY_FLOAT(turn_speed)
    ADD_PROPERTY_OBJECT(seek_shape, Shape2D)
    ADD_PROPERTY(PropertyInfo(Variant::VECTOR2, "offset"), "set_offset", "get_offset");
}

Tracker::Tracker()
{
    seek_query = NEW_OBJECT(PhysicsShapeQueryParameters2D)
    seek_query->set_collide_with_areas(true);
    seek_query->set_collide_with_bodies(false);
}
Tracker::~Tracker()
{
}

SETTER_GETTER(seek_shape, Ref<Shape2D>, Tracker)
SETTER_GETTER(turn_speed, float, Tracker)
SETTER_GETTER(offset, Vector2, Tracker)

void Tracker::spawn_bullet()
{
    CHECK_CAPACITY
    if (target != nullptr)
    {
        for (Node2D* barrel : barrels)
        {
            CHECK_CAPACITY
            Vector2 position = barrel->get_global_position();
            Vector2 velocity = target_position - position;
            velocity.normalize();
            velocity *= get_speed();
            velocities[index_empty] = velocity;
            transforms[index_empty] = Transform2D(velocity.angle() + M_PI_2, get_scale(), 0, position);
            index_empty++;
        }
    } 
    else
    {
        for (Node2D* barrel : barrels)
        {
            float angle = barrel->get_rotation();
            velocities[index_empty] = Vector2(get_speed(), 0).rotated(angle);
            transforms[index_empty] = Transform2D(angle + M_PI_2, get_scale(), 0, barrel->get_global_position());
            index_empty++;
        }
    }
}

void Tracker::lock_target(int index)
{
    GET_BULLET_TRANSFORM
    Vector2 velocity = velocities[index];
    velocity += (target_position - transform.get_origin()).normalized() * turn_speed * delta32;
    velocity.normalize();
    velocity *= get_speed();

    transform.set_rotation(velocity.angle() + M_PI_2);
    velocities[index] = velocity;
    Bullet::move_bullet(index);
}

void Tracker::move_bullets()
{
    if (target != nullptr)
    {
        LOOP_BULLETS
        {
            lock_target(index);
        }
        return;
    }
    LOOP_BULLETS
    {
        Bullet::move_bullet(index);
    }
}

bool Tracker::collide(Dictionary& result, int index)
{
    GET_COLLIDER
    collider->call_deferred("hit");
    return true;
}

void Tracker::_ready()
{
    Bullet::set_collide_areas(true);
    Bullet::set_collide_bodies(true);
    Bullet::_ready();

    seeker = Object::cast_to<Node2D>(get_parent());
    seek_query->set_shape(seek_shape);
    seek_query->set_collision_mask(get_collision_layer());
    
}

void Tracker::_physics_process(double delta)
{
    if (target != nullptr)
    {
        target_position = target->get_global_position();
        if (!target->is_monitorable())
        {
            target = nullptr;
        }
        return Bullet::_physics_process(delta);
    }
    seek_query->set_transform(seeker->get_transform().translated(offset));
    COLLIDE_QUERY(seek_query)
    if (result.is_empty())
    {
        return Bullet::_physics_process(delta);
    }
    GET_COLLIDER
    target = static_cast<Area2D*>(collider);
    
    return Bullet::_physics_process(delta);
}