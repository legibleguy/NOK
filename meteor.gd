extends TileMap

var SPEED = 256.0
var interval = .06
var timeSInceMove = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if position.y < 0: queue_free()
	if timeSInceMove >= interval: 
		translate(Vector2(0, SPEED))
		timeSInceMove = 0
	else: timeSInceMove += delta
