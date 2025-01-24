#ifndef BOSS_HPP
#define BOSS_HPP

#include <godot_cpp/classes/area2d.hpp>
#include <godot_cpp/classes/range.hpp>
#include <godot_cpp/classes/tween.hpp>
#include <godot_cpp/classes/property_tweener.hpp>

#include <utility.hpp>
#include <item_manager.hpp>
#include <player.hpp>

class Boss : public Area2D
{
GDCLASS(Boss, Area2D)

private:
    int threshold = 2727;
    int item = 0;

    NodePath heath_path;
    Range *heath_bar;
    ItemManager *item_manager;
    Ref<Tween> tween;
protected:
    static void _bind_methods();
public:
    virtual void _ready() override;
    virtual void _process(double delta) override;
    SET_GET(threshold, int)
    SET_GET(heath_path, NodePath)
    
    void hit();
    void spawn_item();
    void _body_entered(Node2D *body);
};

#endif