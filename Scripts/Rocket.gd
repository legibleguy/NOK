extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var gucci = preload("res://Sounds/gucci.wav")
var rocketHitSound = preload("res://Sounds/hit.wav")
var shootingSound = preload("res://Sounds/shot.wav")

var MOVE_INTERVAL = 0.134
var SHOOT_INTERVAL = 0.3
var SPEED = 4096.0
const ROCKETSIZE: float = 14.0*64.0
var threeROCKETS: float = 36.0*64.0

onready var actualSpeed = SPEED

var timeSinceLastMove: float
var timeSinceLastShot: float

var currentShootingRocket: int = 0

var NOK
var GME
var AMC
var rockets = []

func removeRocket(inRocket):
	var toKeep = []
	for roc in rockets:
		if inRocket != roc: toKeep.push_back(roc)
	rockets = toKeep
	
	$AudioStreamPlayer2D.stop()
	$AudioStreamPlayer2D.stream = rocketHitSound
	$AudioStreamPlayer2D.play()
	

func diamondHit():
	$AudioStreamPlayer2D.stop()
	$AudioStreamPlayer2D.stream = gucci
	$AudioStreamPlayer2D.play()

# Called when the node enters the scene tree for the first time.
func _ready():
	NOK = get_child(0)
	GME = get_child(1)
	AMC = get_child(2)
	rockets = [GME, NOK, AMC]
	
	
	
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func adjustSpeed():
	if rockets.size() > 2: actualSpeed = SPEED
	elif rockets.size() == 2: actualSpeed = SPEED * 2
	elif rockets.size() == 1: actualSpeed = SPEED *4
	else: actualSpeed = 0 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	adjustSpeed()
	
	var interval: bool = timeSinceLastMove >= MOVE_INTERVAL
	var interval_shoot = timeSinceLastShot >= SHOOT_INTERVAL
	
	var locClampMax: float
	var locClampMin: float
	
	if rockets.has(AMC): locClampMax = threeROCKETS
	elif rockets.has(NOK): locClampMax = ROCKETSIZE * 2.0
	else: locClampMax = 0.0
	
	if rockets.has(GME): locClampMin = 0.0
	elif rockets.has(NOK): locClampMin = -ROCKETSIZE
	else: locClampMin = -ROCKETSIZE * 2.0
	#left
	if position.x > locClampMin and Input.is_action_pressed("move_left") and interval: 
		translate(Vector2(-actualSpeed*delta, 0))
		timeSinceLastMove = 0.0
	#right
	elif position.x < (48.0*64.0 - locClampMax) and Input.is_action_pressed("move_right") and interval: 
		translate(Vector2(actualSpeed*delta, 0))
		timeSinceLastMove = 0.0
	else: timeSinceLastMove += delta
	
	if interval_shoot and Input.is_action_just_pressed("shoot") and rockets.size() != 0:
		timeSinceLastShot = 0
		var rocket
		if currentShootingRocket < rockets.size():
			 rocket = rockets[currentShootingRocket]
			 if !$AudioStreamPlayer2D.playing: $AudioStreamPlayer2D.play()
		else:
			currentShootingRocket = 0
			rocket = rockets[0]
		rocket.shoot()
		if currentShootingRocket + 1 >= rockets.size(): currentShootingRocket = 0
		else: currentShootingRocket += 1
		
	else: timeSinceLastShot += delta


func _on_AudioStreamPlayer2D_finished():
	if $AudioStreamPlayer2D.stream != shootingSound: $AudioStreamPlayer2D.stream = shootingSound
