#include "item_drop.hpp"

SETTER_GETTER(gravity, float, ItemDrop)
SETTER_GETTER(velocity, Vector2, ItemDrop)

void ItemDrop::_bind_methods()
{
    BIND_FUNCTION(visibility_changed, ItemDrop)
    BIND_FUNCTION(body_entered, ItemDrop)

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
    velocity.y -= gravity * delta;
    translate(velocity * delta);

    if (world_border.has_point(get_global_position()))
    {
        return;
    }
    disable();
}

void ItemDrop::visibility_changed()
{
    set_process_mode(Node::PROCESS_MODE_INHERIT);
}

void ItemDrop::body_entered(Node2D *body)
{
    global_score->add_bomb();
    disable();
}

void ItemDrop::_ready()
{
    set_monitoring(true);
    set_monitorable(false);
    set_collision_mask(8);
    set_collision_layer(0);
    set_pickable(false);
    set_process_mode(Node::PROCESS_MODE_DISABLED);
    hide();

    connect("visibility_changed", callable_mp(this, &ItemDrop::visibility_changed), CONNECT_PERSIST);
    connect("body_entered", callable_mp(this, &ItemDrop::body_entered), CONNECT_PERSIST);
    CHECK_EDITOR
    global_score = get_node<ScoreManager>("/root/GlobalScore");
}