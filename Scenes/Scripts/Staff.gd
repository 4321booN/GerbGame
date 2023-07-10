
extends Node2D
var beam = Rect2(0, 0, 12.5, 4)

func _ready():
	$RayCast2D.enabled = false
	$StaffSprite.hide()

func blast():
	$StaffSprite.show()
	$StaffSprite/Begin/Beam.hide()
	$"../PlayerSprite".play("HoldStaff")
	if $"..".staff_blast_chargeup == 5:
		$StaffSprite/Begin.show()
		$RayCast2D.enabled = true
		beam = Rect2(0,0,get_global_mouse_position().x/8,4)
		look_at(get_global_mouse_position())
		$StaffSprite/Begin/Beam.set_region_rect(beam)
		$RayCast2D.look_at(get_global_mouse_position())
		$RayCast2D.cast_to = get_global_mouse_position()
		if $RayCast2D.is_colliding():
			$RayCast2D.get_collider().blasted()
	else:
		$RayCast2D.enabled = false
		$StaffSprite/Begin.hide()
		$StaffSprite.hide()

