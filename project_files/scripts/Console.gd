extends Node

var commands_list = { "quit" : funcref(self, "quit"),
					  "help" : funcref(self, "help") }

var entered_commands = Array()
var open = false

func _ready():
	open = true
	toggle_console()
	$OutputField.clear()

func _input(event):
	if event.is_action_pressed("OpenConsole"):
		event.unicode = SPKEY # so nothing is input to $InputField
		toggle_console()
		print(open)
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
		
func quit():
	get_tree().quit()
	
func help():
	$OutputField.add_text("List of valid commands: \n")
	for command in commands_list.keys():
		$OutputField.add_text(str(command, '\n'))

func enter_command(command: String) -> void:
	entered_commands.push_back(command)
	
	$InputField.clear()
	
	if (commands_list.has(command)):
		commands_list[command].call_func()
	else:
		$OutputField.add_text(str("Unknown command \"", command, "\"\n"))
