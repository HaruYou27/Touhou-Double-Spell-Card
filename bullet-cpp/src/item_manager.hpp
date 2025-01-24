#ifndef ITEM_MANAGER_HPP
#define ITEM_MANAGER_HPP

#include <spinner.hpp>
#include <graze_body.hpp>

class ItemManager : public Spinner
{
    GDCLASS(ItemManager, Spinner)
    
    private:
        float gravity = 98;
        
        Vector2 position1;
        Vector2 position2;
    protected:
        static void _bind_methods();
        inline void create_item(const Vector2 position, const float random);
        virtual bool collide(const Dictionary &result, const int index) override;
        virtual void move_bullet(const int index) override;
        virtual void cache_barrel() override;
    public:
        Node2D *player1;
        Node2D *player2;
        SET_GET(gravity, float)
        
        void spawn_item(const Vector2 position);
        void get_players();
        Vector2 get_nearest_player(const Vector2 position);
        bool is_offline();

        virtual void spawn_circle(const int count, const Vector2 position) override;
        virtual void _ready() override;
};
#endif