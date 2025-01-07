#ifndef BULLET_PLAYER
#define BULLET_PLAYER

#include <bullet.hpp>

class BulletPlayer : public Bullet
{
GDCLASS(BulletPlayer, Bullet)
private:
    Ref<Texture2D> texture_vfx;
    Vector2 positions_vfx[half_bullet];
    int index_vfx = 0;
    int frames[half_bullet];
protected:
    static void _bind_methods();
    virtual void cache_barrel() override;
    virtual bool collide(const Dictionary& result, const int index) override;
public:
    BulletPlayer();
    SET_GET(texture_vfx, Ref<Texture2D>)
};

#endif