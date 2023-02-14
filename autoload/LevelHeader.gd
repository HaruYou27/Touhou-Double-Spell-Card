extends Resource
class_name LevelHeader

export (String) var title := 'Test Level'
export (Texture) var preview
export (PackedScene) var level

var score :Score

func load_score():
	score = load('user://' + title)
	if not score:
		score = Score.new()
		Global.save_resource('user://' + title + '.tscn', score)
