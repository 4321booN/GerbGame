extends Area2D

func _on_Portal_body_entered(_body):
	if _body.collision_layer == 1:
		if Global.gems >= 7 and Global.level == 1:
			get_tree().change_scene("res://Scenes/Level2.tscn")
			Global.mana -= 2
			Global.gems -= 2
		elif Global.gems >= 11 and Global.mana >= 4 and Global.level == 2:
			get_tree().change_scene("res://Scenes/Victory.tscn")
		elif Global.level == 3366:
			get_tree().change_scene("res://Scenes/Main-TitleMenu.tscn")
