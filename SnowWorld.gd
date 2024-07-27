extends Node2D
const player = preload("res://Player/2Dplayer.tscn")

onready var list =[get_node("YSort/2Dplayer")]
var active=0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_2Dplayer_place_clone(position):
	var clone_node = player.instance()
	clone_node.position = position
	clone_node.player = false
	var ysort = get_node("YSort")
	ysort.add_child(clone_node)
	list.append(clone_node)
	active += 1
	list[active].stats.health = 50
	list[active].healthbar.no_effect(50)
	set_physics_process(true)

func _process(delta):
	read_input(delta)


func read_input(delta):
	if Input.is_action_just_pressed("switch"):
		print(list[active])
		if !is_instance_valid(list[active]):
			list.pop_back()
			active = active % len(list)
		list[active].set_physics_process(false)
		active =(active +1) % len(list)
		if list[active].player :
			list[active].state = 0
		list[active].set_physics_process(true)
	elif Input.is_action_just_pressed("remove_clone"):
		if not list[active].player:
			var temp = list[active].stats.health
			list[active].queue_free()
			list.remove(active)
			active = active % len(list)
			print(active)
			list[active].stats.health += temp
			list[active].healthbar.no_effect(list[active].stats.health)
			list[active].set_physics_process(true)
			
