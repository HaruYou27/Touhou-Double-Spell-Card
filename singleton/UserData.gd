extends Resource
class_name UserData

@export_category('Gameplay')
enum LANGUAGE
{
	ENGLISH,
}
@export var language := LANGUAGE.ENGLISH
@export var user_name := "HaruYou27"

@export_category('Graphic')
@export var particle_amount := 1.0
enum GRAPHIC_LEVEL
{
	MINIMAL,
	LOW,
	MEDIUM,
	HIGH,
}
@export var graphic_level := GRAPHIC_LEVEL.HIGH
@export var screen_shake_intensity := 2.0


@export_category("Controls")
@export var sentivity := 1.2
@export var raw_input := true : set = _set_raw_input
func _set_raw_input(value:bool) -> void:
	Input.use_accumulated_input = value

@export_category('User data')
@export var scores := {}
