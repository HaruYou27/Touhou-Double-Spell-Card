#ifndef PLAYER_HPP
#define PLAYER_HPP

#include <godot_cpp/classes/static_body2d.hpp>
#include <godot_cpp/classes/scene_tree.hpp>
#include <godot_cpp/classes/scene_tree_timer.hpp>
#include <godot_cpp/classes/input_event_screen_drag.hpp>
#include <godot_cpp/classes/tween.hpp>
#include <godot_cpp/classes/property_tweener.hpp>
#include <godot_cpp/classes/gpu_particles2d.hpp>
#include <godot_cpp/classes/audio_stream_player.hpp>

#include <utility.hpp>
#include <score_manager.hpp>
#include <item_manager.hpp>
#include <screen_effect.hpp>

class Player : public StaticBody2D
{
GDCLASS(Player, StaticBody2D)

private:
    Node2D *visual;
    Node *sound_effect;
    Node *global;
    GPUParticles2D *death_vfx;
    ItemManager *item_manager;
    ScoreManager *score_manager;
    ScreenEffect *screen_effect;
    Ref<Tween> tween;

    NodePath visual_path;
    NodePath death_vfx_path;
    double death_time = 1;
    double revive_time = 3;
    double respawn_time = 3;

    float sentivity = 1.2;
    Vector2 spawn_position;
    int collision_layer;
    
    void bomb();
protected:
    SceneTree *tree;
    static void _bind_methods();
    virtual void clamp_position();
public:
    Player();
    Callable bomb_finished;
    Callable timeout_revive;
    Callable timeout_death;
    Callable respawn;

    SET_GET(death_time, double)
    SET_GET(respawn_time, double)
    SET_GET(revive_time, double)
    SET_GET(visual_path, NodePath)
    SET_GET(death_vfx_path, NodePath)

    virtual void _ready() override;
    virtual void _unhandled_input(const Ref<InputEvent> &event) override;

    void _update_position(const Vector2 position);
    virtual void _bomb_away();
    void _bomb_finished();

    void hit();
    void _timeout_death();
    void _sync_death();

    void _timeout_revive();
    void revive();
    void _sync_revive();
};

#endif