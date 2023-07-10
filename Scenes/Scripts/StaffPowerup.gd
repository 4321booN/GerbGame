extends Area2D

export var type = "none"

func _ready():
	$AnimatedSprite.play(type)

func _on_StaffPowerup_body_entered(_body):
	$PowerupCollectSoundPT1.play()
	$PowerupCollectSoundPT2.play()
	if type == "blast":
		Global.staffpowerup = "blast"
	$"../../HUD".staff_powerup()
	set_collision_mask_bit(0,0)
	print_debug(type, " powerup collected")
