extends Player
#Statellite manager.

onready var orb_tween := create_tween()
onready var orb1 := $bullet2/YinyangOrb
onready var orb2 := $bullet2/YinyangOrb2
onready var orb3 := $bullet2/YinyangOrb3
onready var orb4 := $bullet2/YinyangOrb4

func focus() -> void:
	.focus()
	orb_tween.kill()
	orb_tween = create_tween()
	orb_tween.tween_property(orb3, 'position', Vector2(-22, -80), 0.15)
	orb_tween.parallel().tween_property(orb4, 'position', Vector2(-65, -80), 0.15)
	orb_tween.parallel().tween_property(orb2, 'position', Vector2(65, -80), 0.15)
	orb_tween.parallel().tween_property(orb1, 'position', Vector2(22, -80), 0.15)
	
func unfocus() -> void:
	.unfocus()
	orb_tween.kill()
	orb_tween = create_tween()
	orb_tween.tween_property(orb1, 'position', Vector2(-65, 54), 0.15)
	orb_tween.parallel().tween_property(orb2, 'position', Vector2(-112, 54), 0.15)
	orb_tween.parallel().tween_property(orb3, 'position', Vector2(112, 54), 0.15)
	orb_tween.parallel().tween_property(orb4, 'position', Vector2(65, 54), 0.15)
	
