extends Node

func _ready() -> void:
	set_process(false)

@export var tick0 : AudioStreamPlayer
@export var tick1 : AudioStreamPlayer
func hover() -> void:
	tick0.play()

@export var press0 : AudioStreamPlayer
@export var press1 : AudioStreamPlayer
func press(pitch:bool) -> void:
	if pitch:
		press1.play()
	else:
		press0.play()

@onready var recorder : AudioEffectRecord = AudioServer.get_bus_effect(4, 1)
func _process(_delta) -> void:
	rpc('_play_voice', recorder.get_recording())

@export var voice : AudioStreamPlayer
@rpc("any_peer")
func _play_voice(stream:AudioStreamWAV) -> void:
	voice.stream = stream
	voice.play()
