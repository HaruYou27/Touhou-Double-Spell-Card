extends VisibilityNotifier2D
#Enemy AI toggler.

var preset :Resource
var active :bool
var enemies :Array

func _on_PlayerDectector_screen_entered() -> void:
	if is_network_master():
		for enemy in enemies:
			enemy.wakeup()
		active = true
		rpc('delete')
	else:
		rpc_id(1, 'change_master', Network.ID)

func _on_PlayerDectector_screen_exited() -> void:
	if is_network_master():
		for enemy in enemies:
			enemy.go_sleep()

#Networking funcion.
master func change_master(id:int) -> void:
	if active:
		return
	set_network_master(id)
	for enemy in enemies:
		enemy.change_master(id)
	_on_PlayerDectector_screen_entered()

puppet func delete():
	queue_free()
