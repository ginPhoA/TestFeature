extends Area2D
signal hit # Signal functionality used to detect when this player is hit by an enemy

# Declare member variables
# @export allows the variable to be setup in the inspector
@export var speed = 400 # Player movement speed (pixels/sec)
var screen_size # Size of game window

# Called when the node enters the scene tree for the first time.
func _ready():
	# Finds the size of the game window, in this case 480x720 (WxH)
	screen_size = get_viewport_rect().size
	hide() # hides player when game start

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Sets velocity to (0,0)
	var velocity = Vector2.ZERO # Player movement vector
	
	# Check for user input
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		
	# Speed of the player, Normalizing the velocity then multiply by desired speed
	# Prevents fast diagonal movement
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play() # If player moves > Animated sprite
	else:
		$AnimatedSprite2D.stop() # If player stops > Do not animate sprite
		
	# delta parameter refers to frame length, by clamping it, prevents player leaving screen
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	# Changes the player sprites animation based on directional input
	if velocity.x != 0: # if player vector is NOT 0, play "walk" animation, do not flip/look down while turning left/right, and flip sprite horizontally based on directional movement (left/right) 
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0: # same thing but for vertical movement
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0

# Godot created a function found under "Signals" which will be used to emit signals from the player if the body comes in touch with the enemies RigidBody2D node
func _on_body_entered(body: Node2D) -> void:
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
	
	# Each time enemy hits player, signal is emitted, in doing so - we disable player collision to not trigger hit after DEAD/HIT
	# set_deferred tells Godot to wait to disable shape until safe
	
# Function called to reset player when starting new game, reset position, show player, and disable collision
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
