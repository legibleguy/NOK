extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var score: int
var spawnInterval = 2.0

var meteorRef = preload("res://meteor2D.tscn")
var diamondRef = preload("res://Diamond.tscn")

func _spawn_meteor():
	randomize()
	var locX = rand_range(512, 48*64-512)
	
	if randi()%2:
		var newMeteor = meteorRef.instance()
		add_child(newMeteor)
		newMeteor.position = Vector2(locX, 256)
		newMeteor.rockets = $Rocket.rockets
		newMeteor.start()
	else:
		var newDiamond = diamondRef.instance()
		add_child(newDiamond)
		newDiamond.position = Vector2(locX, 256)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	
#	$AudioStreamPlayer2D.stream = dababy
#	$AudioStreamPlayer2D.play()
	
	var timer = Timer.new()
	timer.connect("timeout", self, "_spawn_meteor")
	add_child(timer)
	timer.start(spawnInterval)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
#
