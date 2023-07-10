extends Control


func _ready():
	UI.show()


func _on_TitleScreen_pressed():
	get_tree().change_scene("res://Scenes/Main-TitleMenu.tscn")


func _on_Start_pressed():
	get_tree().change_scene("res://Scenes/Level1.tscn")
