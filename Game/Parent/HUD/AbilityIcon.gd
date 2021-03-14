extends Control

export var icon:Texture

func _ready():
	$TextureProgress.texture_under = icon
	$TextureProgress.texture_progress = icon
	$TextureProgress.tint_under = Color(0.3, 0.3, 0.3, 1)

func setProgress(time:float, maxTime:float):
	
	$TextureProgress.value = 1-(time/maxTime)
	
	if $TextureProgress.value >= 1:
		$CenterContainer/Time.text = ""
		$Animation.play("Ready")
		return
	
	if time < 1:
		$CenterContainer/Time.text = String(stepify(time, 0.1))
	else:
		$CenterContainer/Time.text = String(int(time))
	
	pass
	
func canUse(can:bool):
	if can and $TextureProgress.value >= 1:
		$Animation.play("Ready")
	elif $TextureProgress.value < 1:
		$Animation.play("Use")
	else:
		$Animation.play("Disabled")
	
func use():
	$Animation.play("Use")
	pass
