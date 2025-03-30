extends Node2D
## Public variables and signals

## Emit when player change graphic settings.
signal update_graphic
var leveler: Leveler

const main_menu := "res://user-interface/menu/menu.tscn"
const config_path := 'user://saveData.res'

var user_data : UserData
func _ready() -> void:
	if not Engine.is_editor_hint:
		print(Engine.get_license_text())
	user_data = load(config_path)
	if user_data:
		return
		
	user_data = UserData.new()
