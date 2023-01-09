extends Area2D
class_name boss

export (int) var point := 64
export (int) var hp := 10
export (float) var duration := 0.0


var updating_gauge := false
var player_bomb_damage := 0

const boss_spot := Vector2(323, 235)

func _player_entered():
	var node :Player = Global.player
	if hp:
		node.connect("bombing", self, '_player_bombing')
		node.connect("bomb_impact", self, '_bomb_impact')
	node.connect("bombed", self, '_die')

func _player_bombing(times):
	player_bomb_damage = int(hp / times)

func _bomb_impact():
	hp -= player_bomb_damage
	if not updating_gauge:
		updating_gauge = true
		call_deferred('_update_gauge')

func _ready():
	call_deferred('_player_entered')
	Global.connect("spell_timeout", self, '_die')

	if global_position != boss_spot:
		var tween := create_tween()
		tween.tween_property(self, 'global_position', boss_spot, 2.0)
	
func _die():
	if global_position != boss_spot:
		var tween := create_tween()
		tween.tween_property(self, 'global_position', boss_spot, 2.0)
		tween.connect("finished", Global, "emit_signal", ['next_level'])
		get_tree().call_group('enemy_bullet', 'stop')
		return

	Global.emit_signal('next_level')

func _hit():
	hp -= 1
	if not hp:
		Global.emit_signal("spawn_item", point)
		_die()

	if not updating_gauge:
		updating_gauge = true
		call_deferred('_update_gauge')
		
func _update_gauge():
	Global.emit_signal("update_boss_hp", hp)
	updating_gauge = false
