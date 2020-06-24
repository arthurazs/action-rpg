extends KinematicBody2D

const ACCEL = 300
const FRICT = 1200

var knock_back = Vector2.ZERO

func _ready():
	$AnimatedSprite.play()

func _physics_process(delta):
	knock_back = knock_back.move_toward(Vector2.ZERO, FRICT * delta)
	knock_back = move_and_slide(knock_back)
	

func _on_Hurtbox_area_entered(area):
	$Hurtbox.health -= area.damage
	knock_back = global_position - area.get_parent().global_position
	knock_back = knock_back.normalized() * ACCEL


func _on_Hurtbox_no_health():
	$CollisionShape2D.set_deferred("disabled", true)
	$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite.hide()
	$DeathAnimation.show()
	$DeathAnimation.play()


func _on_DeathAnimation_finished():
	queue_free()
