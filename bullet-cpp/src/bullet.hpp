#ifndef BULLET
#define BULLET

#include <godot_cpp/classes/node2d.hpp>
#include <godot_cpp/classes/shape2d.hpp>
#include <godot_cpp/classes/physics_shape_query_parameters2d.hpp>
#include <godot_cpp/classes/world2d.hpp>
#include <godot_cpp/classes/physics_direct_space_state2d.hpp>
#include <godot_cpp/classes/worker_thread_pool.hpp>
#include <godot_cpp/classes/thread.hpp>
#include <godot_cpp/classes/rendering_server.hpp>
#include <godot_cpp/classes/scene_tree.hpp>
#include <godot_cpp/classes/engine.hpp>

#define SET_GET(var, type) void set_##var(const type value); type get_##var() const;
#define CHECK_CAPACITY if (index_empty == max_bullet) {return;}
#define BIND_SETGET(var, class) ClassDB::bind_method(D_METHOD("set_"#var, #var), &class::set_##var); ClassDB::bind_method(D_METHOD("get_"#var), &class::get_##var);
#define ADD_PROPERTY_BOOL(var) ADD_PROPERTY(PropertyInfo(Variant::BOOL, #var), "set_" #var, "get_" #var);
#define ADD_PROPERTY_FLOAT(var) ADD_PROPERTY(PropertyInfo(Variant::FLOAT, #var), "set_" #var, "get_" #var);
#define ADD_PROPERTY_OBJECT(var, type) ADD_PROPERTY(PropertyInfo(Variant::OBJECT, #var, PROPERTY_HINT_RESOURCE_TYPE, #type), "set_" #var, "get_" #var);
#define ADD_PROPERTY_COLLISION(var) ADD_PROPERTY(PropertyInfo(Variant::INT, #var, PROPERTY_HINT_LAYERS_2D_PHYSICS), "set_" #var, "get_" #var);
#define SETTER_GETTER(var, type, class) void class::set_##var(const type value) {var = value;} type class::get_##var() const {return var;}
#define FILL_ARRAY_HOLE(array) array[index] = array[index_empty];
#define BIND_FUNCTION(func, class) ClassDB::bind_method(D_METHOD(#func), &class::func);
#define IS_BULLETS_EMPTY if (index_empty == 0) {return;}
#define NEW_OBJECT(class) Ref<class>(memnew(class()));

using namespace godot;
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
        bool collide_areas = false;
        bool collide_bodies = true;

        Ref<PhysicsShapeQueryParameters2D> query;
        unsigned int collision_graze = 0;
        unsigned int collision_layer = 4;
        SceneTree* tree;
        void expire_bullets();
        void move_bullets();
        Callable action_expire;
        Rect2 world_border;
        Callable action_move;
        WorkerThreadPool* threader;
        Engine* engine;
    protected:
        static const short max_bullet = 2727;
        Ref<Thread> task_move;
        std::vector<Node2D*> barrels;
        RID canvas_item;
        float delta32 = 0;
        bool tick = false;
        short indexes_delete[max_bullet];
        short index_expire = max_bullet - 1;
        short index_collided = 0;
        short index_half;
        PhysicsDirectSpaceState2D* space;
        RenderingServer* renderer;
        Node* item_manager;

        short index_empty = 0;
        Transform2D transforms[max_bullet];
        Vector2 velocities[max_bullet];
        bool grazes[max_bullet];
        static void _bind_methods();
        virtual bool collide(const Dictionary& result, const short index);
        virtual void move_bullet(const short index);
        virtual void expire_bullet();
        virtual bool collision_check(const short index);
        virtual void sort_bullets(short index);
        virtual void reset_bullet();
        static Object* get_collider(const Dictionary& result);
        static float get_collision_mask(const Dictionary& result);
    public:
        Bullet();

        SET_GET(speed, float)
        SET_GET(texture, Ref<Texture2D>)
        SET_GET(barrel_group, StringName)
        SET_GET(local_rotation, bool)
        SET_GET(hitbox, Ref<Shape2D>)
        SET_GET(grazable, bool)
        SET_GET(collide_areas, bool)
        SET_GET(collide_bodies, bool)
        SET_GET(collision_layer, int)

        virtual void _physics_process(const double delta) override;
        virtual void _ready() override;

        virtual void spawn_bullet();
        virtual void spawn_circle(const signed long count, const Vector2 position);
        void clear();
};
#endif