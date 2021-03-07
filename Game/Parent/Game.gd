extends Node2D

class_name Game

var Dummy = preload("res://Game/Objects/Dummy/Dummy.tscn")

var killMessages = {
	
	"fast":["liquidated", "annihilated", "eradicated", "slaughtered"],
	"norm":["eliminated", "executed", "neutralized", "assassinated", "dispatched", "deleted", "lynched"],
	
}

onready var chat = $UI/Chat

var killWatch = {}
var playersLoaded = []
var fastKillTime:float = 4

func loadMap(map:String):
	
	var mapScene = load(Globals.maps[map]).instance()
	$Map.add_child(mapScene)
	
	pass

func _process(delta):
	
	for player in killWatch.keys():
		
		killWatch[player] -= delta
		
		if killWatch[player] <= 0:
			killWatch.erase(player)

func spawnPlayers(players:Dictionary, points:Array, s:int):
	
	seed(s)
	var spawned = {}
	points.shuffle()
	
	for player in players.keys():
		
		var character:Character = load(CharacterInfo.characters[players[player].character].scene).instance()
		character.name = String(player)
		character.allAllies = players[player].allies
		if players[player].has("skin"):
			character.skin = players[player].skin
		var spawnedWithAlly = false
		for ally in players[player].allies:
			if spawned.has(ally):
				character.global_position = spawned[ally].global_position
				spawnedWithAlly = true
				break
		if not spawnedWithAlly:
			character.global_position = points[players[player].pos].global_position
			spawned[player] = character
			
		$Players.add_child(character)
		character.initialize(player, players[player].allies)
		character.team = players[player].team
		character.connect("hit", self, "playerDamaged")
		character.connect("died", self, "playerDied")
		character.setPos(character.global_position)
		
	pass
	
	
func playerDamaged(player:int, hitter:int):
	
	if not killWatch.has(player):
		killWatch[player] = fastKillTime
	
	pass
	
func playerDied(player:int, killer:int):
	
	if player == get_tree().get_network_unique_id():
		$UI/MarginContainer/Surrender.text = "Leave Game"
		died = true
	
	if $Players.has_node(String(killer)):
		$Players.get_node(String(killer)).kill()
	
	match killer:
		
		Globals.deathCodes.OUT_OF_MAP:
			
			chat.addMessage(-1, "%s Fell Into the Void" % Network.players[player].name)
			
		Globals.deathCodes.LAGGING:
			
			chat.addMessage(-1, "%s Lagged out of existence" % Network.players[player].name)
			
		Globals.deathCodes.SURRENDER:
			
			chat.addMessage(-1, "%s Self Destructed" % Network.players[player].name)
		
		Globals.deathCodes.SPIKES:
			
			chat.addMessage(-1, "%s Has Been Impaled" % Network.players[player].name)
		_:
	
			var killMessage:String
			
			if killWatch.has(player):
				killMessages.fast.shuffle()
				killMessage = killMessages.fast[0]
			else:
				killMessages.norm.shuffle()
				killMessage = killMessages.norm[0]
			
			chat.addMessage(-1, "%s %s %s" % [Network.players[killer].name, killMessage, Network.players[player].name])
		
	pass

remotesync func returnToLobby():
	Manager.changeScene("res://Screens/Lobby/Lobby.tscn")

master func playerLoaded(id:int):
	
	playersLoaded.append(id)
	
	if playersLoaded.size() >= Network.players.size():
		yield(get_tree().create_timer(0.5), "timeout")
		rpc("start")
	
	pass

remotesync func start():
	$UI/LoadingScreen.hide()
	pass

var died:bool = false

func _on_Surrender_pressed():
	if not died:
		$Players.get_node(String(get_tree().get_network_unique_id())).rpc("hit", 1000000, -8)
		$UI/MarginContainer/Surrender.text = "Leave Game"
		died = true
	else:
		Network.leaveGame()
		
		
	
func commands(text:String):
	
	var player = $Players.get_node(String(get_tree().get_network_unique_id()))
	
	match text:
		
		"hit20":
			player.rpc("hit", 20, player.get_network_master())
			
		"hit10":
			player.rpc("hit", 10, player.get_network_master())
			
		"hit50":
			player.rpc("hit", 50, player.get_network_master())
		
		"kill":
			player.rpc("hit", 100000, -8)
		
		"heal":
			player.rpc("heal", 100000)
		
		"invincible":
			player.rset("devInvincible",  not player.devInvincible)
		
		"noclip":
			player.rset("devInvincible",  not player.devInvincible)
			player.get_node("CollisionShape2D").disabled = not player.get_node("CollisionShape2D").disabled
		
		"reset":
			player.rpc("setAbility1Cooldown", 0)
			player.rpc("setAbility2Cooldown", 0)
			player.rpc("reloadAmmo", player.maxAmmo-player.ammo)
			
		"place_dummy":
			rpc("placeDummy", get_global_mouse_position())
		"place_ally_dummy":
			rpc("placeDummy", get_global_mouse_position(), true)
		"party":
			player.rpc("setGraphics")
		
remotesync func placeDummy(pos:Vector2, allied:bool=false):
	
	var d = Dummy.instance()
	Manager.loose.add_child(d)
	d.global_position = pos
	var allies:Array = []
	if allied:
		allies.append(get_tree().get_network_unique_id())
		
		for ally in $Players.get_node(String(get_tree().get_network_unique_id())).allAllies:
			allies.append(ally)
		
	d.create(allies)
	
	pass
