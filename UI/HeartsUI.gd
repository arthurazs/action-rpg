extends Control

signal no_hearts

const HEART_SIZE = 15

var max_hearts = 3 setget change_max_hearts
var hearts = 2 setget change_hearts

func _ready():
	$EmptyHearts.rect_size.x = max_hearts * HEART_SIZE
	$FullHearts.rect_size.x = hearts * HEART_SIZE

func change_max_hearts(value):
	max_hearts = max(value, 1)
	$EmptyHearts.rect_size.x = max_hearts * HEART_SIZE
	change_hearts(hearts + 1)

func change_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	$FullHearts.rect_size.x = hearts * HEART_SIZE
	if hearts == 0:
		emit_signal("no_hearts")
