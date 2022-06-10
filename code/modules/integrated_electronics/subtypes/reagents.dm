/obj/item/integrated_circuit/reagent
	category_text = "Reagent"
	cooldown_per_use = 10
	var/volume = 0
	unacidable = 1
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2, TECH_BIO = 2)

/obj/item/integrated_circuit/reagent/Initialize(mapload)
	. = ..()
	if(volume)
		create_reagents(volume)
		push_vol()

/obj/item/integrated_circuit/reagent/proc/push_vol()
	set_pin_data(IC_OUTPUT, 1, reagents.total_volume)
	push_data()

/obj/item/integrated_circuit/reagent/smoke
	name = "smoke generator"
	desc = "Unlike most electronics, creating smoke is completely intentional."
	icon_state = "smoke"
	extended_desc = "This smoke generator creates clouds of smoke on command.  It can also hold liquids inside, which will go \
	into the smoke clouds when activated.  The reagents are consumed when smoke is made."
	flags = OPENCONTAINER
	complexity = 20
	cooldown_per_use = 30 SECONDS
	inputs = list()
	outputs = list("volume used" = IC_PINTYPE_NUMBER,"self reference" = IC_PINTYPE_SELFREF)
	activators = list("create smoke" = IC_PINTYPE_PULSE_IN,"on smoked" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3, TECH_BIO = 3)
	volume = 100
	power_draw_per_use = 20

/obj/item/integrated_circuit/reagent/smoke/on_reagent_change()
	set_pin_data(IC_OUTPUT, 1, reagents.total_volume)
	push_data()

/obj/item/integrated_circuit/reagent/smoke/interact(mob/user)
	set_pin_data(IC_OUTPUT, 2, WEAKREF(src))
	push_data()
	..()

/obj/item/integrated_circuit/reagent/smoke/do_work()
	playsound(src.loc, 'sound/effects/smoke.ogg', 50, 1, -3)
	var/datum/effect_system/smoke_spread/chem/smoke_system = new()
	smoke_system.set_up(reagents, 10, 0, get_turf(src))
	spawn(0)
		for(var/i = 1 to 8)
			smoke_system.start()
		reagents.clear_reagents()
	activate_pin(2)

/obj/item/integrated_circuit/reagent/injector
	name = "integrated hypo-injector"
	desc = "This scary looking thing is able to pump liquids into, or suck liquids out of, whatever it's pointed at."
	icon_state = "injector"
	extended_desc = "This autoinjector can push up to 30 units of reagents into another container or someone else outside of the machine.  The target \
	must be adjacent to the machine, and if it is a person, they cannot be wearing thick clothing.  A negative quantity inverts the injector, sucking out reagents instead."
	flags = OPENCONTAINER
	volume = 30
	complexity = 20
	cooldown_per_use = 6 SECONDS
	inputs = list("target" = IC_PINTYPE_REF, "injection amount" = IC_PINTYPE_NUMBER)
	inputs_default = list("2" = 5)
	outputs = list(
		"volume used" = IC_PINTYPE_NUMBER,
		"self reference" = IC_PINTYPE_SELFREF
		)
	activators = list(
		"push ref" = IC_PINTYPE_PULSE_IN,
		"inject" = IC_PINTYPE_PULSE_IN,
		"on injected" = IC_PINTYPE_PULSE_OUT,
		"on fail" = IC_PINTYPE_PULSE_OUT
		)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 15
	var/direction_mode = SYRINGE_INJECT
	var/transfer_amount = 10
	var/busy = FALSE

/obj/item/integrated_circuit/reagent/injector/Initialize(mapload)
	. = ..()
	reagents.reagents_holder_flags |= OPENCONTAINER

/obj/item/integrated_circuit/reagent/injector/on_reagent_change(changetype)
	push_vol()

/obj/item/integrated_circuit/reagent/injector/on_data_written()
	var/new_amount = get_pin_data(IC_INPUT, 2)
	if(new_amount < 0)
		new_amount = -new_amount
		direction_mode = SYRINGE_DRAW
	else
		direction_mode = SYRINGE_INJECT
	if(isnum(new_amount))
		new_amount = clamp(new_amount, 0, volume)
		transfer_amount = new_amount


/obj/item/integrated_circuit/reagent/injector/do_work(ord)
	switch(ord)
		if(1)
			inject()
		if(4)
			set_pin_data(IC_OUTPUT, 2, WEAKREF(src))
			push_data()

/obj/item/integrated_circuit/reagent/injector/proc/inject()
	set waitfor = FALSE // Don't sleep in a proc that is called by a processor without this set, otherwise it'll delay the entire thing
	var/atom/movable/AM = get_pin_data_as_type(IC_INPUT, 1, /atom/movable)
	var/atom/movable/acting_object = get_object()

	if(busy || !check_target(AM))
		activate_pin(3)
		return

	if(!istype(AM)) //Invalid input
		activate_pin(3)
		return

	if(!AM.reagents)
		activate_pin(3)
		return

	if(direction_mode == SYRINGE_INJECT)
		if(!reagents.total_volume || !AM.can_be_injected_by(src) || AM.reagents.holder_full())
			activate_pin(3)
			return
		if(isliving(AM))
			var/mob/living/L = AM
			if(!L.can_inject(null, 0))
				activate_pin(3)
				return

//Always log attemped injections for admins
			var/contained = reagents.log_list()
			log_attack(src, L, "attempted to inject [L] which had [contained]")
			L.visible_message("<span class='danger'>[acting_object] is trying to inject [L]!</span>", \
								"<span class='userdanger'>[acting_object] is trying to inject you!</span>")
			busy = TRUE
			if(do_atom(src, L, extra_checks=CALLBACK(L, /mob/living/proc/can_inject,null,0)))
				reagents.trans_to(L, transfer_amount)
				log_attack(src, L, "attempted to inject [L] which had [contained]")
				L.visible_message("<span class='danger'>[acting_object] injects [L] with its needle!</span>", \
									"<span class='userdanger'>[acting_object] injects you with its needle!</span>")
			else
				busy = FALSE
				activate_pin(3)
				return
			busy = FALSE
		else
			reagents.trans_to(AM, transfer_amount)
	if(direction_mode == SYRINGE_DRAW)
		if(reagents.total_volume >= reagents.maximum_volume)
			acting_object.visible_message("[acting_object] tries to draw from [AM], but the injector is full.")
			activate_pin(3)
			return

		var/tramount = abs(transfer_amount)

		if(isliving(AM))
			var/mob/living/L = AM
			L.visible_message("<span class='danger'>[acting_object] is trying to take a blood sample from [L]!</span>", \
								"<span class='userdanger'>[acting_object] is trying to take a blood sample from you!</span>")
			busy = TRUE
			if(do_atom(src, L, extra_checks=CALLBACK(L, /mob/living/proc/can_inject,null,0)))
				var/mob/living/carbon/LB = L
				if(LB.take_blood(src, tramount))
					L.visible_message("<span class='danger'>[acting_object] takes a blood sample from [L]!</span>", \
					"<span class='userdanger'>[acting_object] takes a blood sample from you!</span>")
				else
					L.visible_message("<span class='warning'>[acting_object] fails to take a blood sample from [L].</span>", \
								"<span class='userdanger'>[acting_object] fails to take a blood sample from you!</span>")
					busy = FALSE
					activate_pin(3)
					return
			busy = FALSE

		else
			if(!AM.reagents.total_volume)
				acting_object.visible_message("<span class='notice'>[acting_object] tries to draw from [AM], but it is empty!</span>")
				activate_pin(3)
				return

			if(!AM.can_be_injected_by())
				activate_pin(3)
				return
			tramount = min(tramount, AM.reagents.total_volume)
			AM.reagents.trans_to(src, tramount)
	activate_pin(2)



/obj/item/integrated_circuit/reagent/pump
	name = "reagent pump"
	desc = "Moves liquids safely inside a machine, or even nearby it."
	icon_state = "reagent_pump"
	extended_desc = "This is a pump, which will move liquids from the source ref to the target ref.  The third pin determines \
	how much liquid is moved per pulse, between 0 and 50.  The pump can move reagents to any open container inside the machine, or \
	outside the machine if it is next to the machine.  Note that this cannot be used on entities."
	flags = OPENCONTAINER
	complexity = 8
	inputs = list("source" = IC_PINTYPE_REF, "target" = IC_PINTYPE_REF, "injection amount" = IC_PINTYPE_NUMBER)
	inputs_default = list("3" = 5)
	outputs = list()
	activators = list("transfer reagents" = IC_PINTYPE_PULSE_IN, "on transfer" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2, TECH_BIO = 2)
	var/transfer_amount = 10
	var/direc = 1
	power_draw_per_use = 10

/obj/item/integrated_circuit/reagent/pump/on_data_written()
	var/new_amount = get_pin_data(IC_INPUT, 3)
	if(new_amount < 0)
		new_amount = -new_amount
		direc = 0
	else
		direc = 1
	if(isnum(new_amount))
		new_amount = clamp(new_amount, 0, 50)
		transfer_amount = new_amount

/obj/item/integrated_circuit/reagent/pump/do_work()
	var/atom/movable/source = get_pin_data_as_type(IC_INPUT, 1, /atom/movable)
	var/atom/movable/target = get_pin_data_as_type(IC_INPUT, 2, /atom/movable)

	if(!istype(source) || !istype(target)) //Invalid input
		return
	var/turf/T = get_turf(src)
	var/turf/TS = get_turf(source)
	var/turf/TT = get_turf(target)
	if(TS.Adjacent(T) && TT.Adjacent(T))
		if(!source.reagents || !target.reagents)
			return
		if(ismob(source) || ismob(target))
			return
		if(!source.is_open_container() || !target.is_open_container())
			return
		if(direc)
			if(!target.reagents.get_free_space())
				return
			source.reagents.trans_to(target, transfer_amount)
		else
			if(!source.reagents.get_free_space())
				return
			target.reagents.trans_to(source, transfer_amount)
		activate_pin(2)

/obj/item/integrated_circuit/input/beaker_connector
	category_text = "Reagent"
	cooldown_per_use = 1
	name = "beaker slot"
	desc = "Lets you add a beaker to your assembly and remove it even when the assembly is closed."
	icon_state = "reagent_storage"
	extended_desc = "It can help you extract reagents easier."
	complexity = 4
	can_be_asked_input = TRUE
	inputs = list()
	outputs = list(
		"volume used" = IC_PINTYPE_NUMBER,
		"current beaker" = IC_PINTYPE_REF
		)
	activators = list(
		"on insert" = IC_PINTYPE_PULSE_OUT,
		"on remove" = IC_PINTYPE_PULSE_OUT,
		"push ref" = IC_PINTYPE_PULSE_OUT
		)

	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	can_be_asked_input = TRUE

	var/obj/item/reagent_containers/glass/beaker/current_beaker

/obj/item/integrated_circuit/input/beaker_connector/ask_for_input(obj/item/I, mob/living/user, a_intent)
	if(!isobj(I))
		return FALSE
	attackby_react(I, user, a_intent)

/obj/item/integrated_circuit/input/beaker_connector/attackby_react(var/obj/item/reagent_containers/I, var/mob/living/user)
	//Check if it truly is a reagent container
	if(!istype(I,/obj/item/reagent_containers/glass/beaker))
		to_chat(user,"<span class='warning'>The [I.name] doesn't seem to fit in here.</span>")
		return

	//Check if there is no other beaker already inside
	if(current_beaker)
		to_chat(user,"<span class='notice'>There is already a reagent container inside.</span>")
		return

	//The current beaker is the one we just attached, its location is inside the circuit
	current_beaker = I
	user.transferItemToLoc(I,src)

	to_chat(user,"<span class='warning'>You put the [I.name] inside the beaker connector.</span>")

	//Set the pin to a weak reference of the current beaker
	push_vol()
	set_pin_data(IC_OUTPUT, 2, WEAKREF(current_beaker))
	push_data()
	activate_pin(1)
	activate_pin(3)


/obj/item/integrated_circuit/input/beaker_connector/ask_for_input(mob/user)
	attack_self(user)


/obj/item/integrated_circuit/input/beaker_connector/attack_self(mob/user)
	//Check if no beaker attached
	if(!current_beaker)
		to_chat(user, "<span class='notice'>There is currently no beaker attached.</span>")
		return

	//Remove beaker and put in user's hands/location
	to_chat(user, "<span class='notice'>You take [current_beaker] out of the beaker connector.</span>")
	user.put_in_hands(current_beaker)
	current_beaker = null
	//Remove beaker reference
	push_vol()
	set_pin_data(IC_OUTPUT, 2, null)
	push_data()
	activate_pin(2)
	activate_pin(3)


/obj/item/integrated_circuit/input/beaker_connector/proc/push_vol()
	var/beakerVolume = 0
	if(current_beaker)
		beakerVolume = current_beaker.reagents.total_volume

	set_pin_data(IC_OUTPUT, 1, beakerVolume)
	push_data()


/obj/item/reagent_containers/glass/beaker/on_reagent_change()
	..()
	if(istype(loc,/obj/item/integrated_circuit/input/beaker_connector))
		var/obj/item/integrated_circuit/input/beaker_connector/current_circuit = loc
		current_circuit.push_vol()

/obj/item/integrated_circuit/reagent/storage
	name = "reagent storage"
	desc = "Stores liquid inside, and away from electrical components.  Can store up to 60u."
	icon_state = "reagent_storage"
	extended_desc = "This is effectively an internal beaker."
	flags = OPENCONTAINER
	complexity = 4
	inputs = list()
	outputs = list("volume used" = IC_PINTYPE_NUMBER,"self reference" = IC_PINTYPE_REF)
	activators = list()
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2, TECH_BIO = 2)
	volume = 60


/obj/item/integrated_circuit/reagent/storage/interact(mob/user)
	set_pin_data(IC_OUTPUT, 2, WEAKREF(src))
	push_data()
	..()

/obj/item/integrated_circuit/reagent/storage/on_reagent_change()
	set_pin_data(IC_OUTPUT, 1, reagents.total_volume)
	push_data()

/obj/item/integrated_circuit/reagent/storage/cryo
	name = "cryo reagent storage"
	desc = "Stores liquid inside, and away from electrical components.  Can store up to 60u.  This will also suppress reactions."
	icon_state = "reagent_storage_cryo"
	extended_desc = "This is effectively an internal cryo beaker."
	flags = OPENCONTAINER | NOREACT
	complexity = 8
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 2, TECH_DATA = 2, TECH_BIO = 2)

/obj/item/integrated_circuit/reagent/storage/heater
	name = "chemical heater"
	desc = "Stores liquid inside the device away from electrical components.  It can store up to 60u.  It will heat or cool the reagents \
	to the target temperature when turned on."
	icon_state = "heater"
	complexity = 8
	inputs = list(
		"target temperature" = IC_PINTYPE_NUMBER,
		"on" = IC_PINTYPE_BOOLEAN
		)
	inputs_default = list("1" = 300)
	outputs = list("volume used" = IC_PINTYPE_NUMBER,"self reference" = IC_PINTYPE_SELFREF,"temperature" = IC_PINTYPE_NUMBER)
	spawn_flags = IC_SPAWN_RESEARCH
	var/heater_coefficient = 0.1

/obj/item/integrated_circuit/reagent/storage/heater/on_data_written()
	if(get_pin_data(IC_INPUT, 2))
		power_draw_idle = 30
	else
		power_draw_idle = 0

/obj/item/integrated_circuit/reagent/storage/heater/Initialize()
	.=..()
	START_PROCESSING(SScircuit, src)

/obj/item/integrated_circuit/reagent/storage/heater/Destroy()
	STOP_PROCESSING(SScircuit, src)
	return ..()

/obj/item/integrated_circuit/reagent/storage/big
	name = "big reagent storage"
	desc = "Stores liquid inside, and away from electrical components.  Can store up to 180u."
	icon_state = "reagent_storage_big"
	extended_desc = "This is effectively an internal beaker."
	flags = OPENCONTAINER
	complexity = 16
	volume = 180
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 2, TECH_DATA = 2, TECH_BIO = 2)

/obj/item/integrated_circuit/reagent/funnel
	category_text = "Reagent"
	name = "reagent funnel"
	desc = "A funnel with a small pump that lets you refill an internal reagent storage."
	icon_state = "reagent_funnel"
	can_be_asked_input = TRUE
	inputs = list(
		"target" = IC_PINTYPE_REF
	)
	activators = list(
		"on transfer" = IC_PINTYPE_PULSE_OUT
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	complexity = 4
	power_draw_per_use = 5

/obj/item/integrated_circuit/reagent/funnel/proc/ask_for_input(obj/item/I, mob/living/user, a_intent)
	if(!isobj(I))
		return FALSE
	attackby_react(I, user, a_intent)

/obj/item/integrated_circuit/reagent/funnel/attackby_react(obj/item/I, mob/living/user, intent)
	var/atom/movable/target = get_pin_data_as_type(IC_INPUT, 1, /atom/movable)
	var/obj/item/reagent_containers/container = I

	if(!check_target(target) || !I.reagents)
		return FALSE

	if(container.standard_pour_into(user, target))
		activate_pin(1)
		return TRUE

	return FALSE

/obj/item/integrated_circuit/reagent/tubing
	name = "tubing"
	desc = "A length of flexible piping that can be used to connect one container to another."
	extended_desc = "Use these to supply your fuel cell with never-ending phoron! Beware of leaks."
	icon_state = "reagent_funnel"
	flags = OPENCONTAINER
	inputs = list(
		"toggle cap"		= IC_PINTYPE_BOOLEAN,
		"source vol"		= IC_PINTYPE_NUMBER,
		"destination vol"	= IC_PINTYPE_NUMBER
		)
	outputs = list(
		"volume"		= IC_PINTYPE_NUMBER
		)
	power_draw_per_use = 0
	complexity = 1
	volume = 5
	next_use = null
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/reagent/tubing/on_data_written()
	if(world.time < next_use)
		return
	// Vars for final comparison.
	var/s_vol = get_pin_data(IC_INPUT, 2)
	var/d_vol = get_pin_data(IC_INPUT, 3)
	var/obj/item/integrated_circuit/s = get_pin_linked_src(IC_INPUT, 2)
	var/obj/item/integrated_circuit/d = get_pin_linked_src(IC_INPUT, 3)
	// Try to transfer any pipe contents to an attached container.  If no container, spill.
	src.reagents.total_volume ? (d && d.reagents) ? reagents.trans_to(d, 5) : reagents.splash_area(assembly.loc, 0) : null
	if(s && s.reagents.total_volume)
		s.reagents.trans_to(src, 5)
	if(s_vol != get_pin_data(IC_INPUT, 2) || d_vol != get_pin_data(IC_INPUT, 3))
		spawn(5) on_data_written()
	next_use = world.time + 5
	push_vol()

/obj/item/integrated_circuit/reagent/storage/grinder
	name = "reagent grinder"
	desc = "This is a reagent grinder.  It accepts a ref to something, and refines it into reagents.  It can store up to 100u."
	icon_state = "blender"
	extended_desc = ""
	inputs = list(
		"target" = IC_PINTYPE_REF
		)
	outputs = list(
		"volume used" = IC_PINTYPE_NUMBER,
		"self reference" = IC_PINTYPE_SELFREF
		)
	activators = list(
		"grind" = IC_PINTYPE_PULSE_IN,
		"on grind" = IC_PINTYPE_PULSE_OUT,
		"on fail" = IC_PINTYPE_PULSE_OUT,
		"push ref" = IC_PINTYPE_PULSE_IN
		)
	flags = OPENCONTAINER
	volume = 100
	power_draw_per_use = 150
	complexity = 16
	spawn_flags = IC_SPAWN_RESEARCH


/obj/item/integrated_circuit/reagent/storage/grinder/do_work(ord)
	switch(ord)
		if(1)
			grind()
		if(4)
			set_pin_data(IC_OUTPUT, 2, WEAKREF(src))
			push_data()

/obj/item/integrated_circuit/reagent/storage/grinder/proc/grind()
	if(reagents.total_volume >= reagents.maximum_volume)
		activate_pin(3)
		return FALSE
	var/obj/item/I = get_pin_data_as_type(IC_INPUT, 1, /obj/item)
	if(istype(I) && (I.reagents.total_volume) && check_target(I))
		var/list/reagent_names_list = list()
		for(var/datum/reagent/R in reagents?.reagent_list)
			reagent_names_list.Add(R.name)
		var/atom/AM = get_object()
		AM.investigate_log("ground reagents: [jointext(reagent_names_list, ", ")] with [src].", INVESTIGATE_CIRCUIT)
		playsound(src, 'sound/machines/blender.ogg', 50, 1)
		I.reagents.trans_to(src, I.reagents.total_volume)
		qdel(I)
		activate_pin(2)
		return TRUE
	activate_pin(3)
	return FALSE

/obj/item/integrated_circuit/reagent/storage/scan
	name = "reagent scanner"
	desc = "Stores liquid inside, and away from electrical components.  Can store up to 60u.  On pulse this beaker will send list of contained reagents."
	icon_state = "reagent_scan"
	extended_desc = "Mostly useful for reagent filter."
	flags = OPENCONTAINER
	complexity = 8
	outputs = list("volume used" = IC_PINTYPE_NUMBER,"self reference" = IC_PINTYPE_REF,"list of reagents" = IC_PINTYPE_LIST)
	activators = list("scan" = IC_PINTYPE_PULSE_IN)
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 2, TECH_DATA = 2, TECH_BIO = 2)

/obj/item/integrated_circuit/reagent/storage/scan/do_work()
	var/cont[0]
	for(var/datum/reagent/RE in reagents.reagent_list)
		cont += RE.id
	set_pin_data(IC_OUTPUT, 3, cont)
	push_data()


/obj/item/integrated_circuit/reagent/filter
	name = "reagent filter"
	desc = "Filtering liquids by list of desired or unwanted reagents."
	icon_state = "reagent_filter"
	extended_desc = "This is a filter which will move liquids from the source ref to the target ref.  \
	It will move all reagents, except list, given in fourth pin if amount value is positive.\
	Or it will move only desired reagents if amount is negative, The third pin determines \
	how much reagent is moved per pulse, between 0 and 50.  Amount is given for each separate reagent."
	flags = OPENCONTAINER
	complexity = 8
	inputs = list("source" = IC_PINTYPE_REF, "target" = IC_PINTYPE_REF, "injection amount" = IC_PINTYPE_NUMBER, "list of reagents" = IC_PINTYPE_LIST)
	inputs_default = list("3" = 5)
	outputs = list()
	activators = list("transfer reagents" = IC_PINTYPE_PULSE_IN, "on transfer" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2, TECH_BIO = 2)
	var/transfer_amount = 10
	var/direc = 1
	power_draw_per_use = 10

/obj/item/integrated_circuit/reagent/filter/on_data_written()
	var/new_amount = get_pin_data(IC_INPUT, 3)
	if(new_amount < 0)
		new_amount = -new_amount
		direc = 0
	else
		direc = 1
	if(isnum(new_amount))
		new_amount = clamp(new_amount, 0, 50)
		transfer_amount = new_amount

/obj/item/integrated_circuit/reagent/filter/do_work()
	var/atom/movable/source = get_pin_data_as_type(IC_INPUT, 1, /atom/movable)
	var/atom/movable/target = get_pin_data_as_type(IC_INPUT, 2, /atom/movable)
	var/list/demand = get_pin_data(IC_INPUT, 4)
	if(!istype(source) || !istype(target)) //Invalid input
		return
	var/turf/T = get_turf(src)
	if(source.Adjacent(T) && target.Adjacent(T))
		if(!source.reagents || !target.reagents)
			return
		if(ismob(source) || ismob(target))
			return
		if(!source.is_open_container() || !target.is_open_container())
			return
		if(!target.reagents.get_free_space())
			return
		for(var/datum/reagent/G in source.reagents.reagent_list)
			if (!direc)
				if(G.id in demand)
					source.reagents.trans_id_to(target, G.id, transfer_amount)
			else
				if(!(G.id in demand))
					source.reagents.trans_id_to(target, G.id, transfer_amount)
		activate_pin(2)
		push_data()

/obj/item/integrated_circuit/reagent/extinguisher
	name = "integrated extinguisher"
	desc = "This circuit sprays any of its contents out like an extinguisher."
	icon_state = "injector"
	extended_desc = "This circuit can hold up to 30 units of any given chemicals.  On each use, it sprays these reagents like a fire extinguisher."

	volume = 30
	flags = OPENCONTAINER

	complexity = 20
	cooldown_per_use = 6 SECONDS
	inputs = list(
		"target" = IC_PINTYPE_REF,
		)
	outputs = list(
		"volume" = IC_PINTYPE_NUMBER,
		"self reference" = IC_PINTYPE_SELFREF
		)
	activators = list(
		"spray" = IC_PINTYPE_PULSE_IN,
		"on sprayed" = IC_PINTYPE_PULSE_OUT,
		"on fail" = IC_PINTYPE_PULSE_OUT,
		"push ref" = IC_PINTYPE_PULSE_IN
		)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 15
	var/busy = FALSE

/obj/item/integrated_circuit/reagent/extinguisher/Initialize()
	.=..()
	set_pin_data(IC_OUTPUT,2, src)

/obj/item/integrated_circuit/reagent/extinguisher/on_reagent_change(changetype)
	push_vol()

/obj/item/integrated_circuit/reagent/extinguisher/do_work()
	//Check if enough volume
	if(!reagents || reagents.total_volume < 10)
		push_data()
		activate_pin(3)
		return

	var/mob/living/user = null
	if(ismob(src.loc))
		user = src.loc
	else if(ismob(src.loc.loc))
		user = src.loc.loc
	var/atom/movable/A = get_pin_data(IC_INPUT, 1)
	if(!extinguish_spray(A, user, 10, spray_size = 3, delay = 10, spray_particles = 3))
		activate_pin(3)
	push_vol()
	activate_pin(2)


