extends Node2D
const grass = preload("res://Effects/grasseffect.tscn")

func create_grass_effect():
	var grasseff = grass.instance()
	get_parent().add_child(grasseff)
	grasseff.global_position = global_position


func _on_hurt_area_entered(area):
	create_grass_effect()
	queue_free()
