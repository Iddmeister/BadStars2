extends Game

func _ready():
	
	loadMap(Globals.currentGameInfo.map)
	
	var data = Globals.currentGameInfo.players
	
	spawnPlayers(data, get_tree().get_nodes_in_group("SpawnPoint"))
	
	get_tree().call_group("Player", "loaded")


func playerDied(player:int, killer:int):
	.playerDied(player, killer)
	
	if killer in Globals.deathCodes.values():
		return
	
	if is_network_master():
		
		var winner:int = -1
		var passed = []
		
		for player in get_tree().get_nodes_in_group("Player"):
			if int(player.name) in passed:
				continue
			if not player.dead:
				if not winner == -1:
					return
				winner = int(player.name)
				passed.append(int(player.name))
				
				for ally in Globals.currentGameInfo.players[int(player.name)].allies:
					passed.append(ally)
					
					
		rpc("endGame", winner)
		
	pass
	
remotesync func endGame(winner:int):
	
	var winners = []
	winners.append(Network.players[winner].name)
	for ally in Globals.currentGameInfo.players[winner].allies:
		winners.append(Network.players[ally].name)
		
	var message = ""
	
	for n in range(winners.size()):
		
		if n == winners.size()-1:
			message += winners[n]
		else:
			message += winners[n] + " + "
		
	chat.addMessage(-1, message+" WINS!!!", Color(0, 1, 0, 1))
	
	if is_network_master():
		yield(get_tree().create_timer(2), "timeout")
		rpc("returnToLobby")
	
	pass

