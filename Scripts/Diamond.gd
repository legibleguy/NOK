extends KinematicBody2D

var col: CollisionShape2D

var SPEED =  256.0
var interval = 0.1
var timeSinceMove = 0



func _ready():
	col = get_child(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if position.y < 0: queue_free()
	if timeSinceMove >= interval: 
		var col = move_and_collide(Vector2(0, SPEED))
		if col:
			if col.collider.get_parent().has_method("diamondHit"): 
				col.collider.get_parent().diamondHit()
				queue_free()
			elif col.collider.name == "bullet": 
				queue_free()
				col.collider.queue_free()
			
		#translate(Vector2(0, SPEED))
		timeSinceMove = 0
	else: timeSinceMove += delta
