extends Control


func _ready():
	$Play/VBoxContainer/Name.text = Network.info.name
	pass


func _on_Play_pressed():
	$Main.hide()
	$Play.show()


func _on_Quit_pressed():
	get_tree().quit()


func _on_Host_pressed():
	var err = Network.hostGame()
	if err == OK:
		Manager.changeScene("res://Screens/Lobby/Lobby.tscn")

func _on_Join_pressed():
	var err = Network.joinGame($Play/VBoxContainer/IP.text)
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
