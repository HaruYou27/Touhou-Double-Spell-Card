extends Enemy
#Phantom that burst 4 bullets when die.
#The lowest intelligent entity.


var agent := GSAISteeringAgent
var seek := GSAISeek.new(agent, target)

export (int) var damage
export (int) var max_speed

func _on_Dectection_area_entered(area) -> void:
	target = area.parent
	alert = true
	$Dectection.pause_mode = Node.PAUSE_MODE_STOP
	set_physics_process(true)
	cooldown.start()
	
func _physics_process(delta) -> void:
	rot = global_position.angle_to_point(target.global_position)
	var velocity = Vector2(speed, 0).rotated(rot)
	position += velocity * delta
	rpc_unreliable('_puppet_position_update', position)

func remove_target(node):
	cooldown.stop()
	$Dectection.pause_mode = Node.PAUSE_MODE_INHERIT
	.remove_target(node)
	
func die():
	var bullets = PoolIntArray([0, 0, 0, 0])
	var positions = PoolVector2Array([position, position, position, position])
	var rotations = PoolRealArray([0.785, 2.356, 3.927, 5.498])
	Global.rpc('instance_bullet', name, bullets, positions, rotations, Network.server_clock)
	
	$spirit.emitting = false
	pause_mode = Node.PAUSE_MODE_STOP

func _on_Cooldown_timeout():
	Global.rpc('instance_bullet', name, PoolIntArray([0]), PoolVector2Array([position]), PoolRealArray([rot]))
