#!/usr/bin/python3
"""
Translate formal dialogue scripts into JSON objects to be used in game dialogue.

Accept one dialogue script from standard input. Write translated JSON to standard output.

Only known to work with Python 3.8.

example:
  dialogue script:
    TOWN SCENE: Street 2

    HESCHIER
    Beware the Jabberwock, my son! The jaws that bite, the claws that catch!

    ADEL
    ...?

    (End)

  translated JSON:
  {
    "dialogue_name": "TOWN SCENE: Street 2",
    "sequence": [
      {
        "speaker": "HESCHIER",
        "text": "Beware the Jabberwock, my son! The jaws that bite, the claws that catch!"
      },
      {
        "speaker": "ADEL",
        "text": "...?"
      }
    ]
  }
"""

import os
import json
from typing import Dict, Tuple, List
import argparse

# Constants describing what gets written into JSON
DIALOGUE_LABEL_KEY = 'dialogue_name'
SEQUENCE_KEY = 'sequence'
SPEAKER_KEY = 'speaker'
TEXT_KEY = 'text'
TYPE_KEY = 'type'
TYPE_CONTEXT_VALUE = 'context'
TYPE_CHOICE_VALUE = 'choice'
TYPE_CHOICE_RESPONSE_VALUE = 'choice_response'
OPTIONS_KEY = 'options'

# Debug printouts
DEBUG = False

def is_context(entry_lines: List[str]) -> bool:
  """Returns `True` if `entry_lines` is `[ "\[.*?\]" ]`; otherwise `False`"""
  return (len(entry_lines) == 1
      and entry_lines[0][0] == '['
      and entry_lines[0][-1] == ']')

def is_end(entry_lines: List[str]) -> bool:
  """Returns `True` if `entry_lines` is `[ "(End)" ]`; otherwise `False`"""
  return (len(entry_lines) == 1
      and entry_lines[0] == '(End)')


def translate_interaction(script: List[List[str]]) -> dict:

  # create empty dict to hold output
  output = {}
  # keep track of whether or not we're in a choice chain
  is_in_choice_chain = False

  # loop over all entries in the script
  for entry_lines in script:
    # first entry is the dialogue_name
    if DIALOGUE_LABEL_KEY not in output.keys():
      assert len(entry_lines) == 1 # to make sure this isn't wrong
      output[DIALOGUE_LABEL_KEY] = entry_lines[0]
      output[SEQUENCE_KEY] = []
      if DEBUG: print("Parsed dialogue name: " + entry_lines[0])
      continue
    
    # If the entry is just "(End)", then we want to ignore it
    if is_end(entry_lines):
      if DEBUG: print("Skipping '(End)' entry")
      continue

    # This is some contents of the dialogue

    # Is it a context entry?
    if is_context(entry_lines):
      if DEBUG: print("Parsing as context entry")
      assert len(entry_lines) == 1, \
          "context entry should have exactly 1 line, but did not: " \
           + str(entry_lines)
      # then save it as a context entry
      entry = {}
      entry[TYPE_KEY] = TYPE_CONTEXT_VALUE
      entry[TEXT_KEY] = entry_lines[0]
      output[SEQUENCE_KEY].append(entry)
      pass

    else: # Must be a speaker entry
      if DEBUG: print("Parsing as speaker entry")
      
      # Should be two or more lines in this entry -
      # speaker, and text, potentially including choices
      assert len(entry_lines) >= 2, \
          "speaker entry_lines should have at least 2 elements, but did not: " \
           + str(entry_lines)
      # ensure the name doesn't contain lowercase
      for char in entry_lines[0]:
        assert not char.islower(), \
            "speaker entry_lines[0] (name) should not contain lowercase, but did: " \
             + entry_lines[0]
      
      # Set up processing this entry
      entry = {}
      output[SEQUENCE_KEY].append(entry)

      # First element should be speaker name
      entry[SPEAKER_KEY] = entry_lines.pop(0) # pop off of the list

      # If only one more element, it's constant text
      if len(entry_lines) == 1:
        entry[TEXT_KEY] = entry_lines[0]
        is_in_choice_chain = False
        if DEBUG: print( ( "Parsed entry as single text response:\n" 
            "  speaker=" + entry[SPEAKER_KEY] + "\n"
            "  text=" + entry[TEXT_KEY] ) )
      else:
        # Mark this as type choice or response based on `is_in_choice_chain`
        entry[TYPE_KEY] = TYPE_CHOICE_RESPONSE_VALUE \
            if is_in_choice_chain else TYPE_CHOICE_VALUE
        # if not before, then now we're in a choice chain
        is_in_choice_chain = True
        # Set up the options list
        entry[OPTIONS_KEY] = []
        # For each remaining entry line, add a choice
        for line in entry_lines:
          choice_entry = {}
          choice_entry[TEXT_KEY] = line
          entry[OPTIONS_KEY].append(choice_entry)

    # end identify entry
  # end for entry_lines in script

  
  return output

def parse_interaction(input_lines: List[str]) -> List[List[str]]:
  """Parse raw input lines, grouping entries together. (An entry is a combo of speaker + text)"""

  # group lines, separated by a space:
  grouped_lines = []
  active_group = None
  for line in input_lines:
    # if line has contents
    if line:
      # if starting a new group
      if not active_group:
        active_group = []
        grouped_lines.append(active_group)
      active_group.append(line)
    else: # if linen does not have contents
      # end group
      active_group = None
  # end for line in input_lines => grouped_lines
    
  # processing done
  return grouped_lines

def handle_interaction(input_lines: List[str]) -> dict:
  parsed_lines = parse_interaction(input_lines)
  translated = translate_interaction(parsed_lines)
  return translated

def parse_multiple(input_lines: List[str]) -> Tuple[str, List[List[str]]]:
  """Parses multiple interactions into a list of interactions"""

  # Setup output_interactions to hold our data
  output_interactions: List[List[str]] = []
  # whether or not we've finished skipping the header
  header_seen = False
  active_interaction: List[str] = None
  header_text = None

  # Loop across input lines
  for line in input_lines:
    # if we're still looking at the header
    if not header_seen:
      # if the current line doesn't have stuff, then that's the end of the header
      if not line:
        header_seen = True
      elif header_text == None:
        
        header_text = line.strip()
      # skip this line
      continue

    # if there's no active interaction and there is some text, start an interaction
    if active_interaction is None and line:
      active_interaction = []
      output_interactions.append(active_interaction)
    
    # if there is an active interaction, append any text seen
    if active_interaction is not None:
      active_interaction.append(line)
      # if this line is "(End)", then end the interaction
      if line == "(End)":
        active_interaction = None
  # end for line in input_lines

  return (header_text, output_interactions)


def pre_parse(input_lines: List[str]) -> List[str]:
  """Pre-parses input by stripping whitespace and replacing special characters."""

  # strip each line
  input_lines = ( line.strip() for line in input_lines )
  # replace special characters
  for old_char, new_char in pre_parse.character_map.items():
    input_lines = [ line.replace(old_char, new_char) for line in input_lines ]
  return input_lines
# store character map for special Google Drive characters
pre_parse.character_map = {
  '\u2019': "'",
  '\u2014': ' - ',
  '\u2192': '-->',
  '\u2026': '...',
  '\u2018': "'",
}


def parse_args():
  """Parse commandline arguments, and return them as a namespace (sorta-dictionary)."""

  parser = argparse.ArgumentParser(description="Translate dialogue scripts into JSON")
  # Optional input file
  parser.add_argument('-i', '--input', dest="infile",
      type=argparse.FileType('r'), default='-',
      help=("Optional input file to read from. "
      "If omitted, reads from standard input."))
  # Optional output file
  parser.add_argument('-o', '--output', dest="outfile", 
      type=argparse.FileType('w'), default='-',
      help=("Optional output file to write to. "
      "If omitted, writes to standard output."))
  # Pretty JSON (default)
  parser.add_argument('-m', '--minimize',
      default=False, action='store_true',
      help="Write minimized JSON, i.e. disable 'pretty-print'")
  # Mode of parsing: single, object, or multiple
  parser.add_argument('mode', choices=['single', 'object', 'multiple'],
      help=("Whether to parse a `single` dialogue interaction, "
      "a set of `object` interactions, "
      "or `multiple` interactions."))

  return parser.parse_args()

def main():
  """Main program control flow. Handle mode switching and high-level functionality"""
  # parse arguments
  args = parse_args()
  print(args)

  # read in full contents of stdin
  input_lines = pre_parse(args.infile.readlines())

  # switch based on parsing mode
  if args.mode == 'single':

    # handle the single interaction
    translated_script = handle_interaction(input_lines)
    
    # setup the output string to write
    output_str = json.dumps(translated_script,
        indent=(None if args.minimize else 2)) 
    output_str += '\n'

    # write out the translated script
    args.outfile.write(output_str)
  
  elif args.mode == 'object':
    pass # TODO: Implement

  elif args.mode == 'multiple':
    # parse into multiple interactions
    (header_text, parsed_interactions) = parse_multiple(input_lines)
    # make sure the directory exists
    dir = f"output/{header_text.lower().replace(' ','_')}"
    if not os.path.exists(dir):
      os.makedirs(dir)
    
    # handle each interaction
    for interaction in parsed_interactions:
      translated_script = handle_interaction(interaction)
      
      # determine filename to save to based on dialogue_name
      filename = f"{dir}/" + translated_script[DIALOGUE_LABEL_KEY] \
          .lower().replace(' ', '_').replace(':', '') + ".json"

      # compile the string to write out
      output = json.dumps(translated_script,
          indent=(None if args.minimize else 2))
      output += '\n'
      
      # write to file
      with open(filename, 'w') as f:
        f.write(output)
        print("Wrote '" + translated_script[DIALOGUE_LABEL_KEY] + "' to '"
            + filename + "'")
  

if __name__ == '__main__':
  main()
