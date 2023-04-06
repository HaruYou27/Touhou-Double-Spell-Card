extends OptionButton

func _ready() -> void:
	var user_data : UserData = Global.user_data
	for id in user_data.scores.keys():
		set_item_disabled(get_item_index(id), false)

func _on_select_pressed(value:int) -> void:
	select(selected + value)
