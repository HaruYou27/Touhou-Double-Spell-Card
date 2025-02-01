#include <item_manager.hpp>

SETTER_GETTER(gravity, float, ItemManager)

void ItemManager::_bind_methods()
{
    BIND_SETGET(gravity, ItemManager)
    ADD_PROPERTY_FLOAT(gravity)

    BIND_FUNCTION(spawn_item, ItemManager);
    BIND_FUNCTION(is_offline, ItemManager);
    BIND_FUNCTION(revive_player, ItemManager);
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
    if (player1 == nullptr)
    {
        return Vector2(0, 0);
    }
    Vector2 direction1 = position1 - position;
    if (player2 == nullptr)
    {
        return direction1;
    }
    Vector2 direction2 = position2 - position;
    if (direction2.length_squared() < direction1.length_squared())
    {
        return direction2;
    }
    return direction1;
}

void ItemManager::cache_barrel()
{
    if (player1 == nullptr)
    {
        return;
    }
    position1 = player1->get_global_position();
    if (player2 == nullptr)
    {
        return;
    }
    position2 = player2->get_global_position();
}

void ItemManager::_ready()
{
    Bullet::_ready();
}

void ItemManager::create_item(const Vector2 position, const float random)
{
    float rotation = Math_TAU * random;
    velocities[count_bullet] = Vector2(get_speed() * random, 0).rotated(rotation);
    transforms[count_bullet] = Transform2D(rotation, position);
    count_bullet++;
}

void ItemManager::spawn_item(Vector2 position)
{
    CHECK_CAPACITY
    create_item(position, sinf(position.x * position.y));
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

void ItemManager::move_bullet(const int index)
{
    velocities[index].y += gravity * delta32;
    Spinner::move_bullet(index);
}

bool ItemManager::collide(const Dictionary &result, const int index)
{
    Object::cast_to<GrazeBody>(get_collider(result))->item_collect();
    return true;
}