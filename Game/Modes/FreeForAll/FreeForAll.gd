extends Game

var gameEnded:bool = false

func _ready():
	
	loadMap(Globals.currentGameInfo.map)
	
	var data = Globals.currentGameInfo.players
	
	spawnPlayers(data, get_tree().get_nodes_in_group("SpawnPoint"), Globals.currentGameInfo.spawnSeed)
	
	rpc("playerLoaded", get_tree().get_network_unique_id())
	
remotesync func start():
	
	.start()
	get_tree().call_group("Player", "loaded")


func playerDied(player:int, killer:int):
	
	if gameEnded:
		return
		
	var allDead:bool = true
		
	for player in get_tree().get_nodes_in_group("Player"):
		if player.is_in_group("Dummy"):
			continue
		if not player.dead:
			allDead = false
			break
			
	if allDead:
		if is_network_master():
			rpc("endGame", [])
		return
	
	.playerDied(player, killer)
	
	if is_network_master():
		
		if Network.players.size() <= 1:
			return
		
		yield(get_tree(), "idle_frame")
		
		var winners = []
		
		var team:int = -1
		
		for player in $Players.get_children():
			
			if not player.is_in_group("Player"):
				continue
			
			if player.dead:
				continue
				
			if team == -1:
				winners.append(int(player.name))
				team = player.team
				continue
				
			if player.team == team and not player.team == 0:
				winners.append(int(player.name))
				continue
				
			return
			
		rpc("endGame", winners)
		
	pass
	
remotesync func endGame(winnerIDs:Array):
	
	gameEnded = true
	
	if winnerIDs.empty():
		chat.addMessage(-1, "Everyone is Dead. Great Job", Color(0, 1, 0, 1))
		if is_network_master():
			yield(get_tree().create_timer(3.5), "timeout")
			rpc("returnToLobby")
			return
	
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

