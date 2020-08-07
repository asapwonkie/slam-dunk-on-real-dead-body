# Console.gd
class_name Console
extends Node



onready var main = get_node("/root/Main")
onready var color_rect = $ColorRect
onready var output_field = color_rect.get_node("OutputField")
onready var input_field = color_rect.get_node("InputField")



class Command:
	var func_name = ""
	var func_ref = null
	var num_args = 0
	var get_arg_funcs = null
	
	func create(_func_name, _func_ref, _num_args = 0, _get_arg_funcs = null):
		func_name = _func_name
		func_ref = _func_ref
		num_args = _num_args
		get_arg_funcs = _get_arg_funcs
	
	func run(args):
		if args.size() == num_args:
			if num_args == 0:
				func_ref.call_func()
			elif num_args == 1:
				func_ref.call_func(args[0])
		else:
			return 1
	
	func get_str():
		var string = func_name
		for i in num_args:
			string += " " + str(int(get_arg_funcs[i].call_func()))
		return string



var open = false
var commands_list = { }
var entered_commands = Array()
var command_index = 0



func _ready():
	commands_list["help"] = Command.new()
	commands_list["help"].create("help", funcref(self, "help"), 0)
	
	commands_list["quit"] = Command.new()
	commands_list["quit"].create("quit", funcref(main, "quit"), 0)
	
	commands_list["restart"] = Command.new()
	commands_list["restart"].create("restart", funcref(main, "restart"), 0)
	
	output_field.clear()



func add_command(func_name, func_ref, num_args = 0, get_arg_funcs = null):
	commands_list[func_name] = Command.new()
	commands_list[func_name].create(func_name, func_ref, num_args, get_arg_funcs)


func _input(event):
	if event.is_action_pressed("OpenConsole"):
		get_tree().set_input_as_handled()
		toggle_console()
	elif open and event.is_action_pressed("Enter"):
		enter_command(input_field.text)
		command_index = entered_commands.size()
	elif event.is_action_pressed("PreviousCommand"):
		get_tree().set_input_as_handled()
		if command_index > 0:
			command_index -= 1
			input_field.text = entered_commands[command_index]
			input_field.caret_position = input_field.text.length()
	elif event.is_action_pressed("NextCommand"):
		get_tree().set_input_as_handled()
		if command_index < entered_commands.size():
			command_index += 1
			if command_index == entered_commands.size():
				input_field.text = ""
			else:
				input_field.text = entered_commands[command_index]
				input_field.caret_position = input_field.text.length()
	elif event.is_action_pressed("Tab") and input_field.text != "":
		var keys = commands_list.keys()
		var matches = [ ]
		var longest_match = ""
		
		for i in range(keys.size()):
			if keys[i].begins_with(input_field.text):
				matches.append(keys[i])
				if keys[i].length() > longest_match.length():
					longest_match = keys[i]
		
		if matches.size() > 0:
			var text
			if matches.size() == 1:
				text = commands_list[matches[0]].get_str()
			elif matches.size() > 1:
				var index = input_field.text.length() - 1
				var current_char = null
				var least_common_index = 0
				
				for i in range(index, longest_match.length()):
					current_char = longest_match.ord_at(i)
					for j in range(matches.size()):
						if matches[j].length() >= index + 1 and matches[j].ord_at(index+1) == current_char:
							least_common_index = index
						else:
							break
							
				text = longest_match.substr(0, least_common_index)
				
			input_field.text = text
			input_field.caret_position = input_field.text.length()


func toggle_console():
	if open:
		get_tree().paused = false
		open = false
		color_rect.visible = false
		input_field.pause_mode = Node.PAUSE_MODE_STOP
	else:
		get_tree().paused = true
		open = true
		color_rect.visible = true
		input_field.pause_mode = Node.PAUSE_MODE_PROCESS
		input_field.grab_focus()



func enter_command(text: String) -> void:
	entered_commands.push_back(text)
	
	print_entered_command(text)
	input_field.clear()
	
	var split = text.split(" ")
	var func_name = split[0]
	split.remove(0)
	var args = split
	
	var command = commands_list.get(func_name)
	if command != null:
		output_field.push_color(Color(0, 255, 0, 255))
		var args_error = command.run(args)
		output_field.pop()
		if args_error:
			if command.num_args == 1:
				print_error(str("Command ", func_name, " takes 1 argument."))
			else:
				print_error(str("Command ", func_name, " takes ", command.num_args, " arguments."))
	else:
		print_error(str("Unknown command \"", func_name, "\""))



func print_entered_command(command):
	output_field.add_text(command + "\n")



func print_error(message):
	output_field.push_color(Color(255, 0, 0, 255))
	output_field.add_text(message + "\n")
	output_field.pop()



func help():
	output_field.add_text("List of valid commands: \n")
	for command in commands_list.keys():
		output_field.add_text(str(command, '\n'))
