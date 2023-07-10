extends Area2D

func _ready():
	$AnimationPlayer.play("RESET")

func _on_AnimationPlayer_animation_finished(_anim_name):
	if _anim_name == "Collect_Bounce":
		queue_free()


func _on_GemButBetter1_body_entered(_body):
	$AnimationPlayer.play("Collect_Bounce")
	$GemCollectSound.play()
	_body.add_gem("gem_but_better")
	set_collision_mask_bit(0,0)
	print_debug("gems: ",str(Global.gems),", gem_but_better collected")
