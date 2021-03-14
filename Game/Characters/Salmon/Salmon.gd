extends Character

export var UnoCard:PackedScene = preload("res://Game/Characters/Salmon/UnoCard.tscn")
export var Pickup2Card:PackedScene = preload("res://Game/Characters/Salmon/WildCard.tscn")
export var shieldTime:float = 2.5
var shielded:bool = false

func _ready():
	canUseAbility1 += 1
	ability1Icon.canUse(false)

func attack1():
	rpc("shoot", get_network_master(), global_position, getAimDirection(), Network.clock, 0)
	
func attack2():
	rpc("shoot", get_network_master(), global_position, getAimDirection(), Network.clock, 1)

remotesync func shoot(id:int, pos:Vector2, dir:float, time:float, type:int=0):
	
	var bullet:PackedScene
	
	match type:
		
		0:
			bullet = UnoCard
		1:
			bullet = Pickup2Card
	
	var b:Projectile = bullet.instance()
	Manager.loose.add_child(b)
	b.global_position = global_position
	b.initialize(id, pos, dir, time)

func ability2():
	rpc("reverseCard")
	pass
	
remotesync func hit(damage:int, id:int):
	.hit(damage, id)
	if is_network_master():
		if shielded:
			if get_parent().has_node(String(id)):
				get_parent().get_node(String(id)).rpc("hit", damage, get_network_master())
	pass
	
remotesync func reverseCard():
	$Graphics/Shield.visible = true
	invincible += 1
	shielded = true
	usingAbility2 = true
	yield(get_tree().create_timer(shieldTime), "timeout")
	usingAbility2 = false
	$Graphics/Shield.visible = false
	invincible -= 1
	shielded = false
	pass
	
func ability1():
	
	var wildCards = get_tree().get_nodes_in_group("Wild")
	randomize()
	wildCards.shuffle()
	rpc("swap", wildCards[0].playerPath)
	
	$Space/Camera.followType = $Space/Camera.SMOOTH
	yield($Space/Camera, "caughtUp")
	$Space/Camera.followType = $Space/Camera.STATIC
	
func updates(delta:float):
	
	if not get_tree().get_nodes_in_group("Wild").empty() and canUseAbility1 > 0:
		canUseAbility1 -= 1
		ability1Icon.canUse(true)
	elif canUseAbility1 <= 0 and get_tree().get_nodes_in_group("Wild").empty():
		canUseAbility1 += 1
		ability1Icon.canUse(false)
	
	pass
	
remotesync func swap(path:String):
	var pos = get_node(path).global_position
	get_node(path).setPos(global_position)
	setPos(pos)
