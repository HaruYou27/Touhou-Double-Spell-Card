extends Enemy

export (int) var max_speed

func remove_target(node):
	cooldown.stop()
	$Dectection.pause_mode = Node.PAUSE_MODE_INHERIT
	.remove_target(node)
	
func die():
	var bullets = PoolIntArray([0, 0, 0, 0])
	var positions = PoolVector2Array([position, position, position, position])
	var rotations = PoolRealArray([0.785, 2.356, 3.927, 5.498])
	Global.rpc('instance_bullet', name, bullets, positions, rotations)
	
	$spirit.emitting = false
	pause_mode = Node.PAUSE_MODE_STOP
