extends Node

func start_level() -> void:
	Global.player.bomb_count += 1
	Global.leveler.hud._update_bomb()
	Global.leveler.hud.reward_sfx.play()
	
	Dialogic
