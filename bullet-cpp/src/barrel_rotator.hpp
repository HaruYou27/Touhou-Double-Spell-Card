#ifndef BARREL_ROTATOR_HPP
#define BARREL_ROTATOR_HPP

#include <godot_cpp/classes/marker2d.hpp>

#include "utility.hpp"

class BarrelRotator : public Marker2D
{
GDCLASS(BarrelRotator, Marker2D)

private:
    float speed = -Math_PI;
protected:
    static void _bind_methods();
public:
    virtual void _ready() override;
    virtual void _physics_process(double delta) override;

    void _visibility_changed();
    SET_GET(speed, float)
};

#endif