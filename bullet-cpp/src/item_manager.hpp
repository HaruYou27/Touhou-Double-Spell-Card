#ifndef ITEM_MANAGER
#define ITEM_MANAGER

#include <bullet.hpp>

using namespace godot;

class ItemManager : public Bullet
{
    GDCLASS(ItemManager, Bullet)
    
    private:
        float gravity;
        float speed_angular;
    protected:
        static void _bind_methods();
        inline void create_item(Vector2 position, float random);
        virtual bool collide(Dictionary& result, int index) override;
        virtual void move_bullet(int index) override;
    public:
        ItemManager();
        ~ItemManager();
        
        SET_GET(gravity, float)
        SET_GET(speed_angular, float)
        void spawn_item(Vector2 position);
        virtual void spawn_circle(int count, Vector2 position) override;
};
#endif