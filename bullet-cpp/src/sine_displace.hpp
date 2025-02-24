#ifndef SINE_DISPLACE_HPP
#define SINE_DISPLACE_HPP

#include "utility.hpp"
#include "bullet.hpp"

class SineDisplace : public Bullet
{
GDCLASS(SineDisplace, Bullet)

private:
    float displace_speed = 3;
    float displace = 72;
protected:
    static void _bind_methods();
    float life_times[max_bullet];
    
    virtual void move_bullet(const int index) override;
    virtual void sort_bullet(const int index) override;
    virtual void reset_bullet() override;
public:
    SET_GET(displace_speed, float)
    SET_GET(displace, float)
};

#endif