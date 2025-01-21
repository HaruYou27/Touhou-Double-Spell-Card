#include <accelerator.hpp>

SETTER_GETTER(speed_final, float, Accelerator)

void Accelerator::_bind_methods()
{
    BIND_SETGET(speed_final, Accelerator)
    ADD_PROPERTY_FLOAT(speed_final)
}

float Accelerator::calculate_speed(const int index)
{
    return Math::lerp(get_speed(), speed_final, life_times[index] / get_duration());
}

