extends Node2D

var dying = false
export var interactable = true

func _ready():
	if not interactable:
		$Hurtbox/CollisionShape2D.set_deferred("disabled", true)

func _on_AnimatedSprite_animation_finished():
	queue_free()

func _on_Hurtbox_area_entered(_area):
	if not dying:
		$AnimatedSprite.play()
		dying = true
