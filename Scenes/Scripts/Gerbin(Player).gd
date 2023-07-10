extends KinematicBody2D

#STATE VARs
enum States {AIR=1, FLOOR, LADDER, DEAD, NONE}
var state = States.AIR
var is_on_ladder := false
var velocity = Vector2(0,0)
#STAT VARs
export var SPEED = 190
export var JUMP_FORCE = 4.4
export var GRAVITY = 25
export var STOP_SPEED = 0.5
export var RUNSPEED = 400
#SPELL VARs
const FIREBALL = preload("res://Scenes/Fireball1.tscn")
const SHEILD_SPELL = preload("res://Scenes/SheildSpell.tscn")
export var staff_blast_chargeup = 0
#COOLDOWN VARs
var sheildcooldown = false
var fireballcooldown = false
var healcooldown = false
var damagecooldown = false
var staffcooldown = false

#READY

func _ready():
	if Global.level == 0:
		Global.level = 1
	if Global.level == 2:
		Global.level = 2
	UI.show()
	$"../HUD".playhealth()
	$AnimationPlayer.play("HealAura Hide")

#STATE MACHINE

func _physics_process(_delta):
	if Global.health > Global.max_health:
		Global.health = Global.max_health
	if Global.gems < 0:
		Global.gems = 0
	if Global.mana < 0:
		Global.mana = 0
	match state:
		States.AIR:
			if is_on_floor():
				state = States.FLOOR
				continue
			elif should_climb_ladder():
				state = States.LADDER
				continue
			elif Global.health == 0:
				gameover()
				state = States.DEAD
				continue
			$PlayerSprite.play("Idle")
			if Input.is_action_pressed("right"):
				$PlayerSprite.flip_h = false
				velocity.x = lerp(velocity.x,SPEED,0.3)
			elif Input.is_action_pressed("left"):
				$PlayerSprite.flip_h = true
				velocity.x = lerp(velocity.x,-SPEED,0.3)
			else:
				velocity.x = lerp(velocity.x,0,STOP_SPEED)
			move_and_fall()
			cast1()
			castsheild()
			castheal()
			
		States.FLOOR:
			if not is_on_floor():
				state = States.AIR
				continue
			elif should_climb_ladder():
				state = States.LADDER
				continue
			elif Global.health == 0:
				gameover()
				state = States.DEAD
				continue
			if Input.is_action_pressed("right"):
				$"../HUD".playhealth()
				$PlayerSprite.play("Walk")
				$PlayerSprite.flip_h = false
				velocity.x = lerp(velocity.x,SPEED,0.3)
			elif Input.is_action_pressed("left"):
				$"../HUD".playhealth()
				$PlayerSprite.play("Walk")
				$PlayerSprite.flip_h = true
				velocity.x = lerp(velocity.x,-SPEED,0.3)
			else:
				$PlayerSprite.play("Idle")
				velocity.x = lerp(velocity.x,0,STOP_SPEED)
			if Input.is_action_just_pressed("up"):
				$"../HUD".playhealth()
				velocity.y = -SPEED * JUMP_FORCE
				$JumpSound.play()
				state = States.AIR
			move_and_fall()
			cast1()
			castsheild()
			castheal()
			caststaffblast()
			
		States.LADDER:
			if Input.is_action_pressed("crouch - exit ladder"):
				bounce()
				state = States.AIR
				continue
			if not is_on_ladder:
				state = States.AIR
				continue
			elif Global.health == 0:
				gameover()
				state = States.DEAD
				continue
			if Input.is_action_pressed("up") or Input.is_action_pressed("down") or Input.is_action_pressed("left") or Input.is_action_pressed("right"):
				$PlayerSprite.play("Climb")
			else:
				$PlayerSprite.playing = false
			if Input.is_action_pressed("up"):
				velocity.y = -SPEED
			elif Input.is_action_pressed("down"):
				velocity.y = SPEED
			if Input.is_action_pressed("right"):
				$PlayerSprite.flip_h = false
				velocity.x = lerp(velocity.x,SPEED,0.35)
			elif Input.is_action_pressed("left"):
				$PlayerSprite.flip_h = true
				velocity.x = lerp(velocity.x,-SPEED,0.35)
			else:
				velocity.x = lerp(velocity.x,0,STOP_SPEED+.05)
				velocity.y = lerp(velocity.y,0,STOP_SPEED+.05)
			move_and_slide(velocity,Vector2.UP)
			castsheild()
			
		States.DEAD:
			set_modulate(Color(0.65,0.3,0.3,0.5))
			
		States.NONE:
			pass

#LADDER CHECKS

func should_climb_ladder() -> bool:
	if is_on_ladder and (Input.is_action_pressed("up") or Input.is_action_pressed("down")):
		return true
	else:
		return false

func _on_LadderChecker_body_entered(_body):
	is_on_ladder = true
func _on_LadderChecker_body_exited(_body):
	is_on_ladder = false

#SPELLCASTS

func cast1():
	if Global.mana >= 2:
		fireball_cooldown()
		var direction = 1 if $PlayerSprite.flip_h == false else -1
		if Input.is_action_just_pressed("fireball cast") and not fireballcooldown:
			var fireball1 = FIREBALL.instance()
			fireball1.direction = direction
			get_parent().add_child(fireball1)
			fireball1.position.y = position.y
			fireball1.position.x = position.x + 32*direction
			Global.mana -= round(rand_range(1,2))

func castsheild():
	if Global.mana >= 3:
		sheild_cooldown()
		if Input.is_action_just_pressed("sheild spell cast") and not sheildcooldown:
			var sheild = SHEILD_SPELL.instance()
			get_parent().add_child(sheild)
			sheild.position.y = position.y
			sheild.position.x = position.x
			Global.mana -= round(rand_range(1,3))

func castheal():
	if Global.mana >= 4:
		heal_cooldown()
		if Input.is_action_pressed("heal spell cast") and not healcooldown and Global.health < 3:
			Input.action_release("heal spell cast")
			Global.mana -= round(rand_range(3,4))
			$AnimationPlayer.play("Heal Spell")
			yield(get_tree().create_timer(1),"timeout")
			Global.health += 1
			$"../HUD".playhealth()

func caststaffblast():
	if Global.mana >= 7:
		staff_cooldown()
		if Input.is_action_pressed("staff blast cast") and not staffcooldown and Global.staffpowerup == "blast":
			$Staff.blast()
			staff_blast_chargeup()

func staff_blast_chargeup():
	staff_blast_chargeup += 0
	yield(get_tree().create_timer(1),"timeout")

#SPELL COOLDOWNS

func sheild_cooldown():
	if Input.is_action_pressed("sheild spell cast"):
		yield(get_tree().create_timer(.1),"timeout")
		sheildcooldown = true
		yield(get_tree().create_timer(10),"timeout")
		sheildcooldown = false

func fireball_cooldown():
		if Input.is_action_pressed("fireball cast"):
			yield(get_tree().create_timer(.1),"timeout")
			fireballcooldown = true
			yield(get_tree().create_timer(2),"timeout")
			fireballcooldown = false

func heal_cooldown():
	if Input.is_action_pressed("heal spell cast"):
			yield(get_tree().create_timer(.1),"timeout")
			healcooldown = true
			yield(get_tree().create_timer(2),"timeout")
			healcooldown = false

func staff_cooldown():
	if Input.is_action_just_pressed("staff blast cast") and Global.staffpowerup == "blast":
		yield(get_tree().create_timer(5),"timeout")
		Global.mana -= round(rand_range(6,7))
		staffcooldown = true
		yield(get_tree().create_timer(10),"timeout")
		staffcooldown = false

#MOVEMENT

func move_and_fall():
	velocity.y += GRAVITY #Gravity
	velocity = move_and_slide(velocity,Vector2.UP)

func bounce():
	velocity.y -= JUMP_FORCE*100

#DAMAGE

func hurt(enemyposx):
	if not damagecooldown:
		damage_cooldown()
		Global.health -= 1
		$"../HUD".playhealth()
		bounce()
		if position.x < enemyposx:
			velocity.x = -150
		elif position.x > enemyposx:
			velocity.x = 150
		$HurtSound.play()
		Input.action_release("left")
		Input.action_release("right")

func _on_Fall_Zone_body_entered(_body):
	if not damagecooldown:
		damage_cooldown()
		Global.health -= 1
		$"../HUD".playhealth()
		$HurtSound.play()
		if Global.health != 0:
			yield(get_tree().create_timer(1.02),"timeout")
			$"../HUD".playhealth()
			Global.gems = 0
			get_tree().reload_current_scene()

func spiked():
	if not damagecooldown:
		damage_cooldown()
		Global.health -= 1
		$"../HUD".playhealth()
		$HurtSound.play()
		Input.action_release("up")
		Input.action_release("left")
		Input.action_release("right")

func damage_cooldown():
	damagecooldown = true
	set_modulate(Color(0.65,0.3,0.3,0.5))
	yield(get_tree().create_timer(.5), "timeout")
	set_modulate(Color(0.65,0.3,0.3,0.3))
	yield(get_tree().create_timer(1.8),"timeout")
	set_modulate(Color(1,1,1,1))
	damagecooldown = false

func gameover():
	set_modulate(Color(0.65,0.3,0.3,0.5))
	set_collision_layer_bit(0,0)
	set_collision_mask_bit(0,0)
	Input.action_release("down")
	Input.action_release("left")
	Input.action_release("right")
	Input.action_release("fireball cast")
	Input.action_release("up")
	Input.action_release("crouch - exit ladder")
	$PlayerSprite.play("Idle")
	Music.stop()
	$GameoverSound.play()
	$"../HUD".playhealth()
	yield(get_tree().create_timer(3.06), "timeout")
	get_tree().change_scene("res://Scenes/Gameover.tscn")

#POINTS

func add_gem(var gem_type):
	if gem_type == "gem":
		Global.gems += 1
	if gem_type == "gem_but_better":
		Global.gems += 3

func add_mana(var amount):
	Global.mana += amount
