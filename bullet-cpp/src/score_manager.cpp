#include "score_manager.hpp"

GETTER(graze, int, ScoreManager)
GETTER(score, int, ScoreManager)
GETTER(item, int, ScoreManager)
GETTER(bomb, int, ScoreManager)
GETTER(death_count, int, ScoreManager)

void ScoreManager::_bind_methods()
{
    ADD_SIGNAL(MethodInfo("score_changed", PropertyInfo(Variant::INT, "score")));
    ADD_SIGNAL(MethodInfo("bomb_changed", PropertyInfo(Variant::INT, "bomb")));

    BIND_FUNCTION(reset, ScoreManager)
    BIND_FUNCTION(use_bomb, ScoreManager)
    BIND_FUNCTION(_update_score, ScoreManager)
    //BIND_FUNCTION(add_death_count, ScoreManager)
    //BIND_FUNCTION(add_graze, ScoreManager)
    //BIND_FUNCTION(add_item, ScoreManager)
    
    BIND_FUNCTION(get_score, ScoreManager)
    BIND_FUNCTION(get_bomb, ScoreManager)
    BIND_FUNCTION(get_graze, ScoreManager)
    BIND_FUNCTION(get_item, ScoreManager)
    BIND_FUNCTION(get_death_count, ScoreManager)
}

void ScoreManager::_ready()
{
    engine = Engine::get_singleton();
    if (engine->is_editor_hint())
    {
        return;
    }
    sound_effect = get_node<Node>("/root/SoundEffect");
}

void ScoreManager::reset()
{
    item = 1;
    graze = 1;
    death_count = 0;
    score = 0;
    updating_score = false;
}

void ScoreManager::_update_score()
{
    updating_score = false;
    score = item * graze * engine->get_time_scale();
    emit_signal("score_changed", score);
}

void ScoreManager::update_score()
{
    // It's pointless to update score more than 1 per frame.
    if (updating_score)
    {
        return;
    }
    updating_score = true;
    call_deferred("_update_score");
}

void ScoreManager::add_bomb()
{
    ++bomb;
    sound_effect->call("bomb_pickup");
    emit_signal("bomb_changed", bomb);
}

bool ScoreManager::use_bomb()
{
    if (bomb == 0)
    {
        return false;
    }
    --bomb;
    emit_signal("bomb_changed", bomb);
    return true;
}

void ScoreManager::add_item()
{
    update_score();
    sound_effect->call("item_pickup");
    ++item;
}

void ScoreManager::add_graze()
{
    update_score();
    ++graze;
}

void ScoreManager::add_death_count()
{
    ++death_count;
    bomb = 3;
    emit_signal("bomb_changed", bomb);
}