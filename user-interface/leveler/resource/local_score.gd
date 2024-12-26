extends VBoxContainer

@onready var player1: FormatLabel = $player1
@onready var item1: FormatLabel = $item1
@onready var graze1: FormatLabel = $graze1
@onready var retry1: FormatLabel = $retry1
@onready var score1: FormatLabel = $score1

@onready var player2: FormatLabel = $player2
@onready var item2: FormatLabel = $item2
@onready var graze2: FormatLabel = $graze2
@onready var retry2: FormatLabel = $retry2
@onready var score2: FormatLabel = $score2
func display_score(score:Score) -> void:
	show()
	player1.update_label(score.username)
	item1.update_label(score.item)
	graze1.update_label(score.graze)
	retry1.update_label(score.retry_count)
	score1.update_label(score.item * score.graze * score.game_speed)
	
	player2.update_label(score.partner)
	item2.update_label(score.item_partner)
	graze2.update_label(score.graze_partner)
	retry2.update_label(score.retry_partner)
	score2.update_label(score.item_partner * score.graze_partner * score.game_speed)
