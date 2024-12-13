extends Timer
class_name TimerBurst

@export var cycle := 1.
@export var burst_count := 1

@onready var cycle_timer := $Cycle
var count := 0
func _on_timeout():
	count += 1
	if count == burst_count:
		count = 0
		stop()
		cycle_timer.start(cycle)
