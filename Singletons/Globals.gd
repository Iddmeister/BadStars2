extends Node

#All Preloaded Scenes that can be instanced and 
#childed to a character
var effects:Dictionary = {
	
	"speed":preload("res://Game/Effects/Speed/Speed.tscn")
	
}
var version:String = "0.1.1"

var currentGameInfo = {}
var lastPickedCharacter:String = "none"

var inputBusy:bool = false

enum {YES, NO, OPTIONAL}
var deathCodes = {"OUT_OF_MAP":-10, "LAGGING":-9}

var gameModes = {
	
	"Free For All":
		{
		"scene":"res://Game/Modes/FreeForAll/FreeForAll.tscn",
		"teams":OPTIONAL,
		"maps":["Box Boy", "THE OCTAGON"]
		},
	
}

var maps = {
	
	"Box Boy":"res://Game/Maps/BoxBoy/BoxBoy.tscn",
	"THE OCTAGON":"res://Game/Maps/THE OCTAGON/THE OCTAGON.tscn"
	
}
