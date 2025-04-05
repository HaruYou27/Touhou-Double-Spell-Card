#include "item_manager.hpp"

void ItemManager::_bind_methods()
{
    BIND_FUNCTION(spawn_item, ItemManager)
    BIND_FUNCTION(revive_player, ItemManager)
}

void ItemManager::revive_player()
{
    if (player == nullptr)
    {
        return;
    }
    player->call("revive");
}

void ItemManager::_ready()
{
    set_collision_layer(8);
    set_grazable(true);
    Bullet::_ready();
    collision_graze = 1;
}

void ItemManager::create_item(const Vector2 position, const float random)
{
    float rotation = Math_TAU * random;
    velocities[count_bullet] = Vector2(get_speed() * random, 0).rotated(rotation);
    transforms[count_bullet] = Transform2D(rotation, position);
    
    reset_bullet();
}

void ItemManager::spawn_item(Vector2 position)
{
    CHECK_CAPACITY
    create_item(position, sinf(position.x * position.y));
}

void ItemManager::cache_barrel()
{
    if (player == nullptr)
    {
        player_position = Vector2(0, 0);
        return;
    }
    player_position = player->get_global_position();
}

void ItemManager::spawn_circle(const int count, const Vector2 position)
{
    for (int index = 1; index <= count; index++)
    {
        CHECK_CAPACITY
        create_item(position, sinf(position.x * position.y * index));
    }
}

void ItemManager::sort_bullet(const int index)
{
    FILL_ARRAY_HOLE(distances)
    Bullet::sort_bullet(index);
}

void ItemManager::move_bullet(const int index)
{
    if (grazes[index])
    {
        velocities[index].y += gravity * delta32;
        Spinner::move_bullet(index);
        return;
    }
    
    Transform2D &transform = transforms[index];
    Vector2 local = transform.get_origin() - player_position;
    Vector2 local_origin = player_position;

    distances[index] -= speed_approach * delta32;
    transform.set_origin(local.limit_length(distances[index]) + local_origin);
    draw_bullet(index);
}

Vector2 ItemManager::get_nearest_player(const Vector2 position)
{
    return player_position - position;    
}

bool ItemManager::collide(const Dictionary &result, const int index)
{
    if (grazes[index])
    {
        grazes[index] = false;
        Transform2D &transform = transforms[index];
        transform.set_rotation(PI_2);
        distances[index] = get_nearest_player(transform.get_origin()).length();
        return false;
    }
    Object::cast_to<GrazeBody>(get_collider(result))->item_collect();
    return true;
}