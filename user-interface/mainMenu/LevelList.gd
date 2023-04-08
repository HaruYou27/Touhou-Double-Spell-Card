extends OptionButton

@onready var max_idx := item_count - 1

@export var levels : Array[LevelHeader]

func _ready() -> void:
	for id in Global.user_data.scores.keys():
		set_item_disabled(get_item_index(id), false)

func _on_select_pressed(value:int) -> void:
	if not selected and value < 0:
		select(max_idx)
	elif selected == max_idx:
		select(0)
	else:
		select(selected + value)

func _on_start_pressed():
	Global.change_scene(levels[selected].scene)
