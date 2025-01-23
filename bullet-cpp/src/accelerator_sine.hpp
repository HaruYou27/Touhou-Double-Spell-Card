#ifndef ACCELERATOR_SINE_HPP
#define ACCELERATOR_SINE_HPP

#include <bullet.hpp>


class AcceleratorSine : public Bullet
{
GDCLASS(AcceleratorSine, Bullet)

private:
    float duration = 1;
protected:
    float life_times[max_bullet];

    static void _bind_methods();
    virtual float calculate_speed(const int index);
    virtual void move_bullet(const int index) override;
    virtual void reset_bullet() override;
    virtual void sort_bullet(const int index) override;
public:
    SET_GET(duration, float);
};

#endif