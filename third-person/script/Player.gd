extends CharacterBody3D


var SPEED = 3.0
var JUMP_VELOCITY = 4.5
const walking_speed = 3.0
const running_speed = 8.0
var is_running = false
var is_locked = false

# export settings
@export var sense_horizontal = 0.5
@export var sense_vertical = 0.5

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# game components
@onready var animation_player = $Visuals/MixamoBase/AnimationPlayer
@onready var camera_mount = $CameraMount
@onready var visuals = $Visuals

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * sense_horizontal))
		visuals.rotate_y(deg_to_rad(event.relative.x * sense_horizontal))
		camera_mount.rotate_x(deg_to_rad(-event.relative.y * sense_vertical))

func _physics_process(delta):
	if not animation_player.is_playing():
		is_locked = false
	
	if Input.is_action_pressed("kick"):
		if animation_player.current_animation != "kick":
			animation_player.play("kick")
			is_locked = true
	
	if Input.is_action_pressed("jump"):
		is_locked = true
			
	if Input.is_action_pressed("run"):
		SPEED = running_speed
		is_running = true
	else:
		SPEED = walking_speed
		is_running = false
	
	# gravity settings
	#if not is_on_floor():
		#velocity.y -= gravity * delta
	
	# handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		# there is a direction and speed so we are walking or running
		
		if not is_locked:
			if is_running:
				if animation_player.current_animation != "running":
					animation_player.play("running")
			else:
				if animation_player.current_animation != "walking":
					animation_player.play("walking")	
			
			visuals.look_at(position + direction)
		
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		if not is_locked:
			if animation_player.current_animation != "idle":
				animation_player.play("idle")
			
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if not is_locked:
		move_and_slide()
