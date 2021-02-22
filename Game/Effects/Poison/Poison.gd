extends Effect

var damage:int = 0
var damager:int = -1
var p:Character

func start(info:Dictionary, player:Character):
	damage = info.damage
	damager = info.masterID
	p = player
	$DamageInterval.start()
	pass
	
func end(info:Dictionary, player:Character):
	queue_free()
	pass


func _on_DamageInterval_timeout():
	p.hit(damage, damager)
