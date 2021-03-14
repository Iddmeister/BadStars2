extends Effect

var playerPath:String

func start(info:Dictionary, player:Character):
	playerPath = player.get_path()
	pass
	
func end(info:Dictionary, player:Character):
	queue_free()
	pass
