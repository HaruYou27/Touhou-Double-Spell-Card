extends Control

@onready var death_timer :Slider = $VBoxcontainer/DurationSlider
@onready var speed :Slider = $VBoxcontainer/SpeedSlider
@onready var list :Node = $VBoxcontainer
@onready var spawn_location :Node2D = $preview

@export var players : Array[PackedScene]
var nodes : Array

var header : LevelHeader : set = _set_header
func _set_header(level:LevelHeader) -> void:
	header = level
	death_timer.value = header.score.death_time
	speed.value = header.score.game_speed

func _ready():
	var i:= 0
	
	for scene in players:
		var node :Node2D = scene.instantiate()
		node.free_hitbox()
		node.hide()
		spawn_location.add_child(node)
		
		var button := UberButton.new()
		button.text = node.name
		button.mouse_entered.connect(Callable(self, '_preview').bind(i))
		button.pressed.connect(Callable(self, '_start').bind(i))
		list.add_child(button)
		
		i += 1

	nodes = spawn_location.get_children()
	
func _preview(index:int) -> void:
	for node in nodes:
		node.hide()
		node._set_shooting(false)
	
	var node :Node = nodes[index]
	node._set_shooting(true)
	node.show()

func _start(index:int) -> void:
	header.score.save_setting(death_timer.value, players[index])
	Engine.time_scale = speed.value
	
	get_tree().change_scene_to_file(header.level)
