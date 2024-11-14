extends Player

func move(event:InputEvent) -> void:
	global_position += event.relative * sentivity
	global_position.x = fposmod(global_position.x, 540.0)
	global_position.y = fposmod(global_position.y, 852.0)
	
	if is_multiplayer_authority():
		rpc('_update_position', global_position)
	
@export var fatasy_seal : PackedScene
func bomb() -> void:
	super()
	fatasy_seal.instantiate()
