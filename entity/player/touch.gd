extends Reference
#Script handles player inputs.

var focus := false
var parent
var joystick_move : VirtualJoystick
var joystick_attack : VirtualJoystick

func init(UI) -> void:
	joystick_move = UI.get_node('JoystickMove')
	joystick_attack = UI.get_node('JoystickAttack')

func camera_control(event) -> void:
	if event is InputEventMagnifyGesture and parent.camera.zoom.x > 0.25 and parent.camera.zoom.x < 3:
		parent.camera.zoom *= Input.factor

func move():
	if not joystick_move.is_pressed():
		focus = false
		return
	
	if abs(joystick_move._output.x) <= 0.5 or abs(joystick_move._output.y) <= 0.5:
		focus = true
	else:
		focus = false

	return joystick_move._output
		
func attack():
	if not joystick_attack.is_pressed():
		return
		
	var rotation = joystick_attack._output.angle()
	if not focus:
		return {
		'type' : 0,
		'rotation' : rotation
		}
	
	return {
		'type' : 1,
		'rotation' : rotation
	}
