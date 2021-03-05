extends Game

var team1:int = 0
var team2:int = 0

var currentTeam:int = 0
var players:Dictionary

func _ready():
	
	loadMap(Globals.currentGameInfo.map)
	
	var data = Globals.currentGameInfo.players
	players = data
	
	currentTeam = data[get_tree().get_network_unique_id()].team
	
	spawnPlayers(data, get_tree().get_nodes_in_group("SpawnPoint"), Globals.currentGameInfo.spawnSeed)
	
	rpc("playerLoaded", get_tree().get_network_unique_id())
	
	for goal in get_tree().get_nodes_in_group("Goal"):
		goal.connect("scored", self, "goalScored")
		
	$UI/CenterContainer/VBoxContainer/TimeText.text = String($Time.wait_time)
	
func goalScored(team:int):
	
	match team:
		
		1:
			team1 += 1
		2:
			team2 += 1
			
			
	rpc("updateScores", team1, team2)
	
var spawnPos:Vector2
	
func playerDied(player:int, killer:int):
	.playerDied(player, killer)
	if get_tree().get_network_unique_id() == player:
		$Respawn.start()
	
remotesync func respawn(id:int):
	
	get_node("Ghosts").get_node("Ghost"+String(id)).queue_free()
	var character:Character = load(CharacterInfo.characters[players[id].character].scene).instance()
	character.name = String(id)
	character.allAllies = players[id].allies
	if players[id].has("skin"):
		character.skin = players[id].skin
	$Players.add_child(character)
	character.global_position = spawnPos
	character.initialize(id, players[id].allies)
	character.team = players[id].team
	character.connect("hit", self, "playerDamaged")
	character.connect("died", self, "playerDied")
	character.setPos(character.global_position)
	
	character.loaded()
	
	pass
	
remotesync func updateScores(team1Score:int, team2Score:int):
	
	reset()
	
	if currentTeam == 1:
		$UI/CenterContainer/VBoxContainer/HBoxContainer/Team1.text = String(team1Score)
		$UI/CenterContainer/VBoxContainer/HBoxContainer/Team2.text = String(team2Score)
	else:
		$UI/CenterContainer/VBoxContainer/HBoxContainer/Team2.text = String(team1Score)
		$UI/CenterContainer/VBoxContainer/HBoxContainer/Team1.text = String(team2Score)
	
	
remotesync func reset():
	
	get_tree().call_group("Player", "reset")
	get_tree().call_group("Ball", "reset")
	
	pass

remotesync func start():
	
	.start()
	get_tree().call_group("Player", "loaded")
	spawnPos = $Players.get_node(String(get_tree().get_network_unique_id())).global_position
	
		
	if is_network_master():
		$Time.start()
	$Second.start()

remotesync func endGame():
	pass

func _on_Time_timeout():
	rpc("endGame")


func _on_Second_timeout():
	$UI/CenterContainer/VBoxContainer/TimeText.text = String(max(int($UI/CenterContainer/VBoxContainer/TimeText.text) - 1, 0))


func _on_Respawn_timeout():
	rpc("respawn", get_tree().get_network_unique_id())
