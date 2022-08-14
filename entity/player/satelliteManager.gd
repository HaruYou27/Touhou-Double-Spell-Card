tool
extends Node2D

var statellites :Array
#Use camera2D "smoothing" feature to simulate momentum of some statelites.
onready var tween :Camera2D = $tween

export (Resource) var bullet
export (Resource) var bullet_focus
export (Resource) var data
export (PackedScene) var statellite : PackedScene
export (int, "power 1", "power 2", "power 3", "power 4") var preset

export (bool) var save setget _save

func _ready():
	var node = statellite.instance()
	add_child(node)
	statellites.append(node)

func _save(_value:bool) -> void:
	if not Engine.editor_hint:
		return
	
	var size := statellites.size()
	var index : int
	if size == 1:
		index = 0
	elif size == 2:
		index = 1
	elif size == 3:
		index = 3
	else:
		index = 6
		
	for node in statellites:
		data.positions[index] = node.position
		data.rotations[index] = node.rotation
		index += 1

func load_preset(preset:int) -> void:
	var orb_pos : Array
	var orb_rot : Array
	var index := 0
	
	if preset == 1:
		index = 0
	elif preset == 2:
		index = 1
	elif preset == 3:
		index = 3
	else:
		index = 6
	
	for node in statellites:
		Global.tween.interpolate_property(node, node.position, node.position, orb_pos[index], 1)
		Global.tween.interpolate_property(node, node.rotation, node.rotation, orb_rot[index], 1)
		index += 1
