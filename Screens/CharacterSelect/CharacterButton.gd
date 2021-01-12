extends Control

signal selected()

var character:String

func setup(_character:String):
	
	character = _character
	
	var info = CharacterInfo.characters[character]
	
	$HBoxContainer/Info/VBoxContainer/Name.text = character
	$HBoxContainer/Icon.texture = load(info.icon)
	
	$HBoxContainer/Info/VBoxContainer/Description.text = info.info.description
	$HBoxContainer/Info/VBoxContainer/Info/Attack1/Info.text = info.info.attack1
	$HBoxContainer/Info/VBoxContainer/Info/Attack2/Info.text = info.info.attack2
	$HBoxContainer/Info/VBoxContainer/Info/Ability1/Info.text = info.info.ability1
	$HBoxContainer/Info/VBoxContainer/Info/Ability2/Info.text = info.info.ability2
	pass



func _on_CharacterButton_gui_input(event):
	
	if event is InputEventMouseButton:
		
		if event.is_action_pressed("click"):
			
			emit_signal("selected", character)
