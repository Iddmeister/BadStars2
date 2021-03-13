extends Character

export var communismBadDamage:float = 0.2
export var communismGoodHeal:float = 0.2

onready var sickle = $Space/Sickle


func _ready():
	
	sickle.karl = self
	

func attack1():
	sickle.rpc("throw", getAimDirection())
	usingAttack1 = true
	yield(sickle, "returned")
	usingAttack1 = false
	
	
func ability1():
	rpc("communismBad")
	
master func communismBad():
	
	for player in get_tree().get_nodes_in_group("Player"):
		player.rpc("hit", int(max(player.health*communismBadDamage, 1)), get_network_master())
	
func ability2():
	rpc("communismGood")
	
master func communismGood():
	
	for player in get_tree().get_nodes_in_group("Player"):
		player.rpc("heal", int(player.maxHealth*communismGoodHeal), get_network_master())
