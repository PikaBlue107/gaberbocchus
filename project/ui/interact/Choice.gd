extends Node

signal choice_selected

func _ready():
	self.connect("gui_input", self, "_on_gui_input")
#	self.connect("mouse_entered", self, "_on_Label_mouse_entered")

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_leftclick"):
		emit_signal("choice_selected")

#func _on_Label_mouse_entered():
#	print("mouse entered!")
