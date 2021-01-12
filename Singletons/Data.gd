extends Node


var data = {
	
	"username":"EpicDude54",
	"controls":
		{
		
			"attack1":InputMap.get_action_list("attack1")[0],
			"attack2":InputMap.get_action_list("attack2")[0],
			"ability1":InputMap.get_action_list("ability1")[0],
			"ability2":InputMap.get_action_list("ability2")[0],
		
		}
	
}

const password = "password?"
var savePath:String = "user://BadStars2Data.save"

func _ready():
	retrieveData()
	Network.info.name = data.username

func saveData():
	
	var file = ConfigFile.new()
	
	for key in data.keys():
		file.set_value("data", key, data[key])
	
	file.save_encrypted_pass(savePath, password)
	
	pass
	
func retrieveData():
	
	var file = ConfigFile.new()
	
	var err = file.load_encrypted_pass(savePath, password)

	if not err == OK:
		saveData()
		return
		
	for key in file.get_section_keys("data"):
		data[key] = file.get_value("data", key, data[key])
	
	pass
