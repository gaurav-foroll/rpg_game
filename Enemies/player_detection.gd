extends Area2D

var isplayer = null

func can_see_player():
	return isplayer != null
	

func _on_palyer_detection_body_entered(body):
	isplayer = body



func _on_palyer_detection_body_exited(body):
	isplayer = null
	
