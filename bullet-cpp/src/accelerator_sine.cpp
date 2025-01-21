#include <accelerator_sine.hpp>

SETTER_GETTER(duration, float, AcceleratorSine)

void AcceleratorSine::_bind_methods()
{
    BIND_SETGET(duration, AcceleratorSine)
    ADD_PROPERTY_FLOAT(duration)
}

void AcceleratorSine::reset_bullet()
{
    life_times[count_bullet] = 0;
    Bullet::reset_bullet();
}

float AcceleratorSine::calculate_speed(const int index)
{
    return get_speed() * Math::absf(sin(life_times[index]));
}

void AcceleratorSine::sort_bullet(const int index)
{
    FILL_ARRAY_HOLE(life_times)
}

void AcceleratorSine::move_bullet(const int index)
{
    life_times[index] += delta32;
    Vector2 &velocity = velocities[index];
    velocity.normalize();
    velocity *= calculate_speed(index);
    Bullet::move_bullet(index);
}