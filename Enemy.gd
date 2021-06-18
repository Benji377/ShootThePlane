extends Area2D

export var min_speed = 300
export var max_speed = 500
var velocity
signal enemy_hit


# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]
	velocity = Vector2(rand_range(min_speed, max_speed), 0)

func _process(delta):
	position -= velocity * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Enemy_area_entered(area):
	emit_signal("enemy_hit")
