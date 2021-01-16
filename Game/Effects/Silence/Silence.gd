extends Effect

func start(info:Dictionary, player:Character):
	player.enableAbilities(false)
	
func end(info:Dictionary, player:Character):
	player.enableAbilities(true)
	queue_free()
