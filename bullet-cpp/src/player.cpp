#include <player.hpp>

SETTER_GETTER(sentivity, float, Player)

void Player::_bind_methods()
{
    ADD_SIGNAL(MethodInfo("bomb"));
    ADD_SIGNAL(MethodInfo("position_changed"));
}

void Player::_ready()
{
    CHECK_EDITOR
    item_manager = get_node<ItemManager>("/root/GlobalItem");
    if (is_multiplayer_authority())
    {
        item_manager->player1 = this;
        return;
    }
    item_manager->player2 = this;
    set_process_input(false);
    set_collision_layer(0);
}

void Player::_exit_tree()
{
    CHECK_EDITOR
    if (is_multiplayer_authority())
    {
        item_manager->player1 = nullptr;
    }
    item_manager->player2 = nullptr;
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
        emit_signal("position_changed");

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