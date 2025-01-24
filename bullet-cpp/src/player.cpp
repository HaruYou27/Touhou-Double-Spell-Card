#include <player.hpp>

Player::Player()
{
    Dictionary unreliable = Dictionary();
    RPC_CONFIG(unreliable, authority, unreliable_ordered)
    rpc_config("_update_position", unreliable);

    Dictionary reliable = Dictionary();
    RPC_CONFIG(reliable, authority, reliable)
    rpc_config("_bomb_away", reliable);
    rpc_config("_sync_death", reliable);
    rpc_config("_sync_revive", reliable);

    timeout_death = callable_mp(this, &Player::_timeout_death);
    timeout_revive = callable_mp(this, &Player::_timeout_revive);
    respawn = callable_mp(this, &Player::revive);
    bomb_finished = callable_mp(this, &Player::_bomb_finished);
}

SETTER_GETTER(visual_path, NodePath, Player)
SETTER_GETTER(death_vfx_path, NodePath, Player)
SETTER_GETTER(death_time, double, Player)
SETTER_GETTER(revive_time, double, Player)
SETTER_GETTER(respawn_time, double, Player)

void Player::_bind_methods()
{
    BIND_SETGET(visual_path, Player)
    BIND_SETGET(death_vfx_path, Player)
    BIND_SETGET(death_time, Player)
    BIND_SETGET(revive_time, Player)
    BIND_SETGET(respawn_time, Player)

    ADD_PROPERTY_NODEPATH(visual_path)
    ADD_PROPERTY_NODEPATH(death_vfx_path)
    ADD_PROPERTY_FLOAT(death_time)
    ADD_PROPERTY_FLOAT(revive_time)
    ADD_PROPERTY_FLOAT(respawn_time)

    ADD_SIGNAL(MethodInfo("kaboom"));
    ADD_SIGNAL(MethodInfo("died"));
    ClassDB::bind_method(D_METHOD("_update_position", "position"), &Player::_update_position);

    BIND_FUNCTION(_bomb_away, Player)
    BIND_FUNCTION(_sync_death, Player)
    BIND_FUNCTION(_sync_revive, Player)
    BIND_FUNCTION(_bomb_finished, Player)
    BIND_FUNCTION(_timeout_death, Player)
    BIND_FUNCTION(_timeout_revive, Player)
}

void Player::_timeout_revive()
{
    sound_effect->call("player_revive");
    set_collision_layer(collision_layer);
    visual->set_self_modulate(Color(1, 1, 1, 1));
}

void Player::_sync_revive()
{
    visual->show();
    visual->set_self_modulate(Color(1, 1, 1, 0.5));
    set_global_position(spawn_position);
    tree->create_timer(revive_time, false, true)->connect("timeout", timeout_revive);
    set_process_mode(PROCESS_MODE_INHERIT);
    set_process_unhandled_input(true);
    score_manager->last_stand = false;
}

void Player::revive()
{
    if (get_collision_layer() == collision_layer)
    {
        return;
    }
    _sync_revive();
    rpc("_sync_revive");
}

void Player::_ready()
{
    CHECK_EDITOR
    if (is_multiplayer_authority())
    {
        sound_effect = get_node<Node>("/root/SoundEffect");
        screen_effect = get_node<ScreenEffect>("/root/SrceenVFX");
        item_manager = get_node<ItemManager>("/root/GlobalItem");
        visual = get_node<Node2D>(visual_path);
        tree = get_tree();

        global = get_node<Node>("/root/Global");
        sentivity = global->get("user_data").get("sentivity");
        global->set("player1", this);
        death_vfx = get_node<GPUParticles2D>(death_vfx_path);

        collision_layer = get_collision_layer();
        spawn_position = get_global_position();
        return;
    }
    set_process_unhandled_input(false);
    set_collision_layer(0);
    global->set("player2", this);
}

void Player::clamp_position()
{
    Vector2 position = get_global_position();
    position.x = Math::clamp<float>(position.x, 0, 540);
    position.y = Math::clamp<float>(position.y, 0, 852);
    set_global_position(position);
}

void Player::_sync_death()
{
    set_process_mode(PROCESS_MODE_DISABLED);
    visual->hide();
    death_vfx->set_emitting(true);
    sound_effect->call("player_died");
    score_manager->last_stand = true;
}

void Player::_timeout_death()
{
    screen_effect->hide();
    score_manager->add_death_count();
    set_collision_layer(0);
    set_process_unhandled_input(false);
    _sync_death();
    rpc("sync_death");
    if (item_manager->is_offline())
    {
        global->call("game_pause");
        return;
    }
    if (score_manager->last_stand)
    {
        global->call("game_over");
        return;
    }
    tree->create_timer(respawn_time, true, true)->connect("timeout", respawn);
}

void Player::hit()
{
    if (get_collision_layer() == 0)
    {
        return;
    }
    set_collision_layer(0);
    sound_effect->call("player_hit");
    screen_effect->flash_red();
    tree->create_timer(death_time, true, true)->connect("timeout", timeout_death);
    if (item_manager->is_offline())
    {
        tree->set_pause(true);
    }
}

void Player::_update_position(const Vector2 position)
{
    REPLACE_TWEEN(tween)
    tween->set_ease(Tween::EASE_OUT);
    tween->tween_property(this, "global_position", position, 0.03);
}

void Player::_bomb_finished()
{
    set_collision_layer(collision_layer);
    visual->set_self_modulate(Color(1, 1, 1, 1));
}

void Player::_bomb_away()
{
    emit_signal("kaboom");
}

void Player::bomb()
{
    if (!(score_manager->use_bomb() && get_collision_layer() == 0))
    {
        return;
    }
    visual->set_self_modulate(Color(1, 1, 1, 0.5));
    set_collision_layer(0);
    rpc("_bomb_away");
    _bomb_away();
}

void Player::_unhandled_input(const Ref<InputEvent> &event)
{
    Ref<InputEventScreenDrag> drag_event = event;
    if (!(drag_event == nullptr))
    {
        translate(drag_event->get_relative() * sentivity);
        clamp_position();
        rpc("_update_position", get_global_position());

        if (drag_event->get_index() > 0)
        {
            bomb();
        }
    }
    else if (event->is_action_pressed("bomb"))
    {
        bomb();
    }
}