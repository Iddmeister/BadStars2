extends Node

onready var scene = $Scene
onready var loose = $Loose
onready var draw = $draw

signal sceneLoaded()

var tempData:Dictionary

func sendData(data:Dictionary):
	tempData = data
	pass
	
func recieveData() -> Dictionary:
	return tempData

func changeScene(path:String):
	
	get_tree().paused = true
	yield(get_tree(), "idle_frame")
	clear()
	var s = load(path).instance()
	scene.add_child(s)
	get_tree().paused = false
	emit_signal("sceneLoaded")
	
	pass
	
func clear():
	
	for child in scene.get_children():
		child.free()
		
	for child in loose.get_children():
		child.free()
	
	pass
	
func generateUniqueID():
	
	return "id"+String(OS.get_system_time_msecs()+rand_range(-100, 100))
	
	pass

