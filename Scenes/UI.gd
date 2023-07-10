extends Node

func _ready():
	$Buttons.show()

func _on_Mute_pressed():
	Music.mute()

func _on_UnMute_pressed():
	Music.unmute()
