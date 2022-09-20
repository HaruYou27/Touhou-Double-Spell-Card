extends ColorRect

onready var meimu := $Path2D/PathFollow2D
onready var bullet :Node2D = $meimu/bullet/Bullet
onready var tween :SceneTreeTween

func _ready():
	bullet.rotation = randf() * TAU
	tween = create_tween()
	tween.tween_property(meimu, 'unit_offset', 1.0, 7)
	tween.set_loops()
	
func _physics_process(delta):
	bullet.rotation += 0.897 * delta
