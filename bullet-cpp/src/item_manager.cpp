#include <item_manager.hpp>

using namespace godot;

SETTER_GETTER(gravity, float, ItemManager)
SETTER_GETTER(speed_angular, float, ItemManager)

void ItemManager::_bind_methods()
{
    BIND_SETGET(gravity, ItemManager)
    BIND_SETGET(speed_angular, ItemManager)

    ADD_PROPERTY_FLOAT(gravity)
    ADD_PROPERTY_FLOAT(speed_angular)

    BIND_FUNCTION(spawn_item, ItemManager);
}

void ItemManager::create_item(const Vector2 position, const float random)
{
    float rotation = Math_TAU * random;
    velocities[index_empty] = Vector2(get_speed() * random, 0).rotated(rotation);
    transforms[index_empty] = Transform2D(rotation, position);
    index_empty++;
}

void ItemManager::spawn_item(Vector2 position)
{
    CHECK_CAPACITY
    create_item(position, sinf(position.x * position.y));
}

void ItemManager::spawn_circle(const signed long count, const Vector2 position)
{
    CHECK_CAPACITY
    for (short index = 1; index <= count; index++)
    {
        CHECK_CAPACITY
        create_item(position, sinf(position.x * position.y * index));
    }
}

void ItemManager::move_bullet(const short index)
{
    Transform2D& transform = transforms[index];
    transform.set_rotation(transform.get_rotation() + speed_angular * delta32);
    velocities[index].y += gravity * delta32;
    Bullet::move_bullet(index);
}

bool ItemManager::collide(const Dictionary& result, const short index)
{
    get_collider(result)->call_deferred("item_collect");
    return true;
}