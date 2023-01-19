tool
extends BoxContainer
class_name FocusedBoxcontainer

var updating := false

export (bool) var run setget _run
export (bool) var auto_change
export (bool) var autostart

func _run(_value):
	if Engine.editor_hint:
		assign()
		
func _ready():
	if autostart:
		assign()
	if auto_change:
		connect("child_entered_tree", self, '_on_tree_channged')
		connect("child_exiting_tree", self, "_on_tree_changed")

func _on_tree_changed(_child):
	if is_queued_for_deletion():
		#There's no point if it is about to be deleted.
		return

	updating = true
	call_deferred('assign')

func assign():
	var nodes := []
	var i := 0
	
	for node in get_children():
		if node is Control and node.focus_mode:
			nodes.append(node)

	for node in nodes:
		var next :String = '../' + nodes[0 - nodes.size() + i + 1].name
		node.focus_neighbour_right = next
		node.focus_next = next
		node.focus_neighbour_bottom = next
		
		#Use negative index to avoid index out of bound.
		var previous :String = '../' + nodes[i - 1].name
		node.focus_neighbour_left = previous
		node.focus_neighbour_top = previous
		node.focus_previous = previous
		
		i += 1
		
	updating = false
