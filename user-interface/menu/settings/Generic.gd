extends VBoxContainer

func _ready():
	speed.value = Engine.time_scale
	language.select(user_data.language)
	if user_data.user_name != "HaruYou27":
		user_name.text = user_data.user_name

@onready var user_data := Global.user_data
@onready var speed: Slider = $speed
@onready var user_name: LineEdit = $UserName
@onready var language: OptionButton = $language
@onready var speed_label := $SpeedLabel
func _exit_tree() -> void:
	Engine.time_scale = speed.value
	user_data.user_name = user_name.text
	user_data.language = language.selected

func _on_reset_pressed() -> void:
	speed.value = 1.0
