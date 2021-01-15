extends Node


var data = {
	
	"username":"EpicDude54",
	"controls":
		{
		
			"attack1":{"type":"mouse", "button_index":1},
			"attack2":{"type":"mouse", "button_index":2},
			"ability1":{"type":"key", "scancode":81},
			"ability2":{"type":"key", "scancode":69},
		
		}
	
}

const password = "password?"
var savePath:String = "user://BadStars2Data.save"

func _ready():
	retrieveData()
	Network.info.name = data.username
	
	updateControls()
	
func updateControls():
	
	InputMap.action_erase_events("attack1")
	InputMap.action_add_event("attack1", getInputEventFromDict(data.controls.attack1))

	InputMap.action_erase_events("attack2")
	InputMap.action_add_event("attack2", getInputEventFromDict(data.controls.attack2))

	InputMap.action_erase_events("ability1")
	InputMap.action_add_event("ability1", getInputEventFromDict(data.controls.ability1))

	InputMap.action_erase_events("ability2")
	InputMap.action_add_event("ability2", getInputEventFromDict(data.controls.ability2))

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
	
func getInputEventFromDict(dict:Dictionary):
	
	var event:InputEvent
	
	if dict.type == "mouse":
		event = InputEventMouseButton.new()
		event.button_index = dict.button_index
	elif dict.type == "key":
		event = InputEventKey.new()
		event.scancode = dict.scancode
		
	return event
	
	pass
	
