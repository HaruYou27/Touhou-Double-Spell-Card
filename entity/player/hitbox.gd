extends Area2D
#Player hitbox. Handler colision.

export (int) var max_heath = 10
export (int) var max_mana = 100

var armor :int
var bar_factor :float

onready var parent :KinematicBody2D = $'..'
onready var heath :int = max_heath
onready var mana :int = max_mana

func pick_up(data:Item_Valuable) -> void:
	if data.power:
		parent.power += data.value
	elif data.mana:
		parent.mana += data.value

func _hit(data, velocity:= Vector2()) -> void:
	parent.rpc('_heathbar_update', parent.heathbar.point[1].x - bar_factor * data.damage)
	if armor:
		armor -= data.damage
	else:
		heath -= data.damage
		
	if armor < 0:
		#In case the bullet pierce through armor.
		heath += armor
		armor = 0
	if heath <= 0:
		parent.die()
		parent.graze.monitoring = true
		parent.graze.monitorable = false
		parent.set_sync_to_physics(true)
		parent.position += velocity
