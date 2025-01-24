#ifndef SCORE_MANAGER_HPP
#define SCORE_MANAGER_HPP

#include <utility.hpp>
#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/classes/engine.hpp>

class ScoreManager : public Node
{
GDCLASS(ScoreManager, Node)

private:
    int score = 0;
    int item = 1;
    int graze = 1;
    int bomb = 3;
    int death_count = 0;
    bool updating_score;
    
    void update_score();
    void _update_score();
    
    Engine *engine;
    Node *sound_effect;
protected:
    static void _bind_methods();
public:
    virtual void _ready() override;
    
    void reset();
    void add_item();
    void add_bomb();
    bool use_bomb();
    void add_graze();
    void add_death_count();
    
    int get_item() const;
    int get_graze() const;
    int get_bomb() const;
    int get_death_count() const;
    int get_score() const;
};

#endif
