#ifndef ENEMY_HPP
#define ENEMY_HPP

#include <godot_cpp/classes/area2d.hpp>
#include <godot_cpp/classes/cpu_particles2d.hpp>

#include <utility.hpp>
#include <item_manager.hpp>
#include <player.hpp>

class Enemy : public Area2D
{
GDCLASS(Enemy, Area2D)

private:
    int heath = 4;
    bool is_alive = false;

    NodePath explosion_path;
    NodePath visual_path;
    
    Node *sound_effect;
    ItemManager *item_manager;
protected:
    int item = 4;
    CPUParticles2D *explosion;
    Node2D *visual;

    static void _bind_methods();
    void die();
    void disable();
public:
    virtual void _ready() override;
    void timeout();
    void reset();
    void hit();
    void _body_entered(Node2D *body);

    SET_GET(explosion_path, NodePath)
    SET_GET(visual_path, NodePath)
    SET_GET(heath, int)
    SET_GET(item, int)
    SET_GET(is_alive, bool)
};

#endif