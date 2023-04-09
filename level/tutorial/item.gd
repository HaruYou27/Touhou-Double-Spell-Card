extends Label

@onready var timer : Timer = $Timer



func start_event() -> void:
	timer.start()
