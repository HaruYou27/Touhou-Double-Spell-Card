#ifndef BARREL_ROTATOR_RANDOM_HPP
#define BARREL_ROTATOR_RANDOM_HPP

#include "utility.hpp"
#include "barrel_rotator.hpp"

#include <godot_cpp/core/math.hpp>


class BarrelRotatorRandom : public BarrelRotator
{
GDCLASS(BarrelRotatorRandom, BarrelRotator)

private:
    float angle_min = 0;
    float angle_max = Math_TAU;
    float angle = 0;
protected:
    static void _bind_methods();
public:
    SET_GET(angle_min, float);
    SET_GET(angle_max, float);

    virtual void _ready() override;
    virtual void _physics_process(const double delta) override;
};

#endif