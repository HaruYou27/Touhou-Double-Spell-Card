#include "master_spark.hpp"

SETTER_GETTER(collision_particle_path, NodePath, MasterSpark)
SETTER_GETTER(ray_path, NodePath, MasterSpark)

void MasterSpark::_bind_methods()
{
    BIND_SETGET(collision_particle_path, MasterSpark)
    BIND_SETGET(ray_path, MasterSpark)
    BIND_FUNCTION(_bomb_finished, MasterSpark)
    BIND_FUNCTION(bomb, MasterSpark)

    ADD_PROPERTY_NODEPATH(collision_particle_path)
    ADD_PROPERTY_NODEPATH(ray_path)
}

MasterSpark::MasterSpark()
{
    query.instantiate();
    query->set_collide_with_areas(true);
    query->set_collide_with_bodies(false);
    query->set_collision_mask(2);
}

void MasterSpark::_bomb_finished(Variant value)
{
    set_physics_process(!is_editor);
}

void MasterSpark::_ready()
{
    is_editor = Engine::get_singleton()->is_editor_hint();
    set_physics_process(!is_editor);
    if (is_editor)
    {
        return;
    }

    screen_effect = get_node<ScreenEffect>("/root/ScreenVFX");
    space = get_world_2d()->get_direct_space_state();

    rays[0] = get_node<Node2D>(ray_path);
    TypedArray<Node> children = rays[0]->get_children();
    for (int idx = 0; idx < max_ray - 1; idx++)
    {
        rays[idx + 1] = Object::cast_to<Node2D>(children[idx]);
    }

    collision_particle = get_node<GPUParticles2D>(collision_particle_path);
}

void MasterSpark::bomb()
{
    set_physics_process(false);
    screen_effect->shake(3);
}

void MasterSpark::_physics_process(double delta)
{
    index = Math::posmod(index, max_ray);
    Vector2 from = rays[index]->get_global_position();
    query->set_from(from);
    index++;
    query->set_to(from - Vector2(0, 960));

    Dictionary result = space->intersect_ray(query);
    if (result.is_empty())
    {
        collision_particle->set_global_position(Vector2(0, 1000));
        return;
    }
    result.make_read_only();
    Node2D *collider = Object::cast_to<Node2D>(result["collider"]);
    collision_particle->set_global_position(collider->get_global_position());
    collider->call("hit");
}
