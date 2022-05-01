extends Node

export(bool) var interactable = true

func _ready():
	$InteractClickbox.visible = interactable
