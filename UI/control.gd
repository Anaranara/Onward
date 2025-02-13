extends Control

@onready var gem: Label = $Gem

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	gem.text = "Gem: " + str(GlobalVar.gem)
	for child in get_children():
		child.visible = GlobalVar.can_interact
