extends Node
class_name Stage

var hi_score := 0
var score := 0
var goal := 0
var index := 1

export (Array) var spellcards : Array
export (NodePath) var current_spell
export (String) var stage_name

onready var playground :Control = $Playground

func _ready() -> void:
	if Global.save.hi_score.has(stage_name):
		hi_score = Global.save.hi_score[stage_name]
	else:
		Global.save.hi_score[stage_name] = hi_score
	
	current_spell = get_node(current_spell)
	randomize()
	spellcards.shuffle()

func _update_score(value:int) -> void:
	score += value
func _exit_tree() -> void:
	Global.save.hi_score[stage_name] = hi_score
	Global.save.save()

func next() -> void:
	current_spell.queue_free()
	current_spell = spellcards.pop_back().instance()
	playground.add_child(current_spell)
