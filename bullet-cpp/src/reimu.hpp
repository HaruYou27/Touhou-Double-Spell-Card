#ifndef REIMU_HPP
#define REIMU_HPP

#include <utility.hpp>
#include <player.hpp>
#include <fantasy_seal.hpp>

class Reimu : public Player
{
GDCLASS(Reimu, Player)

private:
    StringName seals_group;
    NodePath bomb_timer_path;

    std::vector<FantasySeal*> seals;
protected:
    static void _bind_methods();
    virtual void clamp_position() override;
public:
    virtual void _ready() override;
    virtual void _bomb_away() override;
};

#endif