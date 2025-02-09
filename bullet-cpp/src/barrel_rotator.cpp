#include "barrel_rotator.hpp"

SETTER_GETTER(speed, float, BarrelRotator)

void BarrelRotator::_bind_methods()
{
    BIND_SETGET(speed, BarrelRotator);
    ADD_PROPERTY_FLOAT(speed);
}

void BarrelRotator::_visibility_changed()
{
    set_physics_process(is_visible_in_tree());
}

void BarrelRotator::_ready()
{
    connect("visibility_changed", callable_mp(this, &BarrelRotator::_visibility_changed));
    set_rotation(0);
}

void BarrelRotator::_physics_process(double delta)
{
    rotate(speed * delta);
}