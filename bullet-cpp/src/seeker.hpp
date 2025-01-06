#ifndef BULLET_SEEKER
#define BULLET_SEEKER

#include <godot_cpp/classes/area2d.hpp>

#include <bullet.hpp>

using namespace godot;
class Seeker : public Bullet
{
    GDCLASS(Seeker, Bullet);

    private:
        float turn_speed = 7272;
        Ref<Texture2D> texture_vfx;
        Ref<Shape2D> seek_shape;
        Ref<PhysicsShapeQueryParameters2D> seek_query;
        Area2D* targets[max_bullet];
        Transform2D transforms_vfx[max_bullet];
        short index_vfx = 0;
    protected:
        static void _bind_methods();
        virtual void expire_bullet() override;
        virtual bool collide(const Dictionary& result, const short index) override;
        virtual bool collision_check(const short index) override;
        virtual void move_bullet(const short index) override;
        virtual void sort_bullets(short index) override;
    public:
        Seeker();

        SET_GET(turn_speed, float)
        SET_GET(offset, Vector2)
        SET_GET(seek_shape, Ref<Shape2D>)
        SET_GET(texture_vfx, Ref<Texture2D>)

        virtual void _ready() override;
};
#endif