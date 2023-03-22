extends Resource
class_name LevelHeader

@export var title := 'test level'
@export var preview :ImageTexture
@export_file var level

var score : Score

func load_score() -> bool:
	var user_data :UserData = Global.user_data
	if user_data.scores.has(level):
		score = load(user_data.scores[level])
		return true
	
	return false
