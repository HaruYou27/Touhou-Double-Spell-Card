#ifndef ACCELERATOR_HPP
#define ACCELERATOR_HPP

#include <accelerator_sine.hpp>

class Accelerator : public AcceleratorSine
{
GDCLASS(Accelerator, AcceleratorSine)

private:
    float speed_final = 527;
protected:
    static void _bind_methods();
    virtual float calculate_speed(const int index) override;
public:
    SET_GET(speed_final, float);
};

#endif