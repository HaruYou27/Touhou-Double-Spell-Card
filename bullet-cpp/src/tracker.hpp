#ifndef BULLET_Tracker
#define BULLET_Tracker

#include <godot_cpp/classes/node2d.hpp>

#include <bullet.hpp>

using namespace godot;
class Tracker : public Bullet
{
    GDCLASS(Tracker, Bullet);

    private:
        float turn_speed = 7272;
        Ref<Shape2D> seek_shape;
        Node2D* seeker;
        PhysicsShapeQueryParameters2D* seek_query;
        Node2D* target;
    protected:
        static void _bind_methods();
        inline void lock_target(int index);
        virtual void move_bullets() override;
        virtual bool collide(Dictionary& result, int index) override;
    public:
        Tracker();
        ~Tracker();

        SET_GET(turn_speed, double)
        SET_GET(seek_shape, Ref<Shape2D>)

        virtual void spawn_bullet() override;
        virtual void _physics_process(double delta) override;
        virtual void _ready() override;
};
#endif