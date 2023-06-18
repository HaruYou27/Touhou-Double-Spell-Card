extends ConfirmationDialog
class_name SFXConfirmationDialog

func _ready():
	get_ok_button().set_script(SFXButton)
	get_cancel_button().set_script(SFXButton)
