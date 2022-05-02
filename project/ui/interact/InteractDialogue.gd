class_name InteractDialogue
extends Control


#--------Signals--------
signal dialogue_begin
signal dialogue_complete


#--------Exports--------
export(String, FILE, "*.json") var json_path setget set_json_path



#--------Onready Nodes--------
onready var DialogueText = $DialogueText
onready var choices = [$ChoiceOne, $ChoiceTwo, $ChoiceThree]
onready var SpeakerText = $SpeakerNamePanel/SpeakerText

#--------Resources--------
# gui component handles any nxn image
var face_dict = {
	'ADEL': preload("res://ui/interact/faces/adel.png"),
	'LUCIA': preload("res://ui/interact/faces/lucia.png"),
	'QUINT': preload("res://ui/interact/faces/quint.png"),
	'DOC HANDE': preload("res://ui/interact/faces/doc_hande.png"),
	'FERRUM': preload("res://ui/interact/faces/blacksmith.png"),
	'JABBERWOCKY': preload("res://ui/interact/faces/jabberwocky.png"),
	'JIMSON': preload("res://ui/interact/faces/farmer.png"),
	'MARGARET': preload("res://ui/interact/faces/nun.png"),
	'SPIRIT': preload("res://ui/interact/faces/spirit_orb.png"),
	'HESCHIER': preload("res://ui/interact/faces/vagrant.png"),
	'PANSY': preload("res://ui/interact/faces/butcher.png")
}


#--------Variables--------
var dialogue_desc = {}
var current_idx = -1
var option_idx = -1
var choice_active = false
var is_single_text = false

#--------Setget--------

func set_json_path(value: String) -> void:
	if value == null:
		return
	json_path = value
	
	# Read in from file
	var file = File.new()
	file.open(json_path, file.READ)
	var text = file.get_as_text()
	file.close()
	
	# Parse into JSON
	dialogue_desc = JSON.parse(text).result
	
	# Check if there's a 'sequence' there, or if it's just a single text
	is_single_text = not 'sequence' in dialogue_desc
	
	
	



#--------Event Handlers--------

## Move the dialogue forward one step. If at last step, emit "dialogue_complete"
func advance_dialogue():
	
	# if at end, emit signal instead
	if !_has_next_dialogue():
#		print("no next dialogue")
		emit_signal("dialogue_complete")
#		restart() # todo remove
		return
	
#	print("moving forward")
	# move forward and update label
	current_idx = _get_next_dialogue_idx()
	_update_label()

func restart():
	current_idx = -1
	option_idx = -1
	choice_active = false
	advance_dialogue()
	
	

	
#--------Event Handlers--------

## On ready, read in the dialogue JSON and start on the first panel.
func _ready():
#	print("Created new InteractDialogue!")
	# Move to the first dialogue panel
	advance_dialogue()

## Respond to "interact" events not during a choice by advancing dialogue
func _input(event):
	if visible and event.is_action_pressed("interact") and not choice_active:
		advance_dialogue()

## When a choice is selected, switch back to the single-text ui,
## and save which option was selected.
func _on_Choice_selected(selected_choice_idx):
	for elem in choices:
		elem.visible = false # TODO: could make this behavior into setget
	DialogueText.visible = true
	choice_active = false
	option_idx = selected_choice_idx
	advance_dialogue()

#--------Private Helpers--------

## Update the dialogue label(s) to match the dialogue at current_idx
func _update_label():
	var content = _get_dialogue_idx(current_idx)
	var type = _get_dialogue_type(content)
	var speaker = ""
	if 'speaker' in content:
		speaker = content.speaker
	
	# Update speaker to match
	SpeakerText.text = speaker.capitalize()
	if speaker in face_dict:
		$Face.texture = face_dict[speaker]
	else:
		$Face.texture = null
	
	# Handle the type of dialogue
	match type:
		# Simplest case - just use the text there
		"default":
			DialogueText.text = content.text
		# Responding to a choice - use the text depending on the option_idx
		"choice_response":
			DialogueText.text = content.options[option_idx].text
		# Present a choice - display choices, set their text and visibility
		"choice":
			choice_active = true
			DialogueText.visible = false
			
			for i in range(content.options.size()):
				var ChoiceLabel = choices[i]
				ChoiceLabel.visible = true
				ChoiceLabel.text = content.options[i].text
			


## Get the Dictionary object for the given index
func _get_dialogue_idx(idx: int):
	# if it's a single text, handle differently
	if is_single_text:
		# if idx != 0, complain
		if idx != 0:
			return null
		# return the one text
		return dialogue_desc
	
	# otherwise, if it's past the sequence bounds, complain
	if idx < 0 or idx >= dialogue_desc.sequence.size():
		return null
	return dialogue_desc.sequence[idx]

## Get the type of the given dialogue step
func _get_dialogue_type(obj: Dictionary):
	if "type" in obj:
		return obj.type
	else:
		return "default"


## Check whether there is a next dialogue element, ignoring context
func _has_next_dialogue():
	# if it's a single text, handle differently
	if is_single_text:
		# can only have a next dialogue if next_idx == 0
		return current_idx == -1
	
	# multiple sequence of text
	var next_idx = current_idx + 1
	# check for trailing context - while inbounds and next is context, skip
	while next_idx < dialogue_desc.sequence.size() and \
			_get_dialogue_type(_get_dialogue_idx(next_idx)) == 'context':
		next_idx += 1
	# if out of bounds, then there's no more dialogue
	return next_idx < dialogue_desc.sequence.size()

## Get the index of the next dialogue element, ignoring context.
func _get_next_dialogue_idx():
	
	# check to make sure there is a next dialogue
	if !_has_next_dialogue():
		return null
		
	# if it's a single text, handle differently
	if is_single_text:
		return 0
	
	var next_idx = current_idx + 1
	# check for trailing context - while inbounds and next is context, skip
	while next_idx < dialogue_desc.sequence.size() and \
			_get_dialogue_type(_get_dialogue_idx(next_idx)) == 'context':
		next_idx += 1
	# return dialogue
	return next_idx

