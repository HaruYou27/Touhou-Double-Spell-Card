#include <fantasy_seal.hpp>

SETTER_GETTER(speed, float, FantasySeal)
SETTER_GETTER(speed_turn, float, FantasySeal)
SETTER_GETTER(speed_angular, float, FantasySeal)
SETTER_GETTER(velocity_inital, Vector2, FantasySeal)
SETTER_GETTER(exploder_path, NodePath, FantasySeal)
SETTER_GETTER(hitbox_path, NodePath, FantasySeal)
SETTER_GETTER(particle_seal_fb_path, NodePath, FantasySeal)
SETTER_GETTER(particle_explosion_path, NodePath, FantasySeal)
SETTER_GETTER(particle_seal_path, NodePath, FantasySeal)
SETTER_GETTER(particle_tail_path, NodePath, FantasySeal)

void FantasySeal::_bind_methods()
{
    BIND_SETGET(speed, FantasySeal)
    BIND_SETGET(speed_turn, FantasySeal)
    BIND_SETGET(speed_angular, FantasySeal)
    BIND_SETGET(velocity_inital, FantasySeal)
    BIND_SETGET(particle_tail_path, FantasySeal)
    BIND_SETGET(particle_seal_path, FantasySeal)
    BIND_SETGET(particle_explosion_path, FantasySeal)
    BIND_SETGET(particle_seal_fb_path, FantasySeal)
    BIND_SETGET(hitbox_path, FantasySeal)
    BIND_SETGET(exploder_path, FantasySeal)

    ADD_PROPERTY_NODEPATH(particle_tail_path)
    ADD_PROPERTY_NODEPATH(particle_seal_path)
    ADD_PROPERTY_NODEPATH(particle_explosion_path)
    ADD_PROPERTY_NODEPATH(particle_seal_fb_path)
    ADD_PROPERTY_NODEPATH(hitbox_path)
    ADD_PROPERTY_NODEPATH(exploder_path)
    ADD_PROPERTY_FLOAT(speed_angular)
    ADD_PROPERTY_FLOAT(speed)
    ADD_PROPERTY_FLOAT(speed_turn)
    ADD_PROPERTY_VECTOR2(velocity_inital)
}

void FantasySeal::_ready()
{
    set_as_top_level(false);
    CHECK_EDITOR
    call_deferred("_toggle", false);

    parent = Object::cast_to<Node2D>(get_parent());
    screen_effect = get_node<ScreenEffect>("/root/SrceenVFX");

    hitbox = get_node<Area2D>(hitbox_path);
    hitbox->connect("area_entered", callable_mp(this, &FantasySeal::_explode));
    exploder = get_node<Node>(exploder_path);
    particle_tail = get_node<GPUParticles2D>(particle_tail_path);
    particle_seal = get_node<GPUParticles2D>(particle_seal_path);
    particle_seal_fb = get_node<CPUParticles2D>(particle_seal_fb_path);
    particle_explosion = get_node<GPUParticles2D>(particle_explosion_path);
    particle_explosion->connect("finished", callable_mp(this, &FantasySeal::_explosion_finished));
}

void FantasySeal::_toggle(const bool on)
{
    particle_seal->set_emitting(on);
    particle_tail->set_emitting(on);
    particle_seal_fb->set_emitting(on);
    
    set_process(on);
    hitbox->set_monitoring(on);
    set_monitoring(on);
    set_as_top_level(false);
    target = nullptr;
}

void FantasySeal::_explosion_finished()
{
    call_deferred("_toggle_exploder", false);
}

void FantasySeal::_toggle_exploder(const bool on)
{
    exploder->set_process_mode((on) ? PROCESS_MODE_INHERIT : PROCESS_MODE_DISABLED);
}

void FantasySeal::_explode(const Variant &value)
{
    screen_effect->flash(0.3);
    screen_effect->shake(0.3);
    particle_explosion->set_emitting(true);
    call_deferred("_toggle", false);
    call_deferred("_toggle_exploder", true);
}

void FantasySeal::_process(double delta)
{
    if (life_time < 1)
    {
        rotation_local += speed_angular * delta;
        position_local += velocity_inital * delta;
        set_global_position(parent->to_global(position_local.rotated(rotation_local)));

        life_time += delta;
        return;
    }
    life_time = 0;
    velocity = Vector2(speed, 0).rotated(get_rotation());
    set_physics_process(true);
    set_process(false);
    set_as_top_level(true);
}

void FantasySeal::_physics_process(double delta)
{
    translate(velocity * delta);
    if (target == nullptr)
    {
        if (has_overlapping_areas())
        {
            target = Object::cast_to<Area2D>(get_overlapping_areas().front());
        }
        else
        {
            return;
        }
    }
    if (!target->is_monitorable())
    {
        target = nullptr;
        return;
    }
    velocity += (target->get_global_position() - get_global_position()).normalized() * speed_turn;
    velocity.normalize();
    velocity *= speed;
}