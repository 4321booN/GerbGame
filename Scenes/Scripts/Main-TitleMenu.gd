extends Control

func _ready():
	$Notice.hide()
	UI.show()
	yield(get_tree().create_timer(.5),"timeout")
	Music.Main_TitleMenuSoundtrack()
	

func _on_Start_pressed():
	get_tree().change_scene("res://Scenes/Level1.tscn")

func _on_Instructions_pressed():
	get_tree().change_scene("res://Scenes/Instructions.tscn")

func _on_Demo_pressed():
	get_tree().change_scene("res://Scenes/Demo.tscn")

func _on_NoticeButton_pressed() -> void:
	$Notice.show()
	$NoticeButton.hide()


func _on_x_pressed() -> void:
	$Notice.hide()
	$NoticeButton.show()
