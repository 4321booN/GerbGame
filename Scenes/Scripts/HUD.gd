extends CanvasLayer


func _ready():
	$"Panel/GemsCounter/Gems".text = "0"
	$"Panel/ManaCounter/Mana".text = "0"
	Global.hud = self

func _process(_delta):
	$"Panel/GemsCounter/Gems".text = str(Global.gems)
	$"Panel/ManaCounter/Mana".text = str(Global.mana)

func playhealth():
	$"Panel/Healthbar/HealthbarSprite".play(str(Global.health)+"hp")

func staff_powerup():
	if Global.staffpowerup == "none":
		$Panel/StaffPowerup.play("Blank")
	if Global.staffpowerup == "blast":
		$Panel/StaffPowerup.play("Blast")
