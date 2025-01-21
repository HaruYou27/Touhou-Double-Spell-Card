#include <item_manager.hpp>

SETTER_GETTER(gravity, float, ItemManager)

void ItemManager::_bind_methods()
{
    BIND_SETGET(gravity, ItemManager)
    ADD_PROPERTY_FLOAT(gravity)

    BIND_FUNCTION(spawn_item, ItemManager);
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
    get_collider(result)->call_deferred("item_collect");
    return true;
}