#ifndef ITEM_MANAGER_HPP
#define ITEM_MANAGER_HPP

#include <spinner.hpp>

using namespace godot;

class ItemManager : public Spinner
{
    GDCLASS(ItemManager, Spinner)
    
    private:
        float gravity = 98;
    protected:
        static void _bind_methods();
        inline void create_item(const Vector2 position, const float random);
        virtual bool collide(const Dictionary &result, const int index) override;
        virtual void move_bullet(const int index) override;
    public:
        SET_GET(gravity, float)
        void spawn_item(const Vector2 position);
        virtual void spawn_circle(const int count, const Vector2 position) override;
};
#endif