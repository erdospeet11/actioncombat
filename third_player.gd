extends CharacterBody3D

const SPEED = 5.0
const SPRINT_SPEED = 9.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.003
const LERP_VAL = 0.15
const ACCELERATION = 40.0
const DECELERATION = 40.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camera_pivot = $Node3D
@onready var spring_arm = $Node3D/SpringArm3D
@onready var visual = $"exported-model"
@onready var animation_player = $"exported-model/AnimationPlayer"
@onready var movement_speed_label = $DebugCanvasLayer/Panel/VBoxContainer/MovementSpeed
@onready var movement_direction_label = $DebugCanvasLayer/Panel/VBoxContainer/MovementDirection
@onready var camera_position_label = $DebugCanvasLayer/Panel/VBoxContainer/CameraPosition
@onready var player_transform_label = $DebugCanvasLayer/Panel/VBoxContainer/PlayerTransform
@onready var camera_3d = $Node3D/SpringArm3D/Camera3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	spring_arm.add_excluded_object(self)
	print("Available animations:", animation_player.get_animation_list())

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		camera_pivot.rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		spring_arm.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, deg_to_rad(-60), deg_to_rad(60))

	if event.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var input_dir = Input.get_vector("left", "right", "forward", "back")

	var direction = (camera_pivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		var current_speed = SPEED
		if Input.is_action_pressed("sprint"):
			current_speed = SPRINT_SPEED
			animation_player.play("Jog_Fwd", 0.1)
		else:
			animation_player.play("Walk", 0.1)
			
		velocity.x = move_toward(velocity.x, direction.x * current_speed, ACCELERATION * delta)
		velocity.z = move_toward(velocity.z, direction.z * current_speed, ACCELERATION * delta)
		
		var target_rotation = atan2(direction.x, direction.z)
		visual.rotation.y = lerp_angle(visual.rotation.y, target_rotation, LERP_VAL)
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)
		velocity.z = move_toward(velocity.z, 0, DECELERATION * delta)
	
	move_and_slide()
	
	var speed = Vector3(velocity.x, 0, velocity.z).length()
	movement_speed_label.text = "Movement Speed: %.2f" % speed
	movement_direction_label.text = "Direction: (%.2f, %.2f, %.2f)" % [direction.x, direction.y, direction.z]
	var cam_pos = camera_3d.global_position
	camera_position_label.text = "Camera Pos: (%.2f, %.2f, %.2f)" % [cam_pos.x, cam_pos.y, cam_pos.z]
	
	var player_pos = global_position
	player_transform_label.text = "Player Pos: (%.2f, %.2f, %.2f)" % [player_pos.x, player_pos.y, player_pos.z]
