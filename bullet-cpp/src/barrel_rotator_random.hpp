#ifndef BARREL_ROTATOR_RANDOM_HPP
#define BARREL_ROTATOR_RANDOM_HPP

#include "utility.hpp"
#include <godot_cpp/classes/node2d.hpp>
#include <godot_cpp/core/math.hpp>


class BarrelRotatorRandom : public Node2D
{
GDCLASS(BarrelRotatorRandom, Node2D)

private:
    float angle_min = 0;
    float angle_max = Math_TAU;
protected:
    static void _bind_methods();
public:
    SET_GET(angle_min, float);
    SET_GET(angle_max, float);

    void transform_barrel();
};

#endif