#ifndef BULLET_PLAYER_HPP
#define BULLET_PLAYER_HPP

#include "bullet.hpp"

class BulletPlayer : public Bullet
{
GDCLASS(BulletPlayer, Bullet)
private:
    Ref<Texture2D> texture_vfx;
    Vector2 positions_vfx[half_bullet];
    Vector2 positions_collision[max_bullet];

    int count_vfx = 0;
    int frames[half_bullet];
protected:
    static void _bind_methods();
    virtual void cache_barrel() override;
    virtual bool collide(const Dictionary &result, const int index) override;
    virtual void sort_bullet(const int index) override;
public:
    BulletPlayer();
    SET_GET(texture_vfx, Ref<Texture2D>)
};

#endif