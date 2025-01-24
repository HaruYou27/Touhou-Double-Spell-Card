#include <reimu.hpp>

void Reimu::_bind_methods()
{}

void Reimu::clamp_position()
{
    Vector2 position = get_global_position();
    position.x = Math::fposmod(position.x, 540);
    position.y = Math::fposmod(position.y, 852);
    set_global_position(position);
}
