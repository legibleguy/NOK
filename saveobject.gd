extends Node
#ADD THIS SCRIPT TO AUTOLOAD
const FILE_NAME = "user://game-data.json"
const FILE_PASS = "vM+7}NZ)>{wQ4zf;" #feel free to change it to your own password

var gameData = {
	"bestScore": -1
}

func saveGame():
	var file = File.new()
	file.open_encrypted_with_pass(FILE_NAME, File.WRITE, FILE_PASS)
	file.store_string(to_json(gameData))
	file.close()

func loadGame():
	var file = File.new()
	if file.file_exists(FILE_NAME):
		file.open(FILE_NAME, File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			gameData = data
			return true
		else:
			printerr("Corrupted data!")
			return false
	else:
		printerr("No saved data!")
		return false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
