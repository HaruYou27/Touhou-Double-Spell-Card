#include <boss.hpp>

SETTER_GETTER(threshold, int, Boss)
SETTER_GETTER(heath_path, NodePath, Boss)

void Boss::_bind_methods()
{
    BIND_SETGET(threshold, Boss)
    BIND_SETGET(heath_path, Boss)

    ADD_PROPERTY_NODEPATH(heath_path)
    ADD_PROPERTY_INT(threshold)
    
    BIND_FUNCTION(spawn_item, Boss)
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
    CHECK_EDITOR
    connect("body_entered", callable_mp(this, &Boss::_body_entered));
    item_manager = get_node<ItemManager>("/root/GlobalItem");
}

void Boss::hit()
{
    heath_bar->set_value(heath_bar->get_value() + 1);
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
    item = heath_bar->get_value();
    REPLACE_TWEEN(tween)
    tween->tween_property(heath_bar, "value", 0, 1);
}