#ifndef BULLET
#define BULLET

#include <godot_cpp/classes/node2d.hpp>
#include <godot_cpp/classes/shape2d.hpp>
#include <godot_cpp/classes/physics_shape_query_parameters2d.hpp>
#include <godot_cpp/classes/world2d.hpp>
#include <godot_cpp/classes/physics_direct_space_state2d.hpp>
#include <godot_cpp/classes/worker_thread_pool.hpp>
#include <godot_cpp/classes/rendering_server.hpp>
#include <godot_cpp/classes/scene_tree.hpp>

#define MAX_BULLET 2727
#define SET_GET(var, type) void set_##var(const type value); type get_##var() const;
#define GET_COLLISION_MASK float mask = static_cast<Vector2>(result["linear_velocity"]).x;
#define GET_COLLIDER Object* collider = ObjectDB::get_instance(static_cast<uint64_t>(result["collider_id"]));
#define CHECK_CAPACITY if (index_empty == MAX_BULLET) {return;}
#define BIND_SETGET(var, class) ClassDB::bind_method(D_METHOD("set_"#var, #var), &class::set_##var); ClassDB::bind_method(D_METHOD("get_"#var), &class::get_##var);
#define ADD_PROPERTY_BOOL(var, class) ADD_PROPERTY(PropertyInfo(Variant::BOOL, #var), "set_" #var, "get_" #var);
#define ADD_PROPERTY_FLOAT(var, class) ADD_PROPERTY(PropertyInfo(Variant::FLOAT, #var), "set_" #var, "get_" #var);
#define ADD_PROPERTY_OBJECT(var, type, class) ADD_PROPERTY(PropertyInfo(Variant::OBJECT, #var, PROPERTY_HINT_RESOURCE_TYPE, #type), "set_" #var, "get_" #var);
#define SETTER_GETTER(var, type, class) void Bullet::set_##var(const type value) {var = value;} type Bullet::get_##var() const {return var;}
#define LOOP_BULLET for (int index = 0; index < index_empty; index++)
#define FILL_ARRAY_HOLE(array) array[index] = array[index_empty];
#define BIND_FUNCTION(func, class) ClassDB::bind_method(D_METHOD(#func), &class::func);

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

        PhysicsShapeQueryParameters2D* query;
        unsigned int collision_graze = 0;
        unsigned int collision_layer = 0;
        RID canvas_item;
        SceneTree* tree;

    protected:
        float delta32;
        Rect2 world_border;
        bool tick;
        PackedInt32Array indexes_delete;
        Ref<World2D> world;
        RenderingServer* renderer;
        WorkerThreadPool* threader;

        int index_empty = 0;
        Transform2D transforms[MAX_BULLET];
        Vector2 velocities[MAX_BULLET];
        bool grazables[MAX_BULLET];

        static void _bind_methods();
        virtual void move_bullets();
        Callable action_move = callable_mp(this, &Bullet::move_bullets);
        virtual bool collision_check(int index);
        virtual bool collide(Dictionary& result, int index);
        inline virtual void sort_bullets(int index);
        virtual void expire_bullets();
        Callable action_expire = callable_mp(this, &Bullet::expire_bullets);
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
#endif