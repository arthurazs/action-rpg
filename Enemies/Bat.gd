extends KinematicBody2D

export var interactable = true
export var wanders = true

signal xp

enum {
	IDLE,
	WANDER,
	CHASE
}

const ACCEL = 300
const FRICT = 1200

var knock_back = Vector2.ZERO
var state = IDLE
var player = null
var direction = Vector2.ZERO
var velocity = Vector2.ZERO
onready var initial_position = global_position
var wander_position

func _ready():
	$AnimatedSprite.play()
	if not interactable:
		$PlayerDetection/CollisionShape2D.set_deferred("disabled", true)
		$Hurtbox/CollisionShape2D.set_deferred("disabled", true)

func _physics_process(delta):
	if knock_back != Vector2.ZERO:
		knock_back = knock_back.move_toward(Vector2.ZERO, FRICT * delta)
		knock_back = move_and_slide(knock_back)
	
	match state:
		IDLE:
			if global_position.distance_to(initial_position) > 50:
				direction = global_position.direction_to(initial_position) * 50
				direction = move_and_slide(direction)
			elif direction != Vector2.ZERO:
				direction = direction.move_toward(Vector2.ZERO, 100 * delta)
				direction = move_and_slide(direction)
			if wanders:
				if $WanderTimer.time_left == 0:
					$WanderTimer.start()
		CHASE:
			direction = position.direction_to(player.global_position) * FRICT * 3 * delta
			$AnimatedSprite.flip_h = direction.x < 0
			direction = move_and_slide(direction)
		WANDER:
			wander_position = initial_position + Vector2(rand_range(-1, 1), rand_range(-1, 1))
			direction = global_position.direction_to(wander_position) * 50
			$AnimatedSprite.flip_h = direction.x < 0
			direction = move_and_slide(direction)
			state = IDLE


func _on_Hurtbox_area_entered(area):
	$Hurtbox.health -= area.damage
	knock_back = global_position - area.get_parent().global_position
	knock_back = knock_back.normalized() * ACCEL


func _on_Hurtbox_no_health():
	state = IDLE
	# warning-ignore:return_value_discarded
	$AnimatedSprite.connect("animation_finished", self, "_on_DeathAnimation_finished")
	$Hitbox/CollisionShape2D.set_deferred("disabled", true)
	$CollisionShape2D.set_deferred("disabled", true)
	$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite.play("Die")
	emit_signal("xp")


func _on_DeathAnimation_finished():
	queue_free()


func _on_PlayerDetection_body_entered(body):
	state = CHASE
	player = body


func _on_PlayerDetection_body_exited(_body):
	state = IDLE
	player = null


func _on_WanderTimer_timeout():
	if state != CHASE:
		state = WANDER
