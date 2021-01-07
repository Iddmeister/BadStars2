extends Game

func _ready():
	
	var data = Globals.currentGameInfo.players
	
	spawnPlayers(data, get_tree().get_nodes_in_group("SpawnPoint"))
	
	get_tree().call_group("Player", "loaded")

remotesync func endGame():
	.endGame()
	pass

func playerDied(player:int, killer:int):
	.playerDied(player, killer)
	pass
	
