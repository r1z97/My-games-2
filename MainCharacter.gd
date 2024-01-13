extends CharacterBody2D
const SPEED = 300.0
const JUMP_VELOCITY = -400.07
var jump_max = 2
var jump_count = 0
var jump_power = 400
var wall_jump_pushback = 10
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")	
@onready var sprite_2d = $Sprite2D
func _physics_process(delta):
	#Animations
	if (velocity.x > 1 or velocity.x < -1):
		sprite_2d.animation = "running"
	else:
		sprite_2d.animation = "default"
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	if is_on_floor() and jump_count!=0:
		jump_count = 0
	
	if jump_count<jump_max:
		if Input.is_action_just_pressed("up"):
			velocity.y = -jump_power
			jump_count += 1
	# Handle jump.
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 15)
	move_and_slide()
	
	var isleft = velocity.x < 0
	sprite_2d.flip_h = isleft
	var isright = velocity.x < 0
	sprite_2d.flip_h = isright

func jump():
	velocity.y =+ gravity
	if Input.is_action_just_pressed("up"):
		velocity.y = jump_power
	if is_on_wall():
		sprite_2d.animation = "wall_slide"
	if is_on_wall_only() and Input.is_action_pressed("up"):
		velocity.y = jump_power
		velocity.x = wall_jump_pushback
		jump_max += 100
	else:
		jump_max -= 100
