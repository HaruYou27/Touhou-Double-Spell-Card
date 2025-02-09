#include "barrel_rotator_random.hpp"

SETTER_GETTER(angle_min, float, BarrelRotatorRandom)
SETTER_GETTER(angle_max, float, BarrelRotatorRandom)

void BarrelRotatorRandom::_bind_methods()
{
    BIND_SETGET(angle_min, BarrelRotatorRandom)
    BIND_SETGET(angle_max, BarrelRotatorRandom)

    ADD_PROPERTY_FLOAT(angle_min)
    ADD_PROPERTY_FLOAT(angle_max)

    BIND_FUNCTION(transform_barrel, BarrelRotatorRandom)
}

void BarrelRotatorRandom::transform_barrel()
{
    set_rotation(angle_min + Math::absf(sin(get_global_position().length())) * (angle_max - angle_min));
}