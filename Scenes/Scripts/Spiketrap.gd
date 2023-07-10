extends Node2D

func _ready():
	$Spikes.play("down")
	$Damager.monitoring = false

func _on_PlayerChecker_body_entered(_body):
	if _body.collision_layer == 1:
		$Damager.monitoring = true
		yield(get_tree().create_timer(.1),"timeout")
		$Damager.monitoring = false
	$Spikes.play("up")
	yield(get_tree().create_timer(2),"timeout")
	$Spikes.play("down")

func _on_Damager_body_entered(_body):
		if _body.collision_layer == 1:
			_body.spiked()
