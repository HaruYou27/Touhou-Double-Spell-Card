#ifndef RICOCHET_TARGET_HPP
#define RICOCHET_TARGET_HPP

#include "ricochetor.hpp"
#include "item_manager.hpp"

class RicochetTarget : public Ricochetor
{
GDCLASS(RicochetTarget, Ricochetor)

protected:
    static void _bind_methods();
    ItemManager *global_item;

    virtual void collide_wall(const int index) override;
public:
    virtual void _ready() override;
};

#endif