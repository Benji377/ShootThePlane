extends Area2D

var speed = 1000
var travelling = true;

func _ready():
	var bullet_types = $Sprite.frames.get_animation_names()
	$Sprite.animation = bullet_types[randi() % bullet_types.size()]
	$Rocket.play()
	yield(get_tree().create_timer(1.0), "timeout")
	$Rocket.stop()

func _physics_process(delta):
	if travelling:
		position -= transform.x * speed * delta

func _on_EnemyBullet_body_entered(body):
	$CollisionShape2D.set_deferred("disabled", true)
	$Sprite.hide()
	body.plane_died()
	travelling = false
	$Explosion.play()
	$ExplosionSound.play()
	yield(get_tree().create_timer(2.0), "timeout")
	queue_free()


func _on_EnemyBullet_area_entered(area):
	if area.is_in_group("enemies"):
		pass
	else:
		$CollisionShape2D.set_deferred("disabled", true)
		$Sprite.hide()
		travelling = false
		$Explosion.play()
		$ExplosionSound.play()
		yield(get_tree().create_timer(2.0), "timeout")
		queue_free()
