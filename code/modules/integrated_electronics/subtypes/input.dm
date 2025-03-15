/obj/item/integrated_circuit/input
	category_text = "Input"
	power_draw_per_use = 5

/obj/item/integrated_circuit/input/proc/ask_for_input(mob/user)
	return

/obj/item/integrated_circuit/input/button
	name = "button"
	desc = "This tiny button must do something, right?"
	icon_state = "button"
	complexity = 1
	can_be_asked_input = 1
	inputs = list()
	outputs = list()
	activators = list("on pressed" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH



/obj/item/integrated_circuit/input/button/ask_for_input(mob/user) //Bit misleading name for this specific use.
	to_chat(user, SPAN_NOTICE("You press the button labeled '[src.displayed_name]'."))
	activate_pin(1)

/obj/item/integrated_circuit/input/toggle_button
	name = "toggle button"
	desc = "It toggles on, off, on, off..."
	icon_state = "toggle_button"
	complexity = 1
	can_be_asked_input = 1
	inputs = list()
	outputs = list("on" = IC_PINTYPE_BOOLEAN)
	activators = list("on toggle" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/input/toggle_button/ask_for_input(mob/user) // Ditto.
	set_pin_data(IC_OUTPUT, 1, !get_pin_data(IC_OUTPUT, 1))
	push_data()
	activate_pin(1)
	to_chat(user, "<span class='notice'>You toggle the button labeled '[src.displayed_name]' [get_pin_data(IC_OUTPUT, 1) ? "on" : "off"].</span>")

/obj/item/integrated_circuit/input/numberpad
	name = "number pad"
	desc = "This small number pad allows someone to input a number into the system."
	icon_state = "numberpad"
	complexity = 2
	can_be_asked_input = 1
	inputs = list()
	outputs = list("number entered" = IC_PINTYPE_NUMBER)
	activators = list("on entered" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 4

/obj/item/integrated_circuit/input/numberpad/ask_for_input(mob/user)
	var/new_input = input(user, "Enter a number, please.","Number pad", null) as null|num
	if(isnum(new_input))
		set_pin_data(IC_OUTPUT, 1, new_input)
		push_data()
		activate_pin(1)

/obj/item/integrated_circuit/input/textpad
	name = "text pad"
	desc = "This small text pad allows someone to input a string into the system."
	icon_state = "textpad"
	complexity = 2
	can_be_asked_input = 1
	inputs = list()
	outputs = list("string entered" = IC_PINTYPE_STRING)
	activators = list("on entered" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 4

/obj/item/integrated_circuit/input/textpad/ask_for_input(mob/user)
	var/new_input = input(user, "Enter some words, please.","Number pad", null) as null|text
	if(istext(new_input))
		set_pin_data(IC_OUTPUT, 1, new_input)
		push_data()
		activate_pin(1)

/obj/item/integrated_circuit/input/colorpad
	name = "color pad"
	desc = "This small color pad allows someone to input a hexadecimal color into the system."
	icon_state = "colorpad"
	complexity = 2
	can_be_asked_input = 1
	inputs = list()
	outputs = list("color entered" = IC_PINTYPE_COLOR)
	activators = list("on entered" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 4

/obj/item/integrated_circuit/input/colorpad/ask_for_input(mob/user)
	var/new_color = input(user, "Enter a color, please.", "Color pad", get_pin_data(IC_OUTPUT, 1)) as color|null
	if(new_color)
		set_pin_data(IC_OUTPUT, 1, new_color)
		push_data()
		activate_pin(1)

/obj/item/integrated_circuit/input/card_reader
	name = "ID card reader" //To differentiate it from the data card reader
	desc = "A circuit that can read the registred name, assignment, and PassKey string from an ID card."
	icon_state = "card_reader"

	complexity = 4
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	outputs = list(
		"registered name" = IC_PINTYPE_STRING,
		"assignment" = IC_PINTYPE_STRING,
		"passkey" = IC_PINTYPE_STRING,
		"rank" = IC_PINTYPE_STRING
	)
	activators = list(
		"on read" = IC_PINTYPE_PULSE_OUT
	)

/obj/item/integrated_circuit/input/card_reader/attackby_react(obj/item/I, mob/living/user, intent)
	var/obj/item/card/id/card
	if(istype(I,/obj/item/card/id))
		card = I
	else
		card = I.GetIdCard()
	var/list/access = I.GetAccess()
	var/json_access = json_encode(access)
	var/passkey = add_data_signature(json_access)

	if(card) // An ID card.
		set_pin_data(IC_OUTPUT, 1, card.registered_name)
		set_pin_data(IC_OUTPUT, 2, card.assignment)
		set_pin_data(IC_OUTPUT, 4, card.rank)

	else if(length(access))	// A non-card object that has access levels.
		set_pin_data(IC_OUTPUT, 1, null)
		set_pin_data(IC_OUTPUT, 2, null)
		set_pin_data(IC_OUTPUT, 4, null)
	else
		return FALSE

	set_pin_data(IC_OUTPUT, 3, passkey)
	user.visible_message(SPAN_NOTICE("\The [user] swipes \the [I] onto \the [get_object()]'s card reader."))
	push_data()
	activate_pin(1)
	return TRUE

/obj/item/integrated_circuit/output/access_displayer
	name = "access circuit"
	desc = "broadcasts access for your assembly via a passkey."
	extended_desc = "Useful for moving drones through airlocks."

	complexity = 4
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	inputs = list("passkey" = IC_PINTYPE_STRING)
	activators = list(
		"set passkey" = IC_PINTYPE_PULSE_IN
	)
	var/list/access

/obj/item/integrated_circuit/output/access_displayer/do_work()
	var/list/signature_and_data = splittext(get_pin_data(IC_INPUT, 1), ":")
	if(length(signature_and_data) < 2)
		return

	var/signature = signature_and_data[1]
	var/result = signature_and_data[2]

	// check if the signature is valid
	if(!check_data_signature(signature, result))
		return FALSE

	if(length(result) > 1)
		result = json_decode(result)
	else
		result = list(result)
	access = result

/obj/item/integrated_circuit/output/access_displayer/GetAccess()
	return access

/obj/item/integrated_circuit/input/med_scanner
	name = "integrated medical analyser"
	desc = "A very small version of the common medical analyser.  This allows the machine to know how healthy someone is."
	icon_state = "medscan"
	complexity = 4
	inputs = list("target" = IC_PINTYPE_REF)
	outputs = list(
		"total health %"		= IC_PINTYPE_NUMBER,
		"total missing health"	= IC_PINTYPE_NUMBER,
		"pulse"					= IC_PINTYPE_NUMBER
		)
	activators = list("scan" = IC_PINTYPE_PULSE_IN, "on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2, TECH_BIO = 2)
	power_draw_per_use = 40

/obj/item/integrated_circuit/input/med_scanner/do_work(ord)
	if(ord == 1)
		var/mob/living/carbon/human/H = get_pin_data_as_type(IC_INPUT, 1, /mob/living/carbon/human)
		if(!istype(H)) //Invalid input
			return
		if(H.Adjacent(get_turf(src))) // Like normal analysers, it can't be used at range.
			var/total_health = round(H.health/H.getMaxHealth(), 0.01)*100
			var/missing_health = H.getMaxHealth() - H.health

			set_pin_data(IC_OUTPUT, 1, total_health)
			set_pin_data(IC_OUTPUT, 2, missing_health)
			set_pin_data(IC_OUTPUT, 3, H.pulse)

		push_data()
		activate_pin(2)



/obj/item/integrated_circuit/input/adv_med_scanner

	name = "integrated advanced medical analyzer"
	desc = "A very small version of the medibot's medical analyzer.  This allows the machine to know how healthy someone is.  \
	This type is much more precise, allowing the machine to know much more about the target than a normal analyzer.	\
	A better health scanner can be installed to expand functionality. T1 for brain damage, bleeding and infection.	\
	T2 For fractions and internal bleeding. T3 for non medical reagents."
	icon_state = "medscan_adv"
	complexity = 12
	inputs = list("target" = IC_PINTYPE_REF)
	outputs = list(
		"brain activity"		= IC_PINTYPE_BOOLEAN,	//1
		"is conscious"			= IC_PINTYPE_BOOLEAN,	//2
		"total health %"		= IC_PINTYPE_NUMBER,	//3
		"total missing health"	= IC_PINTYPE_NUMBER,	//4
		"brute damage"			= IC_PINTYPE_NUMBER,	//5
		"burn damage"			= IC_PINTYPE_NUMBER,	//6
		"tox damage"			= IC_PINTYPE_NUMBER,	//7
		"oxy damage"			= IC_PINTYPE_NUMBER,	//8
		"clone damage"			= IC_PINTYPE_NUMBER,	//9
		"blood loss"			= IC_PINTYPE_NUMBER,	//10
		"pain level"			= IC_PINTYPE_NUMBER,	//11
		"radiation"				= IC_PINTYPE_NUMBER,	//12
		"nutrition"				= IC_PINTYPE_NUMBER,	//13
		"list of reagents"		= IC_PINTYPE_LIST,		//14
		"quantity of reagents"	= IC_PINTYPE_LIST,		//15
		"health scan tier"		= IC_PINTYPE_NUMBER,	//16
		"brain damage"			= IC_PINTYPE_NUMBER,	//17
		"bleeding limbs"		= IC_PINTYPE_LIST,		//18
		"infected limbs"		= IC_PINTYPE_LIST,		//19
		"internal bleeding"		= IC_PINTYPE_LIST,		//20
		"fractured limbs"		= IC_PINTYPE_LIST		//21
	)
	activators = list("scan" = IC_PINTYPE_PULSE_IN, "on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3, TECH_BIO = 4)
	power_draw_per_use = 80
	can_be_asked_input = TRUE
	var/obj/item/healthanalyzer/current_healthanalyzer
	var/advscan = 0
	//T1: brain damage, bleeding, infection. T2: show location of IB and fracture. T3: show non medical reagents

/obj/item/integrated_circuit/input/adv_med_scanner/ask_for_input(mob/living/user, obj/item/I,  a_intent)
	if(!current_healthanalyzer)
		if(!isobj(I))
			return FALSE
		attackby_react(I, user, a_intent)
	else
		attack_self(user)

/obj/item/integrated_circuit/input/adv_med_scanner/attackby_react(var/obj/item/healthanalyzer/I, var/mob/living/user)
	//Check if it truly is a health scanner
	if(!(istype(I,/obj/item/healthanalyzer)))
		to_chat(user,"<span class='warning'>The [I.name] doesn't seem to fit in here.</span>")
		return

	//Check if there is no other health scanner already inside
	if(current_healthanalyzer)
		to_chat(user,"<span class='notice'>There is already a health scanner inside.</span>")
		return

	if(!user.attempt_insert_item_for_installation(I, src))
		return

	//The health scanner is the one we just attached, its location is inside the circuit
	current_healthanalyzer = I

	to_chat(user,"<span class='warning'>You slot in the [I.name] inside the assembly.</span>")

	//Set the pin to a weak reference of the current beaker
	set_pin_data(IC_OUTPUT, 16, I.advscan)
	advscan = I.advscan
	push_data()

/obj/item/integrated_circuit/input/adv_med_scanner/attack_self(mob/user)
	. = ..()
	if(.)
		return
	//Check if no health scanner is attached
	if(!current_healthanalyzer)
		to_chat(user, "<span class='notice'>There is currently no health scanner attached.</span>")
		return

	//Remove beaker and put in user's hands/location
	to_chat(user, "<span class='notice'>You yank the [current_healthanalyzer] out of the slot.</span>")
	user.put_in_hands(current_healthanalyzer)
	current_healthanalyzer = null
	//Reset to 0
	set_pin_data(IC_OUTPUT, 16, 0)
	advscan = 0
	push_data()

/obj/item/integrated_circuit/input/adv_med_scanner/do_work(ord)
	if(ord == 1)
		var/mob/living/carbon/human/H = get_pin_data_as_type(IC_INPUT, 1, /mob/living/carbon/human)
		if(!istype(H)) //Invalid input
			return

		if(H in view(get_turf(H))) // Like medibot's analyzer it can be used in range..

			var/total_health = round(H.health/H.getMaxHealth(), 0.01)*100
			var/missing_health = H.getMaxHealth() - H.health

			set_pin_data(IC_OUTPUT, 1, (H.has_brain() && H.stat != DEAD))
			set_pin_data(IC_OUTPUT, 2, (H.stat == 0))
			set_pin_data(IC_OUTPUT, 3, total_health)
			set_pin_data(IC_OUTPUT, 4, missing_health)
			set_pin_data(IC_OUTPUT, 5, H.getBruteLoss())
			set_pin_data(IC_OUTPUT, 6, H.getFireLoss())
			set_pin_data(IC_OUTPUT, 7, H.getToxLoss())
			set_pin_data(IC_OUTPUT, 8, H.getOxyLoss())
			set_pin_data(IC_OUTPUT, 9, H.getCloneLoss())
			set_pin_data(IC_OUTPUT, 10, round((H.blood_holder.get_total_volume() / H.species.blood_volume)*100))
			set_pin_data(IC_OUTPUT, 11, H.traumatic_shock)
			set_pin_data(IC_OUTPUT, 12, H.radiation)
			set_pin_data(IC_OUTPUT, 13, H.nutrition)
			var/cont[0]
			var/amt[0]
			for(var/datum/reagent/RE in H.reagents.get_reagent_datums())
				if(RE.scannable || advscan >= 3)
					cont += RE.id
					amt	+= round(H.reagents.get_reagent_amount(RE.id), 1)
			set_pin_data(IC_OUTPUT, 14, cont)
			set_pin_data(IC_OUTPUT, 15, amt)
			var/frac[0]
			var/ib[0]
			var/bleed[0]
			var/infec[0]
			if(advscan >= 1)
				set_pin_data(IC_OUTPUT, 17, H.getBrainLoss())
				for(var/obj/item/organ/external/e in H.organs)
					if(!e)
						continue
					// Bleeding
					if(e.status & ORGAN_BLEEDING)
						bleed += e.name
					// Infections
					if(e.has_infected_wound())
						infec += e.name
					if(advscan >= 2)
						// Broken limbs
						if(e.status & ORGAN_BROKEN)
							frac += e.name
						// IB
						for(var/datum/wound/W as anything in e.wounds)
							if(W.internal)
								ib += e.name
			set_pin_data(IC_OUTPUT, 18, bleed)
			set_pin_data(IC_OUTPUT, 19, infec)
			set_pin_data(IC_OUTPUT, 20, ib)
			set_pin_data(IC_OUTPUT, 21, frac)

		push_data()
		activate_pin(2)

/obj/item/integrated_circuit/input/view_filter
	name = "view filter"
	desc = "This circuit will filter every object in assembly view."
	extended_desc = "The first pin is ref to filter, to see avaliable filters go to Filter category. The output will contents everything with filtering type"
	inputs = list(
		"filter" = IC_PINTYPE_REF,
		"radius" = IC_PINTYPE_NUMBER
	)
	outputs = list(
		"objects" = IC_PINTYPE_LIST
	)
	activators = list("scan" = IC_PINTYPE_PULSE_IN, "on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 30
	var/radius = 1

/obj/item/integrated_circuit/input/view_filter/on_data_written()
	var/rad = get_pin_data(IC_INPUT, 2)
	if(isnum(rad))
		rad = clamp(rad, 0, 8)
		radius = rad

/obj/item/integrated_circuit/input/view_filter/do_work(ord)
	var/list/objects = list()
	var/obj/item/integrated_circuit/filter/ref/filter = get_pin_data(IC_INPUT, 1)
	if(istype(filter) && assembly && (filter in assembly.assembly_components))
		for(var/atom/A in view(radius,get_turf(assembly)))
			if(istype(A, filter.filter_type))
				objects.Add(WEAKREF(A))
		set_pin_data(IC_OUTPUT, 1, objects)
		push_data()
		activate_pin(2)

/obj/item/integrated_circuit/input/slime_scanner
	name = "slime scanner"
	desc = "A very small version of the xenobio analyser.  This allows the machine to know every needed properties of slime.  Output mutation list is non-associative."
	icon_state = "medscan_adv"
	complexity = 12
	inputs = list("target" = IC_PINTYPE_REF)
	outputs = list(
		"colour"				= IC_PINTYPE_STRING,
		"adult"					= IC_PINTYPE_BOOLEAN,
		"nutrition"				= IC_PINTYPE_NUMBER,
		"charge"				= IC_PINTYPE_NUMBER,
		"health"				= IC_PINTYPE_NUMBER,
		"possible mutation"		= IC_PINTYPE_LIST,
		"genetic destability"	= IC_PINTYPE_NUMBER,
		"slime core amount"		= IC_PINTYPE_NUMBER,
		"Growth progress"		= IC_PINTYPE_NUMBER,
		"rabid"					= IC_PINTYPE_BOOLEAN,
		"disciplined"			= IC_PINTYPE_BOOLEAN,
		"obedience"				= IC_PINTYPE_NUMBER
	)
	activators = list("scan" = IC_PINTYPE_PULSE_IN, "on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 80

/obj/item/integrated_circuit/input/slime_scanner/do_work(ord)
	if(ord == 1)
		var/mob/living/simple_mob/slime/xenobio/T = get_pin_data_as_type(IC_INPUT, 1, /mob/living/simple_mob/slime)
		if(!isslime(T)) //Invalid input
			return
		if(T in view(get_turf(src))) // Like medbot's analyzer it can be used in range..

			set_pin_data(IC_OUTPUT, 1, T.slime_color)
			set_pin_data(IC_OUTPUT, 2, T.is_adult)
			set_pin_data(IC_OUTPUT, 3, T.nutrition/T.get_max_nutrition())
			set_pin_data(IC_OUTPUT, 4, T.power_charge)
			set_pin_data(IC_OUTPUT, 5, round(T.health/T.maxHealth,0.01)*100)
			set_pin_data(IC_OUTPUT, 6, uniqueList(T.slime_mutation))
			set_pin_data(IC_OUTPUT, 7, T.mutation_chance)
			set_pin_data(IC_OUTPUT, 8, T.cores)
			set_pin_data(IC_OUTPUT, 9, T.amount_grown/1000)
			var/datum/ai_holder/polaris/simple_mob/xenobio_slime/AI = T.ai_holder
			set_pin_data(IC_OUTPUT, 10, AI.rabid)
			set_pin_data(IC_OUTPUT, 11, AI.discipline)
			set_pin_data(IC_OUTPUT, 12, AI.obedience)


		push_data()
		activate_pin(2)

/obj/item/integrated_circuit/input/examiner
	name = "examiner"
	desc = "It's a little machine vision system.  It can return the name, description, distance,\
	relative coordinates, total amount of reagents, and maximum amount of reagents of the referenced object."
	icon_state = "video_camera"
	complexity = 6
	inputs = list("target" = IC_PINTYPE_REF)
	outputs = list(
		"name"				 	= IC_PINTYPE_STRING,
		"description"			= IC_PINTYPE_STRING,
		"X"						= IC_PINTYPE_NUMBER,
		"Y"						= IC_PINTYPE_NUMBER,
		"distance"				= IC_PINTYPE_NUMBER,
		"max reagents"			= IC_PINTYPE_NUMBER,
		"amount of reagents"	= IC_PINTYPE_NUMBER,
		"density"				= IC_PINTYPE_BOOLEAN,
		"opacity"				= IC_PINTYPE_BOOLEAN,
		"occupied turf"			= IC_PINTYPE_REF
	)
	activators = list("scan" = IC_PINTYPE_PULSE_IN, "on scanned" = IC_PINTYPE_PULSE_OUT, "not scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3, TECH_BIO = 4)
	power_draw_per_use = 80

/obj/item/integrated_circuit/input/examiner/do_work(ord)
	if(ord == 1)
		var/atom/H = get_pin_data_as_type(IC_INPUT, 1, /atom)
		var/turf/T = get_turf(src)

		if(!istype(H) || !(H in view(T)))
			activate_pin(3)
		else
			set_pin_data(IC_OUTPUT, 1, H.name)
			set_pin_data(IC_OUTPUT, 2, H.desc)
			set_pin_data(IC_OUTPUT, 3, H.x-T.x)
			set_pin_data(IC_OUTPUT, 4, H.y-T.y)
			set_pin_data(IC_OUTPUT, 5, sqrt((H.x-T.x)*(H.x-T.x)+ (H.y-T.y)*(H.y-T.y)))
			var/mr = 0
			var/tr = 0
			if(H.reagents)
				mr = H.reagents.maximum_volume
				tr = H.reagents.total_volume
			set_pin_data(IC_OUTPUT, 6, mr)
			set_pin_data(IC_OUTPUT, 7, tr)
			set_pin_data(IC_OUTPUT, 8, H.density)
			set_pin_data(IC_OUTPUT, 9, H.opacity)
			set_pin_data(IC_OUTPUT, 10, get_turf(H))
			push_data()
			activate_pin(2)



/obj/item/integrated_circuit/input/turfpoint
	name = "tile pointer"
	desc = "This circuit will get tile ref with given absolute coorinates."
	extended_desc = "If the machine	cannot see the target, it will not be able to scan it.\
	This circuit will only work in an assembly."
	icon_state = "numberpad"
	complexity = 5
	inputs = list("X" = IC_PINTYPE_NUMBER,"Y" = IC_PINTYPE_NUMBER)
	outputs = list("tile" = IC_PINTYPE_REF)
	activators = list("scan" = IC_PINTYPE_PULSE_IN, "on scanned" = IC_PINTYPE_PULSE_OUT,"not scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 40

/obj/item/integrated_circuit/input/turfpoint/do_work(ord)
	if(ord == 1)
		if(!assembly)
			activate_pin(3)
			return
		var/turf/T = get_turf(assembly)
		var/target_x = clamp(get_pin_data(IC_INPUT, 1), 0, world.maxx)
		var/target_y = clamp(get_pin_data(IC_INPUT, 2), 0, world.maxy)
		var/turf/A = locate(target_x, target_y, T.z)
		set_pin_data(IC_OUTPUT, 1, null)
		if(!A || !(A in view(T)))
			activate_pin(3)
			return
		else
			set_pin_data(IC_OUTPUT, 1, WEAKREF(A))
		push_data()
		activate_pin(2)

/obj/item/integrated_circuit/input/turfscan
	name = "tile analyzer"
	desc = "This machine vision system can analyze contents of desired tile and read letters on the floor."
	icon_state = "video_camera"
	complexity = 5
	inputs = list(
		"target" = IC_PINTYPE_REF
		)
	outputs = list(
		"located contents"	= IC_PINTYPE_LIST,
		"Written letters" 	= IC_PINTYPE_STRING,
		"area"				= IC_PINTYPE_STRING
		)
	activators = list(
		"scan" = IC_PINTYPE_PULSE_IN,
		"on scanned" = IC_PINTYPE_PULSE_OUT,
		"not scanned" = IC_PINTYPE_PULSE_OUT
		)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 40
	cooldown_per_use = 10

/obj/item/integrated_circuit/input/turfscan/do_work(ord)
	if(ord == 1)
		var/turf/scanned_turf = get_pin_data_as_type(IC_INPUT, 1, /turf)
		var/turf/circuit_turf = get_turf(src)
		var/area_name = get_area_name(scanned_turf)
		if(!istype(scanned_turf)) //Invalid input
			activate_pin(3)
			return

		if(scanned_turf in view(circuit_turf)) // This is a camera.  It can't examine things that it can't see.
			var/list/turf_contents = new()
			for(var/obj/U in scanned_turf)
				turf_contents += WEAKREF(U)
			for(var/mob/U in scanned_turf)
				turf_contents += WEAKREF(U)
			set_pin_data(IC_OUTPUT, 1, turf_contents)
			set_pin_data(IC_OUTPUT, 3, area_name)
			var/list/St = new()
			for(var/obj/effect/debris/cleanable/crayon/I in scanned_turf)
				St.Add(I.icon_state)
			if(St.len)
				set_pin_data(IC_OUTPUT, 2, jointext(St, ",", 1, 0))
			push_data()
			activate_pin(2)

/obj/item/integrated_circuit/input/local_locator
	name = "local locator"
	desc = "This is needed for certain devices that demand a reference for a target to act upon.  This type only locates something \
	that is holding the machine containing it."
	inputs = list("creatures only" = IC_PINTYPE_BOOLEAN)
	outputs = list(
		"located ref"	= IC_PINTYPE_REF,
		"is ground"		= IC_PINTYPE_BOOLEAN,
		"is creature"	= IC_PINTYPE_BOOLEAN)
	activators = list(
		"locate" = IC_PINTYPE_PULSE_IN,
		"on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 20

/obj/item/integrated_circuit/input/local_locator/do_work(ord)
	if(ord == 1)
		set_pin_data(IC_OUTPUT, 1, null)
		if(!get_pin_data(IC_INPUT, 1)) // Check toggle.  We can just grab ref if false.
			set_pin_data(IC_OUTPUT, 1, assembly.loc)
		else if(istype(assembly.loc, /mob/living)) // Now check if someone's holding us.
			set_pin_data(IC_OUTPUT, 1, assembly.loc)
		set_pin_data(IC_OUTPUT, 2, isturf(assembly.loc))
		set_pin_data(IC_OUTPUT, 3, ismob(assembly.loc))
		push_data()
		activate_pin(2)


/obj/item/integrated_circuit/input/adjacent_locator
	name = "adjacent locator"
	desc = "This is needed for certain devices that demand a reference for a target to act upon.  This type only locates something \
	that is standing a meter away from the machine."
	extended_desc = "The first pin requires a ref to the kind of object that you want the locator to acquire.  This means that it will \
	give refs to nearby objects that are similar.  If more than one valid object is found nearby, it will choose one of them at \
	random."
	inputs = list("desired type ref" = IC_PINTYPE_REF)
	outputs = list("located ref" = IC_PINTYPE_REF)
	activators = list("locate" = IC_PINTYPE_PULSE_IN,"found" = IC_PINTYPE_PULSE_OUT,
		"not found" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 30

/obj/item/integrated_circuit/input/adjacent_locator/do_work(ord)
	if(ord == 1)
		var/atom/I = get_pin_data(IC_INPUT, 1)
		set_pin_data(IC_OUTPUT, 1, null)

		if(!istype(I))
			return

		var/desired_type = I.type

		var/list/nearby_things = range(1, get_turf(src))
		var/list/valid_things = list()
		for(var/atom/thing in nearby_things)
			if(thing.type != desired_type)
				continue
			valid_things.Add(thing)
		if(valid_things.len)
			set_pin_data(IC_OUTPUT, 1, pick(valid_things))
			push_data()
			activate_pin(2)
		else
			push_data()
			activate_pin(3)

/obj/item/integrated_circuit/input/advanced_locator
	complexity = 6
	name = "advanced locator"
	desc = "This is needed for certain devices that demand a reference for a target to act upon.  This type locates something \
	that is standing in given radius of up to 8 meters"
	extended_desc = "The first pin requires a ref to a kind of object that you want the locator to acquire.  This means that it will \
	give refs to nearby objects that are similar to given sample.  If this pin is a string, the locator will search for\
	 item by matching desired text in name + description.  If more than one valid object is found nearby, it will choose one of them at \
	random.  The second pin is a radius."
	inputs = list("desired type" = IC_PINTYPE_ANY, "radius" = IC_PINTYPE_NUMBER)
	outputs = list("located ref" = IC_PINTYPE_REF)
	activators = list("locate" = IC_PINTYPE_PULSE_IN,"found" = IC_PINTYPE_PULSE_OUT,"not found" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 30
	var/radius = 1

/obj/item/integrated_circuit/input/advanced_locator/on_data_written()
	var/rad = get_pin_data(IC_INPUT, 2)
	if(isnum(rad))
		rad = clamp(rad, 0, 8)
		radius = rad

/obj/item/integrated_circuit/input/advanced_locator/do_work(ord)
	if(ord == 1)
		var/datum/I = get_pin_data(IC_INPUT, 1)
		set_pin_data(IC_OUTPUT, 1, null)
		var/turf/T = get_turf(src)
		var/list/nearby_things = view(radius,T)
		var/list/valid_things = list()
		if(istype(I))
			var/atom/A = I
			var/desired_type = A.type
			if(desired_type)
				for(var/i in nearby_things)
					var/atom/thing = i
					if(thing.type == desired_type)
						valid_things.Add(thing)
		else if(istext(I))
			var/DT = I
			for(var/i in nearby_things)
				var/atom/thing = i
				if(findtext(addtext(thing.name," ",thing.desc), DT, 1, 0) )
					valid_things.Add(thing)
		if(valid_things.len)
			set_pin_data(IC_OUTPUT, 1, pick(valid_things))
			push_data()
			activate_pin(2)
		else
			push_data()
			activate_pin(3)


/obj/item/integrated_circuit/input/advanced_locator_list
	complexity = 6
	name = "list advanced locator"
	desc = "This is needed for certain devices that demand list of names for a target to act upon.  This type locates something \
	that is standing in given radius of up to 8 meters.  Output is non-associative.  Input will only consider keys if associative."
	extended_desc = "The first pin requires a list of the kinds of objects that you want the locator to acquire.  It will locate nearby objects by name and description, \
	and will then provide a list of all found objects which are similar.  \
	The second pin is a radius."
	inputs = list("desired type ref" = IC_PINTYPE_LIST, "radius" = IC_PINTYPE_NUMBER)
	outputs = list("located ref" = IC_PINTYPE_LIST)
	activators = list("locate" = IC_PINTYPE_PULSE_IN,"found" = IC_PINTYPE_PULSE_OUT,"not found" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 30
	var/radius = 1
	cooldown_per_use = 10

/obj/item/integrated_circuit/input/advanced_locator_list/on_data_written()
	var/rad = get_pin_data(IC_INPUT, 2)

	if(isnum(rad))
		rad = clamp(rad, 0, 8)
		radius = rad

/obj/item/integrated_circuit/input/advanced_locator_list/do_work(ord)
	if(ord == 1)
		var/datum/I = get_pin_data(IC_INPUT, 1)
		set_pin_data(IC_OUTPUT, 1, null)
		var/list/input_list = list()
		input_list = I
		if(length(input_list))	//if there is no input don't do anything.
			var/turf/T = get_turf(src)
			var/list/nearby_things = view(radius,T)
			var/list/valid_things = list()
			for(var/item in input_list)
				if(!isnull(item) && !isnum(item))
					if(istext(item))
						for(var/i in nearby_things)
							var/atom/thing = i
							if(ismob(thing) && !isliving(thing))
								continue
							if(findtext(addtext(thing.name," ",thing.desc), item, 1, 0) )
								valid_things.Add(WEAKREF(thing))
					else
						var/atom/A = item
						var/desired_type = A.type
						for(var/i in nearby_things)
							var/atom/thing = i
							if(thing.type != desired_type)
								continue
							if(ismob(thing) && !isliving(thing))
								continue
							valid_things.Add(WEAKREF(thing))
			if(valid_things.len)
				set_pin_data(IC_OUTPUT, 1, valid_things)
				push_data()
				activate_pin(2)
			else
				push_data()
				activate_pin(3)
		else
			push_data()
			activate_pin(3)


/obj/item/integrated_circuit/input/signaler
	name = "integrated signaler"
	desc = "Signals from a signaler can be received with this, allowing for remote control.  Additionally, it can send signals as well."
	extended_desc = "When a signal is received from another signaler, the 'on signal received' activator pin will be pulsed.  \
	The two input pins are to configure the integrated signaler's settings.  Note that the frequency should not have a decimal in it.  \
	Meaning the default frequency is expressed as 1457, not 145.7.  To send a signal, pulse the 'send signal' activator pin."
	icon_state = "signal"
	complexity = 4
	inputs = list("frequency" = IC_PINTYPE_NUMBER,"code" = IC_PINTYPE_NUMBER)
	outputs = list()
	activators = list(
		"send signal" = IC_PINTYPE_PULSE_IN,
		"on signal sent" = IC_PINTYPE_PULSE_OUT,
		"on signal received" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	action_flags = IC_ACTION_LONG_RANGE
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2, TECH_MAGNET = 2)
	power_draw_idle = 5
	power_draw_per_use = 40
	cooldown_per_use = 5
	var/simple = 1
	var/frequency = 1457
	var/code = 30
	var/datum/radio_frequency/radio_connection

/obj/item/integrated_circuit/input/signaler/Initialize()
	. = ..()
	set_pin_data(IC_INPUT, 1, frequency)
	set_pin_data(IC_INPUT, 2, code)

/obj/item/integrated_circuit/input/signaler/Destroy()
	radio_controller.remove_object(src,frequency)
	QDEL_NULL(radio_connection)
	frequency = 0
	return ..()

/obj/item/integrated_circuit/input/signaler/on_data_written()
	var/new_freq = get_pin_data(IC_INPUT, 1)
	var/new_code = get_pin_data(IC_INPUT, 2)
	if(isnum(new_freq) && new_freq > 0)
		set_frequency(new_freq)
	code = new_code


/obj/item/integrated_circuit/input/signaler/do_work(ord) // Sends a signal.
	if(!radio_connection || ord != 1)
		return

	radio_connection.post_signal(src, create_signal())
	activate_pin(2)

/obj/item/integrated_circuit/input/signaler/proc/signal_good(datum/signal/signal)
	if(!signal)
		return FALSE
	if(!code)
		return FALSE
	if(!isnum(code))
		return FALSE
	if(!signal.encryption)
		return FALSE
	if(code != signal.encryption)
		return FALSE
	return TRUE

/obj/item/integrated_circuit/input/signaler/proc/create_signal()
	var/datum/signal/signal = new()
	signal.transmission_method = 1
	signal.source = src
	if(isnum(code))
		signal.encryption = code
	signal.data["message"] = "ACTIVATE"
	return signal

/obj/item/integrated_circuit/input/signaler/proc/set_frequency(new_frequency)
	if(!frequency)
		return
	if(!radio_controller)
		sleep(20)
	if(!radio_controller)
		return
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = radio_controller.add_object(src, frequency, RADIO_CHAT)

/obj/item/integrated_circuit/input/signaler/receive_signal(datum/signal/signal)
	if(!signal_good(signal))
		return 0
	treat_signal(signal)
	return 1

//This only procs when a signal is valid.
/obj/item/integrated_circuit/input/signaler/proc/treat_signal(datum/signal/signal)
	activate_pin(3)

	if(loc && simple)
		for(var/mob/O in hearers(1, get_turf(src)))
			to_chat(O, "[icon2html(thing = src, target = O)] *beep beep*")

/obj/item/integrated_circuit/input/signaler/advanced
	name = "advanced integrated signaler"
	icon_state = "signal_advanced"
	desc = "Signals from a signaler can be received with this, allowing for remote control.  Additionally, it can send signals as well."
	extended_desc = "When a signal is received from another signaler with the right code, the 'on signal received' activator pin will be pulsed and the command output is updated.  \
	The two input pins are to configure the integrated signaler's settings.  Note that the frequency should not have a decimal in it.  \
	Meaning the default frequency is expressed as 1457, not 145.7.  To send a signal, pulse the 'send signal' activator pin. Set the command output to set the message received."
	complexity = 8
	inputs = list("frequency" = IC_PINTYPE_NUMBER, "code" = IC_PINTYPE_NUMBER, "command" = IC_PINTYPE_STRING)
	outputs = list("received command" = IC_PINTYPE_STRING)
	var/command
	code = 30
	simple = 0

/obj/item/integrated_circuit/input/signaler/advanced/on_data_written()
	..()
	command = get_pin_data(IC_INPUT,3)

/obj/item/integrated_circuit/input/signaler/advanced/create_signal()
	var/datum/signal/signal = new()
	signal.transmission_method = 1
	signal.data["command"] = command
	signal.encryption = code
	return signal

/obj/item/integrated_circuit/input/signaler/advanced/treat_signal(datum/signal/signal)
	set_pin_data(IC_OUTPUT,1,signal.data["command"])
	push_data()
	..()

/obj/item/integrated_circuit/input/EPv2
	name = "exonet circuit"
	desc = "Enables the sending and receiving of messages on the Exonet with the EPv2 protocol."
	extended_desc = "An EPv2 address is a string with the format of XXXX:XXXX:XXXX:XXXX.  Data can be send or received using the \
	second pin on each side, with additonal data reserved for the third pin.  When a message is received, the second activaiton pin \
	will pulse whatever's connected to it.  Pulsing the first activation pin will send a message."
	icon_state = "signal"
	complexity = 4
	inputs = list(
		"target EPv2 address"	= IC_PINTYPE_STRING,
		"data to send"			= IC_PINTYPE_STRING,
		"secondary text"		= IC_PINTYPE_STRING
		)
	outputs = list(
		"address received"			= IC_PINTYPE_STRING,
		"data received"				= IC_PINTYPE_STRING,
		"secondary text received"	= IC_PINTYPE_STRING
		)
	activators = list("send data" = IC_PINTYPE_PULSE_IN, "on data received" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2, TECH_MAGNET = 2, TECH_BLUESPACE = 2)
	power_draw_per_use = 50
	var/datum/exonet_protocol/exonet = null

/obj/item/integrated_circuit/input/EPv2/Initialize(mapload)
	. = ..()
	exonet = new(src)
	exonet.make_address("EPv2_circuit-\ref[src]")
	desc += "<br>This circuit's EPv2 address is: [exonet.address]"

/obj/item/integrated_circuit/input/EPv2/Destroy()
	if(exonet)
		exonet.remove_address()
		qdel(exonet)
		exonet = null
	return ..()

/obj/item/integrated_circuit/input/EPv2/do_work(ord)
	if(ord == 1)
		var/target_address = get_pin_data(IC_INPUT, 1)
		var/message = get_pin_data(IC_INPUT, 2)
		var/text = get_pin_data(IC_INPUT, 3)

		if(target_address && istext(target_address))
			exonet.send_message(target_address, message, text)

/obj/item/integrated_circuit/input/receive_exonet_message(var/atom/origin_atom, var/origin_address, var/message, var/text)
	set_pin_data(IC_OUTPUT, 1, origin_address)
	set_pin_data(IC_OUTPUT, 2, message)
	set_pin_data(IC_OUTPUT, 3, text)

	push_data()
	activate_pin(2)

/* TBI NTNet
/obj/item/integrated_circuit/input/ntnet_packet
	name = "NTNet networking circuit"
	desc = "Enables the sending and receiving of messages over NTNet via packet data protocol."
	extended_desc = "Data can be sent or received using the second pin on each side, \
	with additonal data reserved for the third pin. When a message is received, the second activation pin \
	will pulse whatever is connected to it. Pulsing the first activation pin will send a message. Messages \
	can be sent to multiple recepients. Addresses must be separated with a semicolon, like this: Address1;Address2;Etc."
	icon_state = "signal"
	complexity = 2
	cooldown_per_use = 1
	inputs = list(
		"target NTNet addresses"= IC_PINTYPE_STRING,
		"data to send"			= IC_PINTYPE_STRING,
		"secondary text"		= IC_PINTYPE_STRING
		)
	outputs = list(
		"address received"			= IC_PINTYPE_STRING,
		"data received"				= IC_PINTYPE_STRING,
		"secondary text received"	= IC_PINTYPE_STRING,
		"passkey"					= IC_PINTYPE_STRING,
		"is_broadcast"				= IC_PINTYPE_BOOLEAN
		)
	activators = list("send data" = IC_PINTYPE_PULSE_IN, "on data received" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	action_flags = IC_ACTION_LONG_RANGE
	power_draw_per_use = 50
	var/address

/obj/item/integrated_circuit/input/ntnet_packet/Initialize(mapload)
	. = ..()
	var/datum/component/ntnet_interface/net = LoadComponent(/datum/component/ntnet_interface)
	address = net.hardware_id
	net.differentiate_broadcast = FALSE
	desc += "<br>This circuit's NTNet hardware address is: [address]"

/obj/item/integrated_circuit/input/ntnet_packet/do_work(ord)
	if(ord == 1)
		var/target_address = get_pin_data(IC_INPUT, 1)
		var/message = get_pin_data(IC_INPUT, 2)
		var/text = get_pin_data(IC_INPUT, 3)

		var/datum/netdata/data = new
		data.recipient_ids = splittext(target_address, ";")
		data.standard_format_data(message, text, assembly ? strtohex(XorEncrypt(json_encode(assembly.access_card.access), SScircuit.cipherkey)) : null)
		ntnet_send(data)

/obj/item/integrated_circuit/input/ntnet_receive(datum/netdata/data)
	set_pin_data(IC_OUTPUT, 1, data.sender_id)
	set_pin_data(IC_OUTPUT, 2, data.data["data"])
	set_pin_data(IC_OUTPUT, 3, data.data["data_secondary"])
	set_pin_data(IC_OUTPUT, 4, data.data["encrypted_passkey"])
	set_pin_data(IC_OUTPUT, 5, data.broadcast)

	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/input/ntnet_advanced
	name = "Low level NTNet transreceiver"
	desc = "Enables the sending and receiving of messages over NTNet via packet data protocol. Allows advanced control of message contents and signalling. Must use associative lists. Outputs associative list. Has a slower transmission rate than normal NTNet circuits, due to increased data processing complexity."
	extended_desc = "Data can be sent or received using the second pin on each side, \
	When a message is received, the second activation pin will pulse whatever is connected to it. \
	Pulsing the first activation pin will send a message. Messages can be sent to multiple recepients. \
	Addresses must be separated with a semicolon, like this: Address1;Address2;Etc."
	icon_state = "signal"
	complexity = 4
	cooldown_per_use = 10
	inputs = list(
		"target NTNet addresses"= IC_PINTYPE_STRING,
		"data"					= IC_PINTYPE_LIST,
		)
	outputs = list("received data" = IC_PINTYPE_LIST, "is_broadcast" = IC_PINTYPE_BOOLEAN)
	activators = list("send data" = IC_PINTYPE_PULSE_IN, "on data received" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	action_flags = IC_ACTION_LONG_RANGE
	power_draw_per_use = 50
	var/address

/obj/item/integrated_circuit/input/ntnet_advanced/Initialize(mapload)
	. = ..()
	var/datum/component/ntnet_interface/net = LoadComponent(/datum/component/ntnet_interface)
	address = net.hardware_id
	net.differentiate_broadcast = FALSE
	desc += "<br>This circuit's NTNet hardware address is: [address]"

/obj/item/integrated_circuit/input/ntnet_advanced/do_work(ord)
	if(ord == 1)
		var/target_address = get_pin_data(IC_INPUT, 1)
		var/list/message = get_pin_data(IC_INPUT, 2)
		if(!islist(message))
			message = list()
		var/datum/netdata/data = new
		data.recipient_ids = splittext(target_address, ";")
		data.data = message
		data.passkey = assembly.access_card.access
		ntnet_send(data)

/obj/item/integrated_circuit/input/ntnet_advanced/ntnet_receive(datum/netdata/data)
	set_pin_data(IC_OUTPUT, 1, data.data)
	set_pin_data(IC_OUTPUT, 2, data.broadcast)
	push_data()
	activate_pin(2)
*/
//This circuit gives information on where the machine is.
/obj/item/integrated_circuit/input/gps
	name = "global positioning system"
	desc = "This allows you to easily know the position of a machine containing this device."
	extended_desc = "The GPS's coordinates it gives is absolute, not relative."
	icon_state = "gps"
	complexity = 4
	inputs = list()
	outputs = list("X"= IC_PINTYPE_NUMBER, "Y" = IC_PINTYPE_NUMBER, "Z" = IC_PINTYPE_NUMBER, "full coords" = IC_PINTYPE_STRING)
	activators = list("get coordinates" = IC_PINTYPE_PULSE_IN, "on get coordinates" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 30

/obj/item/integrated_circuit/input/gps/do_work(ord)
	if(ord == 1)
		var/turf/T = get_turf(src)

		set_pin_data(IC_OUTPUT, 1, null)
		set_pin_data(IC_OUTPUT, 2, null)
		set_pin_data(IC_OUTPUT, 3, null)
		set_pin_data(IC_OUTPUT, 4, null)
		if(!T)
			return

		set_pin_data(IC_OUTPUT, 1, T.x)
		set_pin_data(IC_OUTPUT, 2, T.y)
		set_pin_data(IC_OUTPUT, 3, T.z)
		set_pin_data(IC_OUTPUT, 4, "[T.x],[T.y],[T.z]")
		push_data()
		activate_pin(2)

GLOBAL_DATUM_INIT(circuit_translation_context, /datum/translation_context/simple/integrated_circuit, new)

/datum/translation_context/simple/integrated_circuit
	translation_class = TRANSLATION_CLASS_LEVEL_1

/obj/item/integrated_circuit/input/microphone
	name = "microphone"
	desc = "Useful for spying on people, or for voice-activated machines."
	extended_desc = "This will automatically translate most languages it hears to Galactic Common.  \
	The first activation pin is always pulsed when the circuit hears someone talk, while the second one \
	is only triggered if it hears someone speaking a language other than Galactic Common."
	icon_state = "recorder"
	complexity = 8
	inputs = list()
	atom_flags = ATOM_HEAR
	outputs = list(
	"speaker" = IC_PINTYPE_STRING,
	"message" = IC_PINTYPE_STRING
	)
	activators = list("on message received" = IC_PINTYPE_PULSE_OUT, "on translation" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 5
	/// translation context
	var/datum/translation_context/translation_context

/obj/item/integrated_circuit/input/microphone/Initialize(mapload)
	translation_context = GLOB.circuit_translation_context
	. = ..()
	listening_objects |= src

/obj/item/integrated_circuit/input/microphone/Destroy()
	listening_objects -= src
	return ..()

/obj/item/integrated_circuit/input/microphone/hear_talk(mob/living/M, msg, var/verb="says", datum/prototype/language/speaking=null)
	var/translated = FALSE
	if(M && msg)
		if(speaking)
			if(!translation_context.can_translate(speaking, M))
				msg = speaking.scramble(msg)
			else
				msg = translation_context.attempt_translation(speaking, M, msg)
			if(!istype(speaking, /datum/prototype/language/common) && !istype(speaking, /datum/prototype/language/noise))
				translated = TRUE
		set_pin_data(IC_OUTPUT, 1, M.GetVoice())
		set_pin_data(IC_OUTPUT, 2, msg)

	push_data()
	activate_pin(1)
	if(translated)
		activate_pin(2)

/obj/item/integrated_circuit/input/microphone/sign
	name = "sign-language translator"
	desc = "Useful for spying on people or for sign activated machines."
	extended_desc = "This will automatically translate galactic standard sign language it sees to Galactic Common.  \
	The first activation pin is always pulsed when the circuit sees someone speak sign, while the second one \
	is only triggered if it sees someone speaking a language other than sign language, which it will attempt to \
	lip-read."
	icon_state = "video_camera"
	complexity = 12
	inputs = list()
	outputs = list(
	"speaker" = IC_PINTYPE_STRING,
	"message" = IC_PINTYPE_STRING
	)
	activators = list("on message received" = IC_PINTYPE_PULSE_OUT, "on translation" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 30

	var/list/my_langs = list()
	var/list/readable_langs = list(
		LANGUAGE_GALCOM,
		LANGUAGE_SOL_COMMON,
		LANGUAGE_TRADEBAND,
		LANGUAGE_GUTTER,
		LANGUAGE_TERMINUS
		)

/obj/item/integrated_circuit/input/microphone/sign/Initialize(mapload)
	. = ..()
	for(var/lang in readable_langs)
		var/datum/prototype/language/newlang = RSlanguages.legacy_resolve_language_name(lang)
		my_langs |= newlang

/obj/item/integrated_circuit/input/microphone/sign/hear_talk(mob/living/M, msg, var/verb="says", datum/prototype/language/speaking=null)
	var/signlang = FALSE
	if(M && msg)
		if(speaking)
			if(!((speaking.language_flags & LANGUAGE_NONVERBAL) || (speaking.language_flags & LANGUAGE_SIGNLANG)))
				signlang = FALSE
				msg = speaking.scramble(msg, my_langs)
			else
				signlang = TRUE
		set_pin_data(IC_OUTPUT, 1, M.GetVoice())
		set_pin_data(IC_OUTPUT, 2, msg)

	push_data()
	activate_pin(1)
	if(signlang)
		activate_pin(2)

/obj/item/integrated_circuit/input/microphone/sign/hear_signlang(mob/M as mob, text, verb, datum/prototype/language/speaking)
	hear_talk(M, text, verb, speaking)
	return


/obj/item/integrated_circuit/output/move_detector
	name = "movement detection"
	desc = "It's have a complicit gyroscope system, that activates pin if assembly moved"
	category_text = "Output"
	complexity = 4
	inputs = list("toggle" = IC_PINTYPE_BOOLEAN)
	outputs = list()
	activators = list("moved" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_idle = 0
	var/turf/last_location

/obj/item/integrated_circuit/output/light/advanced/on_data_written()
	get_pin_data(IC_INPUT, 1) ? (power_draw_idle = 10) : (power_draw_idle = 0)

/obj/item/integrated_circuit/output/move_detector/ext_moved()
	var/turf/T = get_turf(get_object())
	if(last_location != T && get_pin_data(IC_INPUT, 1))
		activate_pin(1)
	last_location = T

/obj/item/integrated_circuit/input/sensor
	name = "sensor"
	desc = "Scans and obtains a reference for any objects or persons near you.  All you need to do is shove the machine in their face."
	extended_desc = "If the 'ignore storage' pin is set to true, the sensor will disregard scanning various storage containers such as backpacks."
	icon_state = "recorder"
	complexity = 12
	inputs = list("ignore storage" = IC_PINTYPE_BOOLEAN)
	outputs = list("scanned" = IC_PINTYPE_REF)
	activators = list("on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 120

/obj/item/integrated_circuit/input/sensor/sense(atom/A, mob/user, prox)
	if(!prox || !A || (ismob(A) && !isliving(A)))
		return FALSE
	if(!check_then_do_work())
		return FALSE
	var/ignore_bags = get_pin_data(IC_INPUT, 1)
	//var/datum/component/storage/STR_A = A.GetComponent(/datum/component/storage)
	if(ignore_bags /*&& STR_A*/)
		return FALSE
	set_pin_data(IC_OUTPUT, 1, WEAKREF(A))
	push_data()
	to_chat(user, "<span class='notice'>You scan [A] with [assembly].</span>")
	activate_pin(1)
	return TRUE

/obj/item/integrated_circuit/input/sensor/ranged
	name = "ranged sensor"
	desc = "Scans and obtains a reference for any objects or persons in range.  All you need to do is point the machine towards the target."
	extended_desc = "If the 'ignore storage' pin is set to true, the sensor will disregard scanning various storage containers such as backpacks."
	icon_state = "recorder"
	complexity = 36
	inputs = list("ignore storage" = IC_PINTYPE_BOOLEAN)
	outputs = list("scanned" = IC_PINTYPE_REF)
	activators = list("on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 120

/obj/item/integrated_circuit/input/sensor/ranged/sense(atom/A, mob/user)
	if(!user || !A || (ismob(A) && !isliving(A)))
		return FALSE
	if(user.client)
		if(!(A in view(user.client)))
			return FALSE
	else
		if(!(A in view(user)))
			return FALSE
	if(!check_then_do_work())
		return FALSE
	var/ignore_bags = get_pin_data(IC_INPUT, 1)
	if(ignore_bags)
		if(istype(A, /obj/item/storage))
			return FALSE
	set_pin_data(IC_OUTPUT, 1, WEAKREF(A))
	push_data()
	to_chat(user, "<span class='notice'>You scan [A] with [assembly].</span>")
	activate_pin(1)
	return TRUE

/obj/item/integrated_circuit/input/obj_scanner
	name = "scanner"
	desc = "Scans and obtains a reference for any objects you use on the assembly."
	extended_desc = "If the 'put down' pin is set to true, the assembly will take the scanned object from your hands to its location.  \
	Useful for interaction with the grabber.  The scanner only works using the help intent."
	icon_state = "recorder"
	can_be_asked_input = 1
	complexity = 4
	inputs = list("put down" = IC_PINTYPE_BOOLEAN)
	outputs = list("scanned" = IC_PINTYPE_REF)
	activators = list("on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 20

/obj/item/integrated_circuit/input/obj_scanner/ask_for_input(mob/living/user, obj/item/I, a_intent)
	if(!isobj(I))
		return FALSE
	attackby_react(I, user, a_intent)

/obj/item/integrated_circuit/input/obj_scanner/attackby_react(mob/living/user, obj/item/I, a_intent)
	if(!isobj(I) || a_intent!=INTENT_HELP || !check_then_do_work())
		return FALSE
	var/pu = get_pin_data(IC_INPUT, 1)
	if(pu)
		user.transfer_item_to_loc(I, drop_location())
	set_pin_data(IC_OUTPUT, 1, WEAKREF(I))
	push_data()
	to_chat(user, "<span class='notice'>You let [assembly] scan [I].</span>")
	activate_pin(1)
	return TRUE

/obj/item/integrated_circuit/input/internalbm
	name = "internal battery monitor"
	desc = "This monitors the charge level of an internal battery."
	icon_state = "internalbm"
	extended_desc = "This circuit will give you the values of charge, max charge and the current percentage of the internal battery on demand."
	w_class = WEIGHT_CLASS_TINY
	complexity = 1
	inputs = list()
	outputs = list(
		"cell charge" = IC_PINTYPE_NUMBER,
		"max charge" = IC_PINTYPE_NUMBER,
		"percentage" = IC_PINTYPE_NUMBER,
		"refference to assembly" = IC_PINTYPE_REF,
		"refference to cell" = IC_PINTYPE_REF
		)
	activators = list("read" = IC_PINTYPE_PULSE_IN, "on read" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 4, TECH_DATA = 4, TECH_POWER = 4, TECH_MAGNET = 3)
	power_draw_per_use = 1

/obj/item/integrated_circuit/input/internalbm/do_work(ord)
	if(ord == 1)
		set_pin_data(IC_OUTPUT, 1, null)
		set_pin_data(IC_OUTPUT, 2, null)
		set_pin_data(IC_OUTPUT, 3, null)
		set_pin_data(IC_OUTPUT, 4, null)
		set_pin_data(IC_OUTPUT, 5, null)
		if(assembly)
			set_pin_data(IC_OUTPUT, 4, WEAKREF(assembly))
			if(assembly.battery)
				set_pin_data(IC_OUTPUT, 1, assembly.battery.charge)
				set_pin_data(IC_OUTPUT, 2, assembly.battery.maxcharge)
				set_pin_data(IC_OUTPUT, 3, 100*assembly.battery.charge/assembly.battery.maxcharge)
				set_pin_data(IC_OUTPUT, 5, WEAKREF(assembly.battery))
		push_data()
		activate_pin(2)

/obj/item/integrated_circuit/input/externalbm
	name = "external battery monitor"
	desc = "This can read the battery state of any device in view."
	icon_state = "externalbm"
	extended_desc = "This circuit will give you the charge, max charge and the current percentage values of any device or battery in view."
	w_class = WEIGHT_CLASS_TINY
	complexity = 2
	inputs = list("target" = IC_PINTYPE_REF)
	outputs = list(
		"cell charge" = IC_PINTYPE_NUMBER,
		"max charge" = IC_PINTYPE_NUMBER,
		"percentage" = IC_PINTYPE_NUMBER
		)
	activators = list("read" = IC_PINTYPE_PULSE_IN, "on read" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 4, TECH_DATA = 4, TECH_POWER = 4, TECH_MAGNET = 3)
	power_draw_per_use = 1

/obj/item/integrated_circuit/input/externalbm/do_work(ord)
	if(ord == 1)

		var/atom/movable/AM = get_pin_data_as_type(IC_INPUT, 1, /atom/movable)
		set_pin_data(IC_OUTPUT, 1, null)
		set_pin_data(IC_OUTPUT, 2, null)
		set_pin_data(IC_OUTPUT, 3, null)
		if(AM)


			var/obj/item/cell/cell = null
			if(istype(AM, /obj/item/cell)) // Is this already a cell?
				cell = AM
			else // If not, maybe there's a cell inside it?
				for(var/obj/item/cell/C in AM.contents)
					if(C) // Find one cell to charge.
						cell = C
						break
			if(cell)

				var/turf/A = get_turf(src)
				var/turf/B = get_turf(AM)
				if(A.Adjacent(B) || (AM in view(A)))
					push_data()
					set_pin_data(IC_OUTPUT, 1, cell.charge)
					set_pin_data(IC_OUTPUT, 2, cell.maxcharge)
					set_pin_data(IC_OUTPUT, 3, cell.percent())
		push_data()
		activate_pin(2)
/*TBI NTNet
/obj/item/integrated_circuit/input/ntnetsc
	name = "NTNet scanner"
	desc = "This can return the NTNet IDs of a component inside the given object, if there are any."
	icon_state = "signalsc"
	w_class = WEIGHT_CLASS_TINY
	complexity = 2
	inputs = list("target" = IC_PINTYPE_REF)
	outputs = list(
		"id" = IC_PINTYPE_STRING
		)
	activators = list("read" = IC_PINTYPE_PULSE_IN, "found" = IC_PINTYPE_PULSE_OUT,"not found" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 1

/obj/item/integrated_circuit/input/ntnetsc/do_work(ord)
	if(ord == 1)
		var/atom/AM = get_pin_data_as_type(IC_INPUT, 1, /atom)
		var/datum/component/ntnet_interface/net

		if(AM)
			var/list/processing_list = list(AM)
			while(processing_list.len && !net)
				var/atom/A = processing_list[1]
				processing_list.Cut(1, 2)
				//Byond does not allow things to be in multiple contents, or double parent-child hierarchies, so only += is needed
				//This is also why we don't need to check against assembled as we go along
				processing_list += A.contents
				net = A.GetComponent(/datum/component/ntnet_interface)

		if(net)
			set_pin_data(IC_OUTPUT, 1, net.hardware_id)
			push_data()
			activate_pin(2)
		else
			set_pin_data(IC_OUTPUT, 1, null)
			push_data()
			activate_pin(3)
*/
/* TBI ouija
/obj/item/integrated_circuit/input/ouija
	name = "superstring resonator"
	desc = "A highly dubious piece of hardware.  It may do nothing or it may ruin your day."
	extended_desc = "This chip contains an esoteric mix of sensors with spurious claims.  Proponents claim it facilitates communication \
	with beings from other dimensions.  A larger majority believe it to be a sophisticated hacking device.  The designers simply state\
	that \"more testing is required\"."
	w_class = WEIGHT_CLASS_TINY
	complexity = 4
	inputs = list("toggle on" = IC_PINTYPE_BOOLEAN)
//	outputs = list("" = )
	activators = list("read" = IC_PINTYPE_PULSE_IN, "on activity" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ARCANE = 1, TECH_ILLEGAL = 1)
	power_draw_idle = 10
	power_draw_per_use = 50

/obj/item/integrated_circuit/input/ouija/do_work(ord)
//	if(ord == 1)

*/

/obj/item/integrated_circuit/input/data_card_reader
	name = "data card reader"
	desc = "A circuit that can read from and write to data cards."
	extended_desc = "Setting the \"write mode\" boolean to true will cause any data cards that are used on the assembly to replace\
 their existing function and data strings with the given strings, if it is set to false then using a data card on the assembly will cause\
 the function and data strings stored on the card to be written to the output pins."
	icon_state = "card_reader"
	complexity = 4
	can_be_asked_input = TRUE
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	inputs = list(
		"function" = IC_PINTYPE_STRING,
		"data to store" = IC_PINTYPE_STRING,
		"write mode" = IC_PINTYPE_BOOLEAN
	)
	outputs = list(
		"function" = IC_PINTYPE_STRING,
		"stored data" = IC_PINTYPE_STRING
	)
	activators = list(
		"on write" = IC_PINTYPE_PULSE_OUT,
		"on read" = IC_PINTYPE_PULSE_OUT
	)

/obj/item/integrated_circuit/input/data_card_reader/ask_for_input(mob/living/user, obj/item/I,  a_intent)
	if(!isobj(I))
		return FALSE
	attackby_react(I, user, a_intent)

/obj/item/integrated_circuit/input/data_card_reader/attackby_react(mob/living/user, obj/item/I,  intent)
	var/obj/item/card/data/card = I
	var/write_mode = get_pin_data(IC_INPUT, 3)
	if(card)
		if(write_mode == TRUE)
			card.function = get_pin_data(IC_INPUT, 1)
			card.data = get_pin_data(IC_INPUT, 2)
			push_data()
			activate_pin(1)
		else
			set_pin_data(IC_OUTPUT, 1, card.function)
			set_pin_data(IC_OUTPUT, 2, card.data)
			push_data()
			activate_pin(2)
	else
		return FALSE
	return TRUE

/*Adding some color to cards aswell, because why not //  Because it's not implemented?
/obj/item/card/data/attackby_react(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/integrated_electronics/detailer))
		var/obj/item/integrated_electronics/detailer/D = I
		detail_color = D.detail_color
		update_icon()
	return ..()
*/
/obj/item/integrated_circuit/input/storage_examiner
	name = "storage examiner circuit"
	desc = "This circuit lets you scan a storage's content.  (backpacks, toolboxes etc.)"
	extended_desc = "The items are put out as reference, which makes it possible to interact with them.  Additionally also gives the amount of items."
	icon_state = "grabber"
	can_be_asked_input = 1
	complexity = 6
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	inputs = list(
		"storage" = IC_PINTYPE_REF
	)
	activators = list(
		"examine" = IC_PINTYPE_PULSE_IN,
		"on examined" = IC_PINTYPE_PULSE_OUT
	)
	outputs = list(
		"item amount" = IC_PINTYPE_NUMBER,
		"item list" = IC_PINTYPE_LIST
	)
	power_draw_per_use = 85

/obj/item/integrated_circuit/input/storage_examiner/do_work(ord)
	if(ord == 1)
		var/obj/item/storage = get_pin_data_as_type(IC_INPUT, 1, /obj/item)
		if(!istype(storage,/obj/item/storage))
			return

		set_pin_data(IC_OUTPUT, 1, storage.contents.len)

		var/list/regurgitated_contents = list()
		for(var/obj/o in storage.contents)
			regurgitated_contents.Add(WEAKREF(o))


		set_pin_data(IC_OUTPUT, 2, regurgitated_contents)
		push_data()
		activate_pin(2)

/obj/item/integrated_circuit/mining/ore_analyzer
	name = "ore analyzer"
	desc = "Analyzes a rock for its ore type."
	extended_desc = "Takes a reference for an object and checks if it is a rock first.  If that is the case, it outputs the mineral \
	inside the rock."
	category_text = "Input"
	ext_cooldown = 1
	complexity = 20
	cooldown_per_use = 1 SECONDS
	inputs = list(
		"rock" = IC_PINTYPE_REF
		)
	outputs = list("ore type" = IC_PINTYPE_LIST)
	activators = list(
		"analyze" = IC_PINTYPE_PULSE_IN,
		"on failed" = IC_PINTYPE_PULSE_OUT,
		"on found" = IC_PINTYPE_PULSE_OUT
		)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 20

/obj/item/integrated_circuit/mining/ore_analyzer/do_work(ord)
	if(ord == 1)
		var/turf/simulated/mineral/T
		var/mineral
		T = get_pin_data(IC_INPUT, 1)
		if(!ismineralturf(T) && !T.has_resources)
			mineral = null
			set_pin_data(IC_OUTPUT, 1, null)
			set_pin_data(IC_OUTPUT, 2, null)
			push_data()
			activate_pin(2)
			return
		mineral = T.resources
		set_pin_data(IC_OUTPUT, 1, mineral)
		push_data()
		activate_pin(3)

/obj/item/integrated_circuit/input/atmo_scanner
	name = "integrated atmospheric analyser"
	desc = "The same atmospheric analysis module that is integrated into every PDA.  \
	This allows the machine to know the composition, temperature and pressure of the surrounding atmosphere."
	icon_state = "medscan_adv"
	complexity = 2
	inputs = list()
	outputs = list(
		"pressure"       = IC_PINTYPE_NUMBER,
		"temperature" = IC_PINTYPE_NUMBER,
		"oxygen"         = IC_PINTYPE_NUMBER,
		"nitrogen"          = IC_PINTYPE_NUMBER,
		"carbon dioxide"           = IC_PINTYPE_NUMBER,
		"phoron"           = IC_PINTYPE_NUMBER,
		"other"           = IC_PINTYPE_NUMBER
	)
	activators = list("scan" = IC_PINTYPE_PULSE_IN, "on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3)
	power_draw_per_use = 60

/obj/item/integrated_circuit/input/atmo_scanner/do_work(ord)
	if(ord == 1)
		var/turf/T = get_turf(src)
		if(!istype(T)) //Invalid input
			return
		var/datum/gas_mixture/environment = T.return_air()

		var/pressure = environment.return_pressure()
		var/total_moles = environment.total_moles

		if (total_moles)
			var/o2_level = environment.gas[GAS_ID_OXYGEN]/total_moles
			var/n2_level = environment.gas[GAS_ID_NITROGEN]/total_moles
			var/co2_level = environment.gas[GAS_ID_CARBON_DIOXIDE]/total_moles
			var/phoron_level = environment.gas[GAS_ID_PHORON]/total_moles
			var/unknown_level =  1-(o2_level+n2_level+co2_level+phoron_level)
			set_pin_data(IC_OUTPUT, 1, pressure)
			set_pin_data(IC_OUTPUT, 2, round(environment.temperature-T0C,0.1))
			set_pin_data(IC_OUTPUT, 3, round(o2_level*100,0.1))
			set_pin_data(IC_OUTPUT, 4, round(n2_level*100,0.1))
			set_pin_data(IC_OUTPUT, 5, round(co2_level*100,0.1))
			set_pin_data(IC_OUTPUT, 6, round(phoron_level*100,0.01))
			set_pin_data(IC_OUTPUT, 7, round(unknown_level, 0.01))
		else
			set_pin_data(IC_OUTPUT, 1, 0)
			set_pin_data(IC_OUTPUT, 2, -273.15)
			set_pin_data(IC_OUTPUT, 3, 0)
			set_pin_data(IC_OUTPUT, 4, 0)
			set_pin_data(IC_OUTPUT, 5, 0)
			set_pin_data(IC_OUTPUT, 6, 0)
			set_pin_data(IC_OUTPUT, 7, 0)
		push_data()
		activate_pin(2)

/obj/item/integrated_circuit/input/pressure_sensor
	name = "integrated pressure sensor"
	desc = "A tiny pressure sensor module similar to that found in a PDA atmosphere analyser."
	icon_state = "medscan_adv"
	complexity = 3
	inputs = list()
	outputs = list(
		"pressure"       = IC_PINTYPE_NUMBER
	)
	activators = list("scan" = IC_PINTYPE_PULSE_IN, "on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3)
	power_draw_per_use = 20

/obj/item/integrated_circuit/input/pressure_sensor/do_work(ord)
	if(ord == 1)
		var/turf/T = get_turf(src)
		if(!istype(T)) //Invalid input
			return
		var/datum/gas_mixture/environment = T.return_air()

		var/pressure = environment.return_pressure()
		var/total_moles = environment.total_moles

		if (total_moles)
			set_pin_data(IC_OUTPUT, 1, pressure)
		else
			set_pin_data(IC_OUTPUT, 1, 0)
		push_data()
		activate_pin(2)

/obj/item/integrated_circuit/input/temperature_sensor
	name = "integrated temperature sensor"
	desc = "A tiny temperature sensor module similar to that found in a PDA atmosphere analyser."
	icon_state = "medscan_adv"
	complexity = 3
	inputs = list()
	outputs = list(
		"temperature"       = IC_PINTYPE_NUMBER
	)
	activators = list("scan" = IC_PINTYPE_PULSE_IN, "on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3)
	power_draw_per_use = 20

/obj/item/integrated_circuit/input/temperature_sensor/do_work(ord)
	if(ord == 1)
		var/turf/T = get_turf(src)
		if(!istype(T)) //Invalid input
			return
		var/datum/gas_mixture/environment = T.return_air()

		var/total_moles = environment.total_moles

		if (total_moles)
			set_pin_data(IC_OUTPUT, 1, round(environment.temperature-T0C,0.1))
		else
			set_pin_data(IC_OUTPUT, 1, -273.15)
		push_data()
		activate_pin(2)

/obj/item/integrated_circuit/input/oxygen_sensor
	name = "integrated oxygen sensor"
	desc = "A tiny oxygen sensor module similar to that found in a PDA atmosphere analyser."
	icon_state = "medscan_adv"
	complexity = 3
	inputs = list()
	outputs = list(
		"oxygen"       = IC_PINTYPE_NUMBER
	)
	activators = list("scan" = IC_PINTYPE_PULSE_IN, "on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3)
	power_draw_per_use = 20

/obj/item/integrated_circuit/input/oxygen_sensor/do_work(ord)
	if(ord == 1)
		var/turf/T = get_turf(src)
		if(!istype(T)) //Invalid input
			return
		var/datum/gas_mixture/environment = T.return_air()

		var/total_moles = environment.total_moles

		if (total_moles)
			var/o2_level = environment.gas[GAS_ID_OXYGEN]/total_moles
			set_pin_data(IC_OUTPUT, 1, round(o2_level*100,0.1))
		else
			set_pin_data(IC_OUTPUT, 1, 0)
		push_data()
		activate_pin(2)

/obj/item/integrated_circuit/input/co2_sensor
	name = "integrated co2 sensor"
	desc = "A tiny carbon dioxide sensor module similar to that found in a PDA atmosphere analyser."
	icon_state = "medscan_adv"
	complexity = 3
	inputs = list()
	outputs = list(
		"co2"       = IC_PINTYPE_NUMBER
	)
	activators = list("scan" = IC_PINTYPE_PULSE_IN, "on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3)
	power_draw_per_use = 20

/obj/item/integrated_circuit/input/co2_sensor/do_work(ord)
	if(ord == 1)
		var/turf/T = get_turf(src)
		if(!istype(T)) //Invalid input
			return
		var/datum/gas_mixture/environment = T.return_air()

		var/total_moles = environment.total_moles

		if (total_moles)
			var/co2_level = environment.gas[GAS_ID_CARBON_DIOXIDE]/total_moles
			set_pin_data(IC_OUTPUT, 1, round(co2_level*100,0.1))
		else
			set_pin_data(IC_OUTPUT, 1, 0)
		push_data()
		activate_pin(2)

/obj/item/integrated_circuit/input/nitrogen_sensor
	name = "integrated nitrogen sensor"
	desc = "A tiny nitrogen sensor module similar to that found in a PDA atmosphere analyser."
	icon_state = "medscan_adv"
	complexity = 3
	inputs = list()
	outputs = list(
		"nitrogen"       = IC_PINTYPE_NUMBER
	)
	activators = list("scan" = IC_PINTYPE_PULSE_IN, "on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3)
	power_draw_per_use = 20

/obj/item/integrated_circuit/input/nitrogen_sensor/do_work(ord)
	if(ord == 1)
		var/turf/T = get_turf(src)
		if(!istype(T)) //Invalid input
			return
		var/datum/gas_mixture/environment = T.return_air()

		var/total_moles = environment.total_moles

		if (total_moles)
			var/n2_level = environment.gas[GAS_ID_NITROGEN]/total_moles
			set_pin_data(IC_OUTPUT, 1, round(n2_level*100,0.1))
		else
			set_pin_data(IC_OUTPUT, 1, 0)
		push_data()
		activate_pin(2)

/obj/item/integrated_circuit/input/phoron_sensor
	name = "integrated phoron sensor"
	desc = "A tiny phoron gas sensor module similar to that found in a PDA atmosphere analyser."
	icon_state = "medscan_adv"
	complexity = 3
	inputs = list()
	outputs = list(
		"phoron"       = IC_PINTYPE_NUMBER
	)
	activators = list("scan" = IC_PINTYPE_PULSE_IN, "on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3)
	power_draw_per_use = 20

/obj/item/integrated_circuit/input/phoron_sensor/do_work(ord)
	if(ord == 1)
		var/turf/T = get_turf(src)
		if(!istype(T)) //Invalid input
			return
		var/datum/gas_mixture/environment = T.return_air()

		var/total_moles = environment.total_moles

		if (total_moles)
			var/phoron_level = environment.gas[GAS_ID_PHORON]/total_moles
			set_pin_data(IC_OUTPUT, 1, round(phoron_level*100,0.1))
		else
			set_pin_data(IC_OUTPUT, 1, 0)
		push_data()
		activate_pin(2)

/obj/item/integrated_circuit/input/plant_scanner
	name = "integrated plant analyzer"
	desc = "A very small version of the plant analyser. This allows the machine to know all valuable parameters of plants in trays. \
			It can only scan plants, not seeds or fruits."
	icon_state = "medscan_adv"
	complexity = 12
	inputs = list("target" = IC_PINTYPE_REF)
	outputs = list(
		"plant type"			= IC_PINTYPE_STRING,
		"age"					= IC_PINTYPE_NUMBER,
		"potency"				= IC_PINTYPE_NUMBER,
		"yield"					= IC_PINTYPE_NUMBER,
		"Maturation speed"		= IC_PINTYPE_NUMBER,
		"Production speed"		= IC_PINTYPE_NUMBER,
		"Endurance"				= IC_PINTYPE_NUMBER,
		"Lifespan"				= IC_PINTYPE_NUMBER,
		"Weed Resistance"		= IC_PINTYPE_NUMBER,
		"Weed level"			= IC_PINTYPE_NUMBER,
		"Pest level"			= IC_PINTYPE_NUMBER,
		"Water level"			= IC_PINTYPE_NUMBER,
		"Nutrition level"		= IC_PINTYPE_NUMBER,
		"harvest"				= IC_PINTYPE_NUMBER,
		"dead"					= IC_PINTYPE_NUMBER,
		"plant health"			= IC_PINTYPE_NUMBER,
	)
	activators = list("scan" = IC_PINTYPE_PULSE_IN, "on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 10

/obj/item/integrated_circuit/input/plant_scanner/do_work()
	var/obj/machinery/portable_atmospherics/hydroponics/H = get_pin_data_as_type(IC_INPUT, 1, /obj/machinery/portable_atmospherics/hydroponics)
	if(!istype(H)) //Invalid input
		return
	for(var/i=1, i<=outputs.len, i++)
		set_pin_data(IC_OUTPUT, i, null)
	if(H in view(get_turf(src))) // Like medbot's analyzer it can be used in range..
		if(H.seed)
			set_pin_data(IC_OUTPUT, 1, H.seed.seed_name)
			set_pin_data(IC_OUTPUT, 2, H.age)
			set_pin_data(IC_OUTPUT, 3, H.seed.get_trait(TRAIT_POTENCY))
			set_pin_data(IC_OUTPUT, 4, H.seed.get_trait(TRAIT_YIELD))
			set_pin_data(IC_OUTPUT, 5, H.seed.get_trait(TRAIT_MATURATION))
			set_pin_data(IC_OUTPUT, 6, H.seed.get_trait(TRAIT_PRODUCTION))
			set_pin_data(IC_OUTPUT, 7, H.seed.get_trait(TRAIT_ENDURANCE))
			set_pin_data(IC_OUTPUT, 8, !!H.seed.get_trait(TRAIT_HARVEST_REPEAT))
			set_pin_data(IC_OUTPUT, 9, H.seed.get_trait(TRAIT_WEED_TOLERANCE))
		set_pin_data(IC_OUTPUT, 10, H.weedlevel)
		set_pin_data(IC_OUTPUT, 11, H.pestlevel)
		set_pin_data(IC_OUTPUT, 12, H.waterlevel)
		set_pin_data(IC_OUTPUT, 13, H.nutrilevel)
		set_pin_data(IC_OUTPUT, 14, H.harvest)
		set_pin_data(IC_OUTPUT, 15, H.dead)
		set_pin_data(IC_OUTPUT, 16, H.health)
	push_data()
	activate_pin(2)


/obj/item/integrated_circuit/input/projectile_simulator
	name = "projectile simulator"
	desc = "An IR laser pointer with a camera. Aim at a target or location and get the output the final result. Aiming at coordinates will output a hit refrence. Aiming at a refrence will output a hit or not hit pulse."
	icon_state = "medscan_adv"
	complexity = 8
	inputs = list(
		"x" = IC_PINTYPE_NUMBER,
		"y" = IC_PINTYPE_NUMBER,
		"target ref" = IC_PINTYPE_REF
	)
	outputs = list(
		"target hit"       = IC_PINTYPE_REF
	)
	activators = list(
		"shoot cords" = IC_PINTYPE_PULSE_IN,
		"shoot ref" = IC_PINTYPE_PULSE_IN,
		"cords out" = IC_PINTYPE_PULSE_OUT,
		"target hit" = IC_PINTYPE_PULSE_OUT,
		"target missed" = IC_PINTYPE_PULSE_OUT
		)
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3)
	power_draw_per_use = 20

/obj/item/integrated_circuit/input/projectile_simulator/do_work(ord)
	switch(ord)
		if(1)
			var/list/hit_things
			var/turf/T = get_turf(assembly)
			var/target_x = get_pin_data(IC_INPUT, 1)
			var/target_y = get_pin_data(IC_INPUT, 2)
			var/turf/A = locate(clamp(target_x + T.x,0,world.maxx), clamp(target_y + T.y,0,world.maxy), T.z)
			var/turf/starting = get_turf(src)
			var/obj/projectile/trace/trace_projectile = new(starting)
			trace_projectile.pass_flags = ATOM_PASS_TABLE | ATOM_PASS_GLASS | ATOM_PASS_GRILLE
			trace_projectile.prepare_trace(A, TRUE)
			trace_projectile.fire()
			hit_things = trace_projectile.scanned_atoms
			if(hit_things.len)
				set_pin_data(IC_OUTPUT, 1, WEAKREF(hit_things[1]))
				activate_pin(3)
		if(2)
			var/atom/target = get_pin_data(IC_INPUT, 3)
			var/turf/starting = get_turf(src)
			var/obj/projectile/trace/trace_projectile = new(starting)
			trace_projectile.pass_flags = ATOM_PASS_TABLE | ATOM_PASS_GLASS | ATOM_PASS_GRILLE
			trace_projectile.prepare_trace(target, TRUE)
			trace_projectile.fire()
			if(trace_projectile.could_hit_target)
				activate_pin(4)
				return
			activate_pin(5)





