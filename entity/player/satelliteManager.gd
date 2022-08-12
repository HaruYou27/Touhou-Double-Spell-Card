extends Node2D

var orbs :Array

export (Resource) var bullet
export (Resource) var bullet_focus
export (Resource) var orb_data

func orb_repos() -> void:
	var orb_pos : Array
	var orb_rot : Array
	if orbs.size() == 1:
		Global.tween.interpolate_property(orbs[0], orbs[0].position, orbs[0].position, orb_data.orb1_pos, 1)
		return
	elif orbs.size() == 2:
		orb_pos = orb_data.orb2_pos
		orb_rot = orb_data.orb2_rot
	elif orbs.size() == 3:
		orb_pos = orb_data.orb3_pos
		orb_rot = orb_data.orb3_rot
	else:
		orb_pos = orb_data.orb4_pos
		orb_pos = orb_data.orb4_rot
	
	var index := 0
	for orb_node in orbs:
		Global.tween.interpolate_property(orb_node, orb_node.position, orb_node.position, orb_pos[index], 1)
		Global.tween.interpolate_property(orb_node, orb_node.rotation, orb_node.rotation, orb_rot[index], 1)
		index += 1
	
func add
	
func attack() -> void:
	pass
