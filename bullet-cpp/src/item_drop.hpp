#ifndef ITEM_DROP_HPP
#define ITEM_DROP_HPP

#include <godot_cpp/classes/area2d.hpp>

#include "utility.hpp"
#include "score_manager.hpp"

class ItemDrop : public Area2D
{
GDCLASS(ItemDrop, Area2D)
    
private:
    const Rect2 world_border = Rect2(-100, -100, 740, 1160);

    float gravity = 98;
    Vector2 velocity = Vector2(0, 0);
    ScoreManager *global_score;

    void disable();
protected:
    static void _bind_methods();
public:
    SET_GET(gravity, float)
    SET_GET(velocity, Vector2)

    virtual void _ready() override;
    virtual void _physics_process(const double delta) override;

    void _visibility_changed();
    void _body_entered(Node2D *body);
};

#endif