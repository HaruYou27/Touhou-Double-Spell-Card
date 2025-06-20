#ifndef SCREEN_EFFECT_HPP
#define SCREEN_EFFECT_HPP

#include <godot_cpp/classes/color_rect.hpp>
#include <godot_cpp/classes/tween.hpp>
#include <godot_cpp/classes/property_tweener.hpp>
#include <godot_cpp/classes/time.hpp>
#include <godot_cpp/classes/random_number_generator.hpp>

#include "utility.hpp"

class ScreenEffect : public ColorRect
{
GDCLASS(ScreenEffect, ColorRect)
private:
    double shake_intensity = 1;
    double trauma = 0;
    
    Ref<Tween> tween;
    Control *scene;
    Node *level_loader;
    Time *time;

    Callable action_hide = Callable(this, "hide");
protected:
    static void _bind_methods();
public:
    virtual void _ready() override;
    virtual void _process(double delta) override;

    void shake(const double duration);
    void flash_red();
    void flash(const double duration);
    Ref<Tween> fade2black(const bool reverse = false);
    void reset();
};

#endif