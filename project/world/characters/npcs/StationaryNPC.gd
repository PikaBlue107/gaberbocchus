tool
extends StaticBody2D

export(Texture) var sprite_texture = null setget set_sprite_texture, get_sprite_texture

		
# Link our exported Texture to the one for the Sprite
func set_sprite_texture(value: Texture):
	sprite_texture = value
	if is_inside_tree():
		$Sprite.texture = sprite_texture
func get_sprite_texture() -> Texture:
	if is_inside_tree():
		sprite_texture = $Sprite.texture
	return sprite_texture
func _ready():
	$Sprite.texture = sprite_texture
