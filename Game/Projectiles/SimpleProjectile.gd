extends Projectile

class_name SimpleProjectile

export var damage:int = 0
export var heal:int = 0
export var effects:Array
export var pierce:bool = false
export var knockBack:float = 0

export var collideWithAllies:bool = false
export var collideWithEnemies:bool = false

func collided(body:PhysicsBody2D):
	
	.collided(body)
	
	if not body.is_in_group("Player"):
		hitTerrain()
	
	if (body.is_in_group("Ally"+String(masterID)) and collideWithAllies) or (collideWithEnemies and not body.is_in_group("Ally"+String(masterID))):
		
		if is_network_master():
			
			if knockBack != 0:
				
				if body.has_method("knock"):
					body.rpc("knock", Vector2(knockBack, 0).rotated(global_rotation))

			if damage > 0:
			
				if body.has_method("hit"):
					body.rpc("hit", damage, masterID)
					
			if heal > 0:
				
				if body.has_method("heal"):
					body.rpc("heal", heal, masterID)
					
			if body.has_method("addEffect"):
					
				for effect in effects:
					
					if effect.has("info"):
					
						body.rpc("addEffect", Manager.generateUniqueID(), effect.type, effect.time, effect.info)
					
					else:
						
						body.rpc("addEffect", Manager.generateUniqueID(), effect.type, effect.time, {})
					
		if not pierce:
			destroy()
	
	pass
	
func hitTerrain():
	destroy()
