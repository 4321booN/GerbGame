extends KinematicBody2D

var velocity = Vector2()
export var gravity = 25
export var direction = -1 #1 = right, -1 = left
export var speed = 70
export var detects_cliffs := true
export var health = 4
var death_type
var amount #mana amount

func _ready():
	randomize()
	amount = round(rand_range(3,6))
	if direction == 1:
		$AnimatedSprite.flip_h = true
	$FloorChecker.position.x = $Hitbox.shape.get_extents().x * direction
	$FloorChecker.enabled = detects_cliffs

func _physics_process(_delta):
	if is_on_wall() or not $FloorChecker.is_colliding() and detects_cliffs and is_on_floor():
		direction = direction * -1
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
		$FloorChecker.position.x = $Hitbox.shape.get_extents().x * direction
	if health == 0:
		health = -1
		speed = 0
		if Global.level == 1:
			get_node("/root/Level1/Gerbin (Player)").add_mana(amount)
		if Global.level == 2:
			get_node("/root/Level2/Gerbin (Player)").add_mana(amount)
		if Global.level == 3366:
			$"/root/Demo/Gerbin (Player)".add_mana(amount)
		set_collision_layer_bit(4,0)
		set_collision_mask_bit(0,0)
		$TopChecker.set_collision_layer_bit(4,0)
		$TopChecker.set_collision_mask_bit(0,0)
		$SidesChecker.set_collision_layer_bit(4,0)
		$SidesChecker.set_collision_mask_bit(0,0)
		$SidesChecker.set_collision_mask_bit(5,0)
		$AnimatedSprite.play("Idle")
		$TopHitSound.play()
		$AnimatedSprite.play("Dissolve")
		yield(get_tree().create_timer(1.0), "timeout")
		queue_free()

	velocity.y += gravity

	velocity.x = speed*direction

	velocity = move_and_slide(velocity,Vector2.UP)
	if speed == 70:
		$AnimatedSprite.play("Walk")


func _on_TopChecker_body_entered(_body):
	if _body.collision_layer == 1:
		print_debug("orc top collided with")
		_body.bounce()
		health -= 1
		if health == 3:
			$HurtSound.play()
			$Healthbar/AnimationPlayer.play("HeathbarDecreaseTo3")
			yield(get_tree().create_timer(.25),"timeout")
		if health == 2:
			$HurtSound.play()
			$Healthbar/AnimationPlayer.play("HeathbarDecreaseTo2")
			yield(get_tree().create_timer(.25),"timeout")
		if health == 1:
			$HurtSound.play()
			$Healthbar/AnimationPlayer.play("HeathbarDecreaseTo1")
			yield(get_tree().create_timer(.25),"timeout")
		if health == 0:
			$Healthbar/AnimationPlayer.play("HeathbarDecreaseTo0")

func _on_SidesChecker_body_entered(_body):
	if _body.collision_layer == 1:
		print_debug("orc side(s) collided with")
		_body.hurt(position.x)
	elif _body.collision_layer == 32:
		print_debug("orc hit with spell")
		health -= 2
		if health == 2:
			$HurtSound.play()
			$Healthbar/AnimationPlayer.play("HeathbarDecreaseTo3")
			yield(get_tree().create_timer(.25),"timeout")
			$Healthbar/AnimationPlayer.play("HeathbarDecreaseTo2")
			yield(get_tree().create_timer(.25),"timeout")

		if health == 0:
			$Healthbar/AnimationPlayer.play("HeathbarDecreaseTo1")
			yield(get_tree().create_timer(.25),"timeout")
			$Healthbar/AnimationPlayer.play("HeathbarDecreaseTo0")
			yield(get_tree().create_timer(.25),"timeout")
