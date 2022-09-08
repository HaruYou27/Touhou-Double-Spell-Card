extends Player
#Statellite manager.

onready var animation :AnimationPlayer = $AnimationPlayer

func focus() -> void:
	.focus()
	animation.play("focus")
	
func unfocus() -> void:
	.unfocus()
	animation.play_backwards("focus")
