extends Label

@onready var timer : Timer = $Timer

func _ready() -> void:
	Global.item_collect.connect(Callable(self, '_finished'), CONNECT_ONE_SHOT)

func start_event() -> void:
	timer.start()

func _finished(_value) -> void:
	show()
	text = 'You finished the tutorial!'
	timer.start()
	timer.timeout.disconnect(Callable(self, 'show'))
	timer.timeout.connect(Callable(self, '_back2menu'))
	
func _back2menu() -> void:
	get_tree().change_scene_to_file('res://user-interface/mainMenu/Menu.tscn')
