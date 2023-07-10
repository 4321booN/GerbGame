extends Node2D

func _ready():
	Global.level = 1


func play_level_music():
	Music.Main_GameplaySoundrack()

func _process(_delta):
	play_level_music()
