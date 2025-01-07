#include <bullet.hpp>

void Bullet::_bind_methods()
{
    BIND_SETGET(speed, Bullet)
    BIND_SETGET(barrel_group, Bullet)
    BIND_SETGET(local_rotation, Bullet)
    BIND_SETGET(texture, Bullet)
    BIND_SETGET(hitbox, Bullet)
    BIND_SETGET(grazable, Bullet)
    BIND_SETGET(collision_layer, Bullet)

    BIND_FUNCTION(spawn_bullet, Bullet)
    BIND_FUNCTION(clear, Bullet)
    ClassDB::bind_method(D_METHOD("spawn_circle", "count", "position"), &Bullet::spawn_circle);

    ADD_PROPERTY_FLOAT(speed)
    ADD_PROPERTY(PropertyInfo(Variant::STRING_NAME, "barrel_group", PROPERTY_HINT_TYPE_STRING), "set_barrel_group", "get_barrel_group");
    ADD_PROPERTY_OBJECT(hitbox, Shape2D)
    ADD_PROPERTY_OBJECT(texture, Texture2D)
    ADD_PROPERTY_BOOL(grazable)
    ADD_PROPERTY_BOOL(local_rotation)
    ADD_PROPERTY_COLLISION(collision_layer)
}

SETTER_GETTER(speed, float, Bullet)
SETTER_GETTER(texture, Ref<Texture2D>, Bullet)
SETTER_GETTER(barrel_group, StringName, Bullet)
SETTER_GETTER(local_rotation, bool, Bullet)
SETTER_GETTER(hitbox, Ref<Shape2D>, Bullet)
SETTER_GETTER(grazable, bool, Bullet)
SETTER_GETTER(collision_layer, int, Bullet)

void Bullet::_ready()
{
    engine = Engine::get_singleton();
    set_as_top_level(true);
    if (engine->is_editor_hint())
    {
        set_physics_process(false);
        return;
    }
    canvas_item = get_canvas_item();
    collision_graze = collision_layer + 8;
    space = get_world_2d()->get_direct_space_state();
    renderer = RenderingServer::get_singleton();
    item_manager = get_node<Node>("/root/GlobalItem");

    query->set_shape(hitbox);
    renderer->canvas_item_set_custom_rect(canvas_item, true);

    TypedArray<Node> nodes = get_tree()->get_nodes_in_group(barrel_group);
    int index_stop = nodes.size();
    for (int index = 0; index < index_stop; index++)
    {
        Node2D* node = Object::cast_to<Node2D>(nodes[index]);
        if (node != nullptr)
        {
            barrels[count_node] = node;
            count_node++;
        }
    }
}

void Bullet::spawn_bullet()
{
    CHECK_CAPACITY
    for (int index = 0; index < count_barrel; index++)
    {
        CHECK_CAPACITY
        reset_bullet();
        float angle = barrel_rotations[index];
        velocities[count_bullet] = Vector2(speed, 0).rotated(angle);
        transforms[count_bullet] = Transform2D(angle + M_PI_2, get_scale(), 0, barrel_positions[index]);
        count_bullet++;
    }
}

Bullet::Bullet()
{
    query.instantiate();
    thread_bullet.instantiate();
    thread_barrel.instantiate();
    world_border = Rect2(-100, -100, 740, 1160);
    action_expire = callable_mp(this, &Bullet::expire_bullets);
    action_move = callable_mp(this, &Bullet::move_bullets);
}

void Bullet::reset_bullet()
{
    grazes[count_bullet] = grazable;
}

void Bullet::spawn_circle(const signed long count, const Vector2 position)
{
    CHECK_CAPACITY
    float delta_angle = Math_TAU / count;
    float angle = 0;
    for (int index = 0; index < count; index++)
    {
        reset_bullet();
        velocities[count_bullet] = Vector2(speed, 0).rotated(angle);
        transforms[count_bullet] = Transform2D(angle + M_PI_2, position);
        angle += delta_angle;
        count_bullet++;
    }
}

void Bullet::clear()
{
    count_bullet = 0;
    count_collided = 0;
    count_expire = 0;
}

void Bullet::move_bullet(const int index)
{
    Transform2D& transform = transforms[index];
    transform.set_origin(transform.get_origin() + velocities[index] * delta32);
    texture->draw(canvas_item, transform.get_origin().rotated(-transform.get_rotation()) / transform.get_scale(), Color(transform.get_rotation(), 1, 1));
}

void Bullet::move_bullets()
{
    thread_bullet->set_thread_safety_checks_enabled(false);
    for (int index = 0; index < count_bullet; index++)
    {
        move_bullet(index);
    }
}

Object* Bullet::get_collider(const Dictionary& result)
{
    return ObjectDB::get_instance(static_cast<uint64_t>(result["collider_id"]));
}

float Bullet::get_result_mask(const Dictionary& result)
{
    return static_cast<Vector2>(result["linear_velocity"]).x;
}
// return false means bullet is still alive
bool Bullet::collide(const Dictionary& result, const int index)
{
    if (get_result_mask(result) < 0)
    {
        item_manager->call_deferred("spawn_item", transforms[index]);
        return true;
    }
    grazes[index] = false;
    get_collider(result)->call_deferred("hit");
    return false;
}

void Bullet::cache_barrel()
{
    count_barrel = 0;
    for (int index = 0; index < count_node;index++)
    {
        Node2D* node = barrels[index];
        if (node->is_visible_in_tree())
        {
            barrel_positions[count_barrel] = node->get_global_position();
            barrel_rotations[count_barrel] = (local_rotation) ? node->get_rotation() : node->get_global_rotation();
            count_barrel++;
        }
    }
}

void Bullet::expire_bullets()
{
    thread_barrel->set_thread_safety_checks_enabled(false);
    cache_barrel();
    int index_stop = (tick) ? index_half : count_bullet;
    int index = (tick) ? 0 : index_half;
    while (index < index_stop)
    {
        if (world_border.has_point(transforms[index].get_origin()))
        {
            index++;
            continue;
        }
        indexes_delete_border[count_expire] = index;
        count_expire++;
        index++;
    }
}

void Bullet::sort_bullets(const int index)
{
    FILL_ARRAY_HOLE(transforms)
    FILL_ARRAY_HOLE(velocities)
    FILL_ARRAY_HOLE(grazes)
}

bool Bullet::collision_check(const int index)
{
    Transform2D& transform = transforms[index];
    query->set_transform(transform);
    query->set_collision_mask((grazes[index]) ? collision_graze : collision_layer);
    Dictionary result = space->get_rest_info(query);
    return !result.is_empty() && collide(result, index);
}

void Bullet::_physics_process(const double delta)
{
    renderer->canvas_item_clear(canvas_item);
    if (count_bullet == 0)
    {
        cache_barrel();
        return;
    }
    thread_bullet->start(action_move, Thread::PRIORITY_HIGH);

    tick = !tick;
    delta32 = delta;
    index_half = roundl(count_bullet / 2);
    int index_stop = (tick) ? count_bullet : index_half;
    int index = (tick) ? index_half : 0;
    thread_barrel->start(action_expire);
    while (index < index_stop)
    {
        if (collision_check(index))
        {
            indexes_delete[count_collided] = index;
            count_collided++;
        }
        index++;
    }

    thread_bullet->wait_to_finish();
    thread_barrel->wait_to_finish();

    for (int idx = 0; idx < count_collided; idx++)
    {
        count_bullet--;
        int i = indexes_delete[idx];
        if (i == count_bullet)
        {
            continue;
        }
        sort_bullets(i);
    }
    count_collided = 0;
    for (int idx = 0; idx < count_expire; idx++)
    {
        count_bullet--;
        int i = indexes_delete_border[idx];
        if (i == count_bullet)
        {
            continue;
        }
        sort_bullets(i);
    }
    count_expire = 0;
}