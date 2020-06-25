extends KinematicBody2D

const ACCEL = 300
const FRICT = 1200

enum {
	IDLE,
	WANDER,
	CHASE
}

var knock_back = Vector2.ZERO
var state = IDLE
var player = null
var direction
export var interactable = true

func _ready():
	$AnimatedSprite.play()
	if not interactable:
		$PlayerDetection/CollisionShape2D.set_deferred("disabled", true)
		$Hurtbox/CollisionShape2D.set_deferred("disabled", true)

func _physics_process(delta):
	knock_back = knock_back.move_toward(Vector2.ZERO, FRICT * delta)
	knock_back = move_and_slide(knock_back)
	
	match state:
		CHASE:
			direction = position.direction_to(player.global_position) * FRICT * 3 * delta
			$AnimatedSprite.flip_h = direction.x < 0
			direction = move_and_slide(direction)


func _on_Hurtbox_area_entered(area):
	$Hurtbox.health -= area.damage
	knock_back = global_position - area.get_parent().global_position
	knock_back = knock_back.normalized() * ACCEL


func _on_Hurtbox_no_health():
	state = IDLE
	$CollisionShape2D.set_deferred("disabled", true)
	$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite.hide()
	$DeathAnimation.show()
	$DeathAnimation.play()


func _on_DeathAnimation_finished():
	queue_free()


func _on_PlayerDetection_body_entered(body):
	state = CHASE
	player = body


func _on_PlayerDetection_body_exited(_body):
	state = IDLE
	player = null
