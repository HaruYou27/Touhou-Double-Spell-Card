#include "barrel_sine.hpp"

SETTER_GETTER(life_time, float, BarrelSine)
SETTER_GETTER(position_final, Vector2, BarrelSine)

void BarrelSine::_bind_methods()
{
    BIND_SETGET(life_time, BarrelSine)
    BIND_SETGET(position_final, BarrelSine)

    ADD_PROPERTY_FLOAT(life_time)
    ADD_PROPERTY_VECTOR2(position_final)
}

void BarrelSine::_ready()
{
    float rotation = get_rotation();
    BarrelRotator::_ready();
    set_rotation(rotation);
    set_position(Vector2(0, 0));
}

void BarrelSine::_physics_process(double delta)
{
    life_time += delta * get_speed();
    set_position(position_final * Math::sin(life_time));
}