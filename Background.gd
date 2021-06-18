extends ParallaxBackground

func _process(delta):
	scroll_offset.x -= 100 * delta

func _ready():
	pass
