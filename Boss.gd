extends Area2D

export var min_speed = 100
export var max_speed = 200
export (PackedScene) var bullet
var velocity
var lives = 3
var ran

signal boss_shooting
signal boss_escaped
signal boss_hit
signal boss_died


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
	emit_signal("boss_shooting")
	var b = bullet.instance()
	owner.add_child(b)
	b.transform = $BulletPosition.global_transform

func _on_VisibilityNotifier2D_screen_exited():
	if $AnimatedSprite.is_visible_in_tree():
		emit_signal("boss_escaped")
		print("Boss escaped")
	queue_free()


func _on_BulletSpawn_timeout():
	shoot()

func _on_Boss_body_entered(body):
	body.plane_died()


func _on_Boss_area_entered(_area):
	emit_signal("boss_hit")
	lives -= 1
	if (lives <= 0):
		emit_signal("boss_died")
		$CollisionShape2D.set_deferred("disabled", true)
		$Explosion.play()
		$ExplosionSound.play()
		$AnimatedSprite.hide()
		$BulletSpawn.stop()
		yield(get_tree().create_timer(2.0), "timeout")
		$Explosion.stop()
		$ExplosionSound.stop()
