extends Game

func _ready():
	
	loadMap(Globals.currentGameInfo.map)
	
	var data = Globals.currentGameInfo.players
	
	spawnPlayers(data, get_tree().get_nodes_in_group("SpawnPoint"))
	
	rpc("playerLoaded", get_tree().get_network_unique_id())
	
remotesync func start():
	
	.start()
	get_tree().call_group("Player", "loaded")


func playerDied(player:int, killer:int):
	.playerDied(player, killer)
	
	if killer in Globals.deathCodes.values():
		return
	
	if is_network_master():
		
		if Network.players.size() <= 1:
			return
		
		yield(get_tree(), "idle_frame")
		
		var players = Network.players.keys()
		
		var winners = []
		
		for player in players:
			
			var scene = $Players.get_node(String(player))
			
			if scene.dead:
				continue
				
			winners.append(player)
			
		var team:int = -1
			
		for winner in winners:
			
			if team == -1:
				team = $Players.get_node(String(winner)).team
				continue
				
			if $Players.get_node(String(winner)).team != team:
				return
			
			
		
		rpc("endGame", winners)
		
	pass
	
remotesync func endGame(winnerIDs:Array):
	
	var winners = []
	
	for winner in winnerIDs:
		winners.append(Network.players[winner].name)
		
		if $Players.has_node(String(winner)):
			$Players.get_node(String(winner)).win()
		
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

