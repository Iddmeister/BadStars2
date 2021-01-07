extends Control

var PlayerIcon = preload("res://Screens/Lobby/PlayerIcon.tscn")

var character:String = "none"

var playerOptions = {}

var inTeams:bool = true

func _ready():
	addAllPlayers()
	Network.connect("playerJoined", self, "addNewPlayer")
	Network.connect("playerLeft", self, "removePlayer")
	
	if not is_network_master():
		$Main/Options/VBoxContainer/IPStuff.hide()
	
	pass
	
func addPlayer(player:int):

	var p = PlayerIcon.instance()
	p.name = String(player)
	$Main/Players.add_child(p)
	p.setName(Network.players[player].name)
	p.setTeams(inTeams)
	p.setTeam(0)
	p.connect("kick", self, "kick")
	
	pass
	
func addAllPlayers():
	
	for player in Network.players.keys():
		
		addPlayer(player)
		
func addNewPlayer(id:int):
	
	addPlayer(id)
	
	if is_network_master():
		
		var players = {}
		
		for player in $Main/Players.get_children():
			
			players[player.name] = player.ready
			
		rpc_id(id, "updatePlayers", players)
	
	pass
	
remote func updatePlayers(players:Dictionary):
	
	for player in players.keys():
		$Main/Players.get_node(player).setReady(players[player])
		
	
func removePlayer(id:int):
	$Main/Players.get_node(String(id)).queue_free()

remotesync func readyUp(id:int, r:bool):
	
	$Main/Players.get_node(String(id)).setReady(r)
	
	if is_network_master():
		if checkAllReady():
			
			for player in $Main/Players.get_children():
				playerOptions[int(player.name)]["team"] = player.team
				
			for player in playerOptions.keys():
				playerOptions[player].allies = []
				for player2 in playerOptions.keys():
					if player2 == player:
						continue
					if playerOptions[player].team == playerOptions[player2].team:
						playerOptions[player].allies.append(player2)
			
			rpc("startGame", playerOptions)
	
	pass
	
remotesync func startGame(playerData:Dictionary):
	
	Globals.currentGameInfo["players"] = playerData
	Manager.changeScene("res://Game/Modes/FreeForAll/FreeForAll.tscn")
	
	pass
	
func checkAllReady() -> bool:
	
	for player in $Main/Players.get_children():
		
		if not player.ready:
			return false
			
	return true
	
	pass

func kick(player):
	Network.rpc_id(int(player.name),"kick")
	pass

func _on_Change_pressed():
	$Main.hide()
	$CharacterSelect.show()


func _on_Ready_toggled(button_pressed):
	if not character == "none":
		rpc("readyUp", get_tree().get_network_unique_id(), button_pressed)
	else:
		$Main/Options/Self/Ready.pressed = false

master func setCharacter(id:int, c:String):
	
	playerOptions[id] = {"character":c, "allies":[id]}
	
	pass

func _on_CharacterSelect_characterSelected(c):
	$Main.show()
	$CharacterSelect.hide()
	character = c
	$Main/Options/Self/Character/Name.text = character
	$Main/Options/Self/Character/Icon.texture = load(CharacterInfo.characters[character].icon)
	rpc("setCharacter", get_tree().get_network_unique_id(), character)


func _on_UPNP_toggled(button_pressed):
	if button_pressed:
		Network.activateUPNP()
		$Main/Options/VBoxContainer/IPStuff/GlobalIP.text = Network.getUPNPAddress()
		$Main/Options/VBoxContainer/IPStuff/GlobalIP.show()
	else:
		Network.deactivateUPNP()
		$Main/Options/VBoxContainer/IPStuff/GlobalIP.hide()
