extends KinematicBody2D

signal health_changed(value)

enum {
	MOVE,
	ATTACK,
	ROLL
}

const ACCEL = 1600
const MAX_SPEED = 150
const FRICT = 1600
const FACE_CAMERA = Vector2.DOWN

var state = MOVE
var velocity = Vector2.ZERO
var input_vector = Vector2.ZERO
onready var animation_state = $AnimationTree.get("parameters/playback")

func _ready():
	$AnimationTree.active = true
	$AnimationTree.set("parameters/Idle/blend_position", FACE_CAMERA)
	$AnimationTree.set("parameters/Attack/blend_position", FACE_CAMERA)
	$AnimationTree.set("parameters/Roll/blend_position", FACE_CAMERA)

func _physics_process(delta):
	match state:
		MOVE:
			move_action(delta)
		ATTACK:
			attack_action()
		ROLL:
			roll_action()

func move_action(delta):
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		$AnimationTree.set("parameters/Run/blend_position", input_vector)
		$AnimationTree.set("parameters/Attack/blend_position", input_vector)
		$AnimationTree.set("parameters/Roll/blend_position", input_vector)
		
		animation_state.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCEL * delta)
		if Input.is_action_pressed("player_roll"):
			state = ROLL
	else:
		animation_state.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICT * delta)
		
	move_player()
	
	if state != ROLL:
		if Input.is_action_pressed("player_attack"):
			state = ATTACK
		
func move_player():
	velocity = move_and_slide(velocity)
	
func attack_action():
	velocity = velocity * 0.9
	move_player()
	animation_state.travel("Attack")
	
func roll_action():
	velocity = $AnimationTree.get("parameters/Roll/blend_position") * MAX_SPEED
	move_player()
	animation_state.travel("Roll")
	

func _on_Attack_finished():
	state = MOVE
	
func _on_Roll_finished():
	state = MOVE


func _on_Hurtbox_area_entered(_area):
	$Hurtbox.health -= 1
	emit_signal("health_changed", $Hurtbox.health)


func _on_Hurtbox_no_health():
	queue_free()
