extends KinematicBody2D

var SPEED = 256.0
var interval = .06
var timeSinceMove = 0
var timeInRest = 0.0
const MAX_TIME_IN_REST = 0.2
var ignoreDiamonds = false


var lastPosY: float = 0
var currVelY: float = -1.0

func _ready():
	collision_layer = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if position.y < 0: queue_free()
	if timeSinceMove >= interval: 
		var col = move_and_collide(Vector2(0, -SPEED))
		
		currVelY = position.y - lastPosY
		lastPosY = position.y
		
		if col:
			if col.collider.name == "meteor2D" or col.collider.name == "Diamond": 
				col.collider.queue_free()
				self.queue_free()
		
		timeSinceMove = 0
	else: timeSinceMove += delta
	
	if abs(currVelY) < 0.1:
		timeInRest += delta
		if timeInRest == MAX_TIME_IN_REST: queue_free()
	else: timeInRest = 0
