extends CanvasLayer

signal start_game

func _ready():
	$Music.play()

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	$Music.stop()
	$DeathSound.play()
	# Wait until the MessageTimer has counted down.
	yield($MessageTimer, "timeout")
	$Message.text = "Shoot the Planes"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	yield(get_tree().create_timer(1), "timeout")
	$DeathSound.stop()
	$Music.play()
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)

func update_bulletcount(bulletcount):
	$BulletLabel.text = str(bulletcount)

func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")

func _on_MessageTimer_timeout():
	$Message.hide()
