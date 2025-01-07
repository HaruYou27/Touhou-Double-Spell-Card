#ifndef ITEM_MANAGER
#define ITEM_MANAGER

#include <bullet.hpp>

using namespace godot;

class ItemManager : public Bullet
{
    GDCLASS(ItemManager, Bullet)
    
    private:
        float gravity = 98;
        float speed_angular = Math_PI;
    protected:
        static void _bind_methods();
        inline void create_item(const Vector2 position, const float random);
        virtual bool collide(const Dictionary& result, const int index) override;
        virtual void move_bullet(const int index) override;
    public:
        SET_GET(gravity, float)
        SET_GET(speed_angular, float)
        void spawn_item(const Vector2 position);
        virtual void spawn_circle(const int count, const Vector2 position) override;
};
#endif