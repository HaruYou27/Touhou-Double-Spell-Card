#ifndef PLAYER_HPP
#define PLAYER_HPP

#include <godot_cpp/classes/static_body2d.hpp>
#include <godot_cpp/classes/scene_tree.hpp>
#include <godot_cpp/classes/timer.hpp>
#include <godot_cpp/classes/input_event_screen_drag.hpp>
#include <godot_cpp/classes/tween.hpp>
#include <godot_cpp/classes/gpu_particles2d.hpp>
#include <godot_cpp/classes/audio_stream_player.hpp>

#include <utility.hpp>
#include <score_manager.hpp>
#include <item_manager.hpp>

class Player : public StaticBody2D
{
GDCLASS(Player, StaticBody2D)

private:
    SceneTree *tree;
    Node2D *visual;
    Node *sound_effect;
    Node *global;
    Node2D *screen_effect;
    Timer *death_timer;
    GPUParticles2D *death_vfx;
    Timer *revive_timer;
    ItemManager *item_manager;
    ScoreManager *score_manager;
    Ref<Tween> tween;

    NodePath visual_path;
    NodePath death_timer_path;
    NodePath death_vfx_path;
    NodePath revive_timer_path;

    float sentivity = 1.2;
    Vector2 spawn_position;
    int collision_layer;

    virtual void clamp_position();
    void bomb();
protected:
    static void _bind_methods();
public:
    Player();

    virtual void _ready() override;
    virtual void _unhandled_input(const Ref<InputEvent> &event) override;

    void _update_position(const Vector2 position);
    void _bomb_away();
    void bomb_finished();

    void hit();
    void death_timeout();
    void _sync_death();

    void revive_timeout();
    void revive();
    void _sync_revive();
};

#endif