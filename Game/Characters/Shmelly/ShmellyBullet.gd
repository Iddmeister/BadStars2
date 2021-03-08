extends StraightProjectile


func setupSkin():
	
	match skin:
		"Shmelly Prestige Edition":
			$Sprite.texture = load("res://Game/Characters/Shmelly/ShmellyBulletPrestige.png")
