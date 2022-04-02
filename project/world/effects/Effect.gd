extends AnimatedSprite


func _ready():
	self.connect("animation_finished", self, "_on_animation_finished")
	play("Animate") # must match in AnimationPlayer

func _on_animation_finished():
	queue_free()
