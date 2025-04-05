#ifndef ITEM_MANAGER_HPP
#define ITEM_MANAGER_HPP

#include "spinner.hpp"
#include "graze_body.hpp"

class ItemManager : public Spinner
{
GDCLASS(ItemManager, Spinner)

private:
    static constexpr float gravity = 98;
    static constexpr float speed_approach = 127;
    Vector2 player_position;
protected:
    static void _bind_methods();
    inline void create_item(const Vector2 position, const float random);
    virtual bool collide(const Dictionary &result, const int index) override;
    virtual void move_bullet(const int index) override;
    virtual void cache_barrel() override;
    virtual void sort_bullet(const int index) override;
    
    float distances[max_bullet];
public:
    Node2D *player;
    void revive_player();
    Vector2 get_nearest_player(const Vector2 position);

    void spawn_item(const Vector2 position);
    virtual void spawn_circle(const int count, const Vector2 position) override;
    virtual void _ready() override;
};
#endif