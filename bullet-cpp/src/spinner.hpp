#ifndef SPINNER_HPP
#define SPINNER_HPP

#include <bullet.hpp>

using namespace godot;
class Spinner : public Bullet
{
GDCLASS(Spinner, Bullet)

private:
    float speed_angular = Math_PI;
protected:
    static void _bind_methods();
    virtual void move_bullet(const int index) override;
public:
    SET_GET(speed_angular, float)
};

#endif