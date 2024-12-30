#include <godot_cpp/classes/node2d.hpp>
#include <godot_cpp/classes/shape2d.hpp>
#include <godot_cpp/classes/physics_shape_query_parameters2d.hpp>
#include <godot_cpp/classes/world2d.hpp>
#include <godot_cpp/classes/physics_direct_space_state2d.hpp>
#include <godot_cpp/classes/worker_thread_pool.hpp>
#include <godot_cpp/classes/rendering_server.hpp>
#include <godot_cpp/classes/scene_tree.hpp>

#define MAX_BULLET 5272
#define SET_GET(var, type) void set_##var(const type value); type get_##var() const;

using namespace godot;
class Bullet : public Node2D
{
    GDCLASS(Bullet, Node2D)
    
    private:
        StringName barrel_group;
        bool local_rotation = false;
        Ref<Texture2D> texture;
        float speed = 272.0;
        std::vector<Node2D*> barrels = std::vector<Node2D*>();;
        Ref<Shape2D> hitbox;
        bool grazable = true;
        bool collide_areas = false;
        bool collide_bodies = true;

        PhysicsShapeQueryParameters2D query;
        unsigned int collision_graze;
        unsigned int collision_layer = 1;
        RID canvas_item;
        static SceneTree* tree;

    protected:
        float delta32;
        bool tick;
        static Ref<World2D> world;
        static RenderingServer* renderer;

        int index_empty = 0;
        Transform2D transforms[MAX_BULLET];
        Vector2 velocities[MAX_BULLET];
        bool grazables[MAX_BULLET];

        static void _bind_methods();
        static inline float get_collision_mask(Dictionary& result) {return Object::cast_to<Vector2>(result["linear_velocity"])->x;}
        static Object get_collider(Dictionary& result);
        virtual void draw_bullets();
        virtual void move_bullets();
        virtual void collision_check();
        virtual void collide();
    public:
        Bullet();
        ~Bullet();

        SET_GET(speed, float);
        SET_GET(texture, Ref<Texture2D>);
        SET_GET(barrel_group, StringName);
        SET_GET(local_rotation, bool);
        SET_GET(hitbox, Ref<Shape2D>);
        SET_GET(grazable, bool);
        SET_GET(collide_areas, bool);
        SET_GET(collide_bodies, bool);
        SET_GET(collision_layer, long);

        virtual void _physics_process(double p_delta) override;
        virtual void _ready() override;

        void spawn_bullet();
        void spawn_circle(long count, Vector2 position);
        void clear();
};