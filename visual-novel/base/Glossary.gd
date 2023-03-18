extends Resource
class_name Glossary

@export var tag : PackedStringArray
@export var image : Texture2D
@export var text : String
@export var link : String

func _link_clicked() -> void:
	OS.shell_open(link)
