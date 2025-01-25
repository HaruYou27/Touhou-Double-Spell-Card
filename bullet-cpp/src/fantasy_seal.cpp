#include <fantasy_seal.hpp>

SETTER_GETTER(speed, float, FantasySeal)
SETTER_GETTER(speed_turn, float, FantasySeal)
SETTER_GETTER(speed_angular, float, FantasySeal)
SETTER_GETTER(velocity_inital, Vector2, FantasySeal)

void FantasySeal::_bind_methods()
{
    BIND_SETGET(speed, FantasySeal)
    BIND_SETGET(speed_turn, FantasySeal)
    BIND_SETGET(speed_angular, FantasySeal)
    BIND_SETGET(velocity_inital, FantasySeal)

    ADD_PROPERTY_FLOAT(speed_angular)
    ADD_PROPERTY_FLOAT(speed)
    ADD_PROPERTY_FLOAT(speed_turn)
    ADD_PROPERTY_VECTOR2(velocity_inital)
}

void FantasySeal::_ready()
{
    set_physics_process(false);
    set_process(false);
    parent = get_node<Node2D>("..");
}

void FantasySeal::_process(double delta)
{
    if (life_time < 1)
    {
        rotation_local += speed_angular * delta;
        position_local += velocity_inital * delta;
        set_global_position(parent->to_global(position_local.rotated(rotation_local)));

        life_time += delta;
        return;
    }
    velocity = Vector2(0, -speed);

    life_time = 0;
    rotation_local = 0;
    position_local = Vector2(0, 0);
    set_physics_process(true);
    set_process(false);
    //set_as_top_level(true);
}

void FantasySeal::_physics_process(double delta)
{
    translate(velocity * delta);
    if (has_overlapping_areas())
    {
        Node2D *target = Object::cast_to<Node2D>(get_overlapping_areas().front());
        velocity += (target->get_global_position() - get_global_position()).normalized() * speed_turn;
        velocity.normalize();
        velocity *= speed;
    }
}