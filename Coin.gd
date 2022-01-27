extends Area2D

export var min_speed = 100
export var max_speed = 300
var velocity
var value = 5
signal coin_hit

# Called when the node enters the scene tree for the first time.
func _ready():
	var coin_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = coin_types[randi() % coin_types.size()]
	# Set coin value according to coin type
	if ($AnimatedSprite.animation == "silver_coin"):
		print("Silver coin")
		value = 10
	elif ($AnimatedSprite.animation == "gold_coin"):
		print("Gold coin")
		value = 20
	else:
		print("Bronze coin")
		value = 5
	
	$AnimatedSprite.play()
	velocity = Vector2(rand_range(min_speed, max_speed), 0)

func _process(delta):
	position -= velocity * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Coin_area_entered(_area):
	emit_signal("coin_hit")
