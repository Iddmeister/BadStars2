extends Node

## Each Character should have a name as the key, the path to their scene,
## the path to their icon and an overall description and a description
## of each ability

var characters:Dictionary = {
	
	
	"Clot":
		{
			"icon":"res://Game/Characters/Clot/Clot.png", 
			"scene":"res://Game/Characters/Clot/Clot.tscn", 
			"info":
				{
					"description":"Still Has Red Hair",
					"attack1":"Shoots 3 Bullets in a line",
					"attack2":"BIG BULLET",
					"ability1":"Shoots bullets in 3 directions",
					"ability2":"Shoots a Big Laser",
				}
		},
		
	"Will Smith":
		{
			"icon":"res://Game/Characters/Will Smith/WillSmith.png",
			"scene":"res://Game/Characters/Will Smith/WillSmith.tscn",
			"info":
				{
					"description":"Is Will Smiff",
					"attack1":"Jahrrrrrrrr",
					"attack2":"Jahrrrrrrrrrrrrrrrrrr",
					"ability1":"Jahrrrrrrrrrrrrrrrrrrrrrrrrrrrr",
					"ability2":"JAHRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR",
				}
		},
	
	"Noted":
	{
	  "icon":"res://Game/Characters/Noted/Noted.png",
	  "scene":"res://Game/Characters/Noted/Noted.tscn",
	  "info":
		{
		  "description":"An old friend",
		  "attack1":"Tactical Spraying",
		  "attack2":"RIP",
		  "ability1":"Ascension",
		  "ability2":"???",
		}, 
	 },
	
}

