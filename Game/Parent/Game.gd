extends Node2D

func _ready():
	
	var data = Globals.currentGameInfo.players
	
	spawnPlayers(data, get_tree().get_nodes_in_group("SpawnPoint"))
	get_tree().call_group("Player", "loaded")

func spawnPlayers(players:Dictionary, points:Array):
	
	for player in players.keys():
		
		var character = load(CharacterInfo.characters[players[player].character].scene).instance()
		character.name = String(player)
		$Players.add_child(character)
		character.global_position = points[0].global_position
		points.remove(0)
		character.initialize(player)
		
	
	pass
