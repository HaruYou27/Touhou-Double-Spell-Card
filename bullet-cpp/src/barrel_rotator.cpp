#include "barrel_rotator.hpp"

SETTER_GETTER(speed, float, BarrelRotator)

void BarrelRotator::_bind_methods()
{
    BIND_SETGET(speed, BarrelRotator);
    ADD_PROPERTY_FLOAT(speed);
    BIND_FUNCTION(_visibility_changed, BarrelRotator)
}

void BarrelRotator::_visibility_changed()
{
    set_physics_process(is_visible_in_tree());
}

void BarrelRotator::_ready()
{
    if (Engine::get_singleton()->is_editor_hint())
    {
        connect("visibility_changed", Callable(this, "_visibility_changed"), CONNECT_PERSIST);
    }
    set_rotation(0);
}

void BarrelRotator::_physics_process(double delta)
{
    rotate(speed * delta);
}