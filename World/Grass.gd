extends Node2D

var dying = false

func _on_AnimatedSprite_animation_finished():
	queue_free()

func _on_Hurtbox_area_entered(_area):
	if not dying:
		$AnimatedSprite.play("Animation")
		dying = true
