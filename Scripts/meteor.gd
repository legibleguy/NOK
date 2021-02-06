extends KinematicBody2D

var col: CollisionShape2D

var SPEED =  160.0
var interval = 0.1
var timeSinceMove = 0
var rockets
var wasHit = false

var lastPosY: float = 0
var currVelY: float = -1.0

onready var actualSpeed = SPEED

var allMeteors = [preload("res://Scenes/meteor1.tscn"), preload("res://Scenes/meteor2.tscn"),
preload("res://Scenes/meteor4.tscn"), preload("res://Scenes/meteor3.tscn")]

func adjustSpeed():
	if wasHit: 
		actualSpeed = 0
		return
	
	if rockets.size() > 2: actualSpeed = SPEED
	elif rockets.size() == 2: actualSpeed = SPEED * 2
	elif rockets.size() == 1: actualSpeed = SPEED *2.5
	else: actualSpeed = 0 

func start():
	randomize()
	var ind = randi()%3
	var choice = allMeteors[ind]
	var meteorImg = choice.instance()
	add_child(meteorImg)
	
	col = get_child(0)
	adjustSpeed()
	
	lastPosY = position.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if position.y < 0: queue_free()
	if timeSinceMove >= interval: 
		
		var col = move_and_collide(Vector2(0, actualSpeed))
		
		currVelY = position.y - lastPosY
		lastPosY = position.y
		
		if col:
			if !wasHit and col.collider.has_method("rocketHit"): 
				col.collider.rocketHit()
			elif col.collider.name == "bullet": 
				self.queue_free()
				#col.collider.queue_free()
				
			
		#translate(Vector2(0, SPEED))
		timeSinceMove = 0
	else: timeSinceMove += delta

	if currVelY == 0: queue_free()