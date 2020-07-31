# Console.gd
class_name Console
extends Node



onready var main = get_node("/root/Main")



class Command:
	var func_name = ""
	var func_ref = null
	var num_args = 0
	var arg_names = null
	
	func create(_func_name, _func_ref, _num_args = 0, _arg_names = null):
		func_name = _func_name
		func_ref = _func_ref
		num_args = _num_args
		arg_names = _arg_names
	
	func run(args):
		if args.size() == num_args:
			if num_args == 0:
				func_ref.call_func()
			elif num_args == 1:
				func_ref.call_func(args[0])
		else:
			return 1



var open = false
var commands_list = { }
var entered_commands = Array()
var command_index = 0



func _ready():
	open = true
	toggle_console()
	
	commands_list["help"] = Command.new()
	commands_list["help"].create("help", funcref(self, "help"), 0)
	
	commands_list["quit"] = Command.new()
	commands_list["quit"].create("quit", funcref(main, "quit"), 0)
	
	commands_list["restart"] = Command.new()
	commands_list["restart"].create("restart", funcref(main, "restart"), 0)
	
	commands_list["showfps"] = Command.new()
	commands_list["showfps"].create("showfps", funcref(main, "showfps"), 1, ["value"])
	
	commands_list["timescale"] = Command.new()
	commands_list["timescale"].create("timescale", funcref(main, "timescale"), 1, ["value"])
	
	commands_list["draw_zombie_paths"] = Command.new()
	commands_list["draw_zombie_paths"].create("draw_zombie_paths", funcref(main, "draw_zombie_paths"), 1, ["value"])
	
	$OutputField.clear()



func _input(event):
	if event.is_action_pressed("OpenConsole"):
		event.unicode = SPKEY # so nothing is input to $InputField
		toggle_console()
	elif open and event.is_action_pressed("Enter"):
		enter_command($InputField.text)
		command_index = entered_commands.size()
	elif event.is_action_pressed("PreviousCommand"):
		if command_index >= 1:
			command_index -= 1
			$InputField.text = entered_commands[command_index]
	elif event.is_action_pressed("NextCommand"):
		if command_index < entered_commands.size():
			command_index += 1
			if command_index == entered_commands.size():
				$InputField.text = ""
			else:
				$InputField.text = entered_commands[command_index-1]
	elif event.is_action_pressed("Tab"):
		var keys = commands_list.keys()
		var matches = [ ]
		var longest_match = ""
		
		for i in range(keys.size()):
			if keys[i].begins_with($InputField.text):
				matches.append(keys[i])
				if keys[i].length() > longest_match.length():
					longest_match = keys[i]
		
		if matches.size() == 1:
			$InputField.text = matches[0]
		else:
			var index = $InputField.text.length() - 1
			var current_char = null
			var least_common_index = 0
			
			for i in range(index, longest_match.length()):
				current_char = longest_match.ord_at(i)
				for j in range(matches.size()):
					if matches[j].length() >= index + 1 and matches[j].ord_at(index+1) == current_char:
						least_common_index = index
					else:
						break
				
			$InputField.text = longest_match.substr(0, least_common_index)
		
	if event.is_action_pressed("Debug"):
		print(command_index)
# get least common index


func toggle_console():
	if open:
		get_tree().paused = false
		open = false
		$OutputField.visible = false
		$InputField.visible = false
		$InputField.pause_mode = Node.PAUSE_MODE_STOP
	else:
		get_tree().paused = true
		open = true
		$OutputField.visible = true
		$InputField.visible = true
		$InputField.pause_mode = Node.PAUSE_MODE_PROCESS
		$InputField.grab_focus()



func enter_command(text: String) -> void:
	entered_commands.push_back(text)
	
	print_entered_command(text)
	$InputField.clear()
	
	var split = text.split(" ")
	var func_name = split[0]
	split.remove(0)
	var args = split
	
	var command = commands_list.get(func_name)
	if command != null:
		var args_error = command.run(args)
		if args_error:
			if command.num_args == 1:
				print_error(str("Command ", func_name, " takes 1 argument.\n"))
			else:
				print_error(str("Command ", func_name, " takes ", command.num_args, " arguments.\n"))
	else:
		print_error(str("Unknown command \"", func_name, "\"\n"))



func print_entered_command(command):
	$OutputField.add_text(command + "\n")



func print_error(message):
	$OutputField.push_color(Color(255, 255, 255, 255))
	$OutputField.add_text(message + "\n")
	$OutputField.pop()



func help():
	$OutputField.add_text("List of valid commands: \n")
	for command in commands_list.keys():
		$OutputField.add_text(str(command, '\n'))
