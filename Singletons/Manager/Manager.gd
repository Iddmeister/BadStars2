extends Node

onready var scene = $Scene
onready var loose = $Loose

signal sceneLoaded()

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

