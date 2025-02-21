#include "boss.hpp"

SETTER_GETTER(threshold, int, Boss)
SETTER_GETTER(heath_path, NodePath, Boss)

void Boss::_bind_methods()
{
    BIND_SETGET(threshold, Boss)
    BIND_SETGET(heath_path, Boss)

    ADD_PROPERTY_NODEPATH(heath_path)
    ADD_PROPERTY_INT(threshold)
    
    BIND_FUNCTION(spawn_item, Boss)
    BIND_FUNCTION(_body_entered, Boss)
}

void Boss::_body_entered(Node2D *body)
{
    Player *player = Object::cast_to<Player>(body);
    if (player == nullptr)
    {
        return;
    }
    player->call_deferred("hit");
}

void Boss::_ready()
{
    connect("body_entered", callable_mp(this, &Boss::_body_entered));
    set_collision_layer(2);
    set_collision_mask(4);
    set_monitorable(true);
    set_monitoring(true);
    set_pickable(false);
    CHECK_EDITOR
    item_manager = get_node<ItemManager>("/root/GlobalItem");
}

void Boss::hit()
{
    ++damage;
    heath_bar->set_value(damage);
}

void Boss::_process(double delta)
{
    if (item < 0)
    {
        set_process(false);
        return;
    }
    if (item > 27)
    {
        item -= 27;
        item_manager->spawn_circle(27, get_global_position());
        return;
    }
    item_manager->spawn_circle(item, get_global_position());
    item = 0;
}

void Boss::spawn_item()
{
    set_process(true);
    item = damage;
    damage = 0;
    REPLACE_TWEEN(tween)
    tween->tween_property(heath_bar, "value", 0, 1);
}