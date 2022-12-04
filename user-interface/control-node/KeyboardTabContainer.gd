extends TabContainer

var first_button := []
onready var max_tab = get_tab_count() - 1

func _ready():
	connect("visibility_changed", self, '_on_visibility_changed')
	for child in get_children():
		for grand_child in child.get_children():
			if grand_child is Control and grand_child.focus_mode:
				first_button.append(grand_child)
				break
				
func _on_visibility_changed():
	if visible:
		first_button[0].grab_focus()
		current_tab = 0
	else:
		set_process_input(false)

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
