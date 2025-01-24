#include <screen_effect.hpp>

SETTER_GETTER(noise, Ref<Noise>, ScreenEffect)

void ScreenEffect::_bind_methods()
{
    BIND_FUNCTION(flash_red, ScreenEffect);
    BIND_SETGET(noise, ScreenEffect);
    ADD_PROPERTY_OBJECT(noise, Ref<Noise>);

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
    level_loader = get_node<Node>("/root/LevelLoader");
    shake_intensity = static_cast<double>(get_node<Node>("/root/Global")->get("user_data").get("screen_shake_intensity"));
    time = Time::get_singleton();
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
    tween->connect("finished", Callable(this, "hide"));
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
    tween->connect("finished", Callable(this, "hide"));
}

void ScreenEffect::shake(const double duration)
{
    set_process(true);
    shake_duration += duration;
    scene = Object::cast_to<Control>(level_loader->get("scene"));
}

void ScreenEffect::_process(double delta)
{
    shake_duration -= delta;
    if ((shake_duration < 0) || (shake_intensity < 0.001))
    {
        set_process(false);
        shake_duration = 0;
        scene->set_position(Vector2(0, 0));
        scene->set_rotation_degrees(0);
        return;
    }
    int msec = time->get_ticks_msec();
    int usec = time->get_ticks_usec();
    scene->set_position((scene->get_position() + 
        Vector2(noise->get_noise_2d(-usec, msec),
            noise->get_noise_2d(usec, -msec))).clampf(-5, 5));
    scene->set_rotation_degrees(Math::clamp<double>(scene->get_rotation_degrees() + noise->get_noise_1d(msec), -0.25, 0.25));
}