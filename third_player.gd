extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.003
const ROTATION_SPEED = 10.0
const DEBUG_DRAW = true

var direction := Vector3.FORWARD

@onready var camera_pivot = $Node3D
@onready var spring_arm = $Node3D/SpringArm3D
@onready var camera = $Node3D/SpringArm3D/Camera3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("left", "right", "forward", "back")
	
	print(input_dir)
	#var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
	
	"""
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		var target_rotation = atan2(direction.x, direction.z)
		rotation.y += lerp_angle(rotation.y, target_rotation, ROTATION_SPEED * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	"""
	
	velocity += Vector3(input_dir.x, 0, input_dir.y).normalized()
	move_and_slide()
