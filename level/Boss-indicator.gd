extends Sprite
class_name BossIndicator

onready var boss :Boss = Global.boss

func _ready():
	texture = preload("res://level/textures/boss-indicator.png")
	position = Vector2(0, 878)
	z_index = -10

func _process(_delta):
	global_position.x = boss.global_position.x
