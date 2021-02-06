tool
extends KinematicBody2D

export var rocketName = ""
export var invertColors: bool = false
export var showName = false
export var menuMode = false

const MENU_SPEED = 2.0
const MENU_MOVE_FREQ = 0.1
var timeSinceMove = 0.0

var bulletRef = preload("res://Scenes/bullet.tscn")

func rocketHit():
	get_parent().removeRocket(self)
	queue_free()

func shoot(ignoreD = false):
	var newBullet = bulletRef.instance()
	newBullet.ignoreDiamonds = ignoreD
	if ignoreD: newBullet.set_collision_mask_bit(2, false)
	get_parent().get_parent().add_child(newBullet)
	newBullet.position = get_parent().position + (position * get_parent().scale - Vector2(0, 64.0*5.0)) #position + Vector2(0, -64.0*15.0)
	#get_parent().get_parent().add_child(newBullet)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionShape2D/TileMap/Label.set_text(rocketName)
	$CollisionShape2D/TileMap/Label.visible = showName
	
	if invertColors:
		invertTileMap($CollisionShape2D/TileMap)
		$CollisionShape2D/TileMap/Label.add_color_override("font_color", "43523d")
	else: $CollisionShape2D/TileMap/Label.add_color_override("font_color", "c7f0d8")

func invertTileMap(tm):
	var used = tm.get_used_cells()
	var currTile =  tm.get_cellv(used[0])
	var targetTile = 0
	if currTile == 0: targetTile = 1
	for cell in tm.get_used_cells():
		tm.set_cellv(cell, targetTile)

func setInput(dir):
	if dir == -1:
		$CollisionShape2D/TileMap.visible = false
		$"CollisionShape2D/45".visible = true
		$"CollisionShape2D/45".scale.x = 64
	if dir == 0:
		$CollisionShape2D/TileMap.visible = true
		$"CollisionShape2D/45".visible = false
	if dir == 1:
		$CollisionShape2D/TileMap.visible = false
		$"CollisionShape2D/45".visible = true
		$"CollisionShape2D/45".scale.x = -64

func _process(delta):
	if menuMode:
		if position.y < -10:
			position = Vector2(position.x, 86)
		
		if timeSinceMove >= MENU_MOVE_FREQ:
			translate(Vector2(0, -MENU_SPEED))
			timeSinceMove = 0.0
		else: timeSinceMove += delta
