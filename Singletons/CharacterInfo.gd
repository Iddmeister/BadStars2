extends Node

## Each Character should have a name as the key, the path to their scene,
## the path to their icon and an overall description and a description
## of each ability

var characters:Dictionary = {
	
	
	"Clot":{"icon":"res://Game/Characters/Clot/Clot.png", "info":{
		
		"description":"Still Has Red Hair",
		"attack1":"Shoots 3 Bullets in a line",
		"attack2":"BIG BULLET",
		"ability1":"Shoots bullets in 3 directions",
		"ability2":"Shoots a Big Laser",
		
	}, "scene":"res://Game/Characters/Clot/Clot.tscn"},

	"Noted":{"icon":"res://Game/Characters/Noted/Noted.png", "info":{
		
		"description":"An old friend",
		"attack1":"Tactical Spraying",
		"attack2":"RIP",
		"ability1":"Ascension",
		"ability2":"???",
		
	}, "scene":"res://Game/Characters/Noted/Noted.tscn"},
#	"Frozone":{"icon":"res://Misc/Frozone.png"},
#	"Karl Marx":{"icon":"res://Misc/KarlMarx.png"},
#	"Will Smith":{"icon":"res://Misc/WillSmith.png"}
	
	
}

