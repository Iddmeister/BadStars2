extends Control

var maxBuffer:float = 2
var buffer:float = 0
var sequence = ["Up", "Up", "Down", "Down", "Left", "Right", "Left", "Right", "B", "A"]
var index:int = 0

func _input(event):
	
	if event is InputEventKey and event.is_pressed():
		
		var key = OS.get_scancode_string(event.scancode)
		if key == sequence[index]:
			index += 1
			buffer = 0
			
			if index == sequence.size():
				devMode()
				index = 0
				
func devMode():
	$Dev.show()
	Globals.devMode = true

func _process(delta):
	
	buffer += delta
	
	if buffer >= maxBuffer:
		buffer = 0
		index = 0


func _ready():
	$Play/CenterContainer/VBoxContainer/Name.text = Network.info.name
	pass


func _on_Play_pressed():
	$Main.hide()
	$Play.show()


func _on_Quit_pressed():
	$QuitMessage.show()
	get_tree().quit()


func _on_Host_pressed():
	var err = Network.hostGame()
	if err == OK:
		Manager.changeScene("res://Screens/Lobby/Lobby.tscn")

func _on_Join_pressed():
	var err = Network.joinGame($Play/CenterContainer/VBoxContainer/IP.text)
	if err == OK:
		yield(Network, "recievedPlayerInfo")
		Manager.changeScene("res://Screens/Lobby/Lobby.tscn")


func _on_Name_text_changed(new_text):
	Network.info.name = new_text
	Data.data.username = new_text
	Data.saveData()


func _on_x_pressed():
	Manager.changeScene("res://Screens/Menu/X.tscn")
	pass # Replace with function body.


func _on_Y_button_down():
	$Main/VBoxContainer/Title.text = "Bruh stars"
	$Main/VBoxContainer/Title/Y.visible = false
	pass # Replace with function body.


func _on_Options_pressed():
	Manager.changeScene("res://Screens/Options/Options.tscn")


func _on_Back_pressed():
	$Play.hide()
	$Main.show()
