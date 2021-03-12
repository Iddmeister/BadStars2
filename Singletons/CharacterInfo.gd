extends Node

## Each Character should have a name as the key, the path to their scene and
## the path to their icon

## They should also have an info dictionary with and overall description and
## a description of each ability

## Skins are optional and is a dictionary of skin names as the key and
## a path to the skin icon. Skins should be implemented in each character scene
## individually

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
				},
			"skins":
				{
					"Blood Clot":"res://Game/Characters/Clot/RedBloodCell.png",
					"Cloddmeister":"res://Game/Characters/Clot/Cloddmeister.png",
				
				}
		},
		
	"Shmelly":
		{
			"icon":"res://Game/Characters/Shmelly/Shmelly.png", 
			"scene":"res://Game/Characters/Shmelly/Shmelly.tscn", 
			"info":
				{
					"description":"Shmells",
					"attack1":"Shotgun",
					"attack2":"Poison Bullet",
					"ability1":"Reloads all ammo, breaking her fingers and taking damage in the process",
					"ability2":"Places a zone causing enemies to catch Diarrhea and shit violently. The shit heals Shmelly",
				},
			"skins":
				{
					"Shmelly Prestige Edition":"res://Game/Characters/Shmelly/ShmellyPrestige.png",
				}
		},
		
	"Will Smith":
		{
			"icon":"res://Game/Characters/Will Smith/WillSmith.png",
			"scene":"res://Game/Characters/Will Smith/WillSmith.tscn",
			"info":
				{
					"description":"Is Will Smiff",
					"attack1":"Will Smith's Balls",
					"attack2":"Poof",
					"ability1":"Yarrrrrrrrrrrrrrrrrrrrrrr",
					"ability2":"YARRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR",
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
		"skins":
			{
				"Holy":"res://Game/Characters/Noted/holy.jpg",
			
			}
	 },
	
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
		"skins":
				{
					"Pool Party Frozone":"res://Game/Characters/Frozone/FrozonePool.png",
				}
	},
		
	"Go'Chath":
	{
	  "icon":"res://Game/Characters/Go'Chath/Go'Chath.png",
	  "scene":"res://Game/Characters/Go'Chath/Go'Chath.tscn",
	  "info":
		{
		  "description":"OMNOMNOM",
		  "attack1":"Vorpal Spikes",
		  "attack2":"Silence",
		  "ability1":"BIG",
		  "ability2":"BONK",
		}, 
	 },
	
	"Barrel":
	{
		"icon":"res://Game/Characters/Barrel/Barrel.png",
		"scene":"res://Game/Characters/Barrel/Barrel.tscn",
		"info":
			{
			  "description":"Is a Barrel\nDoes damage on Collision",
			  "attack1":"none",
			  "attack2":"none",
			  "ability1":"BONK\nRecharges on hit",
			  "ability2":"Woooooosh\nAllies are speed and enemies are slow",
			},
			"skins":
				{
					"Udyr":"res://Game/Characters/Barrel/Udyr.png",
				
				}
	},
	
	"Bob The Builder":
	{
		"icon":"res://Game/Characters/BobTheBuilder/Bob.png",
		"scene":"res://Game/Characters/BobTheBuilder/Bob.tscn",
		"info":
			{
			  "description":"Can He Fix It?",
			  "attack1":"Place a Block",
			  "attack2":"Remove a Block",
			  "ability1":"Place Spikes on the Ground",
			  "ability2":"Throw hammer, enemies knocked back when hit",
			}
	},
	
	"Ninja Turtle":
	{
		"icon":"res://Game/Characters/Ninja Turtle/NinjaTurtles.jpg",
		"scene":"res://Game/Characters/Ninja Turtle/Ninja Turtle.tscn",
		"info":
			{
			  "description":"Teenage Mutant Ninja Turtles\nAll Turtles have different Attacks",
			  "attack1":"?",
			  "attack2":"?",
			  "ability1":"Skateboard\nHeal whilst near other skateboarding turtles",
			  "ability2":"Smoke Bomb",
			},

		"default":"Leonardo",

		"skins":
			{
				"Leonardo":"res://Game/Characters/Ninja Turtle/Leonardo.png",
				"Raphael":"res://Game/Characters/Ninja Turtle/Raphael.png",
				"Michelangelo":"res://Game/Characters/Ninja Turtle/Michelangelo.png",
				"Donatello":"res://Game/Characters/Ninja Turtle/Donatello.png",
			}
	}
}
