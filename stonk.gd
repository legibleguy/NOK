extends TileMap

var bulletRef = preload("res://bullet.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func shoot():
	var newBullet = bulletRef.instance()
	get_parent().get_parent().add_child(newBullet)
	newBullet.position = get_parent().position + (position * get_parent().scale - Vector2(0, 64.0*5.0)) #position + Vector2(0, -64.0*15.0)
	#get_parent().get_parent().add_child(newBullet)
	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
