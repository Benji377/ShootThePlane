extends Area2D

export var min_speed = 500
export var max_speed = 700
var velocity
var value = 2
signal coin_hit
var ran

# Called when the node enters the scene tree for the first time.
func _ready():
	var coin_types = $AnimatedSprite.frames.get_animation_names()
	ran = randf() * 100
	if (ran >= 0 && ran <= 10):
		print("Gold coin")
		$AnimatedSprite.animation = coin_types[1]
		value = 5
	elif (ran > 10 && ran <= 40):
		print("Silver coin")
		$AnimatedSprite.animation = coin_types[2]
		value = 3
	else:
		print("Bronze coin")
		$AnimatedSprite.animation = coin_types[0]
		value = 2
	
	$AnimatedSprite.play()
	velocity = Vector2(rand_range(min_speed, max_speed), 0)

func _process(delta):
	position -= velocity * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Coin_body_entered(_body):
	emit_signal("coin_hit")
	queue_free()
