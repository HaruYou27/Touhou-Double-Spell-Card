#ifndef BULLET_Tracker
#define BULLET_Tracker

#include <godot_cpp/classes/area2d.hpp>

#include <bullet.hpp>

using namespace godot;
class Tracker : public Bullet
{
    GDCLASS(Tracker, Bullet);

    private:
        float turn_speed = 7272;
        Vector2 offset = Vector2(0, -256);
        Ref<Shape2D> seek_shape;
        Node2D* seeker;
        Ref<PhysicsShapeQueryParameters2D> seek_query;
        Area2D* target;
        Vector2 target_position;
    protected:
        static void _bind_methods();
        inline void lock_target(int index);
        virtual void move_bullets() override;
        virtual bool collide(Dictionary& result, int index) override;
    public:
        Tracker();
        ~Tracker();

        SET_GET(turn_speed, float)
        SET_GET(offset, Vector2)
        SET_GET(seek_shape, Ref<Shape2D>)

        virtual void spawn_bullet() override;
        virtual void _physics_process(double delta) override;
        virtual void _ready() override;
};
#endif