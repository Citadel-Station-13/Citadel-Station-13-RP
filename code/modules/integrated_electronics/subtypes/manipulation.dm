/obj/item/integrated_circuit/manipulation
	category_text = "Manipulation"

/obj/item/integrated_circuit/manipulation/locomotion
	name = "locomotion circuit"
	desc = "This allows a machine to move in a given direction."
	icon_state = "locomotion"
	extended_desc = "The circuit accepts a 'dir' number as a direction to move towards.<br>\
	Pulsing the 'step towards dir' activator pin will cause the machine to move one step in that direction, assuming it is not \
	being held, or anchored in some way.  It should be noted that the ability to move is dependant on the type of assembly that this circuit inhabits; only drone assemblies can move."
	w_class = ITEMSIZE_NORMAL
	complexity = 10
	cooldown_per_use = 1
	ext_cooldown = 4
	inputs = list("direction" = IC_PINTYPE_DIR)
	outputs = list("obstacle" = IC_PINTYPE_REF)
	activators = list("step towards dir" = IC_PINTYPE_PULSE_IN,"on step"=IC_PINTYPE_PULSE_OUT,"blocked"=IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	action_flags = IC_ACTION_MOVEMENT
	power_draw_per_use = 100

/obj/item/integrated_circuit/manipulation/locomotion/do_work(ord)
	if(ord == 1)
		..()
		var/turf/T = get_turf(src)
		if(T && assembly)
			if(assembly.anchored || !assembly.can_move())
				return
			if(assembly.loc == T) // Check if we're held by someone.  If the loc is the floor, we're not held.
				var/datum/integrated_io/wanted_dir = inputs[1]
				if(isnum(wanted_dir.data))
					if(step(assembly, wanted_dir.data))
						activate_pin(2)
						return
					else
						set_pin_data(IC_OUTPUT, 1, WEAKREF(assembly.collw))
						push_data()
						activate_pin(3)
						return FALSE
		return FALSE

/obj/item/integrated_circuit/manipulation/anchoring
	name = "anchoring bolts"
	desc = "Pop-out anchoring bolts which can secure an assembly to the floor."

	outputs = list(
		"enabled" = IC_PINTYPE_BOOLEAN
	)
	activators = list(
		"toggle" = IC_PINTYPE_PULSE_IN,
		"on toggle" = IC_PINTYPE_PULSE_OUT
	)

	complexity = 8
	cooldown_per_use = 2 SECOND
	power_draw_per_use = 50
	spawn_flags = IC_SPAWN_DEFAULT
	origin_tech = list(TECH_ENGINEERING = 2)

/obj/item/integrated_circuit/manipulation/anchoring/remove(mob/user, silent, index)
	if(assembly.anchored_by == src)
		silent ? null : to_chat(SPAN_WARNING("With the bolts deployed you can't remove the circuit."))
		return
	. = ..()

/obj/item/integrated_circuit/manipulation/anchoring/do_work(ord)
	//var/obj/item/electronic_assembly/ass = assembly
	if(!isturf(assembly.loc))
		return

	if(ord == 1)
		if(assembly.anchored && assembly.anchored_by != src)
			audible_message(SPAN_WARNING("The [assembly] whirrs and clanks!"), SPAN_NOTICE("You hear a soft whirr then a clank."))
			return
		assembly.anchored = !assembly.anchored
		assembly.anchored ? (assembly.anchored_by = src) : (assembly.anchored_by = null)

		visible_message(
			assembly.anchored ? \
			"<span class='notice'>\The [get_object()] deploys a set of anchoring bolts!</span>" \
			: \
			"<span class='notice'>\The [get_object()] retracts its anchoring bolts</span>"
		)

		set_pin_data(IC_OUTPUT, 1, assembly.anchored)
		push_data()
		activate_pin(2)

/obj/item/integrated_circuit/manipulation/hatchlock
	name = "maintenance hatch lock"
	desc = "An electronically controlled lock for the assembly's maintenance hatch."
	extended_desc = "WARNING: If you lock the hatch with no circuitry to reopen it, there is no way to open the hatch again!"
	icon_state = "hatch_lock"

	outputs = list(
		"enabled" = IC_PINTYPE_BOOLEAN
	)
	activators = list(
		"toggle" = IC_PINTYPE_PULSE_IN,
		"on toggle" = IC_PINTYPE_PULSE_OUT
	)

	complexity = 4
	cooldown_per_use = 2 SECOND
	power_draw_per_use = 50
	spawn_flags = IC_SPAWN_DEFAULT
	origin_tech = list(TECH_ENGINEERING = 2)
	var/lock_enabled = -1

/obj/item/integrated_circuit/manipulation/hatchlock/do_work(ord)
	if(ord == 1)
		if(!assembly)
			return
		visible_message(SPAN_NOTICE("\The [assembly] whirrs.[assembly.panel_locked > 1 ? null : lock_enabled ? " The screws are now covered." : " The screws are now exposed!"]"))
		lock_enabled *= -1
		assembly.panel_locked += lock_enabled
		set_pin_data(IC_OUTPUT, 1, lock_enabled)
		push_data()
		activate_pin(2)

/obj/item/integrated_circuit/manipulation/hatchlock/remove(mob/user, silent, index)
	lock_enabled ? (assembly.panel_locked -= 1) : null
	. = ..()

/obj/item/integrated_circuit/manipulation/plant_module
	name = "plant manipulation module"
	desc = "Used to uproot weeds and harvest/plant trays."
	icon_state = "plant_m"
	extended_desc = "The circuit accepts a reference to a hydroponic tray or an item on an adjacent tile.  \
	Mode input (0-harvest, 1-uproot weeds, 2-uproot plant, 3-plant seed) determines action.  \
	Harvesting outputs a list of the harvested plants."
	w_class = WEIGHT_CLASS_TINY
	complexity = 10
	inputs = list("tray" = IC_PINTYPE_REF,"mode" = IC_PINTYPE_NUMBER,"item" = IC_PINTYPE_REF)
	outputs = list("result" = IC_PINTYPE_LIST)
	activators = list("pulse in" = IC_PINTYPE_PULSE_IN,"pulse out" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 50

/obj/item/integrated_circuit/manipulation/plant_module/do_work(ord)
	if(ord == 1)
		..()
		var/obj/acting_object = get_object()
		var/obj/OM = get_pin_data_as_type(IC_INPUT, 1, /obj)
		var/obj/O = get_pin_data_as_type(IC_INPUT, 3, /obj/item)

		if(!check_target(OM))
			push_data()
			activate_pin(2)
			return
	/*	TBI May be pointless.  Testing needed on vines.
		if(istype(OM,/obj/structure/spacevine) && check_target(OM) && get_pin_data(IC_INPUT, 2) == 2)
			qdel(OM)
			push_data()
			activate_pin(2)
			return
	*/
		var/obj/machinery/portable_atmospherics/hydroponics/TR = OM
		if(istype(TR))
			switch(get_pin_data(IC_INPUT, 2))
				if(0)
					var/list/harvest_output = TR.attack_hand()
					for(var/i in 1 to length(harvest_output))
						harvest_output[i] = WEAKREF(harvest_output[i])

					if(length(harvest_output))
						set_pin_data(IC_OUTPUT, 1, harvest_output)
						push_data()
				if(1)
					TR.weedlevel = 0
					TR.update_icon()
				if(2)
					if(TR.seed) //Could be that they're just using it as a de-weeder
						TR.age = 0
						TR.health = 0
						if(TR.harvest)
							TR.harvest = FALSE //To make sure they can't just put in another seed and insta-harvest it
						qdel(TR.seed)
						TR.seed = null
					TR.weedlevel = 0 //Has a side effect of cleaning up those nasty weeds
					TR.dead = 0
					TR.update_icon()
				if(3)
					if(!check_target(O))
						activate_pin(2)
						return FALSE

					else if(istype(O, /obj/item/seeds)/* && !istype(O, /obj/item/seeds/sample)*/)
						if(!TR.seed)

							if(istype(O, /obj/item/seeds/kudzuseed))
								investigate_log("had Kudzu planted in it by [acting_object] at [AREACOORD(src)]","kudzu")
							acting_object.visible_message("<span class='notice'>[acting_object] plants [O].</span>")
							TR.plant_seeds(O)
		activate_pin(2)

/obj/item/integrated_circuit/manipulation/seed_extractor
	name = "seed extractor module"
	desc = "Used to extract seeds from grown produce."
	icon_state = "plant_m"
	extended_desc = "The circuit accepts a reference to a plant item and extracts seeds from it, outputting the results to a list."
	complexity = 8
	inputs = list("target" = IC_PINTYPE_REF)
	outputs = list("result" = IC_PINTYPE_LIST)
	activators = list("pulse in" = IC_PINTYPE_PULSE_IN,"pulse out" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 50
/* TBI:	Move seed extrac proc to root
/obj/item/integrated_circuit/manipulation/seed_extractor/do_work()
	..()
	var/obj/O = get_pin_data_as_type(IC_INPUT, 1, /obj/item)
	if(!check_target(O))
		push_data()
		activate_pin(2)
		return

	var/list/seed_output = seedify(O, -1)
	for(var/i in 1 to length(seed_output))
		seed_output[i] = WEAKREF(seed_output[i])

	if(seed_output.len)
		set_pin_data(IC_OUTPUT, 1, seed_output)
		push_data()
	activate_pin(2)
*/
/obj/item/integrated_circuit/manipulation/grabber
	name = "grabber"
	desc = "A circuit with its own inventory for items.  Used to grab and store things."
	icon_state = "grabber"
	extended_desc = "This circuit accepts a reference to an object to be grabbed, and can store up to 10 objects.  Modes: 1 to grab, 0 to eject the first object, -1 to eject all objects, and -2 to eject the target.  If you throw something from a grabber's inventory with a thrower, the grabber will update its outputs accordingly."
	w_class = WEIGHT_CLASS_SMALL
	size = 3
	cooldown_per_use = 5
	complexity = 10
	inputs = list("target" = IC_PINTYPE_REF,"mode" = IC_PINTYPE_NUMBER)
	outputs = list("first" = IC_PINTYPE_REF, "last" = IC_PINTYPE_REF, "amount" = IC_PINTYPE_NUMBER,"contents" = IC_PINTYPE_LIST)
	activators = list("pulse in" = IC_PINTYPE_PULSE_IN,"pulse out" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	action_flags = IC_ACTION_COMBAT
	power_draw_per_use = 50
	var/max_items = 10

/obj/item/integrated_circuit/manipulation/grabber/do_work(ord)
	if(ord == 1)
		var/obj/item/AM = get_pin_data_as_type(IC_INPUT, 1, /obj/item)
		if(!QDELETED(AM) && !istype(AM, /obj/item/electronic_assembly) && !istype(AM, /obj/item/transfer_valve) && !istype(assembly.loc, /obj/item/implant/compressed))
			var/mode = get_pin_data(IC_INPUT, 2)
			switch(mode)
				if(1)
					grab(AM)
				if(0)
					if(contents.len)
						drop(contents[1])
				if(-1)
					drop_all()
				if(-2)
					drop(AM)
		update_outputs()
		activate_pin(2)

/obj/item/integrated_circuit/manipulation/grabber/proc/grab(obj/item/AM)
	var/max_w_class = assembly.w_class
	if(check_target(AM))
		if(contents.len < max_items && AM.w_class <= max_w_class)
			var/atom/A = get_object()
			A.investigate_log("picked up ([AM]) with [src].", INVESTIGATE_CIRCUIT)
			AM.forceMove(src)

/obj/item/integrated_circuit/manipulation/grabber/proc/drop(obj/item/AM, turf/T = drop_location())
	if(!check_target(AM, FALSE, TRUE, TRUE, TRUE))
		return
	var/atom/A = get_object()
	A.investigate_log("dropped ([AM]) from [src].", INVESTIGATE_CIRCUIT)
	AM.forceMove(T)

/obj/item/integrated_circuit/manipulation/grabber/proc/drop_all()
	if(contents.len)
		var/turf/T = drop_location()
		var/obj/item/U
		for(U in src)
			drop(U, T)

/obj/item/integrated_circuit/manipulation/grabber/proc/update_outputs()
	if(contents.len)
		set_pin_data(IC_OUTPUT, 1, WEAKREF(contents[1]))
		set_pin_data(IC_OUTPUT, 2, WEAKREF(contents[contents.len]))
	else
		set_pin_data(IC_OUTPUT, 1, null)
		set_pin_data(IC_OUTPUT, 2, null)
	set_pin_data(IC_OUTPUT, 3, contents.len)
	set_pin_data(IC_OUTPUT, 4, contents)
	push_data()

/obj/item/integrated_circuit/manipulation/grabber/attack_self(var/mob/user)
	drop_all()
	update_outputs()
	push_data()

/obj/item/integrated_circuit/manipulation/claw
	name = "pulling claw"
	desc = "Circuit which can pull things.."
	icon_state = "pull_claw"
	extended_desc = "This circuit accepts a reference to a thing to be pulled.  Modes: 0 for release.  1 for pull."
	w_class = WEIGHT_CLASS_SMALL
	size = 3
	cooldown_per_use = 5
	complexity = 10
	inputs = list("target" = IC_PINTYPE_REF,"mode" = IC_PINTYPE_INDEX,"dir" = IC_PINTYPE_DIR)
	outputs = list("is pulling" = IC_PINTYPE_BOOLEAN)
	activators = list("pulse in" = IC_PINTYPE_PULSE_IN,"pulse out" = IC_PINTYPE_PULSE_OUT,"release" = IC_PINTYPE_PULSE_IN,"pull to dir" = IC_PINTYPE_PULSE_IN,"released" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 50
	ext_cooldown = 1
	var/max_grab = GRAB_PASSIVE

/obj/item/integrated_circuit/manipulation/claw/do_work(ord)
	var/obj/acting_object = get_object()
	var/atom/movable/AM = get_pin_data_as_type(IC_INPUT, 1, /atom/movable)
	var/mode = get_pin_data(IC_INPUT, 2)
	switch(ord)
		if(1)
			mode = clamp(mode, GRAB_PASSIVE, max_grab)
			if(AM)
				if(check_target(AM, exclude_contents = TRUE))
					acting_object.investigate_log("grabbed ([AM]) using [src].", INVESTIGATE_CIRCUIT)
					acting_object.start_pulling(AM,mode)
					if(acting_object.pulling)
						set_pin_data(IC_OUTPUT, 1, TRUE)
					else
						set_pin_data(IC_OUTPUT, 1, FALSE)
			push_data()

		if(3)
			stop_pulling()

		if(4)
			if(acting_object.pulling)
				var/dir = get_pin_data(IC_INPUT, 3)
				var/turf/G =get_step(get_turf(acting_object),dir)
				var/atom/movable/pullee = acting_object.pulling
				var/turf/Pl = get_turf(pullee)
				var/turf/F = get_step_towards(Pl,G)
				if(acting_object.Adjacent(F))
					if(!step_towards(pullee, F))
						F = get_step_towards2(Pl,G)
						if(acting_object.Adjacent(F))
							step_towards(pullee, F)
	activate_pin(2)

/obj/item/integrated_circuit/manipulation/claw/stop_pulling()
	set_pin_data(IC_OUTPUT, 1, FALSE)
	activate_pin(5)
	push_data()
	..()

/obj/item/integrated_circuit/manipulation/thrower
	name = "thrower"
	desc = "A compact launcher to throw things from inside or nearby tiles at a low enough velocity not to harm someone."
	extended_desc = "The first and second inputs need to be numbers which correspond to the coordinates to throw objects at relative to the machine itself.  \
	The 'fire' activator will cause the mechanism to attempt to throw objects at the coordinates, if possible.  Note that the \
	projectile needs to be inside the machine, or on an adjacent tile, and must be medium sized or smaller.  The assembly \
	must also be a gun if you wish to throw something while the assembly is in hand."
	complexity = 25
	w_class = WEIGHT_CLASS_SMALL
	size = 2
	cooldown_per_use = 10
	ext_cooldown = 1
	inputs = list(
		"target X rel" = IC_PINTYPE_NUMBER,
		"target Y rel" = IC_PINTYPE_NUMBER,
		"projectile" = IC_PINTYPE_REF
		)
	outputs = list()
	activators = list(
		"fire"		= IC_PINTYPE_PULSE_IN,
		"on success"= IC_PINTYPE_PULSE_OUT,
		"on fail"	= IC_PINTYPE_PULSE_OUT
	)
	spawn_flags = IC_SPAWN_RESEARCH
	action_flags = IC_ACTION_COMBAT
	power_draw_per_use = 50

/obj/item/integrated_circuit/manipulation/thrower/do_work(ord)
	if(ord == 1)
		set waitfor = FALSE // Don't sleep in a proc that is called by a processor without this set, otherwise it'll delay the entire thing
		var/max_w_class = assembly.w_class
		var/target_x_rel = round(get_pin_data(IC_INPUT, 1))
		var/target_y_rel = round(get_pin_data(IC_INPUT, 2))
		var/obj/item/A = get_pin_data_as_type(IC_INPUT, 3, /obj/item)

		if(!A || A.anchored || A.throwing || A == assembly || istype(A, /obj/item/transfer_valve)/* || A.GetComponent(/datum/component/two_handed)*/)
			activate_pin(3)
			return

		if (istype(assembly.loc, /obj/item/implant)) //Prevents the more abusive form of chestgun.
			activate_pin(3)
			return

		if(max_w_class && (A.w_class > max_w_class))
			activate_pin(3)
			return

		if(!assembly.can_fire_equipped && ishuman(assembly.loc))
			activate_pin(3)
			return

		// Is the target inside the assembly or close to it?
		if(!check_target(A, exclude_components = TRUE))
			activate_pin(3)
			return

		var/turf/T = get_turf(get_object())
		if(!T)
			activate_pin(3)
			return

		// If the item is in mob's inventory, try to remove it from there.
		if(ismob(A.loc))
			var/mob/living/M = A.loc
			if(A.current_equipped_slot && M.canUnEquip(A))
				visible_message(SPAN_DANGER("\The [src] is trying to remove \the [M]'s [A.name]!"))
				do_atom(src, M, HUMAN_STRIP_DELAY)
				if(!check_target(A, exclude_components = TRUE))
					activate_pin(3)
					return
				add_attack_logs("IC Assembly",src,"Removed equipment from slot [A]")
				M.unEquip(A)
				activate_pin(2)
				return TRUE
			if(!M.unEquip(A))
				activate_pin(3)
				return

		// If the item is in a grabber circuit we'll update the grabber's outputs after we've thrown it.
		var/obj/item/integrated_circuit/manipulation/grabber/G = A.loc

		var/x_abs = clamp(T.x + target_x_rel, 0, world.maxx)
		var/y_abs = clamp(T.y + target_y_rel, 0, world.maxy)
		var/range = round(clamp(sqrt(target_x_rel*target_x_rel+target_y_rel*target_y_rel),0,8),1)

		//throw it
		assembly.visible_message("<span class='danger'>[assembly] has thrown [A]!</span>")
		log_attack("[assembly] [REF(assembly)] has thrown [A] with non-lethal force.")
		A.forceMove(drop_location())
		A.throw_at(locate(x_abs, y_abs, T.z), range, 3, src)

		// If the item came from a grabber now we can update the outputs since we've thrown it.
		if(istype(G))
			G.update_outputs()
		activate_pin(2)

/*!	TBI: Material update
/obj/item/integrated_circuit/manipulation/matman
	name = "material manager"
	desc = "This circuit is designed for automatic storage and distribution of materials."
	extended_desc = "The first input takes a ref of a machine with a material container.  \
					Second input is used for inserting material stacks into the internal material storage.  \
					Inputs 3-13 are used to transfer materials between target machine and circuit storage.  \
					Positive values will take that number of materials from another machine.  \
					Negative values will fill another machine from internal storage.  Outputs show current stored amounts of mats."
	icon_state = "grabber"
	complexity = 16
	inputs = list(
		"target" 				= IC_PINTYPE_REF,
		"sheets to insert"	 	= IC_PINTYPE_NUMBER,
		"Metal"				 	= IC_PINTYPE_NUMBER,
		"Glass"					= IC_PINTYPE_NUMBER,
		"Silver"				= IC_PINTYPE_NUMBER,
		"Gold"					= IC_PINTYPE_NUMBER,
		"Diamond"				= IC_PINTYPE_NUMBER,
		"Uranium"				= IC_PINTYPE_NUMBER,
		"Solid Plasma"			= IC_PINTYPE_NUMBER,
		"Bluespace Mesh"		= IC_PINTYPE_NUMBER,
		"Bananium"				= IC_PINTYPE_NUMBER,
		"Titanium"				= IC_PINTYPE_NUMBER,
		"Plastic"				= IC_PINTYPE_NUMBER
		)
	outputs = list(
		"self ref" 				= IC_PINTYPE_REF,
		"Total amount"		 	= IC_PINTYPE_NUMBER,
		"Metal"				 	= IC_PINTYPE_NUMBER,
		"Glass"					= IC_PINTYPE_NUMBER,
		"Silver"				= IC_PINTYPE_NUMBER,
		"Gold"					= IC_PINTYPE_NUMBER,
		"Diamond"				= IC_PINTYPE_NUMBER,
		"Uranium"				= IC_PINTYPE_NUMBER,
		"Solid Plasma"			= IC_PINTYPE_NUMBER,
		"Bluespace Mesh"		= IC_PINTYPE_NUMBER,
		"Bananium"				= IC_PINTYPE_NUMBER,
		"Titanium"				= IC_PINTYPE_NUMBER,
		"Plastic"				= IC_PINTYPE_NUMBER
		)
	activators = list(
		"insert sheet" = IC_PINTYPE_PULSE_IN,
		"transfer mats" = IC_PINTYPE_PULSE_IN,
		"on success" = IC_PINTYPE_PULSE_OUT,
		"on failure" = IC_PINTYPE_PULSE_OUT,
		"push ref" = IC_PINTYPE_PULSE_IN,
		"on push ref" = IC_PINTYPE_PULSE_IN
		)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 40
	ext_cooldown = 1
	cooldown_per_use = 10
	var/static/list/mtypes = list(
		/datum/material/iron,
		/datum/material/glass,
		/datum/material/silver,
		/datum/material/gold,
		/datum/material/diamond,
		/datum/material/uranium,
		/datum/material/plasma,
		/datum/material/bluespace,
		/datum/material/bananium,
		/datum/material/titanium,
		/datum/material/plastic
		)

/obj/item/integrated_circuit/manipulation/matman/ComponentInitialize()
	var/datum/component/material_container/materials = AddComponent(/datum/component/material_container, mtypes, 100000, FALSE, /obj/item/stack, CALLBACK(src, .proc/is_insertion_ready), CALLBACK(src, .proc/AfterMaterialInsert))
	materials.precise_insertion = TRUE
	.=..()

/obj/item/integrated_circuit/manipulation/matman/proc/AfterMaterialInsert(type_inserted, id_inserted, amount_inserted)
	var/datum/component/material_container/materials = GetComponent(/datum/component/material_container)
	set_pin_data(IC_OUTPUT, 2, materials.total_amount)
	for(var/I in 1 to mtypes.len)
		var/datum/material/M = materials.materials[SSmaterials.GetMaterialRef(I)]
		var/amount = materials[M]
		if(M)
			set_pin_data(IC_OUTPUT, I+2, amount)
	push_data()

/obj/item/integrated_circuit/manipulation/matman/proc/is_insertion_ready(mob/user)
	return TRUE

/obj/item/integrated_circuit/manipulation/matman/do_work(ord)
	var/datum/component/material_container/materials = GetComponent(/datum/component/material_container)
	var/atom/movable/H = get_pin_data_as_type(IC_INPUT, 1, /atom/movable)
	if(!check_target(H))
		activate_pin(4)
		return
	var/turf/T = get_turf(H)
	switch(ord)
		if(1)
			var/obj/item/stack/sheet/S = H
			if(!S)
				activate_pin(4)
				return
			if(materials.insert_item(S, clamp(get_pin_data(IC_INPUT, 2),0,100), multiplier = 1) )
				AfterMaterialInsert()
				activate_pin(3)
			else
				activate_pin(4)
		if(2)
			var/datum/component/material_container/mt = H.GetComponent(/datum/component/material_container)
			var/suc
			for(var/I in 1 to mtypes.len)
				var/datum/material/M = materials.materials[mtypes[I]]
				if(M)
					var/U = clamp(get_pin_data(IC_INPUT, I+2),-100000,100000)
					if(!U)
						continue
					if(!mt) //Invalid input
						if(U>0)
							if(materials.retrieve_sheets(U, SSmaterials.GetMaterialRef(mtypes[I]), T))
								suc = TRUE
					else
						if(mt.transer_amt_to(materials, U, mtypes[I]))
							suc = TRUE
			if(suc)
				AfterMaterialInsert()
				activate_pin(3)
			else
				activate_pin(4)
		if(5)
			set_pin_data(IC_OUTPUT, 1, WEAKREF(src))
			AfterMaterialInsert()
			activate_pin(6)

/obj/item/integrated_circuit/manipulation/matman/Destroy()
	var/datum/component/material_container/materials = GetComponent(/datum/component/material_container)
	materials.retrieve_all()
	.=..()
*/

//Hippie Ported Code--------------------------------------------------------------------------------------------------------


// - inserter circuit - //
/obj/item/integrated_circuit/manipulation/inserter
	name = "inserter"
	desc = "A nimble circuit that puts stuff inside a storage like a backpack and can take it out aswell."
	icon_state = "grabber"
	extended_desc = "This circuit accepts a reference to an object to be inserted or extracted depending on mode.  If a storage is given for extraction, the extracted item will be put in the new storage.  Modes: 1 insert, 0 to extract."
	w_class = WEIGHT_CLASS_SMALL
	size = 3
	cooldown_per_use = 5
	complexity = 10
	can_be_asked_input = TRUE
	inputs = list("target object" = IC_PINTYPE_REF, "target container" = IC_PINTYPE_REF,"mode" = IC_PINTYPE_BOOLEAN)
	activators = list("pulse in" = IC_PINTYPE_PULSE_IN,"on success" = IC_PINTYPE_PULSE_OUT,"on fail" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	action_flags = IC_ACTION_COMBAT
	power_draw_per_use = 20
	var/max_items = 10

/obj/item/integrated_circuit/manipulation/inserter/do_work(ord)
	if(ord == 1)
		//There shouldn't be any target required to eject all contents
		var/obj/item/target_obj = get_pin_data_as_type(IC_INPUT, 1, /obj/item)
		if(!target_obj)
			activate_pin(3)
			return

		var/distance = get_dist(get_turf(src),get_turf(target_obj))
		if(distance > 1)
			activate_pin(3)
			return

		var/atom/movable/A = get_pin_data(IC_INPUT, 2)
		var/mode = get_pin_data(IC_INPUT, 3)
		switch(mode)
			if(1)
				if(A && !isstorage(A) && Adjacent(A))
					A.attackby(src, target_obj)
					activate_pin(2)
					return TRUE
				if(istype(A,/obj/item/integrated_circuit) && Adjacent(A))
					A.attackby(src, target_obj)
					activate_pin(2)
					return TRUE
			if(0)
				if(A && isstorage(A) && Adjacent(A))
					var/obj/item/storage/S = A
					S.remove_from_storage(target_obj,drop_location())
					activate_pin(2)
					return TRUE
				return

/obj/item/integrated_circuit/mining/mining_drill
	name = "mining drill"
	desc = "A mining drill that can drill through rocks."
	extended_desc = "A mining drill to strike the earth.  It takes some time to get the job done and \
	must remain stationary until complete."
	category_text = "Manipulation"
	ext_cooldown = 1
	complexity = 40
	cooldown_per_use = 3 SECONDS
	ext_cooldown = 6 SECONDS
	inputs = list(
		"target" = IC_PINTYPE_REF
		)
	outputs = list()
	activators = list(
		"drill" = IC_PINTYPE_PULSE_IN,
		"on success" = IC_PINTYPE_PULSE_OUT,
		"on failure" = IC_PINTYPE_PULSE_OUT
		)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 1000

	var/busy = FALSE
	var/targetlock
	var/usedx
	var/usedy
	var/targx
	var/targy
	var/drill_force = 15
	var/turf/simulated/mineral

/obj/item/integrated_circuit/mining/mining_drill/do_work(ord)
	if(ord == 1)
		var/atom/target = get_pin_data(IC_INPUT, 1)
		var/drill_delay = null
		if(!target || busy)
			activate_pin(3)
			return
		src.assembly.visible_message(SPAN_DANGER("[assembly] starts to drill [target]!"), null, SPAN_WARNING("You hear a drill."))
		drill_delay = isturf(target)? 6 SECONDS : isliving(target) ? issimple(target) ? 2 SECONDS : 3 SECONDS : 4 SECONDS
		busy = TRUE
		targetlock = target
		usedx = assembly.loc.x
		usedy = assembly.loc.y
		targx = target.loc.x
		targy = target.loc.y
		playsound(src, 'sound/items/drill_use.ogg',50,1)
		addtimer(CALLBACK(src, .proc/drill), drill_delay)


/obj/item/integrated_circuit/mining/mining_drill/proc/drill()
	var/atom/target = get_pin_data(IC_INPUT, 1)
	busy = FALSE
	// The assembly was moved, hence stopping the mining OR the rock was mined before
	if(usedx != assembly.loc.x || usedy != assembly.loc.y || targx != target.loc.x || targy != target.loc.y || target != targetlock)
		activate_pin(3)
		return FALSE
	if(isliving(target))
		if(ishuman(target))
			var/mob/living/carbon/human/S = target
			S.apply_damage(drill_force, BRUTE)
			return
		else if(issimple(target))
			var/mob/living/simple_mob/S = target
			if(S.stat == DEAD)
				if(S.meat_amount > 0)
					S.harvest(assembly)
					return
				else
					S.gib()
					return
		else
			var/mob/living/S = target
			S.apply_damage(drill_force)
			return
	if(istype(target, /turf/simulated/mineral))
		var/turf/simulated/mineral/S = target
		if(S.finds && S.finds.len)
			visible_message(SPAN_WARNING("<b>[pick("There is a crunching noise","[assembly]'s [src] collides with some different rock","Part of the rock face crumbles away","Something breaks under [assembly]'s [src]")]</b>"))
		if(istype(S, /turf/simulated/mineral))
			S.GetDrilled()
			investigate_log("Drilled through [target]")
		else if(istype(S, /turf/simulated/wall))
			investigate_log("Drilled through [target]")
			S.ex_act(2)
	else
		investigate_log("Drilled through [target]")
		target.ex_act(2)
	activate_pin(2)
	return(TRUE)



// Renamer circuit.  Renames the assembly it is in.  Useful in cooperation with telecomms-based circuits.
/obj/item/integrated_circuit/manipulation/renamer
	name = "renamer"
	desc = "A small circuit that renames the assembly it is in.  Useful paired with speech-based circuits."
	icon_state = "internalbm"
	extended_desc = "This circuit accepts a string as input, and can be pulsed to rewrite the current assembly's name with said string.  On success, it pulses the default pulse-out wire."
	inputs = list("name" = IC_PINTYPE_STRING)
	outputs = list("current name" = IC_PINTYPE_STRING)
	activators = list("rename" = IC_PINTYPE_PULSE_IN,"get name" = IC_PINTYPE_PULSE_IN,"pulse out" = IC_PINTYPE_PULSE_OUT)
	power_draw_per_use = 1
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/manipulation/renamer/do_work(ord)
	if(!assembly)
		return
	switch(ord)
		if(1)
			var/new_name = sanitizeSafe(get_pin_data(IC_INPUT, 1),MAX_NAME_LEN)
			if(new_name)
				assembly.name = new_name

		else
			set_pin_data(IC_OUTPUT, 1, assembly.name)
			push_data()

	activate_pin(3)



// - redescribing circuit - //
/obj/item/integrated_circuit/manipulation/redescribe
	name = "redescriber"
	desc = "Takes any string as an input and will set it as the assembly's description."
	extended_desc = "Strings should can be of any length."
	icon_state = "speaker"
	cooldown_per_use = 10
	complexity = 3
	inputs = list("text" = IC_PINTYPE_STRING)
	outputs = list("description" = IC_PINTYPE_STRING)
	activators = list("redescribe" = IC_PINTYPE_PULSE_IN,"get description" = IC_PINTYPE_PULSE_IN,"pulse out" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/manipulation/redescribe/do_work(ord)
	if(!assembly)
		return

	switch(ord)
		if(1)
			assembly.desc = get_pin_data(IC_INPUT, 1)

		else
			set_pin_data(IC_OUTPUT, 1, assembly.desc)
			push_data()

	activate_pin(3)

// - repainting circuit - //
/obj/item/integrated_circuit/manipulation/repaint
	name = "auto-repainter"
	desc = "There's an oddly high amount of spraying cans fitted right inside this circuit."
	extended_desc = "Takes a value in hexadecimal and uses it to repaint the assembly it is in."
	cooldown_per_use = 10
	complexity = 3
	inputs = list("color" = IC_PINTYPE_COLOR)
	outputs = list("current color" = IC_PINTYPE_COLOR)
	activators = list("repaint" = IC_PINTYPE_PULSE_IN,"get color" = IC_PINTYPE_PULSE_IN,"pulse out" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/manipulation/repaint/do_work(ord)
	if(!assembly)
		return

	switch(ord)
		if(1)
			assembly.detail_color = get_pin_data(IC_INPUT, 1)
			assembly.update_icon()

		else
			set_pin_data(IC_OUTPUT, 1, assembly.detail_color)
			push_data()

	activate_pin(3)

/obj/item/integrated_circuit/manipulation/weapon_firing
	name = "weapon firing mechanism"
	desc = "This somewhat complicated system allows one to slot in a gun, direct it towards a position, and remotely fire it."
	extended_desc = "The firing mechanism can slot in most ranged weapons, ballistic and energy.  \
	The first and second inputs need to be numbers.  They are coordinates for the gun to fire at, relative to the machine itself.  \
	The 'fire' activator will cause the mechanism to attempt to fire the weapon at the coordinates, if possible.  Note that the \
	normal limitations to firearms, such as ammunition requirements and firing delays, still hold true if fired by the mechanism."
	complexity = 20
	w_class = ITEMSIZE_NORMAL
	size = 3
	can_be_asked_input = TRUE
	inputs = list(
		"target X rel" = IC_PINTYPE_NUMBER,
		"target Y rel" = IC_PINTYPE_NUMBER
		)
	outputs = list()
	activators = list(
		"fire" = IC_PINTYPE_PULSE_IN
	)
	var/obj/item/gun/installed_gun = null
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3, TECH_COMBAT = 4)
	power_draw_per_use = 50 // The targeting mechanism uses this.  The actual gun uses its own cell for firing if it's an energy weapon.

/obj/item/integrated_circuit/manipulation/weapon_firing/Destroy()
	installed_gun = null // It will be qdel'd by ..() if still in our contents
	return ..()

/obj/item/integrated_circuit/manipulation/weapon_firing/proc/ask_for_input(obj/item/I, mob/living/user, a_intent)
	if(!isobj(I))
		return FALSE
	attackby_react(I, user, a_intent)

/obj/item/integrated_circuit/manipulation/weapon_firing/attackby_react(var/obj/O, var/mob/user)
	if(istype(O, /obj/item/gun))
		var/obj/item/gun/gun = O
		if(installed_gun)
			to_chat(user, "<span class='warning'>There's already a weapon installed.</span>")
			return
		user.drop_from_inventory(gun)
		installed_gun = gun
		size += gun.w_class
		gun.forceMove(src)
		to_chat(user, "<span class='notice'>You slide \the [gun] into the firing mechanism.</span>")
		playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
	else
		..()

/obj/item/integrated_circuit/manipulation/weapon_firing/attack_self(var/mob/user)
	if(installed_gun)
		installed_gun.forceMove(get_turf(src))
		to_chat(user, "<span class='notice'>You slide \the [installed_gun] out of the firing mechanism.</span>")
		size = initial(size)
		playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
		installed_gun = null
	else
		to_chat(user, "<span class='notice'>There's no weapon to remove from the mechanism.</span>")

/obj/item/integrated_circuit/manipulation/weapon_firing/do_work()
	if(!installed_gun)
		return

	var/datum/integrated_io/target_x = inputs[1]
	var/datum/integrated_io/target_y = inputs[2]

	if(src.assembly)
		if(isnum(target_x.data))
			target_x.data = round(target_x.data)
		if(isnum(target_y.data))
			target_y.data = round(target_y.data)

		var/turf/T = get_turf(src.assembly)

		if(target_x.data == 0 && target_y.data == 0) // Don't shoot ourselves.
			return

		// We need to do this in order to enable relative coordinates, as locate() only works for absolute coordinates.
		var/i
		if(target_x.data > 0)
			i = abs(target_x.data)
			while(i > 0)
				T = get_step(T, EAST)
				i--
		else
			i = abs(target_x.data)
			while(i > 0)
				T = get_step(T, WEST)
				i--

		i = 0
		if(target_y.data > 0)
			i = abs(target_y.data)
			while(i > 0)
				T = get_step(T, NORTH)
				i--
		else if(target_y.data < 0)
			i = abs(target_y.data)
			while(i > 0)
				T = get_step(T, SOUTH)
				i--

		if(!T)
			return
		installed_gun.Fire_userless(T)


/obj/item/integrated_circuit/manipulation/grenade
	name = "grenade primer"
	desc = "This circuit comes with the ability to attach most types of grenades at prime them at will."
	extended_desc = "Time between priming and detonation is limited to between 1 to 12 seconds but is optional.  \
					If unset, not a number, or a number less than 1 then the grenade's built-in timing will be used.  \
					Beware: Once primed there is no aborting the process!"
	icon_state = "grenade"
	complexity = 30
	size = 2
	can_be_asked_input = TRUE
	inputs = list("detonation time" = IC_PINTYPE_NUMBER)
	outputs = list()
	activators = list("prime grenade" = IC_PINTYPE_PULSE_IN)
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3, TECH_COMBAT = 4)
	var/obj/item/grenade/attached_grenade
	var/pre_attached_grenade_type

/obj/item/integrated_circuit/manipulation/grenade/Initialize(mapload)
	. = ..()
	if(pre_attached_grenade_type)
		var/grenade = new pre_attached_grenade_type(src)
		attach_grenade(grenade)

/obj/item/integrated_circuit/manipulation/grenade/Destroy()
	if(attached_grenade && !attached_grenade.active)
		attached_grenade.dropInto(loc)
	detach_grenade()
	. =..()

/obj/item/integrated_circuit/manipulation/grenade/proc/ask_for_input(obj/item/I, mob/living/user, a_intent)
	if(!isobj(I))
		return FALSE
	attackby_react(I, user, a_intent)

/obj/item/integrated_circuit/manipulation/grenade/attackby_react(var/obj/item/grenade/G, var/mob/user)
	if(istype(G))
		if(attached_grenade)
			to_chat(user, "<span class='warning'>There is already a grenade attached!</span>")
		else if(user.unEquip(G, force=1))
			user.visible_message("<span class='warning'>\The [user] attaches \a [G] to \the [src]!</span>", "<span class='notice'>You attach \the [G] to \the [src].</span>")
			attach_grenade(G)
			G.forceMove(src)
	else
		..()

/obj/item/integrated_circuit/manipulation/grenade/attack_self(var/mob/user)
	if(attached_grenade)
		user.visible_message("<span class='warning'>\The [user] removes \an [attached_grenade] from \the [src]!</span>", "<span class='notice'>You remove \the [attached_grenade] from \the [src].</span>")
		user.put_in_any_hand_if_possible(attached_grenade) || attached_grenade.dropInto(loc)
		detach_grenade()
	else
		..()

/obj/item/integrated_circuit/manipulation/grenade/do_work()
	if(attached_grenade && !attached_grenade.active)
		var/datum/integrated_io/detonation_time = inputs[1]
		if(isnum(detonation_time.data) && detonation_time.data > 0)
			attached_grenade.det_time = between(1, detonation_time.data, 12) SECONDS
		attached_grenade.activate()
		var/atom/holder = loc
		log_and_message_admins("activated a grenade assembly.  Last touches: Assembly: [holder.fingerprintslast] Circuit: [fingerprintslast] Grenade: [attached_grenade.fingerprintslast]")

/// These procs do not relocate the grenade, that's the callers responsibility
/obj/item/integrated_circuit/manipulation/grenade/proc/attach_grenade(var/obj/item/grenade/G)
	attached_grenade = G
	RegisterSignal(attached_grenade, COMSIG_PARENT_QDELETING, .proc/detach_grenade)
	size += G.w_class
	desc += " \An [attached_grenade] is attached to it!"

/obj/item/integrated_circuit/manipulation/grenade/proc/detach_grenade()
	if(!attached_grenade)
		return
	UnregisterSignal(attached_grenade, COMSIG_PARENT_QDELETING)
	attached_grenade = null
	size = initial(size)
	desc = initial(desc)

/obj/item/integrated_circuit/manipulation/grenade/frag
	pre_attached_grenade_type = /obj/item/grenade/explosive
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3, TECH_COMBAT = 10)
	spawn_flags = null			// Used for world initializing, see the #defines above.
