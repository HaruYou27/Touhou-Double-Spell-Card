extends Label

func start_level() -> void:
	Global.player.bomb_count += 1
	Global.hud._update_bomb()
	Global.hud.reward_sfx.play()
	show()
