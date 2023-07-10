extends Node2D

func _ready():
	Global.level = 2

func play_level_music():
	Music.Main_GameplaySoundrack()

func _process(delta):
	play_level_music()
