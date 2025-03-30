extends Control
class_name Leveler

@onready var pause: Button = $pause
@onready var hud:= $hud
@export var animator: AnimationPlayer
@export var animation: StringName
func _ready() -> void:
	tree.paused = false
	ScreenVFX.fade2black(true)
	Global.leveler = self
	animator.play(animation)
	GlobalScore.reset()
	animator.animation_finished.connect(hud.save_score)

func revive_player() -> void:
	GlobalItem.revive_player()
	
@onready var tree := get_tree()
func restart() -> void:
	tree.paused = true
	LevelLoader.load_scene.call_deferred('', true)
