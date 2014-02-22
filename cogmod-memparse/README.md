parse_mem.py
==================
  
Python script for sorting and visualizing EPIC's working memory buffers.  
  
  The Executive Process Interactive Control (EPIC) cognitive architecture is a model of human information processing that accounts for the detailed timing of human perceptual, cognitive, and motor activity. EPIC provides a framework for constructing models of human-system interaction that are accurate and detailed enough to be useful for practical design purposes. EPIC represents a state-of-the-art synthesis of results on human perceptual/motor performance, cognitive modeling techniques, and task analysis methodology, implemented in the form of computer simulation software. Human performance in a task is simulated by programming the cognitive processor with production rules organized as methods for accomplishing task goals. The EPIC model then is run in interaction with a simulation of the external system and performs the same task as the human operator would. The model generates events (e.g. eye movements, key strokes, vocal utterances) whose timing is accurately predictive of human performance. 
  
  
##Usage:
python parse_mem.py [-h] [-e] [-o OUTFILE] [-c] [-i] INFILE [memory_tags...]  
  
###Example Use/How-to:
Copy-paste EPIC's output into a .txt file (Will be called epic_output.txt in this example)  
Open a terminal window and navigate to the directory containing parse_mem.py and your EPIC output file  
enter: ***python parse_mem.py -c epic_output.txt visual***  
  
Also you can try using other tags (as many as you want, just list them separated by spaces)  
Valid tags: goal, step, visual, motor
  
##Other parameters:
###Output file [-o]:
Specify a location to store the output  
example: ***python parse_mem.py epic_output.txt -o output_file.txt visual*** 
###Item mode (default) [-i]:  
This will output a hierarchtical list of all the stimuli EPIC processed during the trial.  Under each stimulus is a list of it's properties and the onset cycle and timestamp of each property  
example: ***python parse_mem.py -i epic_output.txt visual***
###Cycle mode [-c]:  
In this mode, the script allows the user to specify what memory stores to parse. The output consists of only CHANGES to memory registers on each cycle.  This means that memory that stays the same from one cycle to another is excluded from the list (this simplifies the output & is useful for looking for onset and dissapearance times of items in only the memory store(s) of interest)  
example: ***python parse_mem.py -c epic_output.txt visual motor step***
###Help [-h]:  
Displays help file
###Echo (default) [-e]:
Echo output to current console
