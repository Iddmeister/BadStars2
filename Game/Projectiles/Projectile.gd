extends Area2D

class_name Projectile

var startPos:Vector2
export var maxDistance:float = 500
var masterPos:Vector2
var masterID:int
var startTime:float
var synced:bool = false
var started:bool = false
var skin:String

signal collided(body)

	
func setupSkin():
	pass

func _physics_process(delta):
	
	if not started:
		return
	
	if masterID == get_tree().get_network_unique_id():
		move(delta)
	else:
		if not synced:
			puppetMove(delta)
		else:
			move(delta)

func initialize(id:int, start:Vector2, dir:float, _startTime:float):
	if Globals.currentGameInfo.players[id].has("skin"):
		skin = Globals.currentGameInfo.players[id].skin
		setupSkin()
	masterID = id
	startPos = start
	startTime = _startTime
	global_rotation = dir
	masterPos = calcMasterPos()
	started = true
	pass
	
func calcMasterPos() -> Vector2:
	
	return Vector2()
	
	pass
	
func move(delta:float):
	
	if (global_position-startPos).length() >= maxDistance:
		destroy()
	
	pass
	
func puppetMove(delta:float):
	
	if (global_position-startPos).length() >= maxDistance:
		destroy()
		
	
	pass
	
remotesync func destroy():
	queue_free()

func collided(body):
	emit_signal("collided", body)
	pass

func _on_Projectile_body_entered(body):
	collided(body)
