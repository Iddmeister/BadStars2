extends Control

var PlayerIcon = preload("res://Screens/Lobby/PlayerIcon.tscn")

var character:String = "none"

var playerOptions = {}

onready var gameMode = $Main/Options/VBoxContainer/Mode
onready var gameMap = $Main/Options/VBoxContainer/Map

func _ready():
	addAllPlayers()
	Network.connect("playerJoined", self, "addNewPlayer")
	Network.connect("playerLeft", self, "removePlayer")
	Network.connect("gotPing", self, "gotPing")
	
	for mode in Globals.gameModes.keys():
		
		gameMode.add_item(mode, gameMode.get_item_count())
		
	updateMaps(gameMode.get_item_text(gameMode.selected))
	
	if not is_network_master():
		$Main/Options/VBoxContainer/HBoxContainer.hide()
		gameMode.disabled = true
		$Main/Options/VBoxContainer/Teams.disabled = true
		gameMap.disabled = true
		
	if not Globals.lastPickedCharacter == "none":
		$Main/Options/Self/Character/Name.text = Globals.lastPickedCharacter
		rpc("setCharacter", get_tree().get_network_unique_id(), Globals.lastPickedCharacter)
		character = Globals.lastPickedCharacter
		setupSkins(character)
		
		if CharacterInfo.characters[character].has("default") or not Globals.lastPickedSkin == "default":
			rpc("changedSkin", get_tree().get_network_unique_id(), Globals.lastPickedSkin)
			$Main/Options/Self/Character/Name.selected = CharacterInfo.characters[character].skins.keys().find(Globals.lastPickedSkin)
			$Main/Options/Self/Character/Icon.texture = load(CharacterInfo.characters[character].skins[Globals.lastPickedSkin])
		else:
			$Main/Options/Self/Character/Icon.texture = load(CharacterInfo.characters[character].icon)
		
	pass
	
func gotPing(id:int):
	
	$Main/Players.get_node(String(id)).setPing(Network.players[id].ping)
	
	pass
	
func updateMaps(mode:String):
	
	gameMap.clear()
	
	for map in Globals.gameModes[mode].maps:
		gameMap.add_item(map, gameMap.get_item_count())
	
	pass
	
func addPlayer(player:int):

	var p = PlayerIcon.instance()
	p.name = String(player)
	$Main/Players.add_child(p)
	p.setName(Network.players[player].name)
	p.setTeams($Main/Options/VBoxContainer/Teams.pressed)
	p.setTeam(0)
	p.connect("kick", self, "kick")
	
	if player == 1:
		p.setHost(true)
		return
	if Network.players[player].has("ping"):
		p.setPing(Network.players[player].ping)
	
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
		
		rpc_id(id, "syncState", gameMode.selected, $Main/Options/VBoxContainer/Teams.pressed)
	
		get_tree().call_group("PlayerIcon", "updateTeam")
	
	pass
	
remote func updatePlayers(players:Dictionary):
	
	for player in players.keys():
		$Main/Players.get_node(player).setReady(players[player])
		
	
func removePlayer(id:int):
	$Main/Players.get_node(String(id)).queue_free()
	playerOptions.erase(id)

remotesync func readyUp(id:int, r:bool):
	
	$Main/Players.get_node(String(id)).setReady(r)
	
	if is_network_master():
		if checkAllReady():
			
			for player in $Main/Players.get_children():
				playerOptions[int(player.name)]["team"] = player.team
				
			var num:int = 0
			for player in playerOptions.keys():
				playerOptions[player].pos = num
				num += 1
				playerOptions[player].allies = []
				if playerOptions[player].team == 0:
					continue
				for player2 in playerOptions.keys():
					if player2 == player:
						continue
					if playerOptions[player].team == playerOptions[player2].team:
						playerOptions[player].allies.append(player2)
						
			var spawnSeed = int(rand_range(0, 100))
			
			rpc("startGame", playerOptions, gameMode.get_item_text(gameMode.selected), gameMap.get_item_text(gameMap.selected), spawnSeed)
	
	pass
	
remotesync func startGame(playerData:Dictionary, mode:String, map:String, spawnSeed:int):
	
	Globals.currentGameInfo["players"] = playerData
	Globals.currentGameInfo["map"] = map
	Globals.currentGameInfo["map"] = map
	Globals.currentGameInfo["mode"] = mode
	Globals.currentGameInfo["spawnSeed"] = spawnSeed
	Manager.changeScene(Globals.gameModes[mode].scene)
	
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

func checkAllHavePing():
	
	for player in Network.players.keys():
		if not Network.players[player].has("ping"):
			return false
			
	return true
	
	pass

func _on_Ready_toggled(button_pressed):
	
	if is_network_master():
		if not checkAllHavePing():
			$Main/Options/Self/Ready.pressed = false
			return
			
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
	
	rpc("setCharacter", get_tree().get_network_unique_id(), character)
	Globals.lastPickedCharacter = character
	if CharacterInfo.characters[character].has("default"):
		Globals.lastPickedSkin = CharacterInfo.characters[character].default
		$Main/Options/Self/Character/Icon.texture = load(CharacterInfo.characters[character].skins[Globals.lastPickedSkin])
		rpc("changedSkin", get_tree().get_network_unique_id(), Globals.lastPickedSkin)
	else:
		Globals.lastPickedSkin = "default"
		$Main/Options/Self/Character/Icon.texture = load(CharacterInfo.characters[character].icon)
	setupSkins(character)
	
func setupSkins(c:String):
	
	var n:OptionButton = $Main/Options/Self/Character/Name
	n.clear()
	
	if not CharacterInfo.characters[c].has("skins"):
		n.disabled = true
		n.clear()
		n.text = c
	else:
		n.disabled = false
		if not CharacterInfo.characters[character].has("default"):
			n.add_item(c, 0)
		for skin in CharacterInfo.characters[c].skins.keys():
			n.add_item(skin, n.get_item_count())
	
	pass
	
master func changedSkin(id:int, skin:String):
	
	if skin == "default":
		playerOptions[id].erase("skin")
	else:
		playerOptions[id].skin = skin



func _on_UPNP_toggled(button_pressed):
	if button_pressed:
		Network.activateUPNP()
		$Main/Options/VBoxContainer/HBoxContainer/IPStuff/GlobalIP.text = Network.getUPNPAddress()
		$Main/Options/VBoxContainer/HBoxContainer/IPStuff/GlobalIP.show()
	else:
		Network.deactivateUPNP()
		$Main/Options/VBoxContainer/HBoxContainer/IPStuff/GlobalIP.hide()

remotesync func setMode(mode:int):
	
	gameMode.selected = mode
	
	var teamOptions:int = Globals.gameModes[gameMode.get_item_text(mode)].teams
	
	match teamOptions:
		
		Globals.YES:
			$Main/Options/VBoxContainer/Teams.pressed = true
			$Main/Options/VBoxContainer/Teams.disabled = true
		Globals.NO:
			$Main/Options/VBoxContainer/Teams.pressed = false
			$Main/Options/VBoxContainer/Teams.disabled = true
		Globals.OPTIONAL:
			$Main/Options/VBoxContainer/Teams.pressed = false
			$Main/Options/VBoxContainer/Teams.disabled = false
			
	if not is_network_master():
		$Main/Options/VBoxContainer/Teams.disabled = true
		
	if Globals.gameModes[gameMode.get_item_text(mode)].has("teamRange"):
		get_tree().call_group("PlayerIcon", "setTeamRange", Globals.gameModes[gameMode.get_item_text(mode)].teamRange)
	else:
		get_tree().call_group("PlayerIcon", "setTeamRange", -1)
		
	updateMaps(gameMode.get_item_text(gameMode.selected))
	
	pass
	
puppet func syncState(mode:int, teams:bool):
	setMode(mode)
	enableTeams(teams)
	
	pass
	
remotesync func enableTeams(d:bool):
	$Main/Options/VBoxContainer/Teams.pressed = d
	get_tree().call_group("PlayerIcon", "setTeams", d)
	pass

func _on_Mode_item_selected(index):
	rpc("setMode", index)


func _on_Teams_toggled(button_pressed):
	rpc("enableTeams", button_pressed)


func _on_Map_item_selected(index):
	pass # Replace with function body.


func _on_Leave_pressed():
	Network.leaveGame()


func _on_Copy_pressed():
	if $Main/Options/VBoxContainer/HBoxContainer/IPStuff/UPNP.pressed:
		OS.set_clipboard($Main/Options/VBoxContainer/HBoxContainer/IPStuff/GlobalIP.text)
	else:
		OS.set_clipboard($Main/Options/VBoxContainer/HBoxContainer/IPStuff/LocalIP.text)


func _on_Name_item_selected(index):
	
	if $Main/Options/Self/Character/Name.get_item_text(index) == character:
			rpc("changedSkin", get_tree().get_network_unique_id(), "default")
			$Main/Options/Self/Character/Icon.texture = load(CharacterInfo.characters[character].icon)
			Globals.lastPickedSkin = "default"
			return
	
	$Main/Options/Self/Character/Icon.texture = load(CharacterInfo.characters[character].skins[$Main/Options/Self/Character/Name.get_item_text(index)])
	Globals.lastPickedSkin =$Main/Options/Self/Character/Name.get_item_text(index)
	rpc("changedSkin", get_tree().get_network_unique_id(), $Main/Options/Self/Character/Name.get_item_text(index))
