extends Character


func create(allies:Array=[]):
	initialize(1, allies)
	
func initialize(id:int, allies:Array=[]):
	set_network_master(id)
	
	if not allies.empty():
		for ally in allies:
			add_to_group("Ally"+String(ally))
			
	pass

func hit(damage:int, id:int):
	$DamageReadout/VBoxContainer/LastHit.text = String(damage)
	$DamageReadout/VBoxContainer/Total.text = String(int($DamageReadout/VBoxContainer/Total.text)+damage)
	$DamageTime.start()

func getMoveDirection():
	return Vector2(0, 0)
	

func _on_DamageTime_timeout():
	$DamageReadout/VBoxContainer/LastHit.text = ""
	$DamageReadout/VBoxContainer/Total.text = ""
