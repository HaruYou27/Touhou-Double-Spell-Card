#ifndef REIMU_HPP
#define REIMU_HPP

#include "utility.hpp"
#include "player.hpp"
#include "fantasy_seal.hpp"

class Reimu : public Player
{
GDCLASS(Reimu, Player)

protected:
    static void _bind_methods();
    virtual void clamp_position() override;
};

#endif