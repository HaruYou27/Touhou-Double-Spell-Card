extends VBoxContainer

@export var modes : OptionButton
func _ready() -> void:
	modes.get_popup().transparent_bg = true

@export var host_join : AcceptDialog
func _on_enter_pressed():
	match modes.selected:
		1:
			host_join.show()
