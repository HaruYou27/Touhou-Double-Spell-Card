#ifndef PLAYER_HPP
#define PLAYER_HPP

#include <godot_cpp/classes/static_body2d.hpp>
#include <godot_cpp/classes/input_event_screen_drag.hpp>

#include <utility.hpp>
#include <item_manager.hpp>

class Player : public StaticBody2D
{
GDCLASS(Player, StaticBody2D)

private:
    float sentivity = 1.2;
protected:
    static void _bind_methods();
    virtual void clamp_position();
public:
    SET_GET(sentivity, float)
    virtual void _ready() override;
    virtual void _input(const Ref<InputEvent> &event) override;
};

#endif