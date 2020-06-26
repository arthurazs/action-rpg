extends Area2D

signal no_health

export var max_health = 3
onready var health = max_health setget set_health
export var gets_invincible = false

func set_invincible():
	$CollisionShape2D.set_deferred("disabled", true)
	$Timer.start()

func set_health(value):
	var decreased = health > value
	health = clamp(value, 0, max_health)
	if health <= 0:
		emit_signal("no_health")
	else:
		if decreased:
			if gets_invincible:
				set_invincible()
			$AnimatedSprite.show()
			$AnimatedSprite.play()


func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.hide()
	$AnimatedSprite.frame = 0


func _on_Timer_timeout():
	$CollisionShape2D.disabled = false
	$AnimatedSprite.hide()
	$AnimatedSprite.frame = 0
