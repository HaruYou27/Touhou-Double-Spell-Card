#include <global_score.hpp>

GETTER(graze, int, GlobalScore)
GETTER(item, int, GlobalScore)
GETTER(death_count, int, GlobalScore)

void GlobalScore::_bind_methods()
{
    ADD_SIGNAL(MethodInfo("score_changed", PropertyInfo(Variant::INT, "score")));

    BIND_FUNCTION(reset, GlobalScore)
    BIND_FUNCTION(add_item, GlobalScore)
    BIND_FUNCTION(add_death_count, GlobalScore)
    BIND_FUNCTION(add_graze, GlobalScore)
    BIND_FUNCTION(add_item, GlobalScore)
    
    BIND_FUNCTION(get_score, GlobalScore)
    BIND_FUNCTION(get_graze, GlobalScore)
    BIND_FUNCTION(get_item, GlobalScore)
    BIND_FUNCTION(get_death_count, GlobalScore)
}

void GlobalScore::_ready()
{
    engine = Engine::get_singleton();
}

void GlobalScore::reset()
{
    item = 1;
    graze = 1;
    death_count = 0;
    updating_score = false;
}

int GlobalScore::get_score()
{
    return item * graze * engine->get_time_scale();
}

void GlobalScore::_update_score()
{
    updating_score = false;
    emit_signal("score_changed", get_score());
}

void GlobalScore::update_score()
{
    // It's pointless to update score more than 1 per frame.
    if (updating_score)
    {
        return;
    }
    updating_score = true;
    call_deferred("_update_score");
}

void GlobalScore::add_item()
{
    update_score();
    item++;
}

void GlobalScore::add_graze()
{
    update_score();
    graze++;
}

void GlobalScore::add_death_count()
{
    death_count++;
}