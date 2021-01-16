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
#	"Frozone":{"icon":"res://Misc/Frozone.png"},
#	"Karl Marx":{"icon":"res://Misc/KarlMarx.png"},
#	"Will Smith":{"icon":"res://Misc/WillSmith.png"}
	
<<<<<<< Updated upstream
=======
	"Frozone":
	{
	  "icon":"res://Game/Characters/Frozone/Frozone.png",
	  "scene":"res://Game/Characters/Frozone/Frozone.tscn",
	  "info":
		{
		  "description":"Honey, where's my supersuit",
		  "attack1":"Throws Icicle",
		  "attack2":"Slippery Icicle",
		  "ability1":"Shits out ice",
		  "ability2":"Ice Wall",
		}, 
	"Go'Chath":
	{
	  "icon":"res://Game/Characters/Go'Chath/Go'Chath.png",
	  "scene":"res://Game/Characters/Go'Chath/Go'Chath.tscn",
	  "info":
		{
		  "description":"OMNOMNOM",
		  "attack1":"Vorpal Spikes",
		  "ability1":"Silence",
		  "ability2":"BONK",
		  "ability3":"OMNOMNOM",
		}, 
	 },
>>>>>>> Stashed changes
	
}
}
