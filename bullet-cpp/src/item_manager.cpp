#include "item_manager.hpp"

void ItemManager::_bind_methods()
{
    BIND_FUNCTION(spawn_item, ItemManager)
    BIND_FUNCTION(is_offline, ItemManager)
    BIND_FUNCTION(revive_player, ItemManager)
    ClassDB::bind_method(D_METHOD("get_nearest_player", "position"), &ItemManager::get_nearest_player);
}

bool ItemManager::is_offline()
{
    if (player2 == nullptr)
    {
        return true;
    }
    return false;
}

void ItemManager::revive_player()
{
    // Dirty fix.
    player1->call("revive");
}

Vector2 ItemManager::get_nearest_player(const Vector2 position)
{
    Vector2 direction1 = player1_position - position;
    if (player2 == nullptr)
    {
        return direction1;
    }
    Vector2 direction2 = player2_position - position;

    return (direction2.length_squared() < direction1.length_squared()) ? direction2 : direction1;
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
    player1_position = (player1 == nullptr) ? Vector2(0, 0) : player1->get_global_position();
    player2_position = (player2 == nullptr) ? Vector2(0, 0) : player2->get_global_position();
}

void ItemManager::spawn_circle(const int count, const Vector2 position)
{
    CHECK_CAPACITY
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
    transform.set_rotation(transform.get_rotation() + get_speed_angular() * delta32);
    
    Vector2 local = transform.get_origin() - player1_position;
    Vector2 local_origin = player1_position;
    if (player2 != nullptr)
    {
        Vector2 point2 = transform.get_origin() - player2_position;
        if (point2.length_squared() < local.length_squared())
        {
            local = point2;
            local_origin = player2_position;
        }
    }

    distances[index] -= speed_approach * delta32;
    transform.set_origin(local.limit_length(distances[index]) + local_origin);
    draw_bullet(index);
}

bool ItemManager::collide(const Dictionary &result, const int index)
{
    if (grazes[index])
    {
        grazes[index] = false;
        Transform2D &transform = transforms[index];
        distances[index] = get_nearest_player(transform.get_origin()).length();
        return false;
    }
    Object::cast_to<GrazeBody>(get_collider(result))->item_collect();
    return true;
}