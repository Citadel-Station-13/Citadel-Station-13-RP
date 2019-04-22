/hook/startup/proc/modules_vr()
	GLOB.robot_module_types += "Medihound"
	GLOB.robot_module_types += "K9"
	GLOB.robot_module_types += "Janihound"
	GLOB.robot_module_types += "Sci-borg"
	GLOB.robot_module_types += "Pupdozer"
	return 1

var/global/list/acceptable_fruit_types= list(
											"ambrosia",
											"apple",
											"banana",
											"berries",
											"cabbage",
											"carrot",
											"cherry",
											"chili",
											"cocoa",
											"eggplant",
											"grapes",
											"grass",
											"greengrapes",
											"lemon",
											"lime",
											"onion",
											"orange",
											"peanut",
											"potato",
											"pumpkin",
											"rice",
											"soybean",
											"sugarcane",
											"tomato",
											"watermelon",
											"wheat",
											"whitebeet")