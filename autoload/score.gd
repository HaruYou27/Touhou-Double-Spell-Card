extends Resource
class_name Score

@export var game_speed := .0

@export_category('Personal best')
@export var username := ""
@export var item := 0
@export var graze := 0
@export var retry_count := 0

@export_category('Partner HiScore')
@export var partner := ''
@export var partner_item := 0
@export var partner_graze := 0
@export var partner_retry := 0
