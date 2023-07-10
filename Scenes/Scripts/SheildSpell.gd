extends KinematicBody2D

func _ready():
	yield(get_tree().create_timer(7),"timeout")
	queue_free()

func _physics_process(_delta):
	position.x = $"../Gerbin (Player)".position.x
	position.y = $"../Gerbin (Player)".position.y
