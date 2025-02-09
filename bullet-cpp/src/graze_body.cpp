#include "graze_body.hpp"

SETTER_GETTER(vfx_path, NodePath, GrazeBody)
SETTER_GETTER(sfx_path, NodePath, GrazeBody)

void GrazeBody::_bind_methods()
{
    BIND_FUNCTION(hit, GrazeBody)
    BIND_FUNCTION(item_collect, GrazeBody)

    BIND_SETGET(vfx_path, GrazeBody)
    BIND_SETGET(sfx_path, GrazeBody)

    ADD_PROPERTY_NODEPATH(vfx_path)
    ADD_PROPERTY_NODEPATH(sfx_path)
}

void GrazeBody::_ready()
{
    CHECK_EDITOR
    global_score = get_node<ScoreManager>("/root/GlobalScore");
    vfx = get_node<GPUParticles2D>(vfx_path);
    sfx = get_node<AudioStreamPlayer>(sfx_path);
}

void GrazeBody::item_collect()
{
    CHECK_MULTIPLAYER_AUTHORITY
    global_score->add_item();
}

void GrazeBody::hit()
{
    CHECK_MULTIPLAYER_AUTHORITY
    vfx->set_emitting(true);
    sfx->play();
    global_score->add_graze();
}