extends CharacterBody3D

#GENERAL MOVEMENT
const WALK_SPEED = 5.0
const SPRINT_SPEED = 8.0
const JUMP_VELOCITY = 4.5

#HEADBOB
const SENSITIVITY = 0.003
const BOB_FERQ = 2.0
const BOB_AMP = 0.08

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D

#FOV CHANGE
const BASE_FOV = 75 
const FOV_CHANGE = 1.5

var hbob_time = 0.0
var speed

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#BASE_FOV = camera.fov

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	speed = SPRINT_SPEED if Input.is_action_pressed("sprint") else WALK_SPEED

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = 0.0
			velocity.z = 0.0
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 5.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 5.0)
	#Headbob 
	hbob_time += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = headbob(hbob_time)

	# FOV 
	if is_on_floor():
		var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
		var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
		camera.fov = lerp(camera.fov, target_fov, delta * 8)
	
	move_and_slide()
	
func headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FERQ) * BOB_AMP
	pos.y = cos(time * BOB_FERQ) / 2 * BOB_AMP
	return pos
	
