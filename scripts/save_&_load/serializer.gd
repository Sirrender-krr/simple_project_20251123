extends Resource
class_name Serializer

const SAVE_GAME_PATH = "user://save.tres"

@export var player: Player_data = Player_data.new()

func save_data():
	ResourceSaver.save(self,SAVE_GAME_PATH)

func load_data():
	var save_data = ResourceLoader.load(SAVE_GAME_PATH,"")
	player = save_data.player
