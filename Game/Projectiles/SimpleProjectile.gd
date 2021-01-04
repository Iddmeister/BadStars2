extends StraightProjectile

export var damage:int = 0
export var heal:int = 0
export var effects:Array
export var pierce:bool = false

export var collideWithAllies:bool = false
export var collideWithEnemies:bool = false

func _ready():
	
	set_collision_mask_bit(0, collideWithAllies)
	set_collision_mask_bit(1, collideWithEnemies)

func collided(body:PhysicsBody2D):
	
	if damage > 0:
	
		if body.has_method("hit"):
			body.rpc("hit", damage, get_network_master())
			
	if heal > 0:
		
		if body.has_method("heal"):
			body.rpc("heal", heal, get_network_master())
			
	for effect in effects:
		
		if body.has_method("addEffect"):
			
			body.rpc("addEffect", )
			
			
	if not body.is_in_group("Player") or not pierce:
		destroy()
	
	pass
