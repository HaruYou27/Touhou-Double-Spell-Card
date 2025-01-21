#ifndef RICOCHETOR_HPP
#define RICOCHETOR_HPP

#include <bullet.hpp>

class Ricochetor : public Bullet
{
GDCLASS(Ricochetor, Bullet)
   
protected:
    static void _bind_methods();
    virtual void reset_bullet() override;
    virtual void collide_wall(const int index) override;
    virtual void sort_bullet(const int index);

    bool ricocheted[max_bullet];
};

#endif