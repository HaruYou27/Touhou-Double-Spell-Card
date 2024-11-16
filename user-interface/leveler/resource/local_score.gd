extends VBoxContainer

@onready var player1: FormatLabel = $player1
@onready var item1: FormatLabel = $item1
func diplay_score(score:Score) -> void:
	player1.update_label(score.username)
	
