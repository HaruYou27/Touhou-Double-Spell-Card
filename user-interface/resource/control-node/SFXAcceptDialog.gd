extends AcceptDialog
class_name SFXAcceptDialog

func _ready():
	get_ok_button().set_script(SFXButton)
