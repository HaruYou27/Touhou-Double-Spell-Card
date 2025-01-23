#ifndef BOSS_HPP
#define BOSS_HPP

#include <godot_cpp/classes/area2d.hpp>
#include <godot_cpp/classes/range.hpp>

#include <utility.hpp>

class Boss : public Area2D
{
GDCLASS(Boss, Area2D)

private:
    int threshold = 2727;
    int item = 0;
    NodePath heath_path;
    Range *heath_bar;
protected:
    static void _bind_methods();
public:
    virtual void _process(double delta) override;
    
    void hit();
    void spawn_item();
};

#endif