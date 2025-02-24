#include "sine_displace.hpp"

SETTER_GETTER(displace, float, SineDisplace)
SETTER_GETTER(displace_speed, float, SineDisplace)

void SineDisplace::_bind_methods()
{
    BIND_SETGET(displace, SineDisplace)
    ADD_PROPERTY_FLOAT(displace);

    BIND_SETGET(displace_speed, SineDisplace)
    ADD_PROPERTY_FLOAT(displace_speed);
}

void SineDisplace::move_bullet(const int index)
{
    life_times[index] += delta32 * displace_speed;
    transforms[index].translate_local(Math::sin(life_times[index]) * displace * delta32, 0);
    Bullet::move_bullet(index);
}

void SineDisplace::reset_bullet()
{
    life_times[count_bullet] = 0;
    Bullet::reset_bullet();
}

void SineDisplace::sort_bullet(const int index)
{
    FILL_ARRAY_HOLE(life_times)
    Bullet::sort_bullet(index);
}