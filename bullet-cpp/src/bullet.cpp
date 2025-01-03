#include <bullet.hpp>

using namespace godot;

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
        reset_bullet();
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

Bullet::Bullet()
{
    query = NEW_OBJECT(PhysicsShapeQueryParameters2D)
    indexes_delete = PackedInt32Array();
    world_border = Rect2(-100, -100, 740, 1160);
    barrels = std::vector<Node2D*>();
}
Bullet::~Bullet()
{
}

void Bullet::reset_bullet()
{
    grazes[index_empty] = grazable;
}

void Bullet::spawn_circle(int count, Vector2 position)
{
    CHECK_CAPACITY
    float delta_angle = Math_TAU / count;
    float angle = 0;
    for (int index = 0; index < count; index++)
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
}

void Bullet::move_bullet(int index)
{
    GET_BULLET_TRANSFORM
    transform.set_origin(transform.get_origin() + velocities[index] * delta32);
    texture->draw(canvas_item, transform.get_origin().rotated(-transform.get_rotation()) / transform.get_scale(), Color(transform.get_rotation(), 1, 1));
}

void Bullet::move_bullets()
{
    LOOP_BULLETS
    {
        move_bullet(index);
    }
}

// return false means bullet is still alive
bool Bullet::collide(Dictionary& result, int index)
{
    GET_COLLISION_MASK
    if (mask < 0)
    {
        item_manager->call_deferred("spawn_item", transforms[index]);
        return true;
    }
    grazes[index] = false;
    GET_COLLIDER
    collider->call_deferred("hit");
    return false;
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
        if (world_border.has_point(transforms[index].get_origin()))
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
    if (index == index_empty)
    {
        return;
    }
    FILL_ARRAY_HOLE(transforms)
    FILL_ARRAY_HOLE(velocities)
    FILL_ARRAY_HOLE(grazes)
}

void Bullet::_physics_process(double delta)
{
    renderer->canvas_item_clear(canvas_item);
    IS_BULLETS_EMPTY
    int task_move = threader->add_task(action_move, true);

    tick = !tick;
    delta32 = delta;
    int index_halt = roundl(index_empty / 2);
    int index = 0;
    if (tick)
    {
        index = index_halt;
        index_halt = index_empty;
    }
    int task_expire = threader->add_task(action_expire);
    while (index < index_halt)
    {
        GET_BULLET_TRANSFORM
        query->set_transform(transform);
        query->set_collision_mask((grazes[index]) ? collision_graze : collision_layer);
        COLLIDE_QUERY(query)
        if (!result.is_empty() && collide(result, index))
        {
            indexes_delete.push_back(index);
        }
        index++;
    }

    threader->wait_for_task_completion(task_move);
    threader->wait_for_task_completion(task_expire);

    for (int idx : indexes_delete)
    {
        index_empty--;
        sort_bullets(idx);
    }
    indexes_delete.clear();
}