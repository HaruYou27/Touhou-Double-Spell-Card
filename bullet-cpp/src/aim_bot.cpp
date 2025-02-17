#include "aim_bot.hpp"

void AimBot::_bind_methods()
{
}

void AimBot::_ready()
{
    CHECK_EDITOR
    BarrelRotator::_ready();
    item_manager = get_node<ItemManager>("/root/GlobalItem");
}

void AimBot::_physics_process(double delta)
{
    set_rotation(item_manager->get_nearest_player(get_global_position()).angle());
}