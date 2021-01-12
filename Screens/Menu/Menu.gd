extends Control


func _ready():
	$Play/VBoxContainer/Name.text = Network.info.name
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
	var err = Network.joinGame($Play/VBoxContainer/IP.text)
	if err == OK:
		yield(Network, "recievedPlayerInfo")
		Manager.changeScene("res://Screens/Lobby/Lobby.tscn")


func _on_Name_text_changed(new_text):
	Network.info.name = new_text
	Data.data.username = new_text
	Data.saveData()


func _on_Options_pressed():
	$Shh/CenterContainer/Label.visible = true
	$Main/VBoxContainer/VBoxContainer/Pow.emitting = true
	$Timer.start(3)
	pass 


func _on_Timer_timeout():
	$Shh/CenterContainer/Label.visible = false
	$Main/VBoxContainer/VBoxContainer/Pow.emitting = false
	pass
