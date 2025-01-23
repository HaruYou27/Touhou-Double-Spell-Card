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
}

void Player::_bind_methods()
{
    ADD_SIGNAL(MethodInfo("kaboom"));
    ClassDB::bind_method(D_METHOD("_update_position", "position"), &Player::_update_position);

    BIND_FUNCTION(_bomb_away, Player)
    BIND_FUNCTION(_sync_death, Player)
    BIND_FUNCTION(_sync_revive, Player)
    BIND_FUNCTION(bomb_finished, Player)
    BIND_FUNCTION(death_timeout, Player)
    BIND_FUNCTION(revive_timeout, Player)
}

void Player::revive_timeout()
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
    revive_timer->start();
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
        screen_effect = get_node<Node2D>("/root/SrceenEffect");
        item_manager = get_node<ItemManager>("/root/GlobalItem");
        visual = get_node<Node2D>(visual_path);
        tree = get_tree();

        global = get_node<Node>("/root/Global");
        sentivity = global->get("user_data").get("sentivity");
        global->set("player1", this);

        death_timer = get_node<Timer>(death_timer_path);
        death_timer->connect("timeout", callable_mp(this, &Player::death_timeout));
        death_vfx = get_node<GPUParticles2D>(death_vfx_path);
        
        revive_timer = get_node<Timer>(revive_timer_path);
        revive_timer->connect("timeout", callable_mp(this, &Player::revive_timeout));

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

void Player::death_timeout()
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
    revive_timer->start();
}

void Player::hit()
{
    if (get_collision_layer() == 0)
    {
        return;
    }
    set_collision_layer(0);
    sound_effect->call("player_hit");
    screen_effect->call("flash_red");
    death_timer->start();
    if (item_manager->is_offline())
    {
        tree->set_pause(true);
    }
}

void Player::_update_position(const Vector2 position)
{
    if (tween.is_valid())
    {
        tween->kill();
    }
    tween = create_tween();
    tween->set_ease(Tween::EASE_OUT);
    tween->tween_property(this, "global_position", position, 0.03);
}

void Player::bomb_finished()
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
        set_global_position(get_global_position() + drag_event->get_relative() * sentivity);
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