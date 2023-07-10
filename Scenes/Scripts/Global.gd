extends Node


#PLAYER VARs
var max_health = 3
var health = max_health
var gems = 0
var mana = 0

#GAME VARs
var level = 1
var hud
var staffpowerup = "none"

func _ready():
	health = max_health
