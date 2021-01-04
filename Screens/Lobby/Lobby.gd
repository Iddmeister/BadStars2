extends Control

var PlayerIcon = preload("res://Screens/Lobby/PlayerIcon.tscn")

var character:String

func _ready():
	addAllPlayers()
	Network.connect("playerJoined", self, "addNewPlayer")
	Network.connect("playerLeft", self, "removePlayer")
	pass
	
func addAllPlayers():
	
	for player in Network.players.keys():
		
		var p = PlayerIcon.instance()
		p.name = String(player)
		$Main/Players.add_child(p)
		
func addNewPlayer(id:int):
	var p = PlayerIcon.instance()
	p.name = String(id)
	$Main/Players.add_child(p)
	
	if is_network_master():
		
		var players = {}
		
		for player in $Main/Players.get_children():
			
			players[player.name] = player.ready
			
		rpc_id(id, "updatePlayers", players)
	
	pass
	
remotesync func updatePlayers(players:Dictionary):
	
	for player in players.keys():
		$Main/Players.get_node(player).setReady(players[player])
		
	
func removePlayer(id:int):
	$Main/Players.get_node(String(id)).queue_free()

remotesync func readyUp(id:int, r:bool):
	
	$Main/Players.get_node(String(id)).setReady(r)
	
	if is_network_master():
		if checkAllReady():
			print("woo")
	
	pass
	
func checkAllReady() -> bool:
	
	for player in $Main/Players.get_children():
		
		if not player.ready:
			return false
			
	return true
	
	pass

func _on_Change_pressed():
	$Main.hide()
	$CharacterSelect.show()


func _on_Ready_toggled(button_pressed):
	rpc("readyUp", get_tree().get_network_unique_id(), button_pressed)


func _on_CharacterSelect_characterSelected(c):
	$Main.show()
	$CharacterSelect.hide()
	character = c
	$Main/Options/Self/Character/Name.text = character
	$Main/Options/Self/Character/Icon.texture = load(CharacterInfo.characters[character].icon)
