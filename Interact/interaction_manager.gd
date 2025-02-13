extends Node3D


@onready var player = get_tree().get_first_node_in_group("player")
@onready var label = $Label3D


const  base_text = "[E] to "


var active_areas = []

  
func register_area(area: InteractionArea):
	active_areas.push_back(area)


func unregister_area(area: InteractionArea):
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)


func _process(_delta):
	if active_areas.size() > 0 && GlobalVar.can_interact && !GlobalVar.interact_wait:
		active_areas.sort_custom(_sort_by_distance_to_player)
		label.text = base_text + active_areas[0].action_name
		label.global_position = active_areas[0].global_position
		label.global_position.y = active_areas[0].global_position.y + 0.8
		label.show()
	else:
		label.hide()
	if Input.is_action_just_pressed("interact") && GlobalVar.can_interact && !GlobalVar.interact_wait:
		if active_areas.size() > 0:
			label.hide()
			await active_areas[0].interact.call()

func _sort_by_distance_to_player(area1, area2):
	var area1_to_player = player.global_position.distance_to(area1.global_position)
	var area2_to_player = player.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player
