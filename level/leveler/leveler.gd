extends Node2D
##Node that controls the current_event.

##Next level scene path.
@export var id := 0

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
	
	Global.change_scene(global.main_menu)
