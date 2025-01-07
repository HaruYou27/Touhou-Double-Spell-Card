#include <bullet_player.hpp>

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

void BulletPlayer::sort_bullet(const int index)
{
    Bullet::sort_bullet(index);
    Vector2& collision_point = positions_collision[index];
    if (count_vfx == half_bullet || collision_point == Vector2(0,0))
    {
        return;
    }
    positions_vfx[count_vfx] = collision_point;
    collision_point = Vector2(0,0);
    frames[count_vfx] = 10;
    count_vfx++;
}

bool BulletPlayer::collide(const Dictionary& result, const int index)
{
    get_collider(result)->call_deferred("hit");
    positions_collision[index] = static_cast<Vector2>(result["point"]);
    return true;
}

void BulletPlayer::cache_barrel()
{
    Bullet::cache_barrel();
    if (count_vfx == 0)
    {
        return;
    }
    for (int index = count_vfx - 1; index >= 0; index--)
    {
        Vector2& position = positions_vfx[index];
        int& frame_count = frames[count_vfx];
        texture_vfx->draw(canvas_item, position, Color(0,0,0));
        frame_count--;

        if (frame_count < 0)
        {
            count_vfx--;
            if (index == count_vfx)
            {
                continue;
            }
            position = positions_vfx[index];
            frame_count = frames[count_vfx];
        }
    }
}