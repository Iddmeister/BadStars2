extends KinematicBody2D

class_name Character

export var maxHealth:int = 100
onready var health = maxHealth
export var maxMoveSpeed:float = 200
onready var moveSpeed = maxMoveSpeed
export var acceleration:float = 0.5
export var deceleration:float = 0.1

export var maxAmmo:int = 3
onready var ammo:int = maxAmmo
onready var currentAmmoBox = maxAmmo
export var attack2AmmoCost:int = 1

var AmmoBox = preload("res://Game/Parent/HUD/AmmoBox.tscn")

export var reloadRate:float = 1
var currentReloadTime:float = 0

onready var ammoBoxes = $UI/Main/CenterContainer2/VBoxContainer/Ammo/HBoxContainer

export var ability1Cooldown:float = 1
onready var ability1Charge:float = 0

export var ability2Cooldown:float = 1
onready var ability2Charge:float = 0

var loaded:bool = false
var dead:bool = false
var canMove:int = 0
var invincible:int = 0
var slippery:int = 0
var invisible:int = 0
var damageReduction:float = 0
var damageIncrease:float = 0
var knockedUp:float = false

var team:int = 0

var Ghost = preload("res://Game/Parent/Ghost.tscn")

remotesync var devInvincible:bool = false

signal died(id, killer)
signal hit(id, hitter)
signal initialized(id)

signal ability1Charged()
signal ability2Charged()
signal usedAbility1()
signal usedAbility2()


onready var ability1Icon = $UI/Main/CenterContainer2/VBoxContainer/Abilities/HBoxContainer/Ability1
onready var ability2Icon = $UI/Main/CenterContainer2/VBoxContainer/Abilities/HBoxContainer/Ability2


var moveVelocity:Vector2
var knockVelocity:Vector2
var addedVelocity:Vector2

var currentCharacter:String

var activeEffects = {}

onready var camera:Camera2D = $Space/Camera

## Puppet Variables

var timeSinceUpdate:float = 0
var masterPos:Vector2
var syncSpeed:float = 0.5
var setUpdate:bool = false

export var killLines:PoolStringArray = []
var killStreams:Array

var allAllies:Array = []
var spawnPos:Vector2

signal lagging()

var skin:String = "default"

func _ready():
	
	if not skin == "default":
		setupSkin()
	
	for line in range(killLines.size()):
		killStreams.append(load(killLines[line]))
	
	for a in range(maxAmmo):
		
		var b = AmmoBox.instance()
		b.name = String(a)
		ammoBoxes.add_child(b)
	updateHealth()
	
func playerDisconnected(id:int):
	
	if id == get_network_master():
		hit(100000, -9)
	
	pass
	
func setupSkin():
	pass

func initialize(id:int, allies:Array=[]):
	
	set_network_master(id)
	
	if is_network_master():
		camera.current = true
		$UI/Main.show()
		$Tag.hide()
	else:
		$UI/Main.hide()
		$Tag.show()
		$Tag/VBoxContainer/Name.text = Network.players[id].name
		
	add_to_group("Ally"+String(get_network_master()))
	
	for ally in allies:
		add_to_group("Ally"+String(ally))
		
	if get_tree().get_network_unique_id() in allies:
		$Tag/VBoxContainer/Health.modulate = Color(0.109804, 1, 0)
	elif not is_network_master():
		$Tag/VBoxContainer/Health.modulate = Color(0.993652, 0.089273, 0.089273)
		
	currentCharacter = Globals.currentGameInfo.players[id].character
	
	emit_signal("initialized", id)

		
# warning-ignore:function_conflicts_variable
func loaded():
	loaded = true
	$Spawn.play()
	spawnPos = global_position

func _process(delta):
	if loaded:
		
		if is_network_master() and not dead:
			updateCooldowns(delta)
			if not Globals.inputBusy:
				actions(delta)
			masterAnimations(delta)
		elif not dead:
			puppetAnimations(delta)
			
		updateEffects(delta)
		
	updates(delta)
		
func updates(delta:float):
	pass

func _physics_process(delta):
	
	if loaded:
		if is_network_master() and not dead:
			movement(delta)
		elif not dead:
			syncState(delta)
				

func getMoveDirection() -> Vector2:
	
	if Input.is_action_pressed("cursorMove"):
		return Vector2(1, 0).rotated(getAimDirection())
	
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
	
func getAimDirection() -> float:
	return (get_global_mouse_position()-global_position).angle()
	

func movement(delta:float):
	
	var dir:Vector2 = getMoveDirection()
	
	if Globals.inputBusy or canMove > 0:
		dir = Vector2(0, 0)
		
	var speed:float = max(moveSpeed, 0)
	
	if slippery > 0:
		
		if moveVelocity.length() <= 0:
			moveVelocity = moveVelocity.linear_interpolate(dir*speed, acceleration*delta*60)
		else:
			moveVelocity = moveVelocity.linear_interpolate(moveVelocity.normalized()*speed, acceleration*delta*60)
		
	else:
		knockVelocity = knockVelocity.linear_interpolate(Vector2(0, 0), deceleration*delta*60)
		moveVelocity = moveVelocity.linear_interpolate(dir*speed, acceleration*delta*60)
		
	move_and_slide(moveVelocity+knockVelocity+addedVelocity)
	
	rpc_unreliable("updateState", global_position, Network.clock, setUpdate)

func updateEffects(delta:float):
	
	if invisible > 0:
		if not is_in_group("Ally"+String(get_tree().get_network_unique_id())):
			visible = false
		else:
			modulate.a = 0.5
	else:
		modulate.a = 1
		visible = true
	
	for id in activeEffects.keys():
		
		var effect = activeEffects[id]
		
		if not effect.time == -1:
			effect.time -= delta
			if effect.time <= 0:
				removeEffect(id)
	

remotesync func addEffect(id:String, type:String, time:float, info:Dictionary={}):
	
	if activeEffects.has(id):
		return
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
	
remotesync func cleanse():
	canMove = 0
	canUseAbility1 = 0
	canUseAbility2 = 0
	canUseAttack1 = 0
	canUseAttack2 = 0
	slippery = 0
	pass
	
func syncState(delta:float):
	global_position = global_position.linear_interpolate(masterPos, syncSpeed*delta*60)
	timeSinceUpdate += delta
	if timeSinceUpdate >= 3:
		emit_signal("lagging")
	pass
	
var lastUpdate:float = 0
	
puppet func updateState(pos:Vector2, time:float, set:bool=false):
	
	if time < lastUpdate:
		return
		
	lastUpdate = time
	
	masterPos = pos
	if set:
		global_position = pos
	timeSinceUpdate = 0
	pass
	
puppet func setPos(pos:Vector2):
	global_position = pos
	masterPos = pos
	
	
remotesync func hit(damage:int, id:int):
	
	if devInvincible:
		return
	
	if invincible > 0:
		return
		
	damage = damageTaken(damage)
	
	health = max(health-damage, 0)
	
	emit_signal("hit", get_network_master(), id)
	
	if health <= 0 and not dead:
		die(id)
		
	updateHealth()
	
	pass
	
func damageTaken(damage:int):
	return damage-int(damage*damageReduction)+int(damage*damageIncrease)
	
func die(id:int):
	dead = true
	emit_signal("died", get_network_master(), id)
	$CollisionShape2D.set_deferred("disabled", true)
	$UI/Main.hide()
	clearEffects()
	spawnGhost()
	$Death.play()
	$Graphics.material.set_shader_param("enabled", true)
	$Graphics.global_rotation_degrees = -90
	$Blood.emitting = true
	$DieTime.start()
	pass
	
func destroy():
	queue_free()
	
func kill():
	if not killStreams.empty():
		killStreams.shuffle()
		$Kill.stream = killStreams[0]
		$Kill.play()
	
func win():
	$Win.play()
	
func spawnGhost():
	
	var g = Ghost.instance()
	get_parent().get_parent().get_node("Ghosts").add_child(g)
	g.setPos(global_position)
	g.initialze(get_network_master())
	
	pass

master func knock(vel:Vector2):
	
	knockVelocity += vel
	
	pass
	
remotesync func knockUp(time:float):
	if knockedUp:
		return
	knockedUp = true
	canMove += 1
	$KnockTween.interpolate_property($Graphics, "scale", null, Vector2(2, 2), time/2, Tween.TRANS_SINE, Tween.EASE_IN, 0)
	$KnockTween.start()
	$KnockTween.interpolate_property($Graphics, "rotation_degrees", 0, 180, time/2, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	$KnockTween.start()
	yield($KnockTween, "tween_completed")
	$KnockTween.interpolate_property($Graphics, "scale", null, Vector2(1, 1), time/2, Tween.TRANS_SINE, Tween.EASE_IN, 0)
	$KnockTween.start()
	$KnockTween.interpolate_property($Graphics, "rotation_degrees", null, 361, time/2, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	$KnockTween.start()
	yield($KnockTween, "tween_completed")
	rotation_degrees = 0
	canMove -= 1
	knockedUp = false
	
	pass
	
var addedVelocityID:String = ""
	
master func setAddedVelocity(vel:Vector2, id:String=""):
	addedVelocity = vel
	addedVelocityID = id
	
master func resetAddedVelocity(id:String=""):
	if id == addedVelocityID:
		addedVelocity = Vector2(0, 0)
	
remotesync func heal(amount:int, id:int=-1):
	
	health = min(maxHealth, health+amount)
	
	updateHealth()
	
func updateHealth():
	$UI/Main/CenterContainer/Health.value = (float(health)/float(maxHealth))*100
	$UI/Main/CenterContainer/Health/Num.text = String(health)
	$Tag/VBoxContainer/Health.value = (float(health)/float(maxHealth))
	pass
	
func actions(delta:float):
	
	if Input.is_action_just_pressed("attack1") and ammo > 0 and not usingAttack1 and canUseAttack1 <= 0 and hasAttack1:
		
		attack1()
		if not currentAmmoBox >= maxAmmo:
			ammoBoxes.get_child(currentAmmoBox).value = 0
			ammoBoxes.get_child(currentAmmoBox-1).value = currentReloadTime/reloadRate
		useAmmo()
		
	if Input.is_action_just_pressed("attack2") and ammo >= attack2AmmoCost and not usingAttack2 and canUseAttack2 <= 0 and hasAttack2:
		
		attack2()
		if not currentAmmoBox >= maxAmmo:
			ammoBoxes.get_child(currentAmmoBox).value = 0
			ammoBoxes.get_child(currentAmmoBox-1).value = currentReloadTime/reloadRate
		useAmmo(attack2AmmoCost)
		
	if Input.is_action_just_pressed("ability1") and ability1Charge <= 0 and canUseAbility1 <= 0 and hasAbility1 and not usingAbility1:
		ability1Icon.use()
		ability1Charge = ability1Cooldown
		ability1()
	elif Input.is_action_just_released("ability1"):
		ability1Released()
		
		
	if Input.is_action_just_pressed("ability2") and ability2Charge <= 0 and canUseAbility2 <= 0 and hasAbility2 and not usingAbility2:
		ability2Icon.use()
		ability2Charge = ability2Cooldown
		ability2()
	elif Input.is_action_just_released("ability2"):
		ability2Released()
	
	pass
	
func ability1Released():
	pass
	
func ability2Released():
	pass
	
var usingAttack1:bool = false
var usingAttack2:bool = false
export var hasAttack1:bool = true
export var hasAttack2:bool = true
export var hasAbility1:bool = true
export var hasAbility2:bool = true

var usingAbility1:bool = false
var usingAbility2:bool = false

var canUseAttack1:int = 0
var canUseAttack2:int = 0
var canUseAbility1:int = 0
var canUseAbility2:int = 0
	
func attack1():
	pass
	
func attack2():
	pass
	
func ability1():
	pass

func ability2():
	pass
	
func masterAnimations(delta:float):
	
	pass
	
		
func puppetAnimations(delta:float):
	
	pass

remotesync func useAmmo(amount:int=1):
	
	if ammo <= 0:
		return
	
	for i in range(amount):
	
		ammo -= 1
		ammoBoxes.get_child(currentAmmoBox-1).value = 0
		currentAmmoBox -= 1
		ammoBoxes.get_child(currentAmmoBox).value = currentReloadTime/reloadRate
	
	pass
	
remotesync func reloadAmmo(amount:int=1):
	
	if ammo >= maxAmmo:
		return
	
	for i in range(amount):
		
		ammo += 1
		ammoBoxes.get_child(currentAmmoBox).value = 1
		ammoBoxes.get_child(currentAmmoBox).get_node("Animation").play("Ready")
		currentAmmoBox += 1
		
		
master func setAbility1Cooldown(amount:float):
	
	ability1Charge = amount
	ability1Icon.setProgress(ability1Charge, ability1Cooldown)
	if ability1Charge <= 0:
		emit_signal("ability1Charged")
	
master func setAbility2Cooldown(amount:float):
	
	ability2Charge = amount
	ability2Icon.setProgress(ability2Charge, ability2Cooldown)
	if ability2Charge <= 0:
		emit_signal("ability2Charged")
	
remotesync func setGraphics():
	$Graphics/Sprite.texture = load("res://Game/Characters/Noted/Gnome.png")
	$Graphics/Sprite.scale = Vector2(0.15, 0.15)
	
func updateCooldowns(delta:float):
	
	if not currentAmmoBox >= maxAmmo:
		
		if not usingAttack1 and not usingAttack2:
			
			currentReloadTime = min(reloadRate, currentReloadTime+delta)
			
			ammoBoxes.get_child(currentAmmoBox).value = currentReloadTime/reloadRate
			
			if currentReloadTime >= reloadRate:
				currentReloadTime = 0
				reloadAmmo()
	
	if not ability1Charge <= 0 and not usingAbility1:
		ability1Charge = max(0, ability1Charge-delta)
		ability1Icon.setProgress(ability1Charge, ability1Cooldown)
		if ability1Charge <= 0:
			emit_signal("ability1Charged")
	if not ability2Charge <= 0 and not usingAbility2:
		ability2Charge = max(0, ability2Charge-delta)
		ability2Icon.setProgress(ability2Charge, ability2Cooldown)
		if ability2Charge <= 0:
			emit_signal("ability2Charged")
	
	pass
	
	
remotesync func enableAbilities(d:bool):
	if d:
		canUseAbility1 -= 1
		canUseAbility2 -= 1
	else:
		canUseAbility1 += 1
		canUseAbility2 += 1
	
	ability1Icon.canUse(canUseAbility1<=0)
	ability2Icon.canUse(canUseAbility2<=0)
	
	pass
	
remotesync func enableAttacks(d:bool):
	if d:
		canUseAttack1 -= 1
		canUseAttack2 -= 1
	else:
		canUseAttack1 += 1
		canUseAttack2 += 1
	pass

remotesync func reset(pos:Vector2=spawnPos):
	
	heal(100000)
	global_position = pos
	masterPos = pos
	reloadAmmo(maxAmmo-ammo)
	setAbility1Cooldown(0)
	setAbility2Cooldown(0)
	
	pass
