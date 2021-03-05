extends Area2D

enum teams {TEAM_1=1, TEAM_2=2}
export(teams) var team:int = 1

signal scored(t)

func _on_Goal_body_entered(body):
	emit_signal("scored", team)
