extends Effect


func start(info:Dictionary, player:Character):
	player.slippery += 1
	
func end(info:Dictionary, player:Character):
	player.slippery -= 1
