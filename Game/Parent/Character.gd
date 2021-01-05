extends KinematicBody2D

class_name Character

export var maxHealth:int = 100
onready var health = maxHealth
export var maxMoveSpeed:float = 200
onready var moveSpeed = maxMoveSpeed
export var acceleration:float = 0.5
export var deceleration:float = 0.5

var loaded:bool = false
var dead:bool = false

signal died()

var moveVelocity:Vector2
var addedVelocity:Vector2

var activeEffects = {}

onready var camera:Camera2D = $Space/Camera

## Puppet Variables

var timeSinceUpdate:float = 0
var masterPos:Vector2
var syncSpeed:float = 0.5

signal lagging()

func _ready():
	
	updateHealth()

func initialize(id:int, allies:Array=[]):
	
	set_network_master(id)
	
	if is_network_master():
		camera.current = true
		$UI/Main.show()
	else:
		$UI/Main.hide()
		
	if is_network_master():
		set_collision_layer_bit(0, true)
	elif get_tree().get_network_unique_id() in allies:
		set_collision_layer_bit(0, true)
	else:
		set_collision_layer_bit(1, true)
		
# warning-ignore:function_conflicts_variable
func loaded():
	loaded = true

func _process(delta):
	if loaded:
		
		if is_network_master() and not dead:
			actions(delta)
			masterAnimations(delta)
		elif not dead:
			puppetAnimations(delta)

func _physics_process(delta):
	
	if loaded:
		if is_network_master() and not dead:
			movement(delta)
		elif not dead:
			syncState(delta)
				
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
	
	rpc_unreliable("updateState", global_position)

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
	
remotesync func clearEffects():
	
	for effect in activeEffects.keys():
		removeEffect(effect)
	
	pass
	
func syncState(delta:float):
	global_position = global_position.linear_interpolate(masterPos, syncSpeed*delta*60)
	timeSinceUpdate += delta
	if timeSinceUpdate >= 3:
		emit_signal("lagging")
	pass
	
puppet func updateState(pos:Vector2):
	masterPos = pos
	timeSinceUpdate = 0
	pass
	
	
remotesync func hit(damage:int, id:int):
	
	health = max(health-damage, 0)
	
	if health <= 0:
		die(id)
		
	updateHealth()
	
	pass
	
func die(id:int):
	dead = true
	clearEffects()
	pass
	
remotesync func heal(amount:int, id:int):
	
	health = min(maxHealth, health+amount)
	
	updateHealth()
	
func updateHealth():
	$UI/Main/CenterContainer/Health.value = (float(health)/float(maxHealth))*100
	$UI/Main/CenterContainer/Health/Num.text = String(health)
	pass
	
func actions(delta:float):
	
	## Attacks and Abilities
	
	pass
	
func masterAnimations(delta:float):
	
	pass
	
		
func puppetAnimations(delta:float):
	
	pass
