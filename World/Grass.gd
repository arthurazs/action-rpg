extends Node2D


#func _process(_delta):
#	if Input.is_action_pressed("player_attack"):
#		$AnimatedSprite.play("Animation")
var dying = false

func _on_AnimatedSprite_animation_finished():
	queue_free()


func _on_Hurtbox_area_entered(_area):
	if not dying:
		$AnimatedSprite.play("Animation")
		dying = true
