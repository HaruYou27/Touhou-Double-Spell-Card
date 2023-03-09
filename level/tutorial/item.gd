extends Timer

func start_level() -> void:
	start()
	Global.can_shoot = false
	Global.leveler.item_manager.SpawnItem(27, Global.boss.transform)

func _on_item_timeout() -> void:
	add_child(Dialogic.start('/tutorial/move'))
