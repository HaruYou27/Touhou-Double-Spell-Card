extends Resource
#Store world generation data.
#Value range from Vector2.x to Vector2.y
#Value range should be different for best result.
#Create noise and fillter noise.

export (int) var octaves = 3
export (float) var period = 64
export (float) var persistence = 0.5
export (float) var lacunarity = 2

export (Vector2) var width
export (Vector2) var height
export (Vector2) var areas
export (Array) var enemies

var rng := RandomNumberGenerator.new()

func create_noise() -> OpenSimplexNoise:
	var noise = OpenSimplexNoise.new()
	noise.octaves = octaves
	noise.period = period
	noise.persistence = persistence
	noise.lacunarity = lacunarity
	randomize()
	noise.seed = randi()
	
	var rng := RandomNumberGenerator.new()
	rng.seed = noise.seed
	width = rng.randi_range(width.x, width.y)
	height = rng.randi_range(height.x, height.y)
	areas = rng.randi_range(areas.x, areas.y)
	
	return noise
