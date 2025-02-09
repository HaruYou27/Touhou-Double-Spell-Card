#ifndef FANTASY_SEAL_HPP
#define FANTASY_SEAL_HPP

#include <godot_cpp/classes/area2d.hpp>
#include <godot_cpp/classes/gpu_particles2d.hpp>
#include <godot_cpp/classes/cpu_particles2d.hpp>

#include "utility.hpp"
#include "screen_effect.hpp"

class FantasySeal : public Area2D
{
GDCLASS(FantasySeal, Area2D)

private:
    Node2D *parent;

    float speed = 527;
    float speed_turn = 727;
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

    virtual void _ready() override;
    virtual void _physics_process(double delta) override;
    virtual void _process(double delta) override;
};

#endif