extends KinematicBody2D

export var bulletcount = 5
onready var bullet = preload("res://Bullet.tscn")

var speed = 600
var friction = 0.05
var acceleration = 0.1
var velocity = Vector2.ZERO

var screen_size
export var playing = false
signal hit
signal empty
signal shooting

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	screen_size = get_viewport_rect().size
	var player_types = $Sprite.frames.get_animation_names()
	$Sprite.animation = player_types[randi() % player_types.size()]

func _physics_process(delta):
	if playing:
		$Sprite.rotation = 0.0
		if bulletcount <= 0:
			emit_signal("empty")
		if Input.is_action_just_pressed("ui_select"):
			if bulletcount > 0:
				shoot()
		var input_velocity = Vector2.ZERO
		# Check input for "desired" velocity
		if Input.is_action_pressed("ui_right"):
			input_velocity.x += 1
			$Sprite.rotation = 0.4
		if Input.is_action_pressed("ui_left"):
			input_velocity.x -= 1
			$Sprite.rotation = -0.4
		if Input.is_action_pressed("ui_down"):
			input_velocity.y += 1
			$Sprite.rotation = 0.8
		if Input.is_action_pressed("ui_up"):
			input_velocity.y -= 1
			$Sprite.rotation = -0.8
		input_velocity = input_velocity.normalized() * speed

		# If there's input, accelerate to the input velocity
		if input_velocity.length() > 0:
			velocity = velocity.linear_interpolate(input_velocity, acceleration)
		else:
			# If there's no input, slow down to (0, 0)
			velocity = velocity.linear_interpolate(Vector2.ZERO, friction)
		velocity = move_and_slide(velocity)
	
		position.x = clamp(position.x, 10, screen_size.x-10)
		position.y = clamp(position.y, 10, screen_size.y-10)


func shoot():
	emit_signal("shooting")
	print("SHOOTING")
	var b = bullet.instance()
	b.transform = $BulletPosition.global_transform
	owner.add_child(b)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	
func plane_died():
	playing = false
#	area.queue_free()
	$CollisionShape2D.set_deferred("disabled", true)
	$Explosion.play()
	$ExplosionSound.play()
	$Sprite.hide()
	emit_signal("hit")
	yield(get_tree().create_timer(2.0), "timeout")
	$Explosion.stop()
	$ExplosionSound.stop()
