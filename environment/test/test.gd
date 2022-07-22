extends TileMap

var preset := preload("res://environment/test/preset.res")

func create() -> TileMap:
	var noise := preset.create_noise()
	var rng := RandomNumberGenerator.new()
	var grass :TileMap = preload("res://environment/test/grass.scn").instance()
	
	for x in preset.width:
		for y in preset.height:
			if noise.get_noise_2d(x, y) < 0.5:
				rng.randomize()
				set_cell(x, y, 0, rng.randi_range(0, 1))
			else:
				rng.randomize()
				var rand = rng.randi_range(0, 1)
				rng.randomize()
				grass.set_cell(x, y, rand, rng.randi_range(0, 1))
	
	Global.ysort.add_child(grass)
	return self
