extends KinematicBody2D

var col: CollisionShape2D

var SPEED =  160.0
var interval = 0.1
var timeSinceMove = 0
var rockets

onready var actualSpeed = SPEED

var allMeteors = [preload("res://meteor1.tscn"), preload("res://meteor2.tscn"),
preload("res://meteor3.tscn"), preload("res://meteor4.tscn")]

func adjustSpeed():
	if rockets.size() > 2: actualSpeed = SPEED
	elif rockets.size() == 2: actualSpeed = SPEED * 2
	elif rockets.size() == 1: actualSpeed = SPEED *3
	else: actualSpeed = 0 

func start():
	randomize()
	var ind = randi()%3
	var choice = allMeteors[ind]
	var meteorImg = choice.instance()
	add_child(meteorImg)
	
	col = get_child(0)
	adjustSpeed()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if position.y < 0: queue_free()
	if timeSinceMove >= interval: 
		var col = move_and_collide(Vector2(0, actualSpeed))
		if col:
			if col.collider.has_method("rocketHit"): 
				col.collider.rocketHit()
			elif col.collider.name == "bullet": queue_free()
			
		#translate(Vector2(0, SPEED))
		timeSinceMove = 0
	else: timeSinceMove += delta