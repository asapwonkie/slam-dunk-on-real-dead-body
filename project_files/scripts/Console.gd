# Console.gd
class_name Console
extends Node



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



const WORLD = preload("res://scenes/GameWorld.tscn")



onready var fps_label = get_node("/root/Main/GUI/FPSLabel")



var open = false
var commands_list = { }
var entered_commands = Array()



func _ready():
	open = true
	toggle_console()
	
	commands_list["help"] = Command.new()
	commands_list["help"].create("help", funcref(self, "help"), 0)
	
	commands_list["quit"] = Command.new()
	commands_list["quit"].create("quit", funcref(self, "quit"), 0)
	
	commands_list["restart"] = Command.new()
	commands_list["restart"].create("restart", funcref(self, "restart"), 0)
	
	commands_list["show_fps"] = Command.new()
	commands_list["show_fps"].create("show_fps", funcref(self, "show_fps"), 1, ["value"])
	
	$OutputField.clear()



func _input(event):
	if event.is_action_pressed("OpenConsole"):
		event.unicode = SPKEY # so nothing is input to $InputField
		toggle_console()
	elif open and event.is_action_pressed("Enter"):
		enter_command($InputField.text)



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
		$InputField.clear()



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



func quit():
	get_tree().quit()



func restart():
	get_node("/root/Main/GameWorld").free()
	get_node("/root/Main").add_child(WORLD.instance())



func show_fps(value):
	if value == "0" or value == "1":
		fps_label.visible = int(value)
	else:
		print_error("Command show_fps takes a value of 0 or 1.")
