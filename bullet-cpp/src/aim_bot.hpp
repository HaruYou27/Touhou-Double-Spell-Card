#ifndef AIM_BOT_HPP
#define AIM_BOT_HPP

#include "utility.hpp"
#include "item_manager.hpp"
#include "barrel_rotator.hpp"


class AimBot : public BarrelRotator
{
GDCLASS(AimBot, BarrelRotator)

private:
    ItemManager *item_manager;
protected:
    static void _bind_methods();
public:
    virtual void _ready() override;
    virtual void _physics_process(const double delta) override;
};

#endif