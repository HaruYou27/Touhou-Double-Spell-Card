extends Label

func start_level() -> void:
	$Timer.start()
	Global.can_shoot = false
	Global.leveler.item_manager.SpawnItem(27, Global.boss.transform)
	show()
