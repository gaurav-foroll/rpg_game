extends Area2D


const Hiteffect = preload("res://Effects/hiteffect.tscn")

var invincible = false setget set_invincible

onready var timer = $Timer
onready var collisionshape = $CollisionShape2D

signal invincibility_start
signal invincibility_end

func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invincibility_start")
	else :
		emit_signal("invincibility_end")

func start_invicibility(duration):
	self.invincible = true
	timer.start(duration)
	


func create_hit_effect():
	print('hit')
	var effect = Hiteffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position


func _on_Timer_timeout():
	self.invincible = false


func _on_hurt_invincibility_start():
	collisionshape.set_deferred("disabled" , true)


func _on_hurt_invincibility_end():
	collisionshape.disabled = false

