tool
extends StaticBody2D


# Character number controls which character is displayed
export(int) var character_num = 1 setget set_character_num, get_character_num

func set_character_num(value: int):
	# bounds overriding
	if value < 1:
		value = 1
	if value > 3:
		value = 3
	# set the actual value
	character_num = value

	# if not yet in scene, wait until we are
	if not is_inside_tree():
		yield(self, 'ready');
	# update the child sprite to use the right character
	$Sprite.frame = character_num - 1
#	if is_inside_tree():
#		$Sprite.frame = character_num - 1
#func _ready():
#	sprite.frame = character_num - 1


func get_character_num():
	# if we're loaded, refresh character_num based on the sprite's frame
	if is_inside_tree():
		character_num = $Sprite.frame + 1
	# report whatever we've got, loaded or not
	return character_num
