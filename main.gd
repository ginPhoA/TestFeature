extends Node

@export var mob_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	
	# Calls HUD function to show messages when game over
	$HUD.show_game_over()
	
	$Music.stop()
	$DeathSound.play()
	
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	
	# Display messages
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	
	# call_group function calls named functions on every node in the group - tell mobs to queue_free, meaning delete themselves before new game
	get_tree().call_group("mobs", "queue_free")
	
	$Music.play()

# MobTimer
func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's position to the random location.
	mob.position = mob_spawn_location.position

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

# ScoreTimer
func _on_score_timer_timeout():
	score += 1
	
	# Keeps display in sync with changing score
	$HUD.update_score(score)

# StartTimer
func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
