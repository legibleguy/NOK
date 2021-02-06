extends TileMap

const FILL_FREQ = 0.5
const CELLS_X = 84
const CELLS_Y = 42

var currCellX = 0
var currCellY = 0

var timer: Timer
onready var used = get_used_cells()
var target = 1
var lastTile = 0

func startGame():
	get_tree().change_scene("res://map.tscn")

func startFilling():
	#var currColor = get_cellv(used[0])
	#if currColor == 0: target = 1
	
	timer = Timer.new()
	timer.connect("timeout", self, "fill")
	add_child(timer)
	timer.start(FILL_FREQ)

func fill():
	set_cell(currCellX, currCellY, target)
	currCellX += 1
	lastTile += 1
	
	if currCellX > CELLS_X:
		currCellX = 0
		currCellY += 1
	
	if lastTile == used.size() - 1:
		timer.queue_free()
		startGame()
		
func _ready():
	set_cell(0, 0, 1)
	