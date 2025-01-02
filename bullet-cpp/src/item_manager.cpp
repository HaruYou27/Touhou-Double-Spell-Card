#include <item_manager.hpp>

using namespace godot;

ItemManager::ItemManager()
{
}
ItemManager::~ItemManager()
{
}

SETTER_GETTER(gravity, float, ItemManager)
SETTER_GETTER(speed_angular, float, ItemManager)

void ItemManager::_bind_methods()
{
    BIND_SETGET(gravity, ItemManager)
    BIND_SETGET(speed_angular, ItemManager)

    ADD_PROPERTY_FLOAT(gravity)
    ADD_PROPERTY_FLOAT(speed_angular)
}

void ItemManager::create_item(Vector2 position, float random)
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

void ItemManager::spawn_circle(int count, Vector2 position)
{
    CHECK_CAPACITY
    for (int index = 1; index <= count; index++)
    {
        CHECK_CAPACITY
        create_item(position, sinf(position.x * position.y * index));
    }
}

void ItemManager::move_bullet(int index)
{
    GET_BULLET_TRANSFORM
    transform.rotate(speed_angular * delta32);
    velocities[index].y += gravity * delta32;
    Bullet::move_bullet(index);
}

bool ItemManager::collide(Dictionary& result, int index)
{
    GET_COLLIDER
    collider->call_deferred("item_collect");
    return true;
}