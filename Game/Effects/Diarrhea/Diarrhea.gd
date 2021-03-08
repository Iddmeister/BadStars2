extends Effect

export var shitAmount:int = 3
export var Shit = preload("res://Game/Characters/Shmelly/Shit.tscn")
export var shitDamage:int = 20
var s:int
var masterID:int

func start(info:Dictionary, player:Character):
	s = info.s
	masterID = info.masterID
	pass

func end(info:Dictionary, player:Character):
	
	player.hit(shitDamage, masterID)
	
	for i in shitAmount:
		
		var shit = Shit.instance()
		shit.name = String(masterID)+"shit"+String(i)
		shit.masterID = masterID
		
		if player.get_parent().has_node(String(masterID)):
			shit.shitSkin = player.get_parent().get_node(String(masterID)).shitSkin

		Manager.loose.add_child(shit)
		shit.global_position = player.global_position
		seed(s+i)
		shit.finalPos = shit.global_position+Vector2(160, 0).rotated(deg2rad(rand_range(0, 360)))
	
	queue_free()
	pass
