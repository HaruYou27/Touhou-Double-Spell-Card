extends KeyboardButton

export (int) var offset := 30
onready var default_pos := rect_position
var final_pos

func _ready():
    final_pos = rect_position
    final_pos.x += offset
    connect("focus_exited", self, "_on_focus_exited")

func _on_focus_exited():
    create_tween().tween_property(self, "rect_position", default_pos, duration)

func _on_focus_entered():
    create_tween().tween_property(self, "rect_position", final_pos, duration)
    ._on_focus_entered()
