#ifndef BARREL_ROTATOR_HPP
#define BARREL_ROTATOR_HPP

#include <godot_cpp/classes/node2d.hpp>

#include <utility.hpp>

class BarrelRotator : public Node2D
{
GDCLASS(BarrelRotator, Node2D)

private:
    float speed = -Math_PI;
protected:
    static void _bind_methods();
public:
    BarrelRotator();
    virtual void _ready() override;
    virtual void _physics_process(double delta) override;

    void _sync_rotation(const float rotation);
    SET_GET(speed, float)
};

#endif