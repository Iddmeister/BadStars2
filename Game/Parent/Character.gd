extends KinematicBody2D

class_name Character

export var maxHealth:int = 100
onready var health = maxHealth
export var maxMoveSpeed:float = 200
onready var moveSpeed = maxMoveSpeed
export var acceleration:float = 0.5
export var deceleration:float = 0.5

var loaded:bool = false

var moveVelocity:Vector2
var addedVelocity:Vector2

var activeEffects = {}

onready var camera:Camera2D = $Space/Camera

func initialize(id:int):
	
	set_network_master(id)
	
	if is_network_master():
		camera.current = true
	

func _physics_process(delta):
	
	if loaded:
	
		movement(delta)
		updateEffects(delta)

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
	
func getTime():
	return String(OS.get_system_time_msecs())
	pass
	
func getTimeInt():
	return OS.get_system_time_msecs()
	pass

func movement(delta:float):
	
	var dir:Vector2 = getMoveDirection()
	
	moveVelocity = moveVelocity.linear_interpolate(dir*moveSpeed, acceleration*delta*60)
	
	addedVelocity = addedVelocity.linear_interpolate(Vector2(0, 0), deceleration*delta*60)
	
	move_and_slide(moveVelocity+addedVelocity)

func updateEffects(delta:float):
	
	for id in activeEffects.keys():
		
		var effect = activeEffects[id]
		
		if not effect.time == -1:
			effect.time -= delta
			if effect.time <= 0:
				removeEffect(id)
	

remotesync func addEffect(id:String, type:String, time:float, info:Dictionary={}):
	
	var effect = Globals.effects[type].instance()
	$Effects.add_child(effect)
	effect.start(info, self)

	activeEffects[id] = {"time":time, "type":type, "info":info, "effect":effect}
	
	
remotesync func removeEffect(id:String):
	
	activeEffects[id].effect.end(activeEffects[id].info, self)
	
	activeEffects.erase(id)
