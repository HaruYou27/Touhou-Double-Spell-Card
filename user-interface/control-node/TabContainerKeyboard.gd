extends TabContainer

export (Array) var first_button

onready var max_tab = get_tab_count() - 1

func _ready():
	set_process_input(false)
	for child in get_children():
		for grand_child in child.get_children():
			if grand_child.focus_mode != 0:
				first_button.append(grand_child)
				break

func _input(event):
	if event.is_action_pressed("ui_focus_prev") or event.is_action_pressed('ui_left'):
		if not current_tab:
			current_tab = max_tab
		else:
			current_tab -= 1
	elif event.is_action_pressed('ui_focus_next') or event.is_action_pressed('ui_right'):
		if current_tab == max_tab:
			current_tab = 0
		else:
			current_tab += 1
	else:
		return
	first_button[current_tab].grab_focus()
	accept_event()
