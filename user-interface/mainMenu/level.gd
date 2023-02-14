extends Control

export (Array) var levels

onready var list :VBoxContainer = $HBoxContainer2/list
onready var preview :TextureRect = $HBoxContainer2/preview
onready var title :FormatLabel = $HBoxContainer2/score/title
onready var score :FormatLabel = $HBoxContainer2/score/HiScore
onready var graze :FormatLabel = $HBoxContainer2/score/Graze
onready var item :FormatLabel = $HBoxContainer2/score/Point

func _ready():
	for level in levels:
		
