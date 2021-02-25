extends Character

var skinParams ={
	
	"Leonardo":{"scale":Vector2(0.08, 0.08), "offset":Vector2(2.1, -13.5), "path":"res://Game/Characters/Ninja Turtle/Leonardo.png"},
	"Raphael":{"scale":Vector2(0.07, 0.07), "offset":Vector2(0, -4.46), "path":"res://Game/Characters/Ninja Turtle/Raphael.png"},
	"Michelangelo":{"scale":Vector2(0.3, 0.3), "offset":Vector2(-0.43, 2.27), "path":"res://Game/Characters/Ninja Turtle/Michelangelo.png"},
	"Donatello":{"scale":Vector2(0.28, 0.28), "offset":Vector2(-1.37, -2.97), "path":"res://Game/Characters/Ninja Turtle/Donatello.png"},
	
}

func setupSkin():
	
	var sprite:Sprite = $Graphics/Sprite
	
	sprite.texture = load(skinParams[skin].path)
	sprite.position = skinParams[skin].offset
	sprite.scale = skinParams[skin].scale
	
	pass
		
