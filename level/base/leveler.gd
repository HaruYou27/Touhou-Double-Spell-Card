extends Node2D
##Node that controls the current_event.

##Next level scene path.
@export var next_level : PackedInt64Array

@export var current_scene : Node2D

@onready var tree := get_tree()
@onready var hud := $hud
@onready var user_data :UserData = Global.user_data

func _ready() -> void:
	VisualEffect.fade2black(true)
	VisualEffect.current_scene = current_scene

##Level finisher.
func finished() -> void:
	if Engine.is_editor_hint:
		return
	
	hud.save_score() 
	Global.user_data.unlock_level(next_level)
	tree.change_scene_to(next_level)
