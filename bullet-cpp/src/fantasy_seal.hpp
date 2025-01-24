#ifndef FANTASY_SEAL_HPP
#define FANTASY_SEAL_HPP

#include <godot_cpp/classes/area2d.hpp>
#include <godot_cpp/classes/gpu_particles2d.hpp>
#include <godot_cpp/classes/cpu_particles2d.hpp>

#include <utility.hpp>
#include <screen_effect.hpp>

class FantasySeal : public Area2D
{
GDCLASS(FantasySeal, Area2D)

private:

    NodePath particle_tail_path;
    NodePath particle_seal_path;
    NodePath particle_explosion_path;
    NodePath particle_seal_fb_path;
    NodePath hitbox_path;
    NodePath exploder_path;

    Area2D *hitbox;
    Node *exploder;
    GPUParticles2D *particle_tail;
    GPUParticles2D *particle_seal;
    GPUParticles2D *particle_explosion;
    CPUParticles2D *particle_seal_fb;

    Area2D *target;
    ScreenEffect *screen_effect;
    Node2D *parent;

    float speed = 527;
    float speed_turn = 127;
    float speed_angular = Math_PI;
    Vector2 velocity_inital;

    double life_time = 0;
    Vector2 velocity = Vector2(0, -1);
    Vector2 position_local = Vector2(0, 0);
    float rotation_local = 0;
protected:
    static void _bind_methods();
public:
    SET_GET(speed, float)
    SET_GET(speed_turn, float)
    SET_GET(speed_angular, float)
    SET_GET(velocity_inital, Vector2)
    SET_GET(exploder_path, NodePath)
    SET_GET(particle_tail_path, NodePath)
    SET_GET(particle_seal_path, NodePath)
    SET_GET(particle_explosion_path, NodePath)
    SET_GET(particle_seal_fb_path, NodePath)
    SET_GET(hitbox_path, NodePath)

    virtual void _ready() override;
    virtual void _physics_process(double delta) override;
    virtual void _process(double delta) override;

    void _explode(const Variant &value);
    void _explosion_finished();
    void _toggle(const bool on);
    void _toggle_exploder(const bool on);
};

#endif