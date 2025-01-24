#include <enemy.hpp>

SETTER_GETTER(explosion_path, NodePath, Enemy)
SETTER_GETTER(visual_path, NodePath, Enemy)
SETTER_GETTER(heath, int, Enemy)
SETTER_GETTER(oneshot, bool, Enemy)

void Enemy::_bind_methods()
{
    ADD_SIGNAL(MethodInfo("died"));
    BIND_FUNCTION(timeout, Enemy)
    BIND_FUNCTION(hit, Enemy)
    BIND_FUNCTION(reset, Enemy)
    BIND_FUNCTION(disable, Enemy)

    BIND_SETGET(explosion_path, Enemy)
    BIND_SETGET(visual_path, Enemy)
    BIND_SETGET(heath, Enemy)
    BIND_SETGET(oneshot, Enemy)

    ADD_PROPERTY_INT(heath)
    ADD_PROPERTY_BOOL(oneshot)
    ADD_PROPERTY_NODEPATH(explosion_path)
    ADD_PROPERTY_NODEPATH(visual_path)
}

void Enemy::reset()
{
    is_alive = true;
    set_process_mode(PROCESS_MODE_INHERIT);
    set_monitorable(true);
    set_monitoring(true);
    visual->show();
    heath = item;
}

void Enemy::disable()
{
    set_process_mode(PROCESS_MODE_DISABLED);
    set_monitorable(false);
    set_monitoring(false);
    visual->hide();
}

void Enemy::timeout()
{
    if (!is_alive)
    {
        return;
    }
    is_alive = false;
    heath = 0;
    emit_signal("died");
    call_deferred("disable");
}

void Enemy::die()
{
    item_manager->spawn_circle(item, get_global_position());
    explosion->set_emitting(true);
    sound_effect->call("enemy_died");
    timeout();
}

void Enemy::hit()
{
    if ((heath == 0) && is_alive)
    {
        die();
        return;
    }
    heath--;
}

void Enemy::_body_entered(Node2D *body)
{
    Player *player = Object::cast_to<Player>(body);
    if (player == nullptr)
    {
        die();
        return;
    }
    player->call_deferred("hit");
}

void Enemy::_ready()
{
    connect("body_entered", callable_mp(this, &Enemy::_body_entered));
    CHECK_EDITOR
    explosion = get_node<CPUParticles2D>(explosion_path);
    visual = get_node<Node2D>(visual_path);
    item = heath;
    item_manager = get_node<ItemManager>("/root/GlobalItem");
    sound_effect = get_node<Node>("/root/SoundEffect");

    if (!oneshot)
    {
        call_deferred("disable");
    }
}