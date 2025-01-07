#ifndef BULLET_SEEKER
#define BULLET_SEEKER

#include <godot_cpp/classes/area2d.hpp>

#include <bullet_player.hpp>

class Seeker : public BulletPlayer
{
GDCLASS(Seeker, BulletPlayer);
private:
    float turn_speed = 7272;
    Ref<Shape2D> seek_shape;
    Ref<PhysicsShapeQueryParameters2D> seek_query;
    Area2D* targets[max_bullet];
protected:
    static void _bind_methods();
    virtual bool collision_check(const int index) override;
    virtual void move_bullet(const int index) override;
public:
    Seeker();
    SET_GET(turn_speed, float)
    SET_GET(seek_shape, Ref<Shape2D>)
    virtual void _ready() override;
};
#endif