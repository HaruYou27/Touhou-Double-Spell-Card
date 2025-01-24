#include <barrel_rotator.hpp>

BarrelRotator::BarrelRotator()
{
    Dictionary unreliable;
    RPC_CONFIG(unreliable, authority, unreliable_ordered);
    rpc_config("_sync_rotation", unreliable);
}

SETTER_GETTER(speed, float, BarrelRotator)

void BarrelRotator::_bind_methods()
{
    BIND_SETGET(speed, BarrelRotator);
    ADD_PROPERTY_FLOAT(speed);
}

void BarrelRotator::_ready()
{
    set_physics_process(is_multiplayer_authority());
}

void BarrelRotator::_sync_rotation(const float rotation)
{
    set_rotation(rotation);
}

void BarrelRotator::_physics_process(double delta)
{
    rotate(speed * delta);
    rpc("_sync_rotation");
}