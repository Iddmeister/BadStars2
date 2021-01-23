extends Effect


func start(info:Dictionary, player:Character):
	player.canMove += 1
	player.enableAbilities(false)
	player.enableAttacks(false)
	pass
	
func end(info:Dictionary, player:Character):
	player.canMove -= 1
	player.enableAbilities(true)
	player.enableAttacks(true)
	queue_free()
	pass
