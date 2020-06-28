extends Area2D

export var max_health = 3
export var gets_invincible = false
export var invincibility_time = 1

signal no_health

onready var health = max_health setget set_health
var blinking_animation

func _ready():
	var parent = get_parent()
	if parent.has_node("BlinkingAnimation"):
		blinking_animation = parent.get_node("BlinkingAnimation")

func set_invincible(interval=0):
	if blinking_animation:
		blinking_animation.play("Start")
	$CollisionShape2D.set_deferred("disabled", true)
	if interval == 0:
		interval = invincibility_time
	$Timer.start(interval)

func set_health(value):
	if typeof(value) == TYPE_STRING:
		set_invincible(0.2)
	else:
		var decreased = health > value
		health = clamp(value, 0, max_health)
		if health <= 0:
			emit_signal("no_health")
		else:
			if decreased:
				$AudioStreamPlayer.play()
				if gets_invincible:
					set_invincible()
				$AnimatedHit.frame = 0
				$AnimatedHit.show()
				$AnimatedHit.play()


func _on_AnimatedHit_animation_finished():
	$AnimatedHit.hide()


func _on_Timer_timeout():
	if blinking_animation:
		blinking_animation.play("Stop")
	$CollisionShape2D.disabled = false
