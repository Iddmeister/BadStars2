extends KinematicBody2D

export var maxHealth:int = 100
onready var health = maxHealth
export var healthRegen:float = 0
export var moveSpeed:float = 200
export var acceleration:float = 0.5
export var deceleration:float = 0.5

var moveVelocity:Vector2
var addedVelocity:Vector2

var effects:Dictionary = {
	
	"moveSpeedUp":0,
	"moveSpeedDown":0,
	"healthRegen":1,
	"poison":0,
	
}

var activeEffects = []

func _physics_process(delta):
	
	movement(delta)

func getMoveDirection() -> Vector2:
	
	var dir = Vector2(0, 0)
	
	if Input.is_action_pressed("left"):
		dir.x -= 1
	if Input.is_action_pressed("right"):
		dir.x += 1
	if Input.is_action_pressed("up"):
		dir.y -= 1
	if Input.is_action_pressed("down"):
		dir.y += 1
		
	return dir.normalized()

func movement(delta:float):
	
	var dir:Vector2 = getMoveDirection()
	
	moveVelocity = moveVelocity.linear_interpolate(dir*moveSpeed, acceleration*delta*60)
	
	addedVelocity = addedVelocity.linear_interpolate(Vector2(0, 0), deceleration*delta*60)
	
	moveVelocity += moveVelocity*effects.moveSpeedUp
	moveVelocity -= moveVelocity*effects.moveSpeedDown
	
	move_and_slide(moveVelocity+addedVelocity)

func updateEffects(delta:float):
	
	for effect in activeEffects:
		
		if not effect.time == -1:
			effect.time -= delta
			if effect.time <= 0:
				removeEffect(effect.name)
	
func applyEffect():
	
	pass

remotesync func addEffect(effect:Dictionary):
	
	activeEffects.append(effect)
	
	if Globals.effectGraphics.has(effect.name):
		var e = Globals[effect.name].instance()
		e.name = effect.name
		$Graphics/EffectGraphics.add_child(e)
	
	pass
	
remotesync func removeEffect(effect:String):
	
	pass
