extends Control

@export var list : OptionButton

@onready var scores := Global.user_data.scores

func _on_visibility_changed():
	var score = scores[list.get_item_id(list.selected)]
	
