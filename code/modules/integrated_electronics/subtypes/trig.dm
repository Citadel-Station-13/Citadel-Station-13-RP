//These circuits do not-so-simple math.
/obj/item/integrated_circuit/trig
	complexity = 1
	inputs = list(
		"A" = IC_PINTYPE_NUMBER,
		"B" = IC_PINTYPE_NUMBER,
		"C" = IC_PINTYPE_NUMBER,
		"D" = IC_PINTYPE_NUMBER,
		"E" = IC_PINTYPE_NUMBER,
		"F" = IC_PINTYPE_NUMBER,
		"G" = IC_PINTYPE_NUMBER,
		"H" = IC_PINTYPE_NUMBER
		)
	outputs = list("result" = IC_PINTYPE_NUMBER)
	activators = list("compute" = IC_PINTYPE_PULSE_IN, "on computed" = IC_PINTYPE_PULSE_OUT)
	category_text = "Trig"
	extended_desc = "Input and output are in degrees."
	power_draw_per_use = 1 // Still cheap math.

// Sine //

/obj/item/integrated_circuit/trig/sine
	name = "sin circuit"
	desc = "Only evil if you're allergic to math.  Takes a degree and outputs the sine of said degree."
	icon_state = "sine"
	inputs = list("A" = IC_PINTYPE_NUMBER)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/trig/sine/do_work()
	var/result = null
	var/A = get_pin_data(IC_INPUT, 1)
	if(!isnull(A))
		result = sin(A)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

// Cosine //

/obj/item/integrated_circuit/trig/cosine
	name = "cos circuit"
	desc = "Takes a degree and outputs the cosine of said degree."
	icon_state = "cosine"
	inputs = list("A" = IC_PINTYPE_NUMBER)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/trig/cosine/do_work()
	var/result = null
	var/A = get_pin_data(IC_INPUT, 1)
	if(!isnull(A))
		result = cos(A)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

// Tangent //

/obj/item/integrated_circuit/trig/tangent
	name = "tan circuit"
	desc = "Takes a degree and outputs the tangent of said degree."
	icon_state = "tangent"
	inputs = list("A" = IC_PINTYPE_NUMBER)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/trig/tangent/do_work()
	var/result = null
	var/A = get_pin_data(IC_INPUT, 1)
	if(!isnull(A))
		result = tan(A)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

// ArcSine //

/obj/item/integrated_circuit/trig/arcsine
	name = "arcsin circuit"
	desc = "Reverse function of sine."
	icon_state = "sine"
	inputs = list("A" = IC_PINTYPE_NUMBER)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/trig/arcsine/do_work()
	var/result = null
	var/A = get_pin_data(IC_INPUT, 1)
	if(!isnull(A))
		result = arcsin(A)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

// ArcCos //

/obj/item/integrated_circuit/trig/arccos
	name = "arccos circuit"
	desc = "Reverse function of cosine."
	icon_state = "cosine"
	inputs = list("A" = IC_PINTYPE_NUMBER)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/trig/arccos/do_work()
	var/result = null
	var/A = get_pin_data(IC_INPUT, 1)
	if(!isnull(A))
		result = arccos(A)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

// ArcTan //

/obj/item/integrated_circuit/trig/arctan
	name = "arctan circuit"
	desc = "Reverse function of tangent."
	icon_state = "tangent"
	inputs = list("A" = IC_PINTYPE_NUMBER)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/trig/arctan/do_work()
	var/result = null
	var/A = get_pin_data(IC_INPUT, 1)
	if(!isnull(A))
		result = arctan(A)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

// ArcTan2 //

/obj/item/integrated_circuit/trig/arctantwo
	name = "arctantwo circuit"
	desc = "Returns the degree between two points in an x and y system. The delta is gained by subtracting the target by the origin. Leave origin at 0 for relative x and y."
	icon_state = "tangent"
	inputs = list(
		"X1 Origin" = IC_PINTYPE_NUMBER,
		"Y1 Origin" = IC_PINTYPE_NUMBER,
		"X2 Target" = IC_PINTYPE_NUMBER,
		"Y2 Target" = IC_PINTYPE_NUMBER
		)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/trig/arctantwo/do_work()
	var/result = null
	var/X1 = get_pin_data(IC_INPUT, 1)
	var/Y1 = get_pin_data(IC_INPUT, 2)
	var/X2 = get_pin_data(IC_INPUT, 3)
	var/Y2 = get_pin_data(IC_INPUT, 4)
	if(!isnull(X1) && !isnull(X2) && !isnull(Y1) && !isnull(Y2))
		result = arctantwo(X1,Y1,X2,Y2)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

// Cosecant //

/obj/item/integrated_circuit/trig/cosecant
	name = "cosecant (CSC) circuit"
	desc = "Takes a degree and outputs the cosecant of said degree."
	icon_state = "cosecant"
	inputs = list("A" = IC_PINTYPE_NUMBER)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/trig/cosecant/do_work()
	var/result = null
	var/A = get_pin_data(IC_INPUT, 1)
	if(!isnull(A))
		result = CSC(A)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

// Secant //

/obj/item/integrated_circuit/trig/secant
	name = "secant (SEC) circuit"
	desc = "Takes a degree and outputs the secant of said degree."
	icon_state = "secant"
	inputs = list("A" = IC_PINTYPE_NUMBER)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/trig/secant/do_work()
	var/result = null
	var/A = get_pin_data(IC_INPUT, 1)
	if(!isnull(A))
		result = SEC(A)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

// Cotangent //

/obj/item/integrated_circuit/trig/cotangent
	name = "cotangent (COT) circuit"
	desc = "Takes a degree and outputs the cotangent of said degree."
	icon_state = "cotangent"
	inputs = list("A" = IC_PINTYPE_NUMBER)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/trig/cotangent/do_work()
	var/result = null
	var/A = get_pin_data(IC_INPUT, 1)
	if(!isnull(A))
		result = COT(A)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)
