#ifndef GRAZE_BODY_HPP
#define GRAZE_BODY_HPP

#include <godot_cpp/classes/static_body2d.hpp>
#include <godot_cpp/classes/gpu_particles2d.hpp>
#include <godot_cpp/classes/audio_stream_player.hpp>

#include <utility.hpp>
#include <score_manager.hpp>


class GrazeBody : public StaticBody2D
{
GDCLASS(GrazeBody, StaticBody2D)

private:
    GPUParticles2D *vfx;
    NodePath vfx_path;
    AudioStreamPlayer *sfx;
    NodePath sfx_path;
    ScoreManager *global_score;
protected:
    static void _bind_methods();
public:
    virtual void _ready() override;
    void hit();
    void item_collect();

    SET_GET(vfx_path, NodePath)
    SET_GET(sfx_path, NodePath)
};

#endif