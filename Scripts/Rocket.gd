extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var gucci = preload("res://Sounds/gucci.wav")
var rocketHitSound = preload("res://Sounds/hit.wav")
var shootingSound = preload("res://Sounds/shot.wav")

var MOVE_INTERVAL = 0.134
var SHOOT_INTERVAL = 0.3
var SPEED = 8192.0
const ROCKETSIZE: float = 14.0*64.0
var threeROCKETS: float = 36.0*64.0

#a special shooting mode that unlocks every 10 diamonds
var holdToShoot = false
const TIME_holdToShoot = 7.0

var diamondCounter: int = 0

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
	
	if rockets.size() == 0: 
		get_parent().gameOver()
	
	$AudioStreamPlayer2D.stop()
	$AudioStreamPlayer2D.stream = rocketHitSound
	$AudioStreamPlayer2D.play()

func startHoldToShoot():
	get_parent().startHoldToShoot()
	
	holdToShoot = true
	var timer = Timer.new()
	timer.connect("timeout", self, "stopHoldToShoot")
	add_child(timer)
	timer.start(TIME_holdToShoot)

func stopHoldToShoot():
	holdToShoot = false
	get_parent().stopHoldToShoot()

func diamondHit():
	get_parent().addScore()
	
	$AudioStreamPlayer2D.stop()
	$AudioStreamPlayer2D.stream = gucci
	$AudioStreamPlayer2D.play()
	
	diamondCounter += 1
	if diamondCounter == 10: 
		startHoldToShoot()
		diamondCounter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	NOK = get_child(0)
	GME = get_child(1)
	AMC = get_child(2)
	rockets = [GME, NOK, AMC]
	
	
	
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func turnLeft():
	for rocket in rockets:
		rocket.setInput(-1)

func turnRight():
	for rocket in rockets:
		rocket.setInput(1)

func resetTurn():
	for rocket in rockets:
		rocket.setInput(0)

func adjustSpeed():
	if rockets.size() > 2: actualSpeed = SPEED
	elif rockets.size() == 2: actualSpeed = SPEED * 2
	elif rockets.size() == 1: actualSpeed = SPEED *5
	else: actualSpeed = 0 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if rockets.size() != 0:
		adjustSpeed()
		movement(delta)
		shooting(delta)

func movement(delta):
	var interval: bool = timeSinceLastMove >= MOVE_INTERVAL
	
	var locClampMax: float
	var locClampMin: float
	
	if rockets.has(AMC): locClampMax = threeROCKETS
	elif rockets.has(NOK): locClampMax = ROCKETSIZE * 2.0
	else: locClampMax = 0.0
	
	if rockets.has(GME): locClampMin = 0.0
	elif rockets.has(NOK): locClampMin = -ROCKETSIZE
	else: locClampMin = -ROCKETSIZE * 2.0
	
	if rockets.size() == 1 and rockets.has($"$AMC"):
		locClampMin = -1300
	#left
	if position.x > locClampMin and Input.is_action_pressed("move_left") and interval: 
		translate(Vector2(-actualSpeed*delta, 0))
		timeSinceLastMove = 0.0
		turnLeft()
	#right
	elif position.x < (48.0*64.0 - locClampMax) and Input.is_action_pressed("move_right") and interval: 
		translate(Vector2(actualSpeed*delta, 0))
		timeSinceLastMove = 0.0
		turnRight()
	else: timeSinceLastMove += delta
	
	if !Input.is_action_pressed("move_right") and !Input.is_action_pressed("move_left"):
		resetTurn()

func shooting(delta):
	var interval_shoot = timeSinceLastShot >= SHOOT_INTERVAL
	if (interval_shoot and Input.is_action_just_pressed("shoot")) or (Input.is_action_pressed("shoot") and holdToShoot) and rockets.size() != 0:
		timeSinceLastShot = 0
		var rocket
		if currentShootingRocket < rockets.size():
			 rocket = rockets[currentShootingRocket]
			 if !$AudioStreamPlayer2D.playing: $AudioStreamPlayer2D.play()
		else:
			currentShootingRocket = 0
			rocket = rockets[0]
		rocket.shoot(holdToShoot)
		if currentShootingRocket + 1 >= rockets.size(): currentShootingRocket = 0
		else: currentShootingRocket += 1
		
	else: timeSinceLastShot += delta

func _on_AudioStreamPlayer2D_finished():
	if $AudioStreamPlayer2D.stream != shootingSound: $AudioStreamPlayer2D.stream = shootingSound
