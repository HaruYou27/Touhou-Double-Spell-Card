#include<bullet_player.hpp>

SETTER_GETTER(texture_vfx, Ref<Texture2D>, BulletPlayer)

BulletPlayer::BulletPlayer()
{
    query->set_collide_with_areas(true);
    query->set_collide_with_bodies(false);
}

void BulletPlayer::_bind_methods()
{
    BIND_SETGET(texture_vfx, BulletPlayer)
    ADD_PROPERTY_OBJECT(texture_vfx, Texture2D)
}

bool BulletPlayer::collide(const Dictionary& result, const int index)
{
    get_collider(result)->call_deferred("hit");
    positions_vfx[index_vfx] = static_cast<Vector2>(result["point"]);
    frames[index_vfx] = 5;
    index_vfx++;
    return true;
}

void BulletPlayer::cache_barrel()
{
    Bullet::cache_barrel();
    if (index_vfx == 0)
    {
        return;
    }
    for (int index = index_vfx - 1; index >= 0; index--)
    {
        Vector2& position = positions_vfx[index];
        texture_vfx->draw(canvas_item, position, Color(0,0,0));
        frames[index_vfx]--;

        if (frames[index_vfx] == 0)
        {
            index_vfx--;
            if (index == index_vfx)
            {
                continue;
            }
            position = positions_vfx[index];
        }
    }
}