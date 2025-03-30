extends Node

func _ready() -> void:
	set_process(false)

@export var tick0 : AudioStreamPlayer
@export var tick1 : AudioStreamPlayer
func hover() -> void:
	tick0.play()

func player_hit() -> void:
	press(true)

func player_revive() -> void:
	press(true)

func player_died() -> void:
	press(false)

func bomb_pickup() -> void:
	press(true)

func item_pickup() -> void:
	hover()

func enemy_died() -> void:
	tick1.play()

@export var press0 : AudioStreamPlayer
@export var press1 : AudioStreamPlayer
func press(pitch:bool) -> void:
	if pitch:
		press1.play()
	else:
		press0.play()