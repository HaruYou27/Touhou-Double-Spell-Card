#ifndef BARREL_SINE_HPP
#define BARREL_SINE_HPP

#include "barrel_rotator.hpp"
#include "utility.hpp"

class BarrelSine : public BarrelRotator
{
GDCLASS(BarrelSine, BarrelRotator)

private:
    Vector2 position_final = Vector2(72, 0);
    float life_time = 0;
protected:
    static void _bind_methods();
public:
    virtual void _physics_process(double delta) override;
    virtual void _ready() override;
    
    SET_GET(position_final, Vector2)
    SET_GET(life_time, float)
};

#endif