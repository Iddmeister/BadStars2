extends Control


func _ready():
	
	Manager.changeScene("res://Screens/Menu/Menu.tscn")
	queue_free()
	
	pass
