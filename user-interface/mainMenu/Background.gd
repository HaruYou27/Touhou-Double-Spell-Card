extends Node2D

var previews : Array[LevelPreview]
var current : LevelPreview
var new : LevelPreview
var changing := false

@onready var idx := Global.user_data.last_level
@onready var size := get_child_count()

@export var previous : Button
@export var next : Button
@export var list : OptionButton

func _ready() -> void:
	for node in get_children():
		if node is LevelPreview:
			previews.append(node)
			node.hide()
			list.add_item(node.title)
	current = previews[idx]
	current.show()

func _hide_foreground() -> void:
	if changing:
		return
	
	current.hide_foreground()

func change_preview() -> void:
	changing = true
	new = previews[idx]
	new.show()
	new.modulate = Color.TRANSPARENT
	
	var tween := create_tween()
	tween.tween_property(new, 'modulate', Color.WHITE, .25)
	tween.tween_property(current, 'modulate', Color.TRANSPARENT, .25)
	tween.finished.connect(_on_change_preview_finished)

func _on_change_preview_finished() -> void:
	changing = false
	current.hide()
	current = new

func _on_previous_pressed() -> void:
	if changing:
		return
		
	idx -= 1
	change_preview()

func _on_next_pressed() -> void:
	if changing:
		return
		
	idx += 1
	if idx == size:
		idx = 0
	
	change_preview()

func _on_enter_pressed() -> void:
	Global.user_data.last_level = idx
	Global.change_scene(current.level_scene)

func _on_level_list_item_selected(index:int) -> void:
	if changing:
		list.select(idx)
		return
		
	idx = index
	change_preview()
