extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var MOVE_INTERVAL = 0.134
var SHOOT_INTERVAL = 0.3
var SPEED = 4096.0
const ROCKETSIZE: float = 14.0*64.0
var threeROCKETS: float = 36.0*64.0

var timeSinceLastMove: float
var timeSinceLastShot: float

var currentShootingRocket: int = 0

var NOK
var GME
var AMC
var rockets = []

# Called when the node enters the scene tree for the first time.
func _ready():
	NOK = get_child(0)
	GME = get_child(1)
	AMC = get_child(2)
	rockets = [GME, NOK, AMC]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var interval: bool = timeSinceLastMove >= MOVE_INTERVAL
	var interval_shoot = timeSinceLastShot >= SHOOT_INTERVAL
	#left
	if position.x > 0 and Input.is_action_pressed("move_left") and interval: 
		translate(Vector2(-SPEED*delta, 0))
		timeSinceLastMove = 0.0
	#right
	elif position.x < (48.0*64.0 - threeROCKETS) and Input.is_action_pressed("move_right") and interval: 
		translate(Vector2(SPEED*delta, 0))
		timeSinceLastMove = 0.0
	else: timeSinceLastMove += delta
	
	if interval_shoot and Input.is_action_just_pressed("shoot") and rockets.size() != 0:
		timeSinceLastShot = 0
		var rocket = rockets[currentShootingRocket]
		rocket.shoot()
		if currentShootingRocket + 1 >= rockets.size(): currentShootingRocket = 0
		else: currentShootingRocket += 1
		
	else: timeSinceLastShot += delta
