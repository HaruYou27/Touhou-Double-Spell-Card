#ifndef MASTER_SPARK_HPP
#define MASTER_SPARK_HPP

#include <godot_cpp/classes/node2d.hpp>
#include <godot_cpp/classes/physics_ray_query_parameters2d.hpp>
#include <godot_cpp/classes/physics_direct_space_state2d.hpp>
#include <godot_cpp/classes/gpu_particles2d.hpp>
#include <godot_cpp/classes/world2d.hpp>

#include <utility.hpp>
#include <screen_effect.hpp>

class MasterSpark : public Node2D
{
GDCLASS(MasterSpark, Node2D)

private:
    static const int max_ray = 3;
    NodePath animator_path;
    NodePath collision_particle_path;
    NodePath ray_path;
    
    ScreenEffect *screen_effect;
    GPUParticles2D *collision_particle;
    PhysicsDirectSpaceState2D *space;
    Node2D *rays[max_ray];
    Ref<PhysicsRayQueryParameters2D> query;
    int index = 0;
    bool is_editor;
protected:
    static void _bind_methods();
public:
    MasterSpark();
    SET_GET(animator_path, NodePath)
    SET_GET(collision_particle_path, NodePath)
    SET_GET(ray_path, NodePath)

    void bomb();
    void _bomb_finished(Variant value);

    virtual void _ready() override;
    virtual void _physics_process(double delta) override;
};

#endif