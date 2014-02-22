#This script will pase EPIC's memory contents by memory tag
#Output can be formatted by cycle or by memory store (coming soon)
#FOR PROPER FUNCTION:
#Enable [pps memory contents] & [pps run messages] in EPIC's display settings

import argparse, re

#Regular expressions for identifying memory items by store
cycle_pattern = re.compile('Cycle\s')
visual_pattern = re.compile('\s\s\(Visual\s')
goal_pattern = re.compile('\s\s\(Goal\s')
step_pattern = re.compile('\s\s\(Step\s')
motor_pattern = re.compile('\s\s\(Motor\s')

#Parses properties of a visual stimulus
def parse_visualProperties(self, item):
	foundOnset = False
	foundEccentricity = False
	foundEccentricityZone = False
	foundColor = False
	foundSize = False
	foundShape = False

	onset_pattern = re.compile(item + '\sDetection\sOnset')
	eccentricity_pattern = re.compile(item + '\sEccentricity\s')
	eccentricityZone_pattern = re.compile(item + '\sEccentricity_zone\s')
	color_pattern = re.compile(item + '\sColor\s')
	size_pattern = re.compile(item + '\sEncoded_size\s')
	shape_pattern = re.compile(item + '\sShape\s')

	cycle = 0
	item_properties = {}
	item_properties['name'] = item

	for l in self:
		if foundOnset and foundEccentricity and foundEccentricityZone and foundColor and foundSize and foundShape:
			break
		else:
			match_cycle = re.search(cycle_pattern, l)
			if match_cycle:
				cycle = match_cycle.string.split(' ')[1].strip(':')
			elif re.search(onset_pattern, l) and not foundOnset:
				item_properties['onset'] = cycle
			elif re.search(eccentricity_pattern, l) and not foundEccentricity:
				item_properties['eccentricity'] = l.split(' ')[5].strip(")\n")
				item_properties['eccentricity_onset'] = cycle
			elif re.search(eccentricityZone_pattern, l) and not foundEccentricityZone:
				item_properties['eccentricityZone'] = l.split(' ')[5].strip(")\n")
				item_properties['eccentricityZone_onset'] = cycle
			elif re.search(color_pattern, l) and not foundColor:
				item_properties['color'] = l.split(' ')[5].strip(")\n")
				item_properties['color_onset'] = cycle
			elif re.search(size_pattern, l) and not foundSize:
				item_properties['size'] = l.split(' ')[5].strip(")\n")
				item_properties['size_onset'] = cycle
			elif re.search(shape_pattern, l) and not foundShape:
				item_properties['shape'] = l.split(' ')[5].strip(")\n")
				item_properties['shape_onset'] = cycle
	
	return item_properties

#gets a compleate list of all stimulus that occur during trial
def parse_visualItems(self):
	visual_items = []
	visualItem_names = []
	lines = []

	for l in self:
		if re.match(visual_pattern, l):
			candidate_item = l.split(' ')[3]
			if candidate_item not in visualItem_names:
				visualItem_names.append(candidate_item)
	
	#Get all item properties
	for i in visualItem_names:
		visual_items.append(parse_visualProperties(self, i))

	#Make output text
	for i in visual_items:
		if 'name' in i:
			lines.append(i['name'] + ":")
		if 'onset' in i:
			ms = str(int(i['onset'])*50+50)
			lines.append("\tOnset: " + i['onset'] + " (" + ms + "ms)")
		if 'eccentricity' in i and 'eccentricity_onset' in i:
			ms = str(int(i['eccentricity_onset'])*50+50)
			lines.append("\tEccentricity: " + i['eccentricity'] + " [" + i['eccentricity_onset'] + " (" + ms + "ms)]")
		if 'eccentricityZone' in i and 'eccentricityZone_onset' in i:
			ms = str(int(i['eccentricityZone_onset'])*50+50)
			lines.append("\tEccentricity_zone: " + i['eccentricityZone'] + " [" + i['eccentricityZone_onset'] + " (" + ms + "ms)]")
		if 'color' in i and 'color_onset' in i:
			ms = str(int(i['color_onset'])*50+50)
			lines.append("\tColor: " + i['color'] + " [" + i['color_onset'] + " (" + ms + "ms)]")
		if 'size' in i and 'size_onset' in i:
			ms = str(int(i['size_onset'])*50+50)
			lines.append("\tSize: " + i['size'] + " [" + i['size_onset'] + " (" + ms + "ms)]")
		if 'shape' in i and 'shape_onset' in i:
			ms = str(int(i['shape_onset'])*50+50)
			lines.append("\tShape: " + i['shape'] + " [" + i['shape_onset'] + " (" + ms + "ms)]")
	
	return lines

#returns item & property hierarchtical list
def parseBy_item(self, patterns):
	item_list = []
	if visual_pattern in patterns:
		item_list = item_list + parse_visualItems(self)
	return item_list

#returns memory state timeline
def parseBy_cycle(self, patterns):
	previous_list = []
	current_list = []
	change_list = []
	previous_cycle = 0
	current_cycle = 0
	cycle_ms = 0

	for l in self:
		match_cycle = re.search(cycle_pattern, l)

		for p in patterns:
			if re.match(p, l):
				current_list.append(l)

		if match_cycle:
			for c in current_list:
				if c not in previous_list:
					change_list.append("\tADD:" + c.strip("\n"))
			for p in previous_list:
				if p not in current_list:
					change_list.append("\tREM:" + p.strip("\n"))

			previous_cycle = current_cycle
			previous_list = current_list
			current_cycle = match_cycle.string.split(' ')[1].strip(':')
			cycle_ms = match_cycle.string.split(':')[0]
			current_list = []
			change_list.append("Cycle: " + current_cycle + " (" + cycle_ms + "ms)")

	return change_list

#parse in args
parser = argparse.ArgumentParser()
group = parser.add_mutually_exclusive_group()

parser.add_argument("infile", help="the input file")
parser.add_argument("memory_tags", nargs="+", help="Specifies list of memory stores to parse")
parser.add_argument("-e", "--echo", action="store_true", help="Print output to console")
parser.add_argument("-o", "--outfile", action="store", help="Specifies an output file")

group.add_argument("-c", "--cycle", action="store_true", help="Sort by cycle")
group.add_argument("-i", "--item", action="store_true", help="Sort by item")
args = parser.parse_args()

#Define infile and optional outfile
infile = open(args.infile)
if args.outfile:
	outfile = open(args.outfile, 'w')
intext = infile.readlines()

#clean and validate memory storage tags, assign regular exp
parse_patterns = []
for t in args.memory_tags:
	if t.upper() == "GOAL":
		parse_patterns.append(goal_pattern)
	elif t.upper() == "STEP":
		parse_patterns.append(step_pattern)
	elif t.upper() == "VISUAL":
		parse_patterns.append(visual_pattern)
	elif t.upper() == "MOTOR":
		parse_patterns.append(motor_pattern)
	else:
		print "Unknown memory store definition: " + t

#Parse and sort by appropriate mode
if args.cycle:
	outtext = parseBy_cycle(intext, parse_patterns)
else:
	outtext = parseBy_item(intext, parse_patterns)

#Echo output or write output to file
if args.echo or not args.outfile:
    for l in outtext:
    	print l
elif args.outfile:
	newline_outtext = []
	for i in outtext:
		newline_outtext.append(i + "\n")

	outfile.writelines(newline_outtext)

#close the I/O session because I am so hardcore & like to live on the edge
infile.close()
if args.outfile:
	outfile.close()
