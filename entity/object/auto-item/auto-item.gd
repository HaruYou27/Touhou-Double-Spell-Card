extends Steering
#Resource define an item.

export (Resource) var data

var visual := preload("res://entity/object/global-canvas.gd").new()
var active := false
var trans :Transform2D
var time_created :int

func create(position) -> void:
	visual.data = data
	position = position
	target = Global.player
	trans = Transform2D(0, position)

func process(delta) -> bool:
	if not active:
		visual.draw(trans)
		if Global.clock - time_created > data.life_time:
			return true
	else:
		visual.draw(move(delta))
	
	var result = Global.space_state.intersect_shape(data.query, 1)
	if not result:
		return false
	
	if not active:
		active = true
	else:
		Global.player.pickup(data)
		return true
	
	return false
