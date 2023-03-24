extends Label

func start_event() -> void:
	$Timer.start()
	Global.can_shoot = false
	Global.leveler.item_manager.SpawnItem(27, Global.boss.transform)
	show()

func _on_timer_timeout():
	text = 'You finished the tutorial!'
