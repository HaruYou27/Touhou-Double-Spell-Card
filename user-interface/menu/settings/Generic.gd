extends VBoxContainer

func _ready():
	speed.value = Engine.time_scale

func _on_language_item_selected(index:int) -> void:
	pass # Replace with function body.

@onready var speed := $speed
func _exit_tree() -> void:
	Engine.time_scale = speed.value

@onready var speed_label := $SpeedLabel
func _on_speed_value_changed(value: float) -> void:
	pass # Replace with function body.
