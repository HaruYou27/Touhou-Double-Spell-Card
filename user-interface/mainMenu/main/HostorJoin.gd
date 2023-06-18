extends ConfirmationDialog

@onready var host : Button = get_cancel_button()
@onready var join : Button = get_ok_button()
func _ready():
	host.set_script(SFXButton)
	join.set_script(SFXButton)
