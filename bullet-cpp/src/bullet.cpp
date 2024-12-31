#include <bullet.hpp>

using namespace godot;

void Bullet::_bind_methods()
{
    BIND_SETGET(speed)
    BIND_SETGET(barrel_group)
    BIND_SETGET(local_rotation)
    BIND_SETGET(texture)
    BIND_SETGET(hitbox)
    BIND_SETGET(grazable)
    BIND_SETGET(collide_areas)
    BIND_SETGET(collide_bodies)
    BIND_SETGET(collision_layer)

    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "speed"), "set_speed", "get_speed");
    ADD_PROPERTY(PropertyInfo(Variant::STRING_NAME, "barrel_group", PROPERTY_HINT_TYPE_STRING), "set_barrel_group", "get_barrel_group");
    ADD_PROPERTY_OBJECT(hitbox, Shape2D)
    ADD_PROPERTY_OBJECT(texture, Texture2D)
    ADD_PROPERTY_BOOL(grazable)
    ADD_PROPERTY_BOOL(collide_areas)
    ADD_PROPERTY_BOOL(collide_bodies)
    ADD_PROPERTY_BOOL(local_rotation)
    ADD_PROPERTY(PropertyInfo(Variant::INT, "collision_mask", PROPERTY_HINT_LAYERS_2D_PHYSICS), "set_collision_mask", "get_collision_mask");
}

SETTER_GETTER(speed, float)
SETTER_GETTER(texture, Ref<Texture2D>)
SETTER_GETTER(barrel_group, StringName)
SETTER_GETTER(local_rotation, bool)
SETTER_GETTER(hitbox, Ref<Shape2D>)
SETTER_GETTER(collide_areas, bool)
SETTER_GETTER(grazable, bool)
SETTER_GETTER(collide_bodies, bool)
SETTER_GETTER(collision_layer, long)

void Bullet::_ready()
{
    canvas_item = get_canvas_item();
    collision_graze = collision_layer + 8;
    tree = get_tree();
    world = get_world_2d();
    renderer = RenderingServer::get_singleton();
    threader = WorkerThreadPool::get_singleton();

    query.set_shape(hitbox);
    query.set_collide_with_areas(collide_areas);
    query.set_collide_with_bodies(collide_bodies);

    TypedArray<Node> nodes = tree->get_nodes_in_group(barrel_group);
    int index_halt = nodes.size();
    for (int index = 0; index < index_halt; index++)
    {
        Node* node = Object::cast_to<Node>(nodes[index]);
        if (node->is_class("Node2D"))
        {
            barrels.push_back(Object::cast_to<Node2D>(node));
        }
    }
}

void Bullet::spawn_bullet()
{
    CHECK_CAPACITY
    for (Node2D* barrel : barrels)
    {
        CHECK_CAPACITY
        if (!barrel->is_visible_in_tree())
        {
            continue;
        }
        grazables[index_empty] = grazable;
        float angle;
        if (local_rotation)
        {
            angle = barrel->get_rotation();
        }
        else
        {
            angle = barrel->get_global_rotation();
        }
        velocities[index_empty] = Vector2(speed, 0).rotated(angle);
        transforms[index_empty] = Transform2D(angle + M_PI_2, get_scale(), 0, barrel->get_global_position());
        index_empty++;
    }
}

void Bullet::spawn_circle(long count, Vector2 position)
{
    CHECK_CAPACITY
    float delta_angle = Math_TAU / count;
    float angle = 0;
    for (long index = 0; index < count; index++)
    {
        grazables[index_empty] = grazable;
        velocities[index_empty] = Vector2(speed, 0).rotated(angle);
        transforms[index_empty] = Transform2D(angle + M_PI_2, position);
        angle += delta_angle;
        index_empty++;
    }
}

void Bullet::clear()
{
    index_empty = 0;
}

void Bullet::draw_bullets()
{
    //May it reduce jittering due to race condition.
    Transform2D bullets_transform[MAX_BULLET];
    LOOP_BULLET
    {
        bullets_transform[index] = transforms[index];
    }
    LOOP_BULLET
    {
        Transform2D& transform = bullets_transform[index];
        Color modulate = Color(transform.get_rotation(), 1, 1);
        texture->draw(canvas_item, transform.get_origin().rotated(-transform.get_rotation()) / transform.get_scale(), modulate);
    }
}

void Bullet::move_bullets()
{
    LOOP_BULLET
    {
        Transform2D& transform = transforms[index];
        transform.set_origin(transform.get_origin() + velocities[index] * delta32);
    }
}

// return true means bullet is still alive
bool Bullet::collide(Dictionary& result, int index)
{
    GET_COLLISION_MASK
    if (mask < 0)
    {
        // spawnitem
        return false;
    }
    grazables[index] = false;
    GET_COLLIDER
    collider->call_deferred("hit");
    return true;
}

bool Bullet::collision_check(int index)
{
    Transform2D& transform = transforms[index];
    query.set_transform(transform);
    query.set_collision_mask((grazables[index]) ? collision_graze : collision_layer);
    Dictionary result = world->get_direct_space_state()->get_rest_info(&query);
    return result.is_empty() || collide(result, index);
}

void Bullet::expire_bullets()
{
    int index = roundl(index_empty / 2);
    int index_halt = index_empty;
    if (tick)
    {
        index_halt = index;
        index = 0;
    }
    while (index < index_halt)
    {
        Vector2 position = transforms[index].get_origin();
        if (world_border.has_point(position))
        {
            index++;
            continue;
        }
        indexes_delete.push_back(index);
        index++;
    }
}

void Bullet::sort_bullets(int index)
{
    FILL_ARRAY_HOLE(transforms)
    FILL_ARRAY_HOLE(velocities)
    FILL_ARRAY_HOLE(grazables)
}

void Bullet::_physics_process(double delta)
{
    renderer->canvas_item_clear(canvas_item);
    if (index_empty == 0)
    {
        return;
    }
    long task_draw = threader->add_task(action_draw, true);
    long task_move = threader->add_task(action_move, true);

    tick = !tick;
    int index_halt = roundl(index_empty / 2);
    int index = 0;
    if (tick)
    {
        index = index_halt;
        index_halt = index_empty;
    }
    long task_expire = threader->add_task(action_expire);
    while (index < index_halt)
    {
        if (collision_check(index))
        {
            indexes_delete.push_back(index);
        }
        index++;
    }

    threader->wait_for_task_completion(task_draw);
    threader->wait_for_task_completion(task_move);
    threader->wait_for_task_completion(task_expire);
    
    for (int idx : indexes_delete)
    {
        index_empty--;
        sort_bullets(idx);
    }
  
}