#include "player.hpp"

SETTER_GETTER(sentivity, float, Player)

void Player::_bind_methods()
{
    ADD_SIGNAL(MethodInfo("bomb"));
    BIND_SETGET(sentivity, Player)
}

void Player::_ready()
{
    CHECK_EDITOR
    item_manager = get_node<ItemManager>("/root/GlobalItem");
    item_manager->player = this;
}

void Player::_exit_tree()
{
    item_manager->player = nullptr;
}

void Player::clamp_position()
{
    Vector2 position = get_global_position();
    position.x = Math::clamp<float>(position.x, 0, 540);
    position.y = Math::clamp<float>(position.y, 0, 852);
    set_global_position(position);
}

void Player::_input(const Ref<InputEvent> &event)
{
    Ref<InputEventScreenDrag> drag_event = event;
    if (drag_event.is_valid())
    {
        translate(drag_event->get_relative() * sentivity);
        clamp_position();

        if (drag_event->get_index() > 0)
        {
            emit_signal("bomb");
        }
    }
    else if (event->is_action_pressed("bomb"))
    {
        emit_signal("bomb");
    }
}