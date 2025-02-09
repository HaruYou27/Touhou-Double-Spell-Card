#ifndef BULLET_HPP
#define BULLET_HPP

#include <godot_cpp/classes/node2d.hpp>
#include <godot_cpp/classes/shape2d.hpp>
#include <godot_cpp/classes/physics_shape_query_parameters2d.hpp>
#include <godot_cpp/classes/world2d.hpp>
#include <godot_cpp/classes/physics_direct_space_state2d.hpp>
#include <godot_cpp/classes/thread.hpp>
#include <godot_cpp/classes/rendering_server.hpp>
#include <godot_cpp/classes/scene_tree.hpp>



#include "utility.hpp"

class Bullet : public Node2D
{
GDCLASS(Bullet, Node2D)

private:
    StringName barrel_group;
    bool local_rotation = false;
    Ref<Texture2D> texture;
    float speed = 272.0;
    Ref<Shape2D> hitbox;
    bool grazable = true;
    unsigned int collision_layer = 4;

    static const int max_barrel = 64;
    Node2D *barrels[max_barrel];
    Vector2 barrel_positions[max_barrel];
    float barrel_rotations[max_barrel];
    int count_node = 0;
    int count_barrel = 0;

    void collision_wall();
    void move_bullets();

    Callable action_expire;
    Rect2 world_border = Rect2(-100, -100, 740, 1160);
    Callable action_move;
protected:
    static const int max_bullet = 2000;
    static const int half_bullet = 1000;
    static constexpr float PI_2 = Math_PI / 2;
    Ref<Thread> thread_bullet;
    Ref<Thread> thread_barrel;
    Ref<PhysicsShapeQueryParameters2D> query;
    RID canvas_item;
    
    unsigned int collision_graze = 8;
    float delta32 = 0;
    bool tick = false;
    int indexes_delete[half_bullet];
    int indexes_delete_border[half_bullet];
    int count_expire = 0;
    int count_collided = 0;
    int index_half = 0;
    int count_bullet = 0;

    PhysicsDirectSpaceState2D *space;
    RenderingServer *renderer;
    Node *item_manager;
    Transform2D transforms[max_bullet];
    Vector2 velocities[max_bullet];
    bool grazes[max_bullet];

    virtual bool collide(const Dictionary &result, const int index);
    virtual void move_bullet(const int index);
    virtual void draw_bullet(const int index);
    virtual void cache_barrel();
    virtual bool collision_check(const int index);
    virtual void sort_bullet(const int index);
    virtual void reset_bullet();
    virtual void collide_wall(const int index);

    static void _bind_methods();
    static Object *get_collider(const Dictionary &result);
    static float get_result_mask(const Dictionary &result);
public:
    Bullet();
    SET_GET(speed, float)
    SET_GET(texture, Ref<Texture2D>)
    SET_GET(barrel_group, StringName)
    SET_GET(local_rotation, bool)
    SET_GET(hitbox, Ref<Shape2D>)
    SET_GET(grazable, bool)
    SET_GET(collision_layer, int)

    virtual void _physics_process(const double delta) override;
    virtual void _ready() override;
    virtual void spawn_bullet();
    virtual void spawn_circle(const int count, const Vector2 position);
    void clear();
};
#endif