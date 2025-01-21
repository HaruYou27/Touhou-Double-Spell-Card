#include <spinner.hpp>

SETTER_GETTER(speed_angular, float, Spinner)

void Spinner::_bind_methods()
{
    BIND_SETGET(speed_angular, Spinner)
    ADD_PROPERTY_FLOAT(speed_angular)
}
void Spinner::move_bullet(const int index)
{
    Transform2D& transform = transforms[index];
    transform.set_rotation(transform.get_rotation() + speed_angular * delta32);
    Bullet::move_bullet(index);
}