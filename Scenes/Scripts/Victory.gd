extends Control


func _ready():
	UI.show()


func _on_MainTitleMenu_pressed():
	get_tree().change_scene("res://Scenes/Main-TitleMenu.tscn")
