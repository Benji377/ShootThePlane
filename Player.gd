extends Area2D

export var bulletcount = 5
onready var bullet = preload("res://Bullet.tscn")
export var speed = 500
var screen_size
export var playing = false
signal hit
signal empty
signal shooting


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if playing:
		$Sprite.rotation = 0.0
		if bulletcount <= 0:
			emit_signal("empty")
		if Input.is_action_just_pressed("ui_select"):
			if bulletcount > 0:
				shoot()
		var velocity = Vector2()  # The player's movement vector.
		if Input.is_action_pressed("ui_right"):
			velocity.x += 1
			$Sprite.rotation = 0.4
		if Input.is_action_pressed("ui_left"):
			velocity.x -= 1
			$Sprite.rotation = -0.4
		if Input.is_action_pressed("ui_down"):
			velocity.y += 1
			$Sprite.rotation = 0.8
		if Input.is_action_pressed("ui_up"):
			velocity.y -= 1
			$Sprite.rotation = -0.8
		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
		
		position += velocity * delta
		position.x = clamp(position.x, 0, screen_size.x)
		position.y = clamp(position.y, 0, screen_size.y)


func shoot():
	emit_signal("shooting")
	print("SHOOTING")
	var b = bullet.instance()
	owner.add_child(b)
	b.transform = $BulletPosition.global_transform

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _on_Player_area_entered(area):
	playing = false
	$Sprite.hide()
	area.queue_free()
	$CollisionShape2D.set_deferred("disabled", true)
	$Explosion.play()
	$ExplosionSound.play()
	emit_signal("hit")
	yield(get_tree().create_timer(2.0), "timeout")
	$Explosion.stop()
	$ExplosionSound.stop()
