extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
# Display messages temporarily when game starts
func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
# When player loses, this code will display messages and return to tital screen before display $StartButton.show
func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	$Message.text = "Dodge the Creeps!"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	
# Updates the score
func update_score(score):
	$ScoreLabel.text = str(score)

# When start button pressed, hide the button
func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()

# When start button pressed, hide the message
func _on_message_timer_timeout():
	$Message.hide()
