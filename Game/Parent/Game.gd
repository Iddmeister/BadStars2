extends Node2D

class_name Game

var killMessages = {
	
	"fast":["liquidated", "annihilated", "eradicated", "slaughtered"],
	"norm":["eliminated", "executed", "neutralized", "assassinated", "dispatched", "deleted", "lynched"],
	
}

var killWatch = {}
var fastKillTime:float = 5


func _process(delta):
	
	for player in killWatch.keys():
		
		killWatch[player] -= delta
		
		if killWatch[player] <= 0:
			killWatch.erase(player)

func spawnPlayers(players:Dictionary, points:Array):
	
	for player in players.keys():
		
		var character:Character = load(CharacterInfo.characters[players[player].character].scene).instance()
		character.name = String(player)
		$Players.add_child(character)
		character.global_position = points[0].global_position
		points.remove(0)
		character.initialize(player, players[player].allies)
		character.connect("hit", self, "playerDamaged")
		character.connect("died", self, "playerDied")
		
	pass
	
func playerDamaged(player:int, hitter:int):
	
	if not killWatch.has(player):
		killWatch[player] = fastKillTime
	
	pass
	
func playerDied(player:int, killer:int):
	
	var killMessage:String
	
	if killWatch.has(player):
		killMessages.fast.shuffle()
		killMessage = killMessages.fast[0]
	else:
		killMessages.norm.shuffle()
		killMessage = killMessages.norm[0]
	
	$UI/Chat.addMessage(-1, "%s %s %s" % [Network.players[killer].name, killMessage, Network.players[player].name])
	
	pass
	
remotesync func endGame():
	pass

