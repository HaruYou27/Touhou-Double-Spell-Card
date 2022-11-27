extends GridContainer



func _exit_tree():
	save.death_time = float(death_timer.text)
	save.init_bomb = int(bomb.text)
	save.save()
