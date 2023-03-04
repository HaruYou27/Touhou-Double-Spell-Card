extends Resource
class_name LevelHeader

@export var title := 'Test Level'
@export var preview : ImageTexture
@export var level : PackedScene

var score : Score
var path := 'user://' + title + '.res'

func load_score():
	score = load(path)
	if not score:
		score = Score.new()
		Global.save_resource(path, score)
