extends CharacterBody2D
var gravity : Vector2
@export var jump_height : float ## How high should they jump?
@export var movement_speed : float ## How fast can they move?
@export var horizontal_air_coefficient : float ## Should the player move more slowly left and right in the air? Set to zero for no movement, 1 for the same
@export var speed_limit : float ## What is the player's max speed? 
@export var friction : float ## What friction should they experience on the ground?

# Called when the node enters the scene tree for the first time.
func _ready():
	gravity = Vector2(0, 100)
	pass # Replace with function body.

# Gets input from the player and decides what to do with it (move left, move right, etc.)
func _get_input():
	if is_on_floor(): # If the character is on a platform
		if Input.is_action_pressed("move_left"): # move the character left when pressing "A"
			velocity += Vector2(-movement_speed,0) 

		if Input.is_action_pressed("move_right"): # move the character right when pressing "D"
			velocity += Vector2(movement_speed,0)

		if Input.is_action_just_pressed("jump"): # Jump only happens when we're on the floor (unless we want a double jump, but we won't use that here)
			velocity += Vector2(0,-jump_height) # make the character jump when pressing "SPACE" 

	if not is_on_floor(): # If the character is currently mid-jump or mid-fall in the "air"
		if Input.is_action_pressed("move_left"): # move the character left when pressing "A"
			velocity += Vector2(-movement_speed * horizontal_air_coefficient,0) 

		if Input.is_action_pressed("move_right"): # move the character right when pressing "D"
			velocity += Vector2(movement_speed * horizontal_air_coefficient,0)

# We set a speed limit for the character -- character cannot go faster than the speed limit in any direction 
func _limit_speed():
	if velocity.x > speed_limit: # If the character is going over the speed limit
		velocity = Vector2(speed_limit, velocity.y) # Force character to stay within speed limit

	if velocity.x < -speed_limit: # If the character is going over the speed limit, but in the opposite direction
		velocity = Vector2(-speed_limit, velocity.y) # Force character to stay within speed limit

# If character is on the floor, and the player is not moving it, give the character friction 
func _apply_friction():
	if is_on_floor() and not (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")):
		velocity -= Vector2(velocity.x * friction, 0) # Slow the character down 
		if abs(velocity.x) < 5: # When should character come to a complete stop?
			velocity = Vector2(0, velocity.y) # if the velocity in x gets close enough to zero, we set it to zero

# If we're not on the floor, add some gravity
func _apply_gravity():
	if not is_on_floor():
		velocity += gravity

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	_get_input()
	_limit_speed()
	_apply_friction()
	_apply_gravity()

	move_and_slide() # Applies velocity to the CharacterBody2D as set above, allowing the character to do as defined above
	pass
