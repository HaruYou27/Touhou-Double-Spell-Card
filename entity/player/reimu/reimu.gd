extends Player

@onready var fantasy_seals := $"../FantasySeals"
func _ready() -> void:
	super()
	seals = fantasy_seals.get_children()

func move(event:InputEvent) -> void:
	global_position += event.relative * sentivity
	global_position.x = fposmod(global_position.x, 540.0)
	global_position.y = fposmod(global_position.y, 852.0)
	
	if is_multiplayer_authority():
		rpc('_update_position', global_position)
	
var seals: Array[Node]
func spawn_bomb(index:int) -> void:
	var seal: FantasySeal = seals[index]
	seal.global_position = barrels[index].global_position
	seal.toggle(true)
	
@onready var barrels:Array = get_tree().get_nodes_in_group("Player Barrel")
var tween_bomb: Tween
func bomb() -> void:
	super()
	tween_bomb = create_tween()
	tween_bomb.tween_callback(spawn_bomb.bind(0))
	tween_bomb.tween_interval(0.5)
	tween_bomb.tween_callback(spawn_bomb.bind(1))
	tween_bomb.tween_interval(0.5)
	tween_bomb.tween_callback(spawn_bomb.bind(2))
	tween_bomb.tween_interval(0.5)
	tween_bomb.tween_callback(spawn_bomb.bind(3))
	tween_bomb.tween_interval(0.5)
	tween_bomb.tween_callback(barrels.shuffle)
	tween_bomb.tween_interval(0.5)
	tween_bomb.tween_callback(bomb_finished)
