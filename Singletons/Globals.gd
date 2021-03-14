extends Node

#All Preloaded Scenes that can be instanced and 
#childed to a character
var effects:Dictionary = {
	
	"speed":preload("res://Game/Effects/Speed/Speed.tscn"),
	"slow":preload("res://Game/Effects/Slow/Slow.tscn"),
	"silence":preload("res://Game/Effects/Silence/Silence.tscn"),
	"slippery":preload("res://Game/Effects/Slippery/Slippery.tscn"),
	"freeze":preload("res://Game/Effects/Freeze/Freeze.tscn"),
	"poison":preload("res://Game/Effects/Poison/Poison.tscn"),
	"diarrhea":preload("res://Game/Effects/Diarrhea/Diarrhea.tscn"),
	"stun":preload("res://Game/Effects/Stunned/Stunned.tscn"),
	"wild":preload("res://Game/Effects/Wild/WildEffect.tscn"),
	
}
var version:String = "0.1.1"

var currentGameInfo = {}
var lastPickedCharacter:String = "none"
var lastPickedSkin:String = "default"
var devMode:bool = false

var inputBusy:bool = false

enum {YES, NO, OPTIONAL}
var deathCodes = {"OUT_OF_MAP":-10, "LAGGING":-9, "SURRENDER":-8, "SPIKES":-7}

var gameModes = {
	
	"Free For All":
		{
		"scene":"res://Game/Modes/FreeForAll/FreeForAll.tscn",
		"teams":OPTIONAL,
		"maps":["Box Boy", "THE OCTAGON", "uwu", "Spiky", "hell", "Training Zone", "Swamp"]
		},
	"Bad Ball":
		{
			"scene":"res://Game/Modes/BadBall/BadBall.tscn",
			"teams":YES,
			"maps":["Balls"],
			"teamRange":2
		}
	
}

var maps = {
	
	"Box Boy":"res://Game/Maps/BoxBoy/BoxBoy.tscn",
	"THE OCTAGON":"res://Game/Maps/THE OCTAGON/THE OCTAGON.tscn",
	"uwu":"res://Game/Maps/uwu/uwu.tscn",
	"Spiky":"res://Game/Maps/Spiky/Spiky.tscn",
	"hell":"res://Game/Maps/hell/hell.tscn",
	"Training Zone":"res://Game/Maps/TrainingZone/TrainingZone.tscn",
	"Balls":"res://Game/Maps/Balls/Balls.tscn",
	"Swamp": "res://Game/Maps/Swamp/Swamp.tscn",
	
}
