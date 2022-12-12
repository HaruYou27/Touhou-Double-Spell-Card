extends Node

func _ready():
    Global.connect("dying", self, "_alert")

func _alert():
    Global.connect("bomb", self, "_tutorial_done")
    Global.player.death_tween.stop_all()

func _tutorial_done():
    queue_free()