extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# Play animation and randomly pick out of the 3 set
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names()) # Gets list of animation names (walk, fly, swim)
	$AnimatedSprite2D.animation = mob_types.pick_random() # Array.pick_random() to select one of the animations
	$AnimatedSprite2D.play() # Call play() starts animation once picked


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Got from the VisibleOnScreenNotifier2D node Signals tab > screen_exited()
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free() # deletes the node at the end of the frame
