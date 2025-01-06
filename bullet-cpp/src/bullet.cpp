#include <bullet.hpp>

void Bullet::_bind_methods()
{
    BIND_SETGET(speed, Bullet)
    BIND_SETGET(barrel_group, Bullet)
    BIND_SETGET(local_rotation, Bullet)
    BIND_SETGET(texture, Bullet)
    BIND_SETGET(hitbox, Bullet)
    BIND_SETGET(grazable, Bullet)
    BIND_SETGET(collide_areas, Bullet)
    BIND_SETGET(collide_bodies, Bullet)
    BIND_SETGET(collision_layer, Bullet)

    BIND_FUNCTION(spawn_bullet, Bullet)
    BIND_FUNCTION(clear, Bullet)
    ClassDB::bind_method(D_METHOD("spawn_circle", "count", "position"), &Bullet::spawn_circle);

    ADD_PROPERTY_FLOAT(speed)
    ADD_PROPERTY(PropertyInfo(Variant::STRING_NAME, "barrel_group", PROPERTY_HINT_TYPE_STRING), "set_barrel_group", "get_barrel_group");
    ADD_PROPERTY_OBJECT(hitbox, Shape2D)
    ADD_PROPERTY_OBJECT(texture, Texture2D)
    ADD_PROPERTY_BOOL(grazable)
    ADD_PROPERTY_BOOL(collide_areas)
    ADD_PROPERTY_BOOL(collide_bodies)
    ADD_PROPERTY_BOOL(local_rotation)
    ADD_PROPERTY_COLLISION(collision_layer)
}

SETTER_GETTER(speed, float, Bullet)
SETTER_GETTER(texture, Ref<Texture2D>, Bullet)
SETTER_GETTER(barrel_group, StringName, Bullet)
SETTER_GETTER(local_rotation, bool, Bullet)
SETTER_GETTER(hitbox, Ref<Shape2D>, Bullet)
SETTER_GETTER(collide_areas, bool, Bullet)
SETTER_GETTER(grazable, bool, Bullet)
SETTER_GETTER(collide_bodies, bool, Bullet)
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
    tree = get_tree();
    space = get_world_2d()->get_direct_space_state();
    renderer = RenderingServer::get_singleton();
    threader = WorkerThreadPool::get_singleton();
    item_manager = get_node<Node>("/root/GlobalItem");

    query->set_shape(hitbox);
    query->set_collide_with_areas(collide_areas);
    query->set_collide_with_bodies(collide_bodies);
    renderer->canvas_item_set_custom_rect(canvas_item, true);

    TypedArray<Node> nodes = tree->get_nodes_in_group(barrel_group);
    short index_stop = nodes.size();
    for (short index = 0; index < index_stop; index++)
    {
        Node2D* node = Object::cast_to<Node2D>(nodes[index]);
        if (node != nullptr)
        {
            barrels.push_back(node);
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
        reset_bullet();
        float angle;
        angle = (local_rotation) ? barrel->get_rotation() : barrel->get_global_rotation();
        velocities[index_empty] = Vector2(speed, 0).rotated(angle);
        transforms[index_empty] = Transform2D(angle + M_PI_2, get_scale(), 0, barrel->get_global_position());
        index_empty++;
    }
}

Bullet::Bullet()
{
    query = NEW_OBJECT(PhysicsShapeQueryParameters2D)
    task_move = NEW_OBJECT(Thread)
    world_border = Rect2(-100, -100, 740, 1160);
    barrels = std::vector<Node2D*>();
    action_expire = callable_mp(this, &Bullet::expire_bullets);
    action_move = callable_mp(this, &Bullet::move_bullets);
}

void Bullet::reset_bullet()
{
    grazes[index_empty] = grazable;
}

void Bullet::spawn_circle(const signed long count, const Vector2 position)
{
    CHECK_CAPACITY
    float delta_angle = Math_TAU / count;
    float angle = 0;
    for (short index = 0; index < count; index++)
    {
        reset_bullet();
        velocities[index_empty] = Vector2(speed, 0).rotated(angle);
        transforms[index_empty] = Transform2D(angle + M_PI_2, position);
        angle += delta_angle;
        index_empty++;
    }
}

void Bullet::clear()
{
    index_empty = 0;
    index_collided = 0;
    index_expire = max_bullet - 1;
}

void Bullet::move_bullet(const short index)
{
    Transform2D& transform = transforms[index];
    transform.set_origin(transform.get_origin() + velocities[index] * delta32);
    texture->draw(canvas_item, transform.get_origin().rotated(-transform.get_rotation()) / transform.get_scale(), Color(transform.get_rotation(), 1, 1));
}

void Bullet::move_bullets()
{
    task_move->set_thread_safety_checks_enabled(false);
    for (short index = 0; index < index_empty; index++)
    {
        move_bullet(index);
    }
}

Object* Bullet::get_collider(const Dictionary& result)
{
    return ObjectDB::get_instance(static_cast<uint64_t>(result["collider_id"]));
}

float Bullet::get_collision_mask(const Dictionary& result)
{
    return static_cast<Vector2>(result["linear_velocity"]).x;
}
// return false means bullet is still alive
bool Bullet::collide(const Dictionary& result, const short index)
{
    if (get_collision_mask(result) < 0)
    {
        item_manager->call_deferred("spawn_item", transforms[index]);
        return true;
    }
    grazes[index] = false;
    get_collider(result)->call_deferred("hit");
    return false;
}

void Bullet::expire_bullet()
{
}

void Bullet::expire_bullets()
{
    expire_bullet();
    short index_stop = (tick) ? index_half : index_empty;
    short index = (tick) ? 0 : index_half;
    while (index < index_stop)
    {
        if (world_border.has_point(transforms[index].get_origin()))
        {
            index++;
            continue;
        }
        indexes_delete[index_expire] = index;
        index_expire--;
        index++;
    }
}

void Bullet::sort_bullets(const short index)
{
    FILL_ARRAY_HOLE(transforms)
    FILL_ARRAY_HOLE(velocities)
    FILL_ARRAY_HOLE(grazes)
}

bool Bullet::collision_check(const short index)
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
    IS_BULLETS_EMPTY
    task_move->start(action_move, Thread::PRIORITY_HIGH);

    tick = !tick;
    delta32 = delta;
    index_half = roundl(index_empty / 2);
    short index_stop = (tick) ? index_empty : index_half;
    short index = (tick) ? index_half : 0;
    int task_expire = threader->add_task(action_expire);
    while (index < index_stop)
    {
        if (collision_check(index))
        {
            indexes_delete[index_collided] = index;
            index_collided++;
        }
        index++;
    }

    task_move->wait_to_finish();
    threader->wait_for_task_completion(task_expire);

    for (short idx = 0; idx < index_collided; idx++)
    {
        index_empty--;
        if (index == index_empty)
        {
            return;
        }
        sort_bullets(idx);
    }
    for (short idx = max_bullet - 1; idx < index_expire; idx--)
    {
        index_empty--;
        if (index == index_empty)
        {
            return;
        }
        sort_bullets(idx);
    }
    index_collided = 0;
    index_expire = max_bullet - 1;
}