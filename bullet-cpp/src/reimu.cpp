#include <reimu.hpp>

void Reimu::_bind_methods()
{
}

void Reimu::clamp_position()
{
    Vector2 position = get_global_position();
    position.x = Math::fposmod(position.x, 540);
    position.y = Math::fposmod(position.y, 852);
    set_global_position(position);
}

void Reimu::_ready()
{
    Player::_ready();
    CHECK_EDITOR
    TypedArray<Node> nodes = tree->get_nodes_in_group(seals_group);
    for (int index = 0; index < nodes.size(); index++)
    {
        FantasySeal *seal = Object::cast_to<FantasySeal>(nodes[index]);
        if (seal == nullptr)
        {
            continue;
        }
        seals.push_back(seal);
    }
}

void Reimu::_bomb_away()
{
    for (FantasySeal *seal : seals)
    {
        seal->set_as_top_level(false);
        seal->set_position(Vector2(0, 0));
        seal->call_deferred("_toggle", true);
    }
    tree->create_timer(5, false)->connect("timeout", bomb_finished);
}