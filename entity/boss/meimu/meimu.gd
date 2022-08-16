extends Area2D

export (int) var firerate
export (Array) var barrels

onready var bullet := $bullet

var cooldown : int

func _ready() -> void:
	var index := 0
	for barrel in barrels:
		barrels[index] = get_node(barrel)
		index += 1
	firerate = (60 - firerate) / firerate

func _physics_process(delta):
	if cooldown:
		cooldown -= 1
		return
	for barrel in barrels:
		bullet.SpawnBullet(barrel.global_transform)
		cooldown = firerate
