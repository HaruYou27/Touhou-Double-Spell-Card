extends Player

func move(event:InputEvent) -> void:
	global_position += event.relative * sentivity
	global_position.x = fposmod(global_position.x, 540.0)
	global_position.y = fposmod(global_position.y, 852.0)
	
	if is_multiplayer_authority():
		rpc('_update_position', global_position)
	
@export var seals:Array[Node2D]
func spawn_bomb(index:int) -> void:
	seals[index].global_position = barrels[index].global_position
	
@onready var barrels:Array = get_tree().get_nodes_in_group("Player Barrel")
var tween_bomb: Tween
func bomb() -> void:
	super()
	tween_bomb = create_tween()
	tween_bomb.tween_callback(spawn_bomb.bind(0))
	tween_bomb.tween_interval(1.0)
	tween_bomb.tween_callback(spawn_bomb.bind(1))
	tween_bomb.tween_interval(1.0)
	tween_bomb.tween_callback(spawn_bomb.bind(2))
	tween_bomb.tween_interval(1.0)
	tween_bomb.tween_callback(spawn_bomb.bind(3))
	tween_bomb.tween_interval(0.5)
	tween_bomb.tween_callback(barrels.shuffle)
	tween_bomb.tween_interval(0.5)
	tween_bomb.tween_callback(_bomb_finished)
