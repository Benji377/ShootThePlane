extends Node

var score
export (PackedScene) var Enemy

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$Player.hide()

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func game_over():
	print("Dead")
	get_tree().call_group("enemies", "queue_free")
	$Player.playing = false
	$Menu.show_game_over()
	$EnemySpawnTimer.stop()


func new_game():
	score = 0
	$Player.bulletcount = 5
	$Player.start($PlayerPosition.position)
	$StartDelay.start()
	$Menu.update_score(score)
	$Menu.update_bulletcount($Player.bulletcount)
	$Menu.show_message("Get ready")
	$Player.playing = true
	$Player.show()
	$Player/Sprite.show()


func _on_EnemySpawnTimer_timeout():
	print("Spawn enemy")
	# Choose a random location on Path2D. --> 2142 and 170
	$EnemyPath/EnemySpawnLocation.offset = rand_range(1, 760)
	# Create a Mob instance and add it to the scene.
	var mob = Enemy.instance()
	add_child(mob)
	# Set the mob's direction perpendicular to the path direction.
	var direction = $EnemyPath/EnemySpawnLocation.rotation + PI / 2
	# Set the mob's position to a random location.
	mob.position = $EnemyPath/EnemySpawnLocation.position
	# Add some randomness to the direction.
	direction *= 100
	mob.rotation = direction
	connect_to_enemy(mob)


func connect_to_enemy(enemy_node):
	enemy_node.connect("enemy_hit",self,"_on_Player_point")


func _on_StartDelay_timeout():
	$EnemySpawnTimer.start()


func _on_Player_point():
	if $Player.is_visible_in_tree():
		print("Plane hitted")
		score += 1
		$Player.bulletcount += 5
		$Menu.update_bulletcount($Player.bulletcount)
		$Menu.update_score(score)


func _on_Player_shooting():
	$Player.bulletcount -= 1
	$Menu.update_bulletcount($Player.bulletcount)
