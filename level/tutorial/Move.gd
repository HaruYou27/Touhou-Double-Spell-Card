extends Node2D

onready var timer := $Timer
onready var init_pos := global_position
onready var leveler := Global.leveler

func _ready():
	get_tree().call_group('player_bullet', 'stop')
	
func start():
	timer.start()

func _notification(what):
	if what == CanvasItem.NOTIFICATION_TRANSFORM_CHANGED and init_pos != global_position:
		leveler.next_level()
		timer.queue_free()

func _on_Timer_timeout():
	leveler.add_child(Dialogic.start('/tutorial/move'))
