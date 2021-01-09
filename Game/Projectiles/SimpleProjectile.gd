extends Projectile

class_name SimpleProjectile

export var damage:int = 0
export var heal:int = 0
export var effects:Array
export var pierce:bool = false

export var collideWithAllies:bool = false
export var collideWithEnemies:bool = false

func _ready():
	
	
	if is_network_master():
	
		set_collision_mask_bit(0, collideWithAllies)
		set_collision_mask_bit(1, collideWithEnemies)
		
	else:
		
		set_collision_mask_bit(1, collideWithAllies)
		set_collision_mask_bit(0, collideWithEnemies)
			

func collided(body:PhysicsBody2D):
	
	.collided(body)
	
	if is_network_master():
	
		if damage > 0:
		
			if body.has_method("hit"):
				body.rpc("hit", damage, get_network_master())
				
		if heal > 0:
			
			if body.has_method("heal"):
				body.rpc("heal", heal, get_network_master())
				
		if body.has_method("addEffect"):
				
			for effect in effects:
				
				body.rpc("addEffect", Manager.generateUniqueID(), effect.type, effect.time, effect.info)
				
	if not body.is_in_group("Player") or not pierce:
		destroy()
	
	pass
