#ifndef GLOBAL_SCORE_HPP
#define GLOBAL_SCORE_HPP

#include <utility.hpp>
#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/classes/engine.hpp>

using namespace godot;
class GlobalScore : public Node
{
GDCLASS(GlobalScore, Node)

private:
    int score = 0;
    int item = 1;
    int graze = 1;
    int death_count = 0;
    bool updating_score;
    void update_score();
    void _update_score();
    Engine *engine;
protected:
    static void _bind_methods();
public:
    void _ready() override;
    void reset();
    void add_item();
    void add_graze();
    void add_death_count();
    
    int get_item() const;
    int get_graze() const;
    int get_death_count() const;
    int get_score() const;
};

#endif
