extends TileMap



var originalPointsLoc = []
var originalPoints = []
var middleX: int
var middleY: int

var currPointsLoc = []
var currPoints = []

func rotate(left = true):
	var cells = get_used_cells()
	var center = Vector2(middleX, middleY)
	
	var targetLocations = []
	var tile
	
	for cell in cells:
		if tile == null: tile = get_cellv(cell)
		var initialCoords = world_to_map(cell)
		
		var delta = initialCoords - center
		var offset: Vector2

func getCurrentCenter():
	var used = get_used_rect()
	var centerX = int(used.position.x) + int(floor(used.size.x/2))
	var centerY = int(used.position.y) + int(floor(used.size.y/2))
	return Vector2(centerX, centerY)

func _ready():
	var cells = get_used_cells()
	for cell in cells:
		originalPointsLoc.push_front(cell)
		originalPoints.push_front(get_cellv(cell))
		
	var midpoint = getCurrentCenter()
	middleX = int(midpoint.x)
	middleY = int(midpoint.y)
		