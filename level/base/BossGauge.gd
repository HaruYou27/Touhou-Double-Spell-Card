extends TextureProgress

func _ready():
	Global.connect("update_boss_hp", self, 'update_hp')

func update_hp(hp):
	value = hp

func create_hp_gauge(hp:int):
	max_value = hp
	
	var tween := create_tween()
	tween.tween_property(self, 'value', hp, 2.0)
	tween.connect("finished", Global, 'emit_signal', ['spell_start'])

func hide_gauge():
	create_tween().tween_property(self, 'modulate', Color.transparent, .5)

func show_gauge():
	create_tween().tween_property(self, 'modulate', Color.white, .5)

func create_timer_gauge(duration:float):
	create_hp_gauge(duration)
	Global.connect("spell_start", self, '_start_timer')

func _start_timer():
	var tween := create_tween()
	tween.tween_property(self, 'value', 0.0, max_value)
	tween.connect("finished", Global, 'emit_signal', ['spell_timeout'])
