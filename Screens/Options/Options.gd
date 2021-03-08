extends Control

onready var attack1 = $ScrollContainer/VBoxContainer/Controls/Attack1/Attack1
onready var attack2 = $ScrollContainer/VBoxContainer/Controls/Attack2/Attack2
onready var ability1 = $ScrollContainer/VBoxContainer/Controls/Ability1/Ability1
onready var ability2 = $ScrollContainer/VBoxContainer/Controls/Ability2/Ability2
onready var cursorMove = $ScrollContainer/VBoxContainer/Controls/CursorMove/CursorMove


func _ready():
	updateInputs()
	pass
	
func updateInputs():
	attack1.text = getEventAsText(InputMap.get_action_list("attack1")[0])
	attack2.text = getEventAsText(InputMap.get_action_list("attack2")[0])
	ability1.text = getEventAsText(InputMap.get_action_list("ability1")[0])
	ability2.text = getEventAsText(InputMap.get_action_list("ability2")[0])
	if not InputMap.get_action_list("cursorMove").empty():
		cursorMove.text = getEventAsText(InputMap.get_action_list("cursorMove")[0])
	else:
		cursorMove.text = "-"

func _on_Back_pressed():
	Manager.changeScene("res://Screens/Menu/Menu.tscn")

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

func getEventAsText(event):
	var text = event.as_text()
	if event is InputEventMouseButton:
		if event.is_action("leftClick"):
			text = "Mouse Left"
		elif event.is_action("rightClick"):
			text = "Mouse Right"
		elif event.is_action("middleMouse"):
			text = "Mouse Middle"
	return text

func getEventAsDict(event:InputEvent):
	
	var dict:Dictionary
	
	if event is InputEventMouseButton:
		dict.type = "mouse"
		dict.button_index = event.button_index
	elif event is InputEventKey:
		dict.type = "key"
		dict.scancode = event.scancode
		
	return dict
	
	pass

func _on_Attack1_assignedInput(input):
	Data.data.controls.attack1 = getEventAsDict(input)
	Data.saveData()
	Data.updateControls()


func _on_Attack2_assignedInput(input):
	Data.data.controls.attack2 = getEventAsDict(input)
	Data.saveData()
	Data.updateControls()



func _on_Ability1_assignedInput(input):
	Data.data.controls.ability1 = getEventAsDict(input)
	Data.saveData()
	Data.updateControls()



func _on_Ability2_assignedInput(input):
	Data.data.controls.ability2 = getEventAsDict(input)
	Data.saveData()
	Data.updateControls()



func _on_CursorMove_assignedInput(input):
	Data.data.controls.cursorMove = getEventAsDict(input)
	Data.saveData()
	Data.updateControls()
