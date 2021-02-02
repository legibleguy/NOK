extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var meteorRef = preload("res://meteor2D.tscn")

func _spawn_meteor():
	randomize()
	var locX = rand_range(512, 48*64-512)
	var newMeteor = meteorRef.instance()
	add_child(newMeteor)
	newMeteor.position = Vector2(locX, 640)
	newMeteor.start()
	

# Called when the node enters the scene tree for the first time.
func _ready():
	var timer = Timer.new()
	timer.connect("timeout", self, "_spawn_meteor")
	add_child(timer)
	timer.start(4)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
