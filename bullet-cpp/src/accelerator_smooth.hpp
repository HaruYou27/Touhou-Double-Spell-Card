#ifndef ACCELERATOR_SMOOTH_HPP
#define ACCELERATOR_SMOOTH_HPP

#include "accelerator.hpp"


class AcceleratorSmooth : public Accelerator
{
GDCLASS(AcceleratorSmooth, Accelerator)

private:
    float acceleration = 1;
protected:
    static void _bind_methods();
    virtual float calculate_speed(const int index) override;
public:
    virtual void _ready() override;
};

#endif