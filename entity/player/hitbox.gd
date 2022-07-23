extends Area2D
#Player hitbox. Handler colision and player stats.
signal die


var max_power := 4
var max_lives := 7
var max_spellcard := 7

var power := 0.0
var spellcard := 3.0
var lives := 2

func pick_up(data:Item_Valuable) -> void:
	if data.power and power < max_power:
		power += data.value
	elif data.spellcard and spellcard < max_spellcard:
		spellcard += data.value
	elif data.lives and lives < max_lives: 
		lives += data.value
	
	Global.update()

func hit(data, velocity:= Vector2()) -> void:
	if Global.save.assist:
		Global.pause_mode = Node.PAUSE_MODE_STOP
	else:
		lives -= 1
		if lives >= 0:
			

