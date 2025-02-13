extends RigidBody3D

@onready var interaction_area: InteractionArea = $Interaction_area
@export var dialogue_resource: DialogueResource
@export var play: String = " "

const Balloon = preload("uid://73jm5qjy52vq")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GlobalVar.can_interact:
		interaction_area.interact = Callable(self, "_on_interact")


func _on_interact():
	var balloon: Node = Balloon.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(dialogue_resource,play)
	GlobalVar.can_interact = false
