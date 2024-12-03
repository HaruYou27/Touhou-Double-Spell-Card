extends Resource
class_name Score

@export var game_speed := .0

@export_category('Personal best')
@export var item := 0
@export var graze := 0
@export var retry_count := 0

@export_category('Partner HiScore')
@export var partner := ''
@export var item_partner:= 0
@export var graze_partner := 0
@export var retry_partner := 0
