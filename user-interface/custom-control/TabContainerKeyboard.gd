extends TabContainer

export (Array) var first_button

onready var max_tab = get_tab_count() - 1

func _ready() -> void:
	set_process_input(false)
	var index := 0
	for button in first_button:
		first_button[index] = get_node(button)
		index += 1

func _input(event):
	if event.is_action_pressed("ui_focus_prev"):
		if not current_tab:
			current_tab = max_tab
		else:
			current_tab -= 1
	elif event.is_action_pressed('ui_focus_next'):
		if current_tab == max_tab:
			current_tab = 0
		else:
			current_tab += 1
	else:
		return
	first_button[current_tab].grab_focus()
	accept_event()
