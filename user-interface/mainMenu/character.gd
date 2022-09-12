extends Control

onready var back :BackButton = $back

func _on_main_select_level():
	back.disabled = false
	
