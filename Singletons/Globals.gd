extends Node

#All Preloaded Scenes that can be instanced and 
#childed to a character
var effects:Dictionary = {
	
	"speed":preload("res://Game/Effects/Speed/Speed.tscn")
	
}

var currentGameInfo = {}

var inputBusy:bool = false
