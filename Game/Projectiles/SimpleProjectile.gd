extends Projectile

class_name SimpleProjectile

export var damage:int = 0
export var heal:int = 0
export var effects:Array
export var pierce:bool = false

export var collideWithAllies:bool = false
export var collideWithEnemies:bool = false

func collided(body:PhysicsBody2D):
	
	.collided(body)
	
	if (body.is_in_group("Ally"+String(masterID)) and collideWithAllies) or (collideWithEnemies and not body.is_in_group("Ally"+String(masterID))):
		
		if is_network_master():

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
					
		if not body.is_in_group("Player"):
			hitTerrain()
			return
		if not pierce:
			destroy()
	
	pass
	
func hitTerrain():
	destroy()
