#include "accelerator_smooth.hpp"

void AcceleratorSmooth::_bind_methods()
{
}

void AcceleratorSmooth::_ready()
{
    Bullet::_ready();
    acceleration = get_speed_final() - get_speed();
}

float AcceleratorSmooth::calculate_speed(const int index)
{
    return Math::smoothstep(0, get_duration(), life_times[index]) * acceleration + get_speed();
}