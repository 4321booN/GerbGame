extends KinematicBody2D

var velocity = Vector2()
export var SPEED = 800
export var direction = -1

func _ready():
	velocity.x = SPEED * direction
	yield(get_tree().create_timer(4.0), "timeout")
	queue_free()

func _physics_process(_delta):
	if is_on_wall():
		yield(get_tree().create_timer(0.01), "timeout")
		queue_free()
	
	velocity = move_and_slide(velocity,Vector2.UP)
