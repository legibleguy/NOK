extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var score: int
var bestScore: int
var spawnInterval = 1.0
var timer: Timer
var isGameOver: bool
var holdToShootMode = false
var holdToShootTimer: Timer
const holdToShootInterval = 0.34

var meteorRef = preload("res://Scenes/meteor2D.tscn")
var diamondRef = preload("res://Scenes/Diamond.tscn")

func holdToShootToggle():
	$ScoreContainer/HoldItLabel.visible = !$ScoreContainer/HoldItLabel.visible

func startHoldToShoot():
	$ScoreContainer/Score.visible = false
	$ScoreContainer/HoldItLabel.visible = true
	holdToShootMode = true
	if !holdToShootTimer: 
		holdToShootTimer = Timer.new()
		holdToShootTimer.connect("timeout",self, "holdToShootToggle")
		add_child(holdToShootTimer)
	holdToShootTimer.start(holdToShootInterval)

func stopHoldToShoot():
	holdToShootMode = false
	if holdToShootTimer: holdToShootTimer.stop()
	
	$ScoreContainer/Score.visible = true
	$ScoreContainer/HoldItLabel.visible = false

func _spawn_meteor():
	if isGameOver: return
	randomize()
	var locX = rand_range(512, 48*64-512)
	
	if randi()%2 or holdToShootMode:
		var newMeteor = meteorRef.instance()
		add_child(newMeteor)
		newMeteor.position = Vector2(locX, 256)
		newMeteor.rockets = $Rocket.rockets
		newMeteor.start()
	else:
		var newDiamond = diamondRef.instance()
		add_child(newDiamond)
		newDiamond.position = Vector2(locX, 256)

func gameOver():
	stopHoldToShoot()
	timer.stop()
	timer.queue_free()
	isGameOver = true
	
	$ScoreContainer/Score.visible = true
	$ScoreContainer/HoldItLabel.visible = false

	var newText 
	if score <= bestScore: newText = "Score: " + str(score) + ". Previous Best: " + str(bestScore) + ". Press Spacebar"
	else: 
		newText = "New Best Score: " + str(score) + "! " + " Press Spacebar"
		savegame.gameData.bestScore = score
		savegame.saveGame()
	$ScoreContainer/Score.set_text(newText)
	

func addScore():
	score += 1
	$ScoreContainer/Score.set_text(str(score))

# Called when the node enters the scene tree for the first time.
func _ready():
	
	savegame.loadGame()
	bestScore = savegame.gameData.bestScore
	
#	$AudioStreamPlayer2D.stream = dababy
#	$AudioStreamPlayer2D.play()
	
	
	timer = Timer.new()
	timer.connect("timeout", self, "_spawn_meteor")
	add_child(timer)
	timer.start(spawnInterval)

func _process(delta):
	if isGameOver and Input.is_action_just_pressed("shoot"): 
		get_tree().change_scene("res://map.tscn")
