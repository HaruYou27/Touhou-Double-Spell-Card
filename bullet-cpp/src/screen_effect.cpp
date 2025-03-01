#include "screen_effect.hpp"

void ScreenEffect::_bind_methods()
{
    BIND_FUNCTION(flash_red, ScreenEffect);
    BIND_FUNCTION(reset, ScreenEffect);

    ClassDB::bind_method(D_METHOD("fade2black", "reverse"), &ScreenEffect::fade2black);
    ClassDB::bind_method(D_METHOD("flash", "duration"), &ScreenEffect::flash);
    ClassDB::bind_method(D_METHOD("shake", "duration"), &ScreenEffect::shake);
}

void ScreenEffect::_ready()
{
    set_process(false);
    hide();
    set_custom_minimum_size(Vector2(540, 960));
    set_z_index(4090);
    CHECK_EDITOR
    time = Time::get_singleton();
    level_loader = get_node<Node>("/root/LevelLoader");
    shake_intensity = static_cast<double>(get_node<Node>("/root/Global")->get("user_data").get("screen_shake_intensity"));
}

Ref<Tween> ScreenEffect::fade2black(const bool reverse)
{
    show();
    REPLACE_TWEEN(tween)
    if (reverse)
    {
        set_color(Color(0,0,0));
        tween->tween_property(this, "color", Color(0, 0, 0, 0), 0.5);
    }
    else
    {
        set_color(Color(0, 0, 0, 0));
        tween->tween_property(this, "color", Color(0, 0, 0, 1), 0.5);
    }
    tween->connect("finished", action_hide, CONNECT_ONE_SHOT);
    return tween;
}

void ScreenEffect::flash_red()
{
    show();
    set_color(Color(0.996078, 0.203922, 0.203922, 0.592157));
}

void ScreenEffect::flash(const double duration)
{
    show();
    set_color(Color(1, 1, 1, 0.5));
    REPLACE_TWEEN(tween)
    tween->tween_property(this, "color", Color(1, 1, 1, 0), duration);
    tween->connect("finished", action_hide, CONNECT_ONE_SHOT);
}

void ScreenEffect::shake(const double duration)
{
    set_process(true);
    trauma += duration;
    scene = Object::cast_to<Control>(level_loader->get("scene"));
}

void ScreenEffect::reset()
{
    trauma = 0;
    set_process(false);
}

void ScreenEffect::_process(double delta)
{
    trauma -= delta;
    if ((trauma < 0) || (shake_intensity < 0.001))
    {
        set_process(false);
        trauma = 0;
        scene->set_position(Vector2(0, 0));
        scene->set_rotation(0);
        return;
    }

    int usec = time->get_ticks_usec();
    float sin_usec = sin(usec);
    scene->set_rotation(sin_usec * 0.01);
    
    Vector2 offset = Vector2(sin_usec, cos(usec));
    offset.normalize();
    offset *= 5 * sin_usec;

    scene->set_position(offset);
}