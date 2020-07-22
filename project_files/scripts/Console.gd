# Console.gd
class_name Console
extends Node



onready var fps_label = get_node("/root/Main/GUI/FPSLabel")



var entered_commands = Array()
var open = false
var commands_list = { "quit" : funcref(self, "quit"),
					  "help" : funcref(self, "help"),
					  "show_fps" : funcref(self, "show_fps") }
var nargs_list = { "quit": 0,
				  "help": 0,
				  "show_fps": 1 }



func _ready():
	open = true
	toggle_console()
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



func enter_command(command: String) -> void:
	entered_commands.push_back(command)
	
	print_entered_command(command)
	$InputField.clear()
	
	var split = command.split(" ")
	var f = split[0]
	var nargs = split.size() - 1
	
	if commands_list.has(f):
		if nargs_list[f] == nargs:
			if nargs == 0:
				commands_list[f].call_func()
			elif nargs == 1:
				commands_list[f].call_func(split[1])
		else:
			if nargs_list[f] == 1:
				print_error(str("Command ", f, " takes 1 argument.\n"))
			else:
				print_error(str("Command ", f, " takes ", nargs_list[f], " arguments.\n"))
	else:
		print_error(str("Unknown command \"", command, "\"\n"))



func print_entered_command(command):
	$OutputField.add_text(command + "\n")
	
func print_error(message):
	$OutputField.push_color(Color(255, 255, 255, 255))
	$OutputField.add_text(message + "\n")
	$OutputField.pop()



func quit():
	get_tree().quit()



func help():
	$OutputField.add_text("List of valid commands: \n")
	for command in commands_list.keys():
		$OutputField.add_text(str(command, '\n'))



func show_fps(value):
	if value == "0" or value == "1":
		fps_label.visible = int(value)
	else:
		print_error("Command show_fps takes a value of 0 or 1.")
