extends Control

onready var back :BackButton = $back

func _entered():
	show()
	back.disabled = false

func _on_back_pressed():
	hide()
