extends Control
signal character(level:LevelHeader)
signal preview(index:int)

@onready var back : Button = $VBoxContainer/back
@onready var list :BoxContainer = $VBoxContainer/ScrollContainer/LevelList
@onready var score :FormatLabel = $TabContainer/TabContainer/LocalScore/HiScore
@onready var graze :FormatLabel = $TabContainer/TabContainer/LocalScore/Graze
@onready var item :FormatLabel = $TabContainer/TabContainer/LocalScore/item
@onready var container : TabContainer = $TabContainer

@export var levels : Array[LevelHeader]

func _ready() -> void:
	visibility_changed.connect(Callable(self, '_on_visibility_changed'))
	var i := 0
	for level in levels:
		level.load_score()
		
		var button := UberButton.new()
		button.text = level.title
		button.pressed.connect(Callable(self,'_select_level').bind(i))
		if level.load_score():
			button.mouse_entered.connect(Callable(self, '_preview').bind(i))
		else:
			button.disabled = true
		
		list.add_child(button)
		i += 1
		
func _on_visibility_changed() -> void:
	back.disabled = not is_visible_in_tree()
	
func _select_level(index:int) -> void:
	character.emit(levels[index])
	
func _preview(index:int) -> void:
	var header = levels[index]
	preview.emit(index)
	
	var score_data = header.score
	score.update_label(score_data.score)
	graze.update_label(score_data.graze)
	item.update_label(score_data.item)

func _on_info_toggler_toggled(button_pressed:bool) -> void:
	container.current_tab = int(button_pressed)
