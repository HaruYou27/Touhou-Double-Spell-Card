extends Resource
class_name LevelHeader

@export (String) var title := 'Test Level'
@export (Texture2D) var preview
@export (PackedScene) var level

var score :Score
var path := 'user://' + title + '.res'

func load_score():
	score = load(path)
	if not score:
		score = Score.new()
		Global.save_resource(path, score)
