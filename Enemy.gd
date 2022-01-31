extends Area2D

export var min_speed = 500
export var max_speed = 750
export (PackedScene) var bullet
var velocity
signal enemy_shooting
signal enemy_escaped
signal enemy_hit
var ran


# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]
	velocity = Vector2(rand_range(min_speed, max_speed), 0)
	ran = rand_range(0, 100)
	if (ran <= 25):
		$BulletSpawn.start()
		velocity = Vector2(rand_range(150, 300), 0)

func _process(delta):
	position -= velocity * delta
	

func shoot():
	emit_signal("enemy_shooting")
	var b = bullet.instance()
	owner.add_child(b)
	b.transform = $BulletPosition.global_transform

func _on_VisibilityNotifier2D_screen_exited():
	if $AnimatedSprite.is_visible_in_tree():
		emit_signal("enemy_escaped")
	queue_free()


func _on_BulletSpawn_timeout():
	shoot()

func _on_Enemy_body_entered(body):
	body.plane_died()


func _on_Enemy_area_entered(_area):
	emit_signal("enemy_hit")
