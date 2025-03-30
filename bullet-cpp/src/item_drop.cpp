#include "item_drop.hpp"

SETTER_GETTER(gravity, float, ItemDrop)
SETTER_GETTER(velocity, Vector2, ItemDrop)

void ItemDrop::_bind_methods()
{
    BIND_FUNCTION(_visibility_changed, ItemDrop)
    BIND_FUNCTION(_body_entered, ItemDrop)

    BIND_SETGET(gravity, ItemDrop)
    BIND_SETGET(velocity, ItemDrop)

    ADD_PROPERTY_FLOAT(gravity)
    ADD_PROPERTY_VECTOR2(velocity)
}

void ItemDrop::disable()
{
    hide();
    set_physics_process(false);
    set_process_mode(Node::PROCESS_MODE_DISABLED);
}

void ItemDrop::_physics_process(const double delta)
{
    velocity.y += gravity * delta;
    translate(velocity * delta);

    if (world_border.has_point(get_global_position()))
    {
        return;
    }
    disable();
}

void ItemDrop::_visibility_changed()
{
    set_process_mode(Node::PROCESS_MODE_INHERIT);
}

void ItemDrop::_body_entered(Node2D *body)
{
    global_score->add_bomb();
    disable();
}

void ItemDrop::_ready()
{
    set_monitoring(false);
    set_monitorable(true);
    set_collision_mask(8);
    set_collision_layer(0);
    set_pickable(false);
    set_process_mode(Node::PROCESS_MODE_DISABLED);
    hide();

    connect("visibility_changed", Callable(this, "_visibility_changed"), CONNECT_PERSIST + CONNECT_DEFERRED);
    connect("body_entered", Callable(this, "_body_entered"), CONNECT_PERSIST);
    CHECK_EDITOR
    global_score = get_node<ScoreManager>("/root/GlobalScore");
}