extends Area2D

class_name Melee

var bodies:Array = []
var hitBodies:Array = []

export var characterPath:NodePath

export var damage:int = 0
export var heal:int = 0
export var effects:Array
export var knockBack:float = 0

export var collideWithAllies:bool = false
export var collideWithEnemies:bool = false

var masterID:int

var damaging:bool = false

func _ready():
	get_node(characterPath).connect("initialized", self, "initialize")
	
func initialize(id:int):
	masterID = id

func _process(delta):
	
	if damaging:
		for body in bodies:
			if not body in hitBodies:
				hitBody(body)
				hitBodies.append(body)

func doDamage():
	for body in bodies:
		hitBody(body)
	pass
	
func startDamage():
	damaging = true
	
func endDamage():
	damaging = false
	hitBodies.clear()

func hitBody(body):
	
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
						
						if effect.info.has("damageID"):
							effect.info.masterID = masterID
							
						body.rpc("addEffect", Manager.generateUniqueID(), effect.type, effect.time, effect.info)
					
					else:
						
						body.rpc("addEffect", Manager.generateUniqueID(), effect.type, effect.time, {})

func _on_Melee_body_entered(body):
	bodies.append(body)


func _on_Melee_body_exited(body):
	bodies.erase(body)
