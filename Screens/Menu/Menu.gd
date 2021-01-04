extends Control


func _ready():
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
