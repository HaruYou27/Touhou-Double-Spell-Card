extends VBoxContainer

func _ready():
	speed.value = Engine.time_scale

func _on_language_item_selected(index:int) -> void:
	pass # Replace with function body.

@onready var speed := $speed
func _exit_tree() -> void:
	Engine.time_scale = speed.value
