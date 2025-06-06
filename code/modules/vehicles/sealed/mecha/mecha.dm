
#define MECHA_INT_FIRE 1
#define MECHA_INT_TEMP_CONTROL 2
#define MECHA_INT_SHORT_CIRCUIT 4
#define MECHA_INT_TANK_BREACH 8
#define MECHA_INT_CONTROL_LOST 16

#define MELEE 1
#define RANGED 2

#define MECHA_OPERATING     0
#define MECHA_BOLTS_SECURED 1
#define MECHA_PANEL_LOOSE   2
#define MECHA_CELL_OPEN     3
#define MECHA_CELL_OUT      4

#define MECH_FACTION_NT "nano"
#define MECH_FACTION_SYNDI "syndi"
#define MECH_FACTION_NONE "none"

/obj/vehicle/sealed/mecha
	name = "Mecha"
	desc = "Exosuit"
	description_info = "Alt click to strafe."
	icon = 'icons/mecha/mecha.dmi'
	/// Dense. To raise the heat.
	density = TRUE
	/// Opaque. Menacing.
	opacity = TRUE
	/// No pulling around.
	anchored = TRUE
	integrity_flags = INTEGRITY_ACIDPROOF | INTEGRITY_FIREPROOF
	integrity = 300
	integrity_max = 300
	/// Icon draw layer.
	layer = MOB_LAYER
	/// Byond implementation is bugged.
	infra_luminosity = 15

	enter_delay = 4 SECONDS

	emulate_door_bumps = TRUE
	temporary_legacy_dont_auto_handle_obj_damage_for_mechs = TRUE

	//* Vehicle - Occupant Actions *//
	occupant_actions = list(
		/datum/action/vehicle/mecha/eject,
	)

	//* legacy below

	/// Mech type for resetting icon. Only used for reskinning kits (see custom items).
	var/initial_icon = null
	var/can_move = TRUE

	/// Make a step in step_in/10 sec.
	var/step_in = 10
	/// How many points of slowdown are negated from equipment? Added to the mech's base step_in.
	var/encumbrance_gap = 1

	/// What direction will the mech face when entered/powered on? Defaults to South.
	var/dir_in = 2
	var/step_energy_drain = 10
	/// Chance to deflect the incoming projectiles, hits, or lesser the effect of legacy_ex_act.
	var/deflect_chance = 10
	/// The values in this list show how much damage will pass through, not how much will be absorbed.
	var/list/damage_absorption = list(
		"brute"=0.8,
		"fire"=1.2,
		"bullet"=0.9,
		"laser"=1,
		"energy"=1,
		"bomb"=1,
		"bio"=1,
		"rad"=1,
	)

	/// Incoming damage lower than this won't actually deal damage. Scrapes shouldn't be a real thing.
	var/damage_minimum = 10
	/// Incoming damage won't be fully applied if you don't have at least 20. Almost all AP clears this.
	var/minimum_penetration = 15
	/// By how much failing to penetrate reduces your shit. 66% by default. 100dmg = 66dmg if failed pen.
	var/fail_penetration_value = 0.66

	var/obj/item/cell/cell
	var/state = MECHA_OPERATING
	var/list/log = new
	var/last_message = 0
	var/add_req_access = 1
	var/maint_access = 1
	/// Dna-locking the mech.
	var/dna
	/// Stores proc owners, like proc_res["functionname"] = owner reference.
	var/list/proc_res = list()
	var/datum/effect_system/spark_spread/spark_system = new
	var/lights = 0
	var/lights_power = 6
	var/force = 0

	var/mech_faction = null
	/// It's simple. If it's 0, no one entered it yet. Otherwise someone entered it at least once.
	var/firstactivation = 0

	var/stomp_sound = 'sound/mecha/mechstep.ogg'
	var/swivel_sound = 'sound/mecha/mechturn.ogg'

	//! Inner atmos
	var/use_internal_tank = 0
	var/internal_tank_valve = ONE_ATMOSPHERE
	var/obj/machinery/portable_atmospherics/canister/internal_tank
	var/datum/gas_mixture/cabin_air
	var/obj/machinery/atmospherics/portables_connector/connected_port = null

	var/obj/item/radio/radio = null

	/// Kelvin values.
	var/max_temperature = 25000
	/// Health percentage below which internal damage is possible.
	var/internal_damage_threshold = 33
	/// At least this much damage to trigger some real bad hurt.
	var/internal_damage_minimum = 15
	/// Contains bitflags.
	var/internal_damage = 0

	/// Required access level for mecha operation.
	var/list/operation_req_access = list()
	/// Required access level to open cell compartment.
	var/list/internals_req_access = list(ACCESS_ENGINEERING_MAIN,ACCESS_SCIENCE_ROBOTICS)

	/// Normalizes internal air mixture temperature.
	var/datum/global_iterator/pr_int_temp_processor
	/// Controls intertial movement in spesss.
	var/datum/global_iterator/pr_inertial_movement
	/// Moves air from tank to cabin.
	var/datum/global_iterator/pr_give_air
	/// Processes internal damage.
	var/datum/global_iterator/pr_internal_damage


	var/wreckage
	/// This lists holds what stuff you bolted onto your baby ride.
	var/list/equipment = new
	var/obj/item/vehicle_module/selected
	var/max_equip = 2
	var/datum/events/events

	/// outgoing melee damage (legacy var)
	var/damtype = DAMAGE_TYPE_BRUTE

//mechaequipt2 stuffs
	var/list/hull_equipment = new
	var/list/weapon_equipment = new
	var/list/utility_equipment = new
	var/list/universal_equipment = new
	var/list/special_equipment = new
	var/max_hull_equip = 2
	var/max_weapon_equip = 2
	var/max_utility_equip = 2
	var/max_universal_equip = 2
	var/max_special_equip = 1

	/// List containing starting tools.
	var/list/starting_equipment = null

// Mech Components, similar to Cyborg, but Bigger.
	var/list/internal_components = list(
		MECH_HULL = null,
		MECH_ACTUATOR = null,
		MECH_ARMOR = null,
		MECH_GAS = null,
		MECH_ELECTRIC = null
		)
	var/list/starting_components = list(
		/obj/item/vehicle_component/hull,
		/obj/item/vehicle_component/actuator,
		/obj/item/vehicle_component/armor,
		/obj/item/vehicle_component/gas,
		/obj/item/vehicle_component/electrical
		)

//Working exosuit vars
	var/list/cargo = list()
	var/cargo_capacity = 3

	var/static/image/radial_image_eject = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_eject")
	var/static/image/radial_image_airtoggle = image(icon= 'icons/mob/radial.dmi', icon_state = "radial_airtank")
	var/static/image/radial_image_lighttoggle = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_light")
	var/static/image/radial_image_statpanel = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_examine2")

	//* Legacy - Actions *//
	var/datum/mini_hud/mech/minihud
	/// re we strafing or not?
	var/strafing = 0

	/// Can we even use defence mode? This is used to assign it to mechs and check for verbs.
	var/defence_mode_possible = 0
	/// Are we in defence mode.
	var/defence_mode = 0
	/// How much it deflect.
	var/defence_deflect = 35

	/// Same as above. Don't forget to GRANT the verb&actions if you want everything to work proper.
	var/overload_possible = 0
	/// Are our legs overloaded.
	var/overload = 0
	/// How much extra energy you use when use the L E G.
	var/overload_coeff = 1

	var/zoom = 0
	var/zoom_possible = 0

	var/thrusters = 0
	var/thrusters_possible = 0

	/// Are we currently phasing.
	var/phasing = 0
	/// This is to allow phasing.
	var/phasing_possible = 0
	/// This is an internal check during the relevant procs.
	var/can_phase = TRUE
	var/phasing_energy_drain = 200

	/// Can you switch damage type? It is mostly for the Phazon and its children.
	var/switch_dmg_type_possible = 0

	var/smoke_possible = 0
	/// How many shots you have. Might make a reload later on. MIGHT.
	var/smoke_reserve = 5
	/// This is a check for the whether or not the cooldown is ongoing.
	var/smoke_ready = 1
	/// How long you have between uses.
	var/smoke_cooldown = 100
	var/datum/effect_system/smoke_spread/smoke_system = new

	// Can this exosuit innately cloak?
	var/cloak_possible = FALSE

//All of those are for the HUD buttons in the top left. See Grant and Remove procs in mecha_actions.

	var/datum/action/mecha/mech_toggle_internals/internals_action
	var/datum/action/mecha/mech_toggle_lights/lights_action
	var/datum/action/mecha/mech_view_stats/stats_action
	var/datum/action/mecha/strafe/strafing_action

	var/datum/action/mecha/mech_defence_mode/defence_action
	var/datum/action/mecha/mech_overload_mode/overload_action
	var/datum/action/mecha/mech_smoke/smoke_action
	var/datum/action/mecha/mech_zoom/zoom_action
	var/datum/action/mecha/mech_toggle_thrusters/thrusters_action
	var/datum/action/mecha/mech_cycle_equip/cycle_action
	var/datum/action/mecha/mech_switch_damtype/switch_damtype_action
	var/datum/action/mecha/mech_toggle_phasing/phasing_action
	var/datum/action/mecha/mech_toggle_cloaking/cloak_action

	/// So combat mechs don't switch to their equipment at times.
	var/weapons_only_cycle = FALSE

	//* Legacy *//

	/// the first controller in us
	var/mob/occupant_legacy

/obj/vehicle/sealed/mecha/Initialize(mapload)
	internals_action = new(src)
	lights_action = new(src)
	stats_action = new(src)
	strafing_action = new(src)

	defence_action = new(src)
	overload_action = new(src)
	smoke_action = new(src)
	zoom_action = new(src)
	thrusters_action = new(src)
	cycle_action = new(src)
	switch_damtype_action = new(src)
	phasing_action = new(src)
	cloak_action = new(src)
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(create_components))
	update_transform()

	events = new

	icon_state += "-open"
	add_radio()
	add_cabin()
	if(!add_airtank()) //we check this here in case mecha does not have an internal tank available by default - WIP
		removeVerb(/obj/vehicle/sealed/mecha/verb/connect_to_port)
		removeVerb(/obj/vehicle/sealed/mecha/verb/toggle_internal_tank)

	spark_system.set_up(2, 0, src)
	spark_system.attach(src)

	if(smoke_possible)//I am pretty sure that's needed here.
		src.smoke_system.set_up(3, 0, src)
		src.smoke_system.attach(src)

	add_cell()
	// TODO: BURN ITERATORS WITH FUCKING FIRE
	INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/vehicle/sealed/mecha, add_iterators))
	removeVerb(/obj/vehicle/sealed/mecha/verb/disconnect_from_port)
	log_message("[src.name] created.")
	loc.Entered(src)
	mechas_list += src //global mech list

/obj/vehicle/sealed/mecha/Destroy()
	src.legacy_eject_occupant()
	for(var/mob/M in src) //Be Extra Sure
		M.forceMove(get_turf(src))
		if(M != src.occupant_legacy)
			step_rand(M)

	for(var/atom/movable/A in src.cargo)
		A.forceMove(get_turf(src))
		var/turf/T = get_turf(A)
		if(T)
			T.Entered(A)
		step_rand(A)
	cargo = list()

	if(prob(30))
		explosion(get_turf(loc), 0, 0, 1, 3)

	if(wreckage)
		var/obj/effect/decal/mecha_wreckage/WR = new wreckage(loc)
		hull_equipment.Cut()
		weapon_equipment.Cut()
		utility_equipment.Cut()
		universal_equipment.Cut()
		special_equipment.Cut()
		for(var/obj/item/vehicle_module/E in equipment)
			if(E.salvageable && prob(30))
				WR.crowbar_salvage += E
				E.forceMove(WR)
				E.equip_ready = TRUE
			else
				E.forceMove(loc)
				E.destroy()

		for(var/slot in internal_components)
			var/obj/item/vehicle_component/C = internal_components[slot]
			if(istype(C))
				C.damage_part(rand(10, 20))
				C.detach()
				WR.crowbar_salvage += C
				C.forceMove(WR)

		if(cell)
			WR.crowbar_salvage += cell
			cell.forceMove(WR)
			cell.charge = rand(0, cell.charge)
		if(internal_tank)
			WR.crowbar_salvage += internal_tank
			internal_tank.forceMove(WR)
	else
		for(var/obj/item/vehicle_module/E in equipment)
			E.detach(loc)
			E.destroy()
		for(var/slot in internal_components)
			var/obj/item/vehicle_component/C = internal_components[slot]
			if(istype(C))
				C.detach()
				qdel(C)
		if(cell)
			qdel(cell)
		if(internal_tank)
			qdel(internal_tank)
	equipment.Cut()
	cell = null
	internal_tank = null

	if(smoke_possible)	//Just making sure nothing is running.
		qdel(smoke_system)

	QDEL_NULL(pr_int_temp_processor)
	QDEL_NULL(pr_inertial_movement)
	QDEL_NULL(pr_give_air)
	QDEL_NULL(pr_internal_damage)
	QDEL_NULL(spark_system)
	QDEL_NULL(minihud)

	mechas_list -= src //global mech list
	. = ..()

//! shitcode
// VEHICLE MECHS WHEN?
/obj/vehicle/sealed/mecha/proc/create_components()
	for(var/path in starting_components)
		var/obj/item/vehicle_component/C = new path(src)
		C.attach(src)

	if(starting_equipment && LAZYLEN(starting_equipment))
		for(var/path in starting_equipment)
			var/obj/item/vehicle_module/ME = new path(src)
			ME.attach(src)

/obj/vehicle/sealed/mecha/drain_energy(datum/actor, amount, flags)
	if(!cell)
		return 0
	return cell.drain_energy(actor, amount, flags)

/obj/vehicle/sealed/mecha/can_drain_energy(datum/actor, amount)
	return TRUE

////////////////////////
////// Helpers /////////
////////////////////////

/obj/vehicle/sealed/mecha/proc/legacy_eject_occupant()
	if(!occupant_legacy)
		return
	mob_exit(occupant_legacy)

/obj/vehicle/sealed/mecha/proc/removeVerb(verb_path)
	remove_obj_verb(src, verb_path)

/obj/vehicle/sealed/mecha/proc/addVerb(verb_path)
	add_obj_verb(src, verb_path)

/obj/vehicle/sealed/mecha/proc/add_airtank()
	internal_tank = new /obj/machinery/portable_atmospherics/canister/air(src)
	return internal_tank

/obj/vehicle/sealed/mecha/proc/add_cell(var/obj/item/cell/C=null)
	if(C)
		C.forceMove(src)
		cell = C
		return
	cell = new /obj/item/cell/high(src)

/obj/vehicle/sealed/mecha/get_cell(inducer)
	return cell

/obj/vehicle/sealed/mecha/proc/add_cabin()
	cabin_air = new
	cabin_air.temperature = T20C
	cabin_air.volume = 200
	cabin_air.adjust_multi(GAS_ID_OXYGEN, O2STANDARD*cabin_air.volume/(R_IDEAL_GAS_EQUATION*cabin_air.temperature), GAS_ID_NITROGEN, N2STANDARD*cabin_air.volume/(R_IDEAL_GAS_EQUATION*cabin_air.temperature))
	return cabin_air

/obj/vehicle/sealed/mecha/proc/add_radio()
	radio = new(src)
	radio.name = "[src] radio"
	radio.icon = icon
	radio.icon_state = icon_state
	radio.subspace_transmission = 1

/obj/vehicle/sealed/mecha/proc/add_iterators()
	pr_int_temp_processor = new /datum/global_iterator/mecha_preserve_temp(list(src))
	pr_inertial_movement = new /datum/global_iterator/mecha_intertial_movement(null,0)
	pr_give_air = new /datum/global_iterator/mecha_tank_give_air(list(src))
	pr_internal_damage = new /datum/global_iterator/mecha_internal_damage(list(src),0)

/obj/vehicle/sealed/mecha/proc/enter_after(delay as num, var/mob/user as mob, var/numticks = 5)
	var/delayfraction = delay/numticks

	var/turf/T = user.loc

	for(var/i = 0, i<numticks, i++)
		sleep(delayfraction)
		if(!src || !user || !CHECK_MOBILITY(user, MOBILITY_CAN_MOVE) || !(user.loc == T))
			return 0

	return 1



/obj/vehicle/sealed/mecha/proc/check_for_support()
	var/list/things = orange(1, src)

	if(locate(/obj/structure/grille) in things || locate(/obj/structure/lattice) in things || locate(/turf/simulated) in things || locate(/turf/unsimulated) in things)
		return 1
	else
		return 0

/obj/vehicle/sealed/mecha/examine(mob/user, dist)
	. = ..()

	var/obj/item/vehicle_component/armor/AC = internal_components[MECH_ARMOR]

	var/obj/item/vehicle_component/hull/HC = internal_components[MECH_HULL]

	if(AC)
		. += "It has [AC] attached. [AC.get_efficiency()<0.5?"It is severely damaged.":""]"
	else
		. += "It has no armor plating."

	if(HC)
		if(!AC || AC.get_efficiency() < 0.7)
			. += "It has [HC] attached. [HC.get_efficiency()<0.5?"It is severely damaged.":""]"
		else
			. += "You cannot tell what type of hull it has."

	else
		. += "It does not seem to have a completed hull."


	var/integrity = src.integrity/initial(src.integrity)*100
	switch(integrity)
		if(85 to 100)
			. += "It's fully intact."
		if(65 to 85)
			. += "It's slightly damaged."
		if(45 to 65)
			. += "<span class='notice'>It's badly damaged.</span>"
		if(25 to 45)
			. += "<span class='warning'>It's heavily damaged.</span>"
		else
			. += "<span class='warning'><b> It's falling apart.</b> </span>"
	if(equipment?.len)
		. += "It's equipped with:"
		for(var/obj/item/vehicle_module/ME in equipment)
			. += "[icon2html(ME, world)] [ME]"

/obj/vehicle/sealed/mecha/proc/drop_item()//Derpfix, but may be useful in future for engineering exosuits.
	return

/obj/vehicle/sealed/mecha/hear_talk(mob/M, list/message_pieces, verb)
	if(M == occupant_legacy && radio.broadcasting)
		radio.talk_into(M, message_pieces)

/obj/vehicle/sealed/mecha/proc/check_occupant_radial(var/mob/user)
	if(!user)
		return FALSE
	if(user.stat)
		return FALSE
	if(user != occupant_legacy)
		return FALSE
	if(user.incapacitated())
		return FALSE

	return TRUE

/obj/vehicle/sealed/mecha/proc/show_radial_occupant(var/mob/user)
	var/list/choices = list(
		"Eject" = radial_image_eject,
		"Toggle Airtank" = radial_image_airtoggle,
		"Toggle Light" = radial_image_lighttoggle,
		"View Stats" = radial_image_statpanel
	)

	var/choice = show_radial_menu(user, src, choices, custom_check = CALLBACK(src, PROC_REF(check_occupant_radial), user), require_near = TRUE, tooltips = TRUE)
	if(!check_occupant_radial(user))
		return
	if(!choice)
		return
	switch(choice)
		if("Eject")
			legacy_eject_occupant()
			add_fingerprint(usr)
		if("Toggle Airtank")
			use_internal_tank = !use_internal_tank
			occupant_message("Now taking air from [use_internal_tank?"internal airtank":"environment"].")
			log_message("Now taking air from [use_internal_tank?"internal airtank":"environment"].")
		if("Toggle Light")
			lights = !lights
			if(lights)
				set_light(light_range + lights_power)
			else
				set_light(light_range - lights_power)
			occupant_message("Toggled lights [lights?"on":"off"].")
			log_message("Toggled lights [lights?"on":"off"].")
			playsound(src, 'sound/mecha/heavylightswitch.ogg', 50, 1)
		if("View Stats")
			occupant_legacy << browse(src.get_stats_html(), "window=exosuit")


/obj/vehicle/sealed/mecha/proc/click_action(atom/target,mob/user, params)
	if(!src.occupant_legacy || src.occupant_legacy != user ) return
	if(user.stat) return
	if(target == src && user == occupant_legacy)
		show_radial_occupant(user)
		return
	if(state)
		occupant_message("<font color='red'>Maintenance protocols in effect</font>")
		return

	if(phasing)//Phazon and other mechs with phasing.
		src.occupant_message("Unable to interact with objects while phasing")//Haha dumbass.
		return

	if(!get_charge()) return
	if(src == target) return
	var/dir_to_target = get_dir(src,target)
	if(dir_to_target && !(dir_to_target & src.dir))//wrong direction
		return
	if(hasInternalDamage(MECHA_INT_CONTROL_LOST))
		target = SAFEPICK(view(3,target))
		if(!target)
			return
	if(istype(target, /obj/machinery))
		if (src.interface_action(target))
			return
	if(!sufficiently_adjacent(target))
		if(selected && selected.is_ranged())
			selected.action(target)
	else if(selected && selected.is_melee())
		selected.action(target, params)
	else
		src.melee_action(target)
	return

/obj/vehicle/sealed/mecha/proc/interface_action(obj/machinery/target)
	if(istype(target, /obj/machinery/access_button) || istype(target, /obj/machinery/button/remote/blast_door))
		src.occupant_message("<span class='notice'>Interfacing with [target].</span>")
		src.log_message("Interfaced with [target].")
		target.attack_hand(src.occupant_legacy)
		return 1
	if(istype(target, /obj/machinery/embedded_controller))
		target.ui_interact(src.occupant_legacy)
		return 1
	return 0

/obj/vehicle/sealed/mecha/contents_ui_distance(src_object, mob/living/user)
	. = user.shared_living_ui_distance(src_object) //allow them to interact with anything they can interact with normally.
	if(. != UI_INTERACTIVE)
		//Allow interaction with the mecha or anything that is part of the mecha
		if(src_object == src || (src_object in src))
			return UI_INTERACTIVE
		if(src.Adjacent(src_object))
			src.occupant_message("<span class='notice'>Interfacing with [src_object]...</span>")
			src.log_message("Interfaced with [src_object].")
			return UI_INTERACTIVE
		if(src_object in view(2, src))
			return UI_UPDATE //if they're close enough, allow the occupant_legacy to see the screen through the viewport or whatever.

/obj/vehicle/sealed/mecha/proc/melee_action(atom/target)
	return

/obj/vehicle/sealed/mecha/proc/range_action(atom/target)
	return


//////////////////////////////////
////////  Movement procs  ////////
//////////////////////////////////

/obj/vehicle/sealed/mecha/Moved(atom/old_loc, direction, forced = FALSE)
	. = ..()
	MoveAction()

/obj/vehicle/sealed/mecha/proc/MoveAction() //Allows mech equipment to do an action once the mech moves
	if(!equipment.len)
		return

	for(var/obj/item/vehicle_module/ME in equipment)
		ME.MoveAction()

/obj/vehicle/sealed/mecha/relaymove(mob/user,direction)
	if(user != src.occupant_legacy) //While not "realistic", this piece is player friendly.
		if(istype(user,/mob/living/carbon/brain))
			to_chat(user, "<span class='warning'>You try to move, but you are not the pilot! The exosuit doesn't respond.</span>")
			return 0
		user.forceMove(get_turf(src))
		to_chat(user, "You climb out from [src]")
		return 0

	var/obj/item/vehicle_component/hull/HC = internal_components[MECH_HULL]
	if(!HC)
		occupant_message("<span class='notice'>You can't operate an exosuit that doesn't have a hull!</span>")
		return

	if(connected_port)
		if(world.time - last_message > 20)
			src.occupant_message("<span class='warning'>Unable to move while connected to the air system port</span>")
			last_message = world.time
		return 0
	if(state)
		occupant_message("<span class='warning'>Maintenance protocols in effect</span>")
		return
/*
	if(zoom)
		if(world.time - last_message > 20)
			src.occupant_message("Unable to move while in zoom mode.")
			last_message = world.time
		return 0
*/
	return domove(direction)

/obj/vehicle/sealed/mecha/proc/can_ztravel()
	for(var/obj/item/vehicle_module/tool/jetpack/jp in equipment)
		return jp.equip_ready
	return FALSE

/obj/vehicle/sealed/mecha/proc/domove(direction)

	return call((proc_res["dyndomove"]||src), "dyndomove")(direction)

/obj/vehicle/sealed/mecha/proc/get_step_delay()
	var/tally = 0

	if(LAZYLEN(equipment))
		for(var/obj/item/vehicle_module/ME in equipment)
			if(ME.get_step_delay())
				tally += ME.get_step_delay()

		if(tally <= encumbrance_gap)	// If the total is less than our encumbrance gap, ignore equipment weight.
			tally = 0
		else	// Otherwise, start the tally after cutting that gap out.
			tally -= encumbrance_gap

	for(var/slot in internal_components)
		var/obj/item/vehicle_component/C = internal_components[slot]
		if(C && C.get_step_delay())
			tally += C.get_step_delay()

	var/obj/item/vehicle_component/actuator/actuator = internal_components[MECH_ACTUATOR]

	if(!actuator)	// Relying purely on hydraulic pumps. You're going nowhere fast.
		tally = 2 SECONDS

		return tally

	tally += 0.5 SECONDS * (1 - actuator.get_efficiency())	// Damaged actuators run slower, slowing as damage increases beyond its threshold.

	if(strafing)
		tally = round(tally * actuator.strafing_multiplier)

	for(var/obj/item/vehicle_module/ME in equipment)
		if(istype(ME, /obj/item/vehicle_module/speedboost))
			var/obj/item/vehicle_module/speedboost/SB = ME
			for(var/path in ME.required_type)
				if(istype(src, path))
					tally = round(tally * SB.slowdown_multiplier)
					break
			break

	if(overload)	// At the end, because this would normally just make the mech *slower* since tally wasn't starting at 0.
		tally = min(1, round(tally/2))

	return max(1, round(tally, 0.1))	// Round the total to the nearest 10th. Can't go lower than 1 tick. Even humans have a delay longer than that.

/obj/vehicle/sealed/mecha/proc/dyndomove(direction)
	if(!can_move)
		return 0
	if(src.pr_inertial_movement.active())
		return 0
	if(!has_charge(step_energy_drain))
		return 0

	var/atom/oldloc = loc

	//Can we even move, below is if yes.

	if(defence_mode)//Check if we are currently locked down
		if(world.time - last_message > 20)
			src.occupant_message("<font color='red'>Unable to move while in defence mode</font>")
			last_message = world.time
		return 0

	if(zoom)//:eyes:
		if(world.time - last_message > 20)
			src.occupant_message("Unable to move while in zoom mode.")
			last_message = world.time
		return 0

/*
//A first draft of a check to stop mechs from moving fully. TBD when all thrusters modules are unified.
	if(!thrusters && !src.pr_inertial_movement.active() && isspace(src.loc))//No thrsters, not drifting, in space
		src.occupant_message("Error 543")//debug
		return 0
*/

	if(!thrusters && src.pr_inertial_movement.active()) //I think this mean 'if you try to move in space without thruster, u no move'
		return 0

	if(overload)//Check if you have leg overload
		integrity--
		if(integrity < initial(integrity) - initial(integrity)/3)
			overload = 0
			step_energy_drain = initial(step_energy_drain)
			src.occupant_message("<font color='red'>Leg actuators damage threshold exceded. Disabling overload.</font>")


	var/move_result = 0

	if(hasInternalDamage(MECHA_INT_CONTROL_LOST) && prob(35))
		move_result = mechsteprand()
	//Up/down zmove
	else if(direction & UP || direction & DOWN)
		if(!can_ztravel())
			occupant_message("<span class='warning'>Your vehicle lacks the capacity to move in that direction!</span>")
			return FALSE

		//We're using locs because some mecha are 2x2 turfs. So thicc!
		var/result = TRUE

		for(var/turf/T in locs)
			if(!T.z_exit_check(src, direction))
				occupant_message("<span class='warning'>There's something blocking your movement in that direction!</span>")
				result = FALSE
				break
		if(result)
			move_result = mechstep(direction)

	//Turning

	else if(src.dir != direction)

		if(strafing)
			move_result = mechstep(direction)
		else
			move_result = mechturn(direction)

	//Stepping
	else
		move_result	= mechstep(direction)


	if(move_result)
		can_move = 0
		use_power(step_energy_drain)
		if(istype(src.loc, /turf/space))
			if(!src.check_for_support())
				src.pr_inertial_movement.start(list(src,direction))
				src.log_message("<span class='warning'>Movement control lost. Inertial movement started.</span>")
		sleep(get_step_delay() * ((ISDIAGONALDIR(direction) && (get_dir(oldloc, loc) == direction))? SQRT_2 : 1))
		can_move = 1
		return 1
	return 0

/obj/vehicle/sealed/mecha/proc/handle_equipment_movement()
	for(var/obj/item/vehicle_module/ME in equipment)
		if(ME.chassis == src) //Sanity
			ME.handle_movement_action()
	return

/obj/vehicle/sealed/mecha/proc/mechturn(direction)
	setDir(direction)
	if(swivel_sound)
		playsound(src,swivel_sound,40,1)
	return 1

/obj/vehicle/sealed/mecha/proc/mechstep(direction)
	var/current_dir = dir	//For strafing
	var/result = get_step(src,direction)
	var/atom/oldloc = loc
	if(result && (Move(result, direction) || loc != oldloc))
		if(stomp_sound)
			playsound(src,stomp_sound,40,1)
		handle_equipment_movement()
	if(strafing)	//Also for strafing
		setDir(current_dir)
	return result


/obj/vehicle/sealed/mecha/proc/mechsteprand()
	var/result = get_step_rand(src)
	if(result && Move(result))
		if(stomp_sound)
			playsound(src,stomp_sound,40,1)
		handle_equipment_movement()
	return result

/obj/vehicle/sealed/mecha/Bump(var/atom/obstacle)
//	src.inertia_dir = null
	if(istype(obstacle, /mob))//First we check if it is a mob. Mechs mostly shouln't go through them, even while phasing.
		var/mob/M = obstacle
		M.Move(get_step(obstacle,src.dir))
	else if(istype(obstacle, /obj))//Then we check for regular obstacles.
		var/obj/O = obstacle
		if(emulate_door_bumps)
			if(istype(O, /obj/machinery/door))
				for(var/m in occupants)
					O.Bumped(m)

		if(phasing && get_charge()>=phasing_energy_drain)//Phazon check. This could use an improvement elsewhere.
			spawn()
				if(can_phase)
					can_phase = FALSE
					flick("[initial_icon]-phase", src)
					src.loc = get_step(src,src.dir)
					src.use_power(phasing_energy_drain)
					sleep(get_step_delay() * 3)
					can_phase = TRUE
					occupant_message("Phazed.")
			. = ..(obstacle)
			return
		if(istype(O, /obj/effect/portal))	//derpfix
			src.anchored = 0				//I have no idea what this really fix.
			O.Crossed(src)
			spawn(0)//countering portal teleport spawn(0), hurr
				src.anchored = 1
		else if(O.anchored)
			obstacle.Bumped(src)
		else
			step(obstacle,src.dir)

	else//No idea when this triggers, so i won't touch it.
		. = ..(obstacle)
	return

///////////////////////////////////
////////  Internal damage  ////////
///////////////////////////////////

//ATM, the ignore_threshold is literally only used for the pulse rifles beams used mostly by deathsquads.
// todo: this is uh, not a check, this is a **roll**.
/obj/vehicle/sealed/mecha/proc/check_for_internal_damage(var/list/possible_int_damage,var/ignore_threshold=null)
	if(!islist(possible_int_damage) || !length(possible_int_damage)) return
	if(prob(30))
		if(ignore_threshold || src.integrity*100/initial(src.integrity) < src.internal_damage_threshold)
			for(var/T in possible_int_damage)
				if(internal_damage & T)
					possible_int_damage -= T
			var/int_dam_flag = SAFEPICK(possible_int_damage)
			if(int_dam_flag)
				setInternalDamage(int_dam_flag)
			return	//It already hurts to get some, lets not get both.

	if(prob(10))
		if(ignore_threshold || src.integrity*100/initial(src.integrity) < src.internal_damage_threshold)
			var/obj/item/vehicle_module/destr = SAFEPICK(equipment)
			if(destr)
				destr.destroy()
	return

/obj/vehicle/sealed/mecha/proc/hasInternalDamage(int_dam_flag=null)
	return int_dam_flag ? internal_damage&int_dam_flag : internal_damage


/obj/vehicle/sealed/mecha/proc/setInternalDamage(int_dam_flag)
	if(!pr_internal_damage) return

	internal_damage |= int_dam_flag
	spawn(-1)
		pr_internal_damage.start()
	log_append_to_last("Internal damage of type [int_dam_flag].",1)
	occupant_legacy << sound('sound/mecha/internaldmgalarm.ogg',volume=50) //Better sounding.

/obj/vehicle/sealed/mecha/proc/clearInternalDamage(int_dam_flag)
	internal_damage &= ~int_dam_flag
	switch(int_dam_flag)
		if(MECHA_INT_TEMP_CONTROL)
			occupant_message("<font color='blue'><b>Life support system reactivated.</b></font>")
			pr_int_temp_processor.start()
		if(MECHA_INT_FIRE)
			occupant_message("<font color='blue'><b>Internal fire extinquished.</b></font>")
		if(MECHA_INT_TANK_BREACH)
			occupant_message("<font color='blue'><b>Damaged internal tank has been sealed.</b></font>")

/obj/vehicle/sealed/mecha/proc/take_damage_legacy(amount, type="brute")
	update_damage_alerts()
	if(amount)
		var/damage = absorbDamage(amount,type)

		damage = components_handle_damage(damage,type)

		damage_integrity(damage)

		update_health()
		log_append_to_last("Took [damage] points of damage. Damage type: \"[type]\".",1)
	return

/obj/vehicle/sealed/mecha/proc/components_handle_damage(var/damage, var/type = DAMAGE_TYPE_BRUTE)
	var/obj/item/vehicle_component/armor/AC = internal_components[MECH_ARMOR]

	if(AC)
		var/armor_efficiency = AC.get_efficiency()
		var/damage_change = armor_efficiency * (damage * 0.5) * AC.damage_absorption[type]
		AC.damage_part(damage_change, type)
		damage -= damage_change

	var/obj/item/vehicle_component/hull/HC = internal_components[MECH_HULL]

	if(HC)
		if(HC.integrity)
			var/hull_absorb = round(rand(5, 10) / 10, 0.1) * damage
			HC.damage_part(hull_absorb, type)
			damage -= hull_absorb

	for(var/obj/item/vehicle_component/C in (internal_components - list(MECH_HULL, MECH_ARMOR)))
		if(prob(C.relative_size))
			var/damage_part_amt = round(damage / 4, 0.1)
			C.damage_part(damage_part_amt)
			damage -= damage_part_amt

	return damage

/obj/vehicle/sealed/mecha/proc/get_damage_absorption()
	var/obj/item/vehicle_component/armor/AC = internal_components[MECH_ARMOR]

	if(!istype(AC))
		return

	else
		if(AC.get_efficiency() > 0.25)
			return AC.damage_absorption

	return

/obj/vehicle/sealed/mecha/proc/absorbDamage(damage,damage_type)
	return call((proc_res["dynabsorbdamage"]||src), "dynabsorbdamage")(damage,damage_type)

/obj/vehicle/sealed/mecha/proc/dynabsorbdamage(damage,damage_type)
	return damage*(SAFEACCESS(get_damage_absorption(),damage_type) || 1)

/obj/vehicle/sealed/mecha/airlock_crush(var/crush_damage)
	..()
	take_damage_legacy(crush_damage)
	if(prob(50))	//Try to avoid that.
		check_for_internal_damage(list(MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST))
	return 1

/obj/vehicle/sealed/mecha/proc/update_health()
	if(src.integrity > 0)
		src.spark_system.start()
	else
		qdel(src)
	return

/obj/vehicle/sealed/mecha/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	if(user == occupant_legacy)
		show_radial_occupant(user)
		return

	user.setClickCooldownLegacy(user.get_attack_speed_legacy())
	src.log_message("Attack by hand/paw. Attacker - [user].",1)

	var/obj/item/vehicle_component/armor/ArmC = internal_components[MECH_ARMOR]

	var/temp_deflect_chance = deflect_chance

	if(!ArmC)
		temp_deflect_chance = 1

	else
		temp_deflect_chance = round(ArmC.get_efficiency() * ArmC.deflect_chance + (defence_mode ? 25 : 0))

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.species.can_shred(user))
			if(!prob(temp_deflect_chance))
				src.take_damage_legacy(15)	//The take_damage_legacy() proc handles armor values
				if(prob(25))	//Why would they get free internal damage. At least make it a bit RNG.
					src.check_for_internal_damage(list(MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST))
				playsound(src, 'sound/weapons/slash.ogg', 50, 1, -1)
				to_chat(user, "<span class='danger'>You slash at the armored suit!</span>")
				visible_message("<span class='danger'>\The [user] slashes at [src.name]'s armor!</span>")
			else
				src.log_append_to_last("Armor saved.")
				playsound(src, 'sound/weapons/slash.ogg', 50, 1, -1)
				to_chat(user, "<span class='danger'>Your claws had no effect!</span>")
				src.occupant_message("<span class='notice'>\The [user]'s claws are stopped by the armor.</span>")
				visible_message("<span class='warning'>\The [user] rebounds off [src.name]'s armor!</span>")
		else
			user.visible_message("<span class='danger'>\The [user] hits \the [src]. Nothing happens.</span>","<span class='danger'>You hit \the [src] with no visible effect.</span>")
			src.log_append_to_last("Armor saved.")
		return
	else if ((MUTATION_HULK in user.mutations) && !prob(temp_deflect_chance))
		src.take_damage_legacy(15)	//The take_damage_legacy() proc handles armor values
		if(prob(25))	//Hulks punch hard but lets not give them consistent internal damage.
			src.check_for_internal_damage(list(MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST))
		user.visible_message("<font color='red'><b>[user] hits [src.name], doing some damage.</b></font>", "<font color='red'><b>You hit [src.name] with all your might. The metal creaks and bends.</b></font>")
	else
		user.visible_message("<font color='red'><b>[user] hits [src.name]. Nothing happens.</b></font>","<font color='red'><b>You hit [src.name] with no visible effect.</b></font>")
		src.log_append_to_last("Armor saved.")
	return

/obj/vehicle/sealed/mecha/throw_impacted(atom/movable/AM, datum/thrownthing/TT)
	. = ..()
	log_message("Hit by [AM].",1)
	call((proc_res["dynhitby"]||src), "dynhitby")(AM)

//I think this is relative to throws.
/obj/vehicle/sealed/mecha/proc/dynhitby(atom/movable/A)
	var/obj/item/vehicle_component/armor/ArmC = internal_components[MECH_ARMOR]

	var/temp_deflect_chance = deflect_chance
	var/temp_damage_minimum = damage_minimum

	if(!ArmC)
		temp_deflect_chance = 0
		temp_damage_minimum = 0

	else
		temp_deflect_chance = round(ArmC.get_efficiency() * ArmC.deflect_chance + (defence_mode ? 25 : 0))
		temp_damage_minimum = round(ArmC.get_efficiency() * ArmC.damage_minimum)

	if(istype(A, /obj/item/vehicle_tracking_beacon))
		A.forceMove(src)
		src.visible_message("The [A] fastens firmly to [src].")
		return
	if(prob(temp_deflect_chance) || istype(A, /mob))
		src.occupant_message("<span class='notice'>\The [A] bounces off the armor.</span>")
		src.visible_message("\The [A] bounces off \the [src] armor")
		src.log_append_to_last("Armor saved.")
		if(istype(A, /mob/living))
			var/mob/living/M = A
			M.take_random_targeted_damage(brute = 10)
	else if(istype(A, /obj))
		var/obj/O = A
		if(O.throw_force)

			var/pass_damage = O.throw_force
			var/pass_damage_reduc_mod
			if(pass_damage <= temp_damage_minimum)//Too little to go through.
				src.occupant_message("<span class='notice'>\The [A] bounces off the armor.</span>")
				src.visible_message("\The [A] bounces off \the [src] armor")
				return

			// else if(O.damage_tier < temp_minimum_penetration)	//If you don't have enough pen, you won't do full damage
			// 	src.occupant_message("<span class='notice'>\The [A] struggles to bypass \the [src] armor.</span>")
			// 	src.visible_message("\The [A] struggles to bypass \the [src] armor")
			// 	pass_damage_reduc_mod = temp_fail_penetration_value	//This will apply to reduce damage to 2/3 or 66% by default
			else
				src.occupant_message("<span class='notice'>\The [A] manages to pierce \the [src] armor.</span>")
//				src.visible_message("\The [A] manages to pierce \the [src] armor")
				pass_damage_reduc_mod = 1



			for(var/obj/item/vehicle_module/ME in equipment)
				pass_damage = ME.handle_ranged_contact(A, pass_damage)

			pass_damage = (pass_damage*pass_damage_reduc_mod)//Applying damage reduction
			src.take_damage_legacy(pass_damage)	//The take_damage_legacy() proc handles armor values
			if(pass_damage > internal_damage_minimum)	//Only decently painful attacks trigger a chance of mech damage.
				src.check_for_internal_damage(list(MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST))

/obj/vehicle/sealed/mecha/on_bullet_act(obj/projectile/proj, impact_flags, list/bullet_act_args)
	src.log_message("Hit by projectile. Type: [proj.name]([proj.damage_flag]).",1)
	impact_flags |= call((proc_res["dynbulletdamage"]||src), "dynbulletdamage")(proj) //calls equipment
	impact_flags |= PROJECTILE_IMPACT_SKIP_STANDARD_DAMAGE
	return ..()

/obj/vehicle/sealed/mecha/proc/dynbulletdamage(var/obj/projectile/Proj)
	var/obj/item/vehicle_component/armor/ArmC = internal_components[MECH_ARMOR]

	var/temp_deflect_chance = deflect_chance
	var/temp_damage_minimum = damage_minimum
	var/temp_minimum_penetration = minimum_penetration
	var/temp_fail_penetration_value = fail_penetration_value

	if(!ArmC)
		temp_deflect_chance = 0
		temp_damage_minimum = 0
		temp_minimum_penetration = 0
		temp_fail_penetration_value = 1

	else
		temp_deflect_chance = round(ArmC.get_efficiency() * ArmC.deflect_chance + (defence_mode ? 25 : 0))
		temp_damage_minimum = round(ArmC.get_efficiency() * ArmC.damage_minimum)
		temp_minimum_penetration = round(ArmC.get_efficiency() * ArmC.minimum_penetration)
		temp_fail_penetration_value = round(ArmC.get_efficiency() * ArmC.fail_penetration_value)

	if(prob(temp_deflect_chance))
		src.occupant_message("<span class='notice'>The armor deflects incoming projectile.</span>")
		src.visible_message("The [src.name] armor deflects the projectile")
		src.log_append_to_last("Armor saved.")
		return

	if(Proj.damage_type == DAMAGE_TYPE_HALLOSS)
		use_power(Proj.damage_force * 5)
	if(Proj.damage_inflict_agony)
		use_power(Proj.damage_inflict_agony * 5)

	if(!(Proj.nodamage))
		var/ignore_threshold

		var/pass_damage = Proj.damage_force
		var/pass_damage_reduc_mod
		for(var/obj/item/vehicle_module/ME in equipment)
			pass_damage = ME.handle_projectile_contact(Proj, pass_damage)

		if(pass_damage < temp_damage_minimum)//too pathetic to really damage you.
			src.occupant_message("<span class='notice'>The armor deflects incoming projectile.</span>")
			src.visible_message("The [src.name] armor deflects\the [Proj]")
			return PROJECTILE_IMPACT_BLOCKED

		else if((max(BULLET_TIER_DEFAULT - Proj.damage_tier, 0) * 25) < temp_minimum_penetration)	//If you don't have enough pen, you won't do full damage
			src.occupant_message("<span class='notice'>\The [Proj] struggles to pierce \the [src] armor.</span>")
			src.visible_message("\The [Proj] struggles to pierce \the [src] armor")
			pass_damage_reduc_mod = temp_fail_penetration_value / 1.5	//This will apply to reduce damage to 2/3 or 66% by default

		else	//You go through completely because you use AP. Nice.
			src.occupant_message("<span class='notice'>\The [Proj] manages to pierce \the [src] armor.</span>")
//			src.visible_message("\The [Proj] manages to pierce \the [src] armor")
			pass_damage_reduc_mod = 1

		pass_damage = (pass_damage_reduc_mod*pass_damage)//Apply damage reduction before usage.
		src.take_damage_legacy(pass_damage, Proj.damage_flag)	//The take_damage_legacy() proc handles armor values
		if(prob(25))
			spark_system.start()
		if(pass_damage > internal_damage_minimum)	//Only decently painful attacks trigger a chance of mech damage.
			src.check_for_internal_damage(list(MECHA_INT_FIRE,MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST,MECHA_INT_SHORT_CIRCUIT),ignore_threshold)

		//AP projectiles have a chance to cause additional damage
		if(Proj.legacy_penetrating)
			var/hit_occupant = 1 //only allow the occupant to be hit once
			for(var/i in 1 to min(Proj.legacy_penetrating, round(Proj.damage_force/15)))
				if(src.occupant_legacy && hit_occupant && prob(20))
					Proj.impact(occupant_legacy)
					hit_occupant = 0
				else
					if(pass_damage > internal_damage_minimum)	//Only decently painful attacks trigger a chance of mech damage.
						src.check_for_internal_damage(list(MECHA_INT_FIRE,MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST,MECHA_INT_SHORT_CIRCUIT), 1)

				Proj.legacy_penetrating--

				if(prob(15))
					break //give a chance to exit early

//This refer to whenever you are caught in an explosion.
/obj/vehicle/sealed/mecha/legacy_ex_act(severity)
	var/obj/item/vehicle_component/armor/ArmC = internal_components[MECH_ARMOR]

	var/temp_deflect_chance = deflect_chance

	if(!ArmC)
		temp_deflect_chance = 0

	else
		temp_deflect_chance = round(ArmC.get_efficiency() * ArmC.deflect_chance + (defence_mode ? 25 : 0))

	src.log_message("Affected by explosion of severity: [severity].",1)
	if(prob(temp_deflect_chance))
		severity++
		src.log_append_to_last("Armor saved, changing severity to [severity].")
	switch(severity)
		if(1.0)
			src.take_damage_legacy(initial(src.integrity)/1.25, "bomb")
		if(2.0)
			src.take_damage_legacy(initial(src.integrity)/2.5, "bomb")
			src.check_for_internal_damage(list(MECHA_INT_FIRE,MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST,MECHA_INT_SHORT_CIRCUIT),1)
		if(3.0)
			src.take_damage_legacy(initial(src.integrity)/8, "bomb")
			src.check_for_internal_damage(list(MECHA_INT_FIRE,MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST,MECHA_INT_SHORT_CIRCUIT),1)
	return

/*Will fix later -Sieve
/obj/vehicle/sealed/mecha/attack_blob(mob/user as mob)
	src.log_message("Attack by blob. Attacker - [user].",1)
	if(!prob(src.deflect_chance))
		src.take_damage_legacy(6)
		src.check_for_internal_damage(list(MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST))
		playsound(src, 'sound/effects/blobattack.ogg', 50, 1, -1)
		to_chat(user, "<span class='danger'>You smash at the armored suit!</span>")
		for (var/mob/V in viewers(src))
			if(V.client && !(V.blinded))
				V.show_message("<span class='danger'>\The [user] smashes against [src.name]'s armor!</span>", 1)
	else
		src.log_append_to_last("Armor saved.")
		playsound(src, 'sound/effects/blobattack.ogg', 50, 1, -1)
		to_chat(user, "<span class='warning'>Your attack had no effect!</span>")
		src.occupant_message("<span class='warning'>\The [user]'s attack is stopped by the armor.</span>")
		for (var/mob/V in viewers(src))
			if(V.client && !(V.blinded))
				V.show_message("<span class='warning'>\The [user] rebounds off the [src.name] armor!</span>", 1)
	return
*/

/obj/vehicle/sealed/mecha/emp_act(severity)
	if(get_charge())
		use_power((cell.charge/2)/severity)
		take_damage_legacy(50 / severity,"energy")
	src.log_message("EMP detected",1)
	if(prob(80))
		check_for_internal_damage(list(MECHA_INT_FIRE,MECHA_INT_TEMP_CONTROL,MECHA_INT_CONTROL_LOST,MECHA_INT_SHORT_CIRCUIT),1)
	return

/obj/vehicle/sealed/mecha/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature>src.max_temperature)
		src.log_message("Exposed to dangerous temperature.",1)
		src.take_damage_legacy(5,"fire")	//The take_damage_legacy() proc handles armor values
		src.check_for_internal_damage(list(MECHA_INT_FIRE, MECHA_INT_TEMP_CONTROL))
	return

/obj/vehicle/sealed/mecha/proc/dynattackby(obj/item/W as obj, mob/user as mob)
	user.setClickCooldownLegacy(user.get_attack_speed_legacy(W))
	src.log_message("Attacked by [W]. Attacker - [user]")
	var/pass_damage_reduc_mod			//Modifer for failing to bring AP.

	var/obj/item/vehicle_component/armor/ArmC = internal_components[MECH_ARMOR]

	var/temp_deflect_chance = deflect_chance
	var/temp_damage_minimum = damage_minimum
	var/temp_minimum_penetration = minimum_penetration
	var/temp_fail_penetration_value = fail_penetration_value

	if(!ArmC)
		temp_deflect_chance = 0
		temp_damage_minimum = 0
		temp_minimum_penetration = 0
		temp_fail_penetration_value = 1

	else
		temp_deflect_chance = round(ArmC.get_efficiency() * ArmC.deflect_chance + (defence_mode ? 25 : 0))
		temp_damage_minimum = round(ArmC.get_efficiency() * ArmC.damage_minimum)
		temp_minimum_penetration = round(ArmC.get_efficiency() * ArmC.minimum_penetration)
		temp_fail_penetration_value = round(ArmC.get_efficiency() * ArmC.fail_penetration_value)

	if(prob(temp_deflect_chance))		//Does your attack get deflected outright.
		src.occupant_message("<span class='notice'>\The [W] bounces off [src.name].</span>")
		to_chat(user, "<span class='danger'>\The [W] bounces off [src.name].</span>")
		src.log_append_to_last("Armor saved.")

	else if(W.damage_force < temp_damage_minimum)	//Is your attack too PATHETIC to do anything. 3 damage to a person shouldn't do anything to a mech.
		src.occupant_message("<span class='notice'>\The [W] bounces off the armor.</span>")
		src.visible_message("\The [W] bounces off \the [src] armor")
		return

	else if((max(BULLET_TIER_DEFAULT - W.damage_tier, 0) * 25)  < temp_minimum_penetration)	//If you don't have enough pen, you won't do full damage
		src.occupant_message("<span class='notice'>\The [W] struggles to bypass \the [src] armor.</span>")
		src.visible_message("\The [W] struggles to bypass \the [src] armor")
		pass_damage_reduc_mod = temp_fail_penetration_value	//This will apply to reduce damage to 2/3 or 66% by default

	else
		pass_damage_reduc_mod = 1		//Just making sure.
		src.occupant_message("<font color='red'><b>[user] hits [src] with [W].</b></font>")
		user.visible_message("<font color='red'><b>[user] hits [src] with [W].</b></font>", "<font color='red'><b>You hit [src] with [W].</b></font>")

		var/pass_damage = W.damage_force
		pass_damage = (pass_damage*pass_damage_reduc_mod)	//Apply the reduction of damage from not having enough armor penetration. This is not regular armor values at play.
		for(var/obj/item/vehicle_module/ME in equipment)
			pass_damage = ME.handle_projectile_contact(W, user, pass_damage)
		src.take_damage_legacy(pass_damage, W.damage_type)	//The take_damage_legacy() proc handles armor values
		if(pass_damage > internal_damage_minimum)	//Only decently painful attacks trigger a chance of mech damage.
			src.check_for_internal_damage(list(MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST))
	return

//////////////////////
////// AttackBy //////
//////////////////////

/obj/vehicle/sealed/mecha/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/kit/paint))
		var/obj/item/kit/paint/P = W
		P.customize(src, user)
		return
	if(istype(W, /obj/item/robotanalyzer))
		var/obj/item/robotanalyzer/RA = W
		RA.do_scan(src, user)
		return

	if(istype(W, /obj/item/vehicle_module))
		var/obj/item/vehicle_module/E = W
		if(E.can_attach(src))
			if(!user.attempt_insert_item_for_installation(E, src))
				return
			E.attach(src)
			user.visible_message("[user] attaches [W] to [src]", "You attach [W] to [src]")
		else
			to_chat(user, "You were unable to attach [W] to [src]")
		return

	if(istype(W, /obj/item/vehicle_component) && state == MECHA_CELL_OUT)
		var/obj/item/vehicle_component/MC = W
		if(MC.attach(src))
			user.transfer_item_to_loc(W, src, INV_OP_FORCE)
			user.visible_message("[user] installs \the [W] in \the [src]", "You install \the [W] in \the [src].")
		return

	if(istype(W, /obj/item/card/robot))
		var/obj/item/card/robot/RoC = W
		return attackby(RoC.dummy_card, user)

	if(istype(W, /obj/item/card/id)||istype(W, /obj/item/pda))
		if(add_req_access || maint_access)
			if(internals_access_allowed(usr))
				var/obj/item/card/id/id_card
				if(istype(W, /obj/item/card/id))
					id_card = W
				else
					var/obj/item/pda/pda = W
					id_card = pda.id
				output_maintenance_dialog(id_card, user)
				return
			else
				to_chat(user, "<span class='warning'>Invalid ID: Access denied.</span>")
		else
			to_chat(user, "<span class='warning'>Maintenance protocols disabled by operator.</span>")
	else if(W.is_wrench())
		if(state==MECHA_BOLTS_SECURED)
			state = MECHA_PANEL_LOOSE
			to_chat(user, "You undo the securing bolts.")
		else if(state==MECHA_PANEL_LOOSE)
			state = MECHA_BOLTS_SECURED
			to_chat(user, "You tighten the securing bolts.")
		return
	else if(W.is_crowbar())
		if(state==MECHA_PANEL_LOOSE)
			state = MECHA_CELL_OPEN
			to_chat(user, "You open the hatch to the power unit")
		else if(state==MECHA_CELL_OPEN)
			state=MECHA_PANEL_LOOSE
			to_chat(user, "You close the hatch to the power unit")
		else if(state==MECHA_CELL_OUT)
			var/list/removable_components = list()
			for(var/slot in internal_components)
				var/obj/item/vehicle_component/MC = internal_components[slot]
				if(istype(MC))
					removable_components[MC.name] = MC
				else
					to_chat(user, "<span class='notice'>\The [src] appears to be missing \the [slot].</span>")

			var/remove = input(user, "Which component do you want to pry out?", "Remove Component") as null|anything in removable_components
			if(!remove)
				return

			var/obj/item/vehicle_component/RmC = removable_components[remove]
			RmC.detach()

		return
	else if(istype(W, /obj/item/stack/cable_coil))
		if(state >= MECHA_CELL_OPEN && hasInternalDamage(MECHA_INT_SHORT_CIRCUIT))
			var/obj/item/stack/cable_coil/CC = W
			if(CC.use(2))
				clearInternalDamage(MECHA_INT_SHORT_CIRCUIT)
				to_chat(user, "You replace the fused wires.")
			else
				to_chat(user, "There's not enough wire to finish the task.")
		return
	else if(W.is_screwdriver())
		if(hasInternalDamage(MECHA_INT_TEMP_CONTROL))
			clearInternalDamage(MECHA_INT_TEMP_CONTROL)
			to_chat(user, "You repair the damaged temperature controller.")
		else if(state==MECHA_CELL_OPEN && src.cell)
			src.cell.forceMove(src.loc)
			src.cell = null
			state = MECHA_CELL_OUT
			to_chat(user, "You unscrew and pry out the powercell.")
			src.log_message("Powercell removed")
		else if(state==MECHA_CELL_OUT && src.cell)
			state=MECHA_CELL_OPEN
			to_chat(user, "You screw the cell in place")
		return

	else if(istype(W, /obj/item/multitool))
		if(state>=MECHA_CELL_OPEN && src.occupant_legacy)
			to_chat(user, "You attempt to eject the pilot using the maintenance controls.")
			if(src.occupant_legacy.stat)
				src.legacy_eject_occupant()
				src.log_message("[src.occupant_legacy] was ejected using the maintenance controls.")
			else
				to_chat(user, "<span class='warning'>Your attempt is rejected.</span>")
				src.occupant_message("<span class='warning'>An attempt to eject you was made using the maintenance controls.</span>")
				src.log_message("Eject attempt made using maintenance controls - rejected.")
		return

	else if(istype(W, /obj/item/cell))
		if(state==MECHA_CELL_OUT)
			if(!src.cell)
				if(!user.attempt_insert_item_for_installation(W, src))
					return
				to_chat(user, "You install the powercell")
				src.cell = W
				src.log_message("Powercell installed")
			else
				to_chat(user, "There's already a powercell installed.")
		return

	else if(istype(W, /obj/item/weldingtool) && user.a_intent != INTENT_HARM)
		var/obj/item/weldingtool/WT = W
		if (WT.remove_fuel(0,user))
			if (hasInternalDamage(MECHA_INT_TANK_BREACH))
				clearInternalDamage(MECHA_INT_TANK_BREACH)
				to_chat(user, "<span class='notice'>You repair the damaged gas tank.</span>")
		else
			return
		if(src.integrity<initial(src.integrity))
			to_chat(user, "<span class='notice'>You repair some damage to [src.name].</span>")
			src.integrity += min(10, initial(src.integrity)-src.integrity)
			update_damage_alerts()
		else
			to_chat(user, "The [src.name] is at full integrity")
		return

	else if(istype(W, /obj/item/vehicle_tracking_beacon))
		if(!user.attempt_insert_item_for_installation(W, src))
			return
		user.visible_message("[user] attaches [W] to [src].", "You attach [W] to [src]")
		return

	else if(istype(W,/obj/item/stack/nanopaste))
		if(state >= MECHA_PANEL_LOOSE)
			var/obj/item/stack/nanopaste/NP = W

			for(var/slot in internal_components)
				var/obj/item/vehicle_component/C = internal_components[slot]

				if(C)

					if(C.integrity < C.integrity_max)
						while(C.integrity < C.integrity_max && NP && do_after(user, 1 SECOND, src))
							if(NP.use(1))
								C.adjust_integrity_mecha(10)

						to_chat(user, "<span class='notice'>You repair damage to \the [C].</span>")

			return

		else
			to_chat(user, "<span class='notice'>You can't reach \the [src]'s internal components.</span>")
			return

	else
		call((proc_res["dynattackby"]||src), "dynattackby")(W,user)
/*
		src.log_message("Attacked by [W]. Attacker - [user]")
		if(prob(src.deflect_chance))
			to_chat(user, "<span class='warning'>\The [W] bounces off [src.name] armor.</span>")
			src.log_append_to_last("Armor saved.")
/*
			for (var/mob/V in viewers(src))
				if(V.client && !(V.blinded))
					V.show_message("The [W] bounces off [src.name] armor.", 1)
*/
		else
			src.occupant_message("<font color='red'><b>[user] hits [src] with [W].</b></font>")
			user.visible_message("<font color='red'><b>[user] hits [src] with [W].</b></font>", "<font color='red'><b>You hit [src] with [W].</b></font>")
			src.take_damage_legacy(W.force,W.damtype)
			src.check_for_internal_damage(list(MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST))
*/
	return



/*
/obj/vehicle/sealed/mecha/attack_ai(var/mob/living/silicon/ai/user as mob)
	if(!istype(user, /mob/living/silicon/ai))
		return
	var/output = {"<b>Assume direct control over [src]?</b>
						<a href='?src=\ref[src];ai_take_control=\ref[user];duration=3000'>Yes</a><br>
						"}
	user << browse(output, "window=mecha_attack_ai")
	return
*/

/////////////////////////////////////
////////  Atmospheric stuff  ////////
/////////////////////////////////////

/obj/vehicle/sealed/mecha/return_air()
	RETURN_TYPE(/datum/gas_mixture)
	var/obj/item/vehicle_component/gas/GC = internal_components[MECH_GAS]
	if(use_internal_tank && GC && prob(GC.get_efficiency() * 100))
		return cabin_air
	return loc?.return_air()

/obj/vehicle/sealed/mecha/proc/connect(obj/machinery/atmospherics/portables_connector/new_port)
	//Make sure not already connected to something else
	if(connected_port || !new_port || new_port.connected_device)
		return 0

	//Make sure are close enough for a valid connection
	if(!(new_port.loc in locs))
		return 0

	//Perform the connection
	connected_port = new_port
	connected_port.connected_device = src

	//Actually enforce the air sharing
	var/datum/pipe_network/network = connected_port.return_network(src)
	if(network && !(internal_tank.return_air() in network.gases))
		network.gases += internal_tank.return_air()
		network.update = 1
	playsound(src, 'sound/mecha/gasconnected.ogg', 50, 1)
	log_message("Connected to gas port.")
	return 1

/obj/vehicle/sealed/mecha/proc/disconnect()
	if(!connected_port)
		return 0

	var/datum/pipe_network/network = connected_port.return_network(src)
	if(network)
		network.gases -= internal_tank.return_air()

	connected_port.connected_device = null
	connected_port = null
	playsound(src, 'sound/mecha/gasdisconnected.ogg', 50, 1)
	src.log_message("Disconnected from gas port.")
	return 1


/////////////////////////
////////  Verbs  ////////
/////////////////////////


/obj/vehicle/sealed/mecha/verb/connect_to_port()
	set name = "Connect to port"
	set category = "Exosuit Interface"
	set src = usr.loc
	set popup_menu = 0

	if(!occupant_legacy)
		return

	if(usr != occupant_legacy)
		return

	var/obj/item/vehicle_component/gas/GC = internal_components[MECH_GAS]
	if(!GC)
		return

	for(var/turf/T in locs)
		var/obj/machinery/atmospherics/portables_connector/possible_port = locate(/obj/machinery/atmospherics/portables_connector) in T
		if(possible_port)
			if(connect(possible_port))
				occupant_message("<span class='notice'>\The [name] connects to the port.</span>")
				add_obj_verb(src, /obj/vehicle/sealed/mecha/verb/disconnect_from_port)
				remove_obj_verb(src, /obj/vehicle/sealed/mecha/verb/connect_to_port)
				return
			else
				occupant_message("<span class='danger'>\The [name] failed to connect to the port.</span>")
				return
		else
			occupant_message("Nothing happens")


/obj/vehicle/sealed/mecha/verb/disconnect_from_port()
	set name = "Disconnect from port"
	set category = "Exosuit Interface"
	set src = usr.loc
	set popup_menu = 0

	if(!occupant_legacy)
		return

	if(usr != occupant_legacy)
		return

	if(disconnect())
		occupant_message("<span class='notice'>[name] disconnects from the port.</span>")
		remove_obj_verb(src, /obj/vehicle/sealed/mecha/verb/disconnect_from_port)
		add_obj_verb(src, /obj/vehicle/sealed/mecha/verb/connect_to_port)
	else
		occupant_message("<span class='danger'>[name] is not connected to the port at the moment.</span>")

/obj/vehicle/sealed/mecha/verb/toggle_lights()
	set name = "Toggle Lights"
	set category = "Exosuit Interface"
	set src = usr.loc
	set popup_menu = 0
	lights()

/obj/vehicle/sealed/mecha/verb/lights()
	if(usr!=occupant_legacy)	return
	lights = !lights
	if(lights)	set_light(light_range + lights_power)
	else		set_light(light_range - lights_power)
	src.occupant_message("Toggled lights [lights?"on":"off"].")
	log_message("Toggled lights [lights?"on":"off"].")
	playsound(src, 'sound/mecha/heavylightswitch.ogg', 50, 1)
	return


/obj/vehicle/sealed/mecha/verb/toggle_internal_tank()
	set name = "Toggle internal airtank usage"
	set category = "Exosuit Interface"
	set src = usr.loc
	set popup_menu = 0
	internal_tank()

/obj/vehicle/sealed/mecha/proc/internal_tank()
	if(usr!=src.occupant_legacy)
		return

	var/obj/item/vehicle_component/gas/GC = internal_components[MECH_GAS]
	if(!GC)
		to_chat(occupant_legacy, "<span class='warning'>The life support systems don't seem to respond.</span>")
		return

	if(!prob(GC.get_efficiency() * 100))
		to_chat(occupant_legacy, "<span class='warning'>\The [GC] shudders and barks, before returning to how it was before.</span>")
		return

	use_internal_tank = !use_internal_tank
	src.occupant_message("Now taking air from [use_internal_tank?"internal airtank":"environment"].")
	src.log_message("Now taking air from [use_internal_tank?"internal airtank":"environment"].")
	playsound(src, 'sound/mecha/gasdisconnected.ogg', 30, 1)
	return


/obj/vehicle/sealed/mecha/verb/toggle_strafing()
	set name = "Toggle strafing"
	set category = "Exosuit Interface"
	set src = usr.loc
	set popup_menu = 0
	strafing()

/obj/vehicle/sealed/mecha/proc/strafing()
	if(usr!=src.occupant_legacy)
		return
	strafing = !strafing
	src.occupant_message("Toggled strafing mode [strafing?"on":"off"].")
	src.log_message("Toggled strafing mode [strafing?"on":"off"].")
	return

//returns an equipment object if we have one of that type, useful since is_type_in_list won't return the object
//since is_type_in_list uses caching, this is a slower operation, so only use it if needed
/obj/vehicle/sealed/mecha/proc/get_equipment(var/equip_type)
	for(var/obj/item/vehicle_module/ME in equipment)
		if(istype(ME,equip_type))
			return ME
	return null

/obj/vehicle/sealed/mecha/mob_can_enter(mob/entering, datum/event_args/actor/actor, silent, suppressed)
	if (src.occupant_legacy)
		to_chat(actor.initiator, "<span class='danger'>The [src.name] is already occupied!</span>")
		return FALSE
	var/passed
	if(src.dna)
		if(entering.dna.unique_enzymes==src.dna)
			passed = 1
	else if(src.operation_allowed(entering))
		passed = 1
	if(!passed)
		to_chat(actor.initiator, "<span class='warning'>Access denied</span>")
		src.log_append_to_last("Permission denied.")
		return FALSE
	return ..()

/obj/vehicle/sealed/mecha/mob_try_enter(mob/entering, datum/event_args/actor/actor, silent, suppressed, enter_delay, use_control_flags)
	src.log_message("[usr] tries to move in.")
	return ..()

/obj/vehicle/sealed/mecha/proc/play_entered_noise(var/mob/who)
	if(!hasInternalDamage()) //Otherwise it's not nominal!
		switch(mech_faction)
			if(MECH_FACTION_NT)//The good guys category
				if(firstactivation)//First time = long activation sound
					firstactivation = 1
					who << sound('sound/mecha/LongNanoActivation.ogg',volume=50)
				else
					who << sound('sound/mecha/nominalnano.ogg',volume=50)
			if(MECH_FACTION_SYNDI)//Bad guys
				if(firstactivation)
					firstactivation = 1
					who << sound('sound/mecha/LongSyndiActivation.ogg',volume=50)
				else
					who << sound('sound/mecha/nominalsyndi.ogg',volume=50)
			else//Everyone else gets the normal noise
				who << sound('sound/mecha/nominal.ogg',volume=50)

/obj/vehicle/sealed/mecha/AltClick(mob/living/user)
	if(user == occupant_legacy)
		strafing()

/obj/vehicle/sealed/mecha/verb/view_stats()
	set name = "View Stats"
	set category = "Exosuit Interface"
	set src = usr.loc
	set popup_menu = 0
	if(usr!=src.occupant_legacy)
		return
	//pr_update_stats.start()
	src.occupant_legacy << browse(src.get_stats_html(), "window=exosuit")
	return

/obj/vehicle/sealed/mecha/proc/operation_allowed(mob/living/carbon/human/H)
	for(var/ID in list(H.get_active_held_item(), H.wear_id, H.belt))
		if(src.check_access(ID,src.operation_req_access))
			return 1
	return 0


/obj/vehicle/sealed/mecha/proc/internals_access_allowed(mob/living/carbon/human/H)
	if(istype(H))
		for(var/atom/ID in list(H.get_active_held_item(), H.wear_id, H.belt))
			if(src.check_access(ID,src.internals_req_access))
				return 1
	else if(istype(H, /mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = H
		if(src.check_access(R.idcard,src.internals_req_access))
			return 1
	return 0


/obj/vehicle/sealed/mecha/check_access(obj/item/card/id/I, list/access_list)
	if(!istype(access_list))
		return 1
	if(!access_list.len) //no requirements
		return 1
	if(istype(I, /obj/item/pda))
		var/obj/item/pda/pda = I
		I = pda.id
	if(!istype(I) || !I.access) //not ID or no access
		return 0
	if(access_list==src.operation_req_access)
		for(var/req in access_list)
			if(!(req in I.access)) //doesn't have this access
				return 0
	else if(access_list==src.internals_req_access)
		for(var/req in access_list)
			if(req in I.access)
				return 1
	return 1


////////////////////////////////////
///// Rendering stats window ///////
////////////////////////////////////

/obj/vehicle/sealed/mecha/proc/get_stats_html()
	var/output = {"<html>
						<head><title>[src.name] data</title>
						<style>
						body {color: #00ff00; background: #000000; font-family:"Lucida Console",monospace; font-size: 12px;}
						hr {border: 1px solid #0f0; color: #0f0; background-color: #0f0;}
						a {padding:2px 5px;;color:#0f0;}
						.wr {margin-bottom: 5px;}
						.header {cursor:pointer;}
						.open, .closed {background: #32CD32; color:#000; padding:1px 2px;}
						.links a {margin-bottom: 2px;padding-top:3px;}
						.visible {display: block;}
						.hidden {display: none;}
						</style>
						<script language='javascript' type='text/javascript'>
						[js_byjax]
						[js_dropdowns]
						function ticker() {
						    setInterval(function(){
						        window.location='byond://?src=\ref[src]&update_content=1';
						    }, 1000);
						}

						window.onload = function() {
							dropdowns();
							ticker();
						}
						</script>
						</head>
						<body>
						<div id='content'>
						[src.get_stats_part()]
						</div>
						<div id='eq_list'>
						[src.get_equipment_list()]
						</div>
						<hr>
						<div id='commands'>
						[src.get_commands()]
						</div>
						</body>
						</html>
					 "}
	return output


/obj/vehicle/sealed/mecha/proc/report_internal_damage()
	var/output = null
	var/list/dam_reports = list(
										"[MECHA_INT_FIRE]" = "<font color='red'><b>INTERNAL FIRE</b></font>",
										"[MECHA_INT_TEMP_CONTROL]" = "<font color='red'><b>LIFE SUPPORT SYSTEM MALFUNCTION</b></font>",
										"[MECHA_INT_TANK_BREACH]" = "<font color='red'><b>GAS TANK BREACH</b></font>",
										"[MECHA_INT_CONTROL_LOST]" = "<font color='red'><b>COORDINATION SYSTEM CALIBRATION FAILURE</b></font> - <a href='?src=\ref[src];repair_int_control_lost=1'>Recalibrate</a>",
										"[MECHA_INT_SHORT_CIRCUIT]" = "<font color='red'><b>SHORT CIRCUIT</b></font>"
										)
	for(var/tflag in dam_reports)
		var/intdamflag = text2num(tflag)
		if(hasInternalDamage(intdamflag))
			output += dam_reports[tflag]
			output += "<br />"
	if(return_pressure() > WARNING_HIGH_PRESSURE)
		output += "<font color='red'><b>DANGEROUSLY HIGH CABIN PRESSURE</b></font><br />"
	return output


/obj/vehicle/sealed/mecha/proc/get_stats_part()
	var/integrity = src.integrity/initial(src.integrity)*100
	var/cell_charge = get_charge()
	var/tank_pressure = internal_tank ? round(internal_tank.return_pressure(),0.01) : "None"
	var/tank_temperature = internal_tank ? internal_tank.return_temperature() : "Unknown"
	var/cabin_pressure = round(return_pressure(),0.01)

	var/obj/item/vehicle_component/hull/HC = internal_components[MECH_HULL]
	var/obj/item/vehicle_component/armor/AC = internal_components[MECH_ARMOR]

	var/output_text = {"[report_internal_damage()]
						<b>Armor Integrity: </b>[AC?"[round(AC.integrity / AC.integrity_max * 100, 0.1)]%":"<span class='warning'>ARMOR MISSING</span>"]<br>
						<b>Hull Integrity: </b>[HC?"[round(HC.integrity / HC.integrity_max * 100, 0.1)]%":"<span class='warning'>HULL MISSING</span>"]<br>
						[integrity<30?"<font color='red'><b>DAMAGE LEVEL CRITICAL</b></font><br>":null]
						<b>Chassis Integrity: </b> [integrity]%<br>
						<b>Powercell charge: </b>[isnull(cell_charge)?"No powercell installed":"[cell.percent()]%"]<br>
						<b>Air source: </b>[use_internal_tank?"Internal Airtank":"Environment"]<br>
						<b>Airtank pressure: </b>[tank_pressure]kPa<br>
						<b>Airtank temperature: </b>[tank_temperature]K|[tank_temperature - T0C]&deg;C<br>
						<b>Cabin pressure: </b>[cabin_pressure>WARNING_HIGH_PRESSURE ? "<font color='red'>[cabin_pressure]</font>": cabin_pressure]kPa<br>
						<b>Cabin temperature: </b> [return_temperature()]K|[return_temperature() - T0C]&deg;C<br>
						<b>Lights: </b>[lights?"on":"off"]<br>
						[src.dna?"<b>DNA-locked:</b><br> <span style='font-size:10px;letter-spacing:-1px;'>[src.dna]</span> \[<a href='?src=\ref[src];reset_dna=1'>Reset</a>\]<br>":null]
					"}


	if(defence_mode_possible)
		output_text += "<b>Defence mode: [defence_mode?"on":"off"]</b><br>"
	if(overload_possible)
		output_text += "<b>Leg actuators overload: [overload?"on":"off"]</b><br>"
	if(smoke_possible)
		output_text += "<b>Smoke:</b> [smoke_reserve]<br>"
	if(thrusters_possible)
		output_text += "<b>Thrusters:</b> [thrusters?"on":"off"]<br>"

//Cargo components. Keep this last otherwise it does weird alignment issues.
	output_text += "<b>Cargo Compartment Contents:</b><div style=\"margin-left: 15px;\">"
	if(src.cargo.len)
		for(var/obj/O in src.cargo)
			output_text += "<a href='?src=\ref[src];drop_from_cargo=\ref[O]'>Unload</a> : [O]<br>"
	else
		output_text += "Nothing"
	output_text += "</div>"
	return output_text

/obj/vehicle/sealed/mecha/proc/get_commands()
	var/output_text = {"<div class='wr'>
						<div class='header'>Electronics</div>
						<div class='links'>
						<a href='?src=\ref[src];toggle_lights=1'>Toggle Lights</a><br>
						<b>Radio settings:</b><br>
						Microphone: <a href='?src=\ref[src];rmictoggle=1'><span id="rmicstate">[radio.broadcasting?"Engaged":"Disengaged"]</span></a><br>
						Speaker: <a href='?src=\ref[src];rspktoggle=1'><span id="rspkstate">[radio.listening?"Engaged":"Disengaged"]</span></a><br>
						Frequency:
						<a href='?src=\ref[src];rfreq=-10'>-</a>
						<a href='?src=\ref[src];rfreq=-2'>-</a>
						<span id="rfreq">[format_frequency(radio.frequency)]</span>
						<a href='?src=\ref[src];rfreq=2'>+</a>
						<a href='?src=\ref[src];rfreq=10'>+</a><br>
						</div>
						</div>
						<div class='wr'>
						<div class='header'>Airtank</div>
						<div class='links'>
						<a href='?src=\ref[src];toggle_airtank=1'>Toggle Internal Airtank Usage</a><br>
						[(/obj/vehicle/sealed/mecha/verb/disconnect_from_port in src.verbs)?"<a href='?src=\ref[src];port_disconnect=1'>Disconnect from port</a><br>":null]
						[(/obj/vehicle/sealed/mecha/verb/connect_to_port in src.verbs)?"<a href='?src=\ref[src];port_connect=1'>Connect to port</a><br>":null]
						</div>
						</div>
						<div class='wr'>
						<div class='header'>Permissions & Logging</div>
						<div class='links'>
						<a href='?src=\ref[src];toggle_id_upload=1'><span id='t_id_upload'>[add_req_access?"L":"Unl"]ock ID upload panel</span></a><br>
						<a href='?src=\ref[src];toggle_maint_access=1'><span id='t_maint_access'>[maint_access?"Forbid":"Permit"] maintenance protocols</span></a><br>
						<a href='?src=\ref[src];view_log=1'>View internal log</a><br>
						<a href='?src=\ref[src];change_name=1'>Change exosuit name</a><br>
						</div>
						</div>
						<div id='equipment_menu'>[get_equipment_menu()]</div>
						<hr>
						<a href='?src=\ref[src];eject=1'>Eject</a><br>
						"}
	return output_text

/obj/vehicle/sealed/mecha/proc/get_equipment_menu() //outputs mecha html equipment menu
	var/output_text
	if(equipment.len)
		output_text += {"<div class='wr'>
						<div class='header'>Equipment</div>
						<div class='links'>"}
		for(var/obj/item/vehicle_module/W in hull_equipment)
			output_text += "Hull Module: [W.name] <a href='?src=\ref[W];detach=1'>Detach</a><br>"
		for(var/obj/item/vehicle_module/W in weapon_equipment)
			output_text += "Weapon Module: [W.name] <a href='?src=\ref[W];detach=1'>Detach</a><br>"
		for(var/obj/item/vehicle_module/W in utility_equipment)
			output_text += "Utility Module: [W.name] <a href='?src=\ref[W];detach=1'>Detach</a><br>"
		for(var/obj/item/vehicle_module/W in universal_equipment)
			output_text += "Universal Module: [W.name] <a href='?src=\ref[W];detach=1'>Detach</a><br>"
		for(var/obj/item/vehicle_module/W in special_equipment)
			output_text += "Special Module: [W.name] <a href='?src=\ref[W];detach=1'>Detach</a><br>"
		for(var/obj/item/vehicle_module/W in micro_utility_equipment)
			output_text += "Micro Utility Module: [W.name] <a href='?src=\ref[W];detach=1'>Detach</a><br>"
		for(var/obj/item/vehicle_module/W in micro_weapon_equipment)
			output_text += "Micro Weapon Module: [W.name] <a href='?src=\ref[W];detach=1'>Detach</a><br>"
	output_text += {"<b>Available hull slots:</b> [max_hull_equip-hull_equipment.len]<br>
	 <b>Available weapon slots:</b> [max_weapon_equip-weapon_equipment.len]<br>
	 <b>Available micro weapon slots:</b> [max_micro_weapon_equip-micro_weapon_equipment.len]<br>
	 <b>Available utility slots:</b> [max_utility_equip-utility_equipment.len]<br>
	 <b>Available micro utility slots:</b> [max_micro_utility_equip-micro_utility_equipment.len]<br>
	 <b>Available universal slots:</b> [max_universal_equip-universal_equipment.len]<br>
	 <b>Available special slots:</b> [max_special_equip-special_equipment.len]<br>
	 </div></div>
	 "}
	return output_text

/obj/vehicle/sealed/mecha/proc/get_equipment_list() //outputs mecha equipment list in html
	if(!equipment.len)
		return
	var/output_text = "<b>Equipment:</b><div style=\"margin-left: 15px;\">"
	for(var/obj/item/vehicle_module/MT in equipment)
		output_text += "<div id='\ref[MT]'>[MT.get_equip_info()]</div>"
	output_text += "</div>"
	return output_text


/obj/vehicle/sealed/mecha/proc/get_log_html()
	var/output_text = "<html><head><title>[src.name] Log</title></head><body style='font: 13px 'Courier', monospace;'>"
	for(var/list/entry in log)
		output_text += {"<div style='font-weight: bold;'>[time2text(entry["time"],"DDD MMM DD hh:mm:ss")] [game_year]</div>
						<div style='margin-left:15px; margin-bottom:10px;'>[entry["message"]]</div>
						"}
	output_text += "</body></html>"
	return output_text

/obj/vehicle/sealed/mecha/proc/get_log_tgui()
	var/list/data = list()
	for(var/list/entry in log)
		data.Add(list(list(
			"time" = time2text(entry["time"], "DDD MMM DD hh:mm:ss"),
			"year" = game_year,
			"message" = entry["message"],
		)))
	return data


/obj/vehicle/sealed/mecha/proc/output_access_dialog(obj/item/card/id/id_card, mob/user)
	if(!id_card || !user) return
	var/output_text = {"<html>
						<head><style>
						h1 {font-size:15px;margin-bottom:4px;}
						body {color: #00ff00; background: #000000; font-family:"Courier New", Courier, monospace; font-size: 12px;}
						a {color:#0f0;}
						</style>
						</head>
						<body>
						<h1>Following keycodes are present in this system:</h1>"}
	for(var/a in operation_req_access)
		output_text += "[get_access_desc(a)] - <a href='?src=\ref[src];del_req_access=[a];user=\ref[user];id_card=\ref[id_card]'>Delete</a><br>"
	output_text += "<hr><h1>Following keycodes were detected on portable device:</h1>"
	for(var/a in id_card.access)
		if(a in operation_req_access) continue
		var/a_name = get_access_desc(a)
		if(!a_name) continue //there's some strange access without a name
		output_text += "[a_name] - <a href='?src=\ref[src];add_req_access=[a];user=\ref[user];id_card=\ref[id_card]'>Add</a><br>"
	output_text += "<hr><a href='?src=\ref[src];finish_req_access=1;user=\ref[user]'>Finish</a> <font color='red'>(Warning! The ID upload panel will be locked. It can be unlocked only through Exosuit Interface.)</font>"
	output_text += "</body></html>"
	user << browse(output_text, "window=exosuit_add_access")
	onclose(user, "exosuit_add_access")
	return

/obj/vehicle/sealed/mecha/proc/output_maintenance_dialog(obj/item/card/id/id_card,mob/user)
	if(!id_card || !user) return

	var/maint_options = "<a href='?src=\ref[src];set_internal_tank_valve=1;user=\ref[user]'>Set Cabin Air Pressure</a>"
	if (locate(/obj/item/vehicle_module/tool/passenger) in contents)
		maint_options += "<a href='?src=\ref[src];remove_passenger=1;user=\ref[user]'>Remove Passenger</a>"

	var/output_text = {"<html>
						<head>
						<style>
						body {color: #00ff00; background: #000000; font-family:"Courier New", Courier, monospace; font-size: 12px;}
						a {padding:2px 5px; background:#32CD32;color:#000;display:block;margin:2px;text-align:center;text-decoration:none;}
						</style>
						</head>
						<body>
						[add_req_access?"<a href='?src=\ref[src];req_access=1;id_card=\ref[id_card];user=\ref[user]'>Edit operation keycodes</a>":null]
						[maint_access?"<a href='?src=\ref[src];maint_access=1;id_card=\ref[id_card];user=\ref[user]'>Initiate maintenance protocol</a>":null]
						[(state>0) ? maint_options : ""]
						</body>
						</html>"}
	user << browse(output_text, "window=exosuit_maint_console")
	onclose(user, "exosuit_maint_console")
	return


////////////////////////////////
/////// Messages and Log ///////
////////////////////////////////

/obj/vehicle/sealed/mecha/proc/occupant_message(message as text)
	if(message)
		if(src.occupant_legacy && src.occupant_legacy.client)
			to_chat(src.occupant_legacy, "[icon2html(src, world)] [message]")
	return

/obj/vehicle/sealed/mecha/proc/log_message(message as text,red=null)
	log.len++
	log[log.len] = list("time"=world.timeofday,"message"="[red?"<font color='red'>":null][message][red?"</font>":null]")
	return log.len

/obj/vehicle/sealed/mecha/proc/log_append_to_last(message as text,red=null)
	var/list/last_entry = src.log[src.log.len]
	last_entry["message"] += "<br>[red?"<font color='red'>":null][message][red?"</font>":null]"
	return


/////////////////
///// Topic /////
/////////////////

/obj/vehicle/sealed/mecha/Topic(href, href_list)
	..()
	if(href_list["update_content"])
		if(usr != src.occupant_legacy)	return
		send_byjax(src.occupant_legacy,"exosuit.browser","content",src.get_stats_part())
		return
	if(href_list["close"])
		return
	if(usr.stat > 0)
		return
	var/datum/topic_input/top_filter = new /datum/topic_input(href,href_list)
	if(href_list["select_equip"])
		if(usr != src.occupant_legacy)	return
		var/obj/item/vehicle_module/equip = top_filter.getObj("select_equip")
		if(equip)
			src.selected = equip
			src.occupant_message("You switch to [equip]")
			src.visible_message("[src] raises [equip]")
			send_byjax(src.occupant_legacy,"exosuit.browser","eq_list",src.get_equipment_list())
		return
	if(href_list["eject"])
		if(usr != src.occupant_legacy)	return
		mob_try_exit(usr)
		return
	if(href_list["toggle_lights"])
		if(usr != src.occupant_legacy)	return
		src.lights()
		return
/*
	if(href_list["toggle_strafing"])
		if(usr != src.occupant_legacy)	return
		src.strafing()
		return*/

	if(href_list["toggle_airtank"])
		if(usr != src.occupant_legacy)	return
		src.internal_tank()
		return
	if (href_list["toggle_thrusters"])
		src.toggle_thrusters()
	if (href_list["smoke"])
		src.smoke()
	if (href_list["toggle_zoom"])
		src.zoom()
	if(href_list["toggle_defence_mode"])
		src.defence_mode()
	if(href_list["switch_damtype"])
		src.switch_damtype()
	if(href_list["phasing"])
		src.phasing()

	if(href_list["rmictoggle"])
		if(usr != src.occupant_legacy)	return
		radio.broadcasting = !radio.broadcasting
		send_byjax(src.occupant_legacy,"exosuit.browser","rmicstate",(radio.broadcasting?"Engaged":"Disengaged"))
		return
	if(href_list["rspktoggle"])
		if(usr != src.occupant_legacy)	return
		radio.listening = !radio.listening
		send_byjax(src.occupant_legacy,"exosuit.browser","rspkstate",(radio.listening?"Engaged":"Disengaged"))
		return
	if(href_list["rfreq"])
		if(usr != src.occupant_legacy)	return
		var/new_frequency = (radio.frequency + top_filter.getNum("rfreq"))
		if ((radio.frequency < MIN_FREQ || radio.frequency > MAX_FREQ))
			new_frequency = sanitize_frequency(new_frequency)
		radio.set_frequency(new_frequency)
		send_byjax(src.occupant_legacy,"exosuit.browser","rfreq","[format_frequency(radio.frequency)]")
		return
	if(href_list["port_disconnect"])
		if(usr != src.occupant_legacy)	return
		src.disconnect_from_port()
		return
	if (href_list["port_connect"])
		if(usr != src.occupant_legacy)	return
		src.connect_to_port()
		return
	if (href_list["view_log"])
		if(usr != src.occupant_legacy)	return
		src.occupant_legacy << browse(src.get_log_html(), "window=exosuit_log")
		onclose(occupant_legacy, "exosuit_log")
		return
	if (href_list["change_name"])
		if(usr != src.occupant_legacy)	return
		var/newname = sanitizeSafe(input(occupant_legacy,"Choose new exosuit name","Rename exosuit",initial(name)) as text, MAX_NAME_LEN)
		if(newname)
			name = newname
		else
			alert(occupant_legacy, "nope.avi")
		return
	if (href_list["toggle_id_upload"])
		if(usr != src.occupant_legacy)	return
		add_req_access = !add_req_access
		send_byjax(src.occupant_legacy,"exosuit.browser","t_id_upload","[add_req_access?"L":"Unl"]ock ID upload panel")
		return
	if(href_list["toggle_maint_access"])
		if(usr != src.occupant_legacy)	return
		if(state)
			occupant_message("<font color='red'>Maintenance protocols in effect</font>")
			return
		maint_access = !maint_access
		send_byjax(src.occupant_legacy,"exosuit.browser","t_maint_access","[maint_access?"Forbid":"Permit"] maintenance protocols")
		return
	if(href_list["req_access"] && add_req_access)
		if(!in_range(src, usr))	return
		output_access_dialog(top_filter.getObj("id_card"),top_filter.getMob("user"))
		return
	if(href_list["maint_access"] && maint_access)
		if(!in_range(src, usr))	return
		var/mob/user = top_filter.getMob("user")
		if(user)
			if(state==MECHA_OPERATING)
				state = MECHA_BOLTS_SECURED
				to_chat(user, "The securing bolts are now exposed.")
			else if(state==MECHA_BOLTS_SECURED)
				state = MECHA_OPERATING
				to_chat(user, "The securing bolts are now hidden.")
			output_maintenance_dialog(top_filter.getObj("id_card"),user)
		return
	if(href_list["set_internal_tank_valve"] && state >=MECHA_BOLTS_SECURED)
		if(!in_range(src, usr))	return
		var/mob/user = top_filter.getMob("user")
		if(user)
			var/new_pressure = input(user,"Input new output pressure","Pressure setting",internal_tank_valve) as num
			if(new_pressure)
				internal_tank_valve = new_pressure
				to_chat(user, "The internal pressure valve has been set to [internal_tank_valve]kPa.")
	if(href_list["remove_passenger"] && state >= MECHA_BOLTS_SECURED)
		var/mob/user = top_filter.getMob("user")
		var/list/passengers = list()
		for (var/obj/item/vehicle_module/tool/passenger/P in contents)
			if (P.occupant_legacy)
				passengers["[P.occupant_legacy]"] = P

		if (!passengers)
			to_chat(user, "<span class='warning'>There are no passengers to remove.</span>")
			return

		var/pname = input(user, "Choose a passenger to forcibly remove.", "Forcibly Remove Passenger") as null|anything in passengers

		if (!pname)
			return

		var/obj/item/vehicle_module/tool/passenger/P = passengers[pname]
		var/mob/occupant_legacy = P.occupant_legacy

		user.visible_message("<span class='notice'>\The [user] begins opening the hatch on \the [P]...</span>", "<span class='notice'>You begin opening the hatch on \the [P]...</span>")
		if (!do_after(user, 40))
			return

		user.visible_message("<span class='notice'>\The [user] opens the hatch on \the [P] and removes [occupant_legacy]!</span>", "<span class='notice'>You open the hatch on \the [P] and remove [occupant_legacy]!</span>")
		P.go_out()
		P.log_message("[occupant_legacy] was removed.")
		return
	if(href_list["add_req_access"] && add_req_access && top_filter.getObj("id_card"))
		if(!in_range(src, usr))	return
		operation_req_access += top_filter.getNum("add_req_access")
		output_access_dialog(top_filter.getObj("id_card"),top_filter.getMob("user"))
		return
	if(href_list["del_req_access"] && add_req_access && top_filter.getObj("id_card"))
		if(!in_range(src, usr))	return
		operation_req_access -= top_filter.getNum("del_req_access")
		output_access_dialog(top_filter.getObj("id_card"),top_filter.getMob("user"))
		return
	if(href_list["finish_req_access"])
		if(!in_range(src, usr))	return
		add_req_access = 0
		var/mob/user = top_filter.getMob("user")
		user << browse(null,"window=exosuit_add_access")
		return
	if(href_list["repair_int_control_lost"])
		if(usr != src.occupant_legacy)	return
		src.occupant_message("Recalibrating coordination system.")
		src.log_message("Recalibration of coordination system started.")
		var/T = src.loc
		sleep(100)
		if(T == src.loc)
			src.clearInternalDamage(MECHA_INT_CONTROL_LOST)
			src.occupant_message("<font color='blue'>Recalibration successful.</font>")
			src.log_message("Recalibration of coordination system finished with 0 errors.")
		else
			src.occupant_message("<font color='red'>Recalibration failed.</font>")
			src.log_message("Recalibration of coordination system failed with 1 error.",1)
	if(href_list["drop_from_cargo"])
		var/obj/O = locate(href_list["drop_from_cargo"])
		if(O && (O in src.cargo))
			src.occupant_message("<span class='notice'>You unload [O].</span>")
			O.forceMove(get_turf(src))
			src.cargo -= O
			var/turf/T = get_turf(O)
			if(T)
				T.Entered(O)
			src.log_message("Unloaded [O]. Cargo compartment capacity: [cargo_capacity - src.cargo.len]")
	return

	//debug
	/*
	if(href_list["debug"])
		if(href_list["set_i_dam"])
			setInternalDamage(top_filter.getNum("set_i_dam"))
		if(href_list["clear_i_dam"])
			clearInternalDamage(top_filter.getNum("clear_i_dam"))
		return
	*/



/*

	if (href_list["ai_take_control"])
		var/mob/living/silicon/ai/AI = locate(href_list["ai_take_control"])
		var/duration = text2num(href_list["duration"])
		var/mob/living/silicon/ai/O = new /mob/living/silicon/ai(src)
		var/cur_occupant = src.occupant_legacy
		O.invisibility = 0
		O.canmove = 1
		O.name = AI.name
		O.real_name = AI.real_name
		O.anchored = 1
		O.aiRestorePowerRoutine = 0
		O.control_disabled = 1 // Can't control things remotely if you're stuck in a card!
		O.laws = AI.laws
		O.set_stat(AI.stat)
		O.oxyloss = AI.getOxyLoss()
		O.fireloss = AI.getFireLoss()
		O.bruteloss = AI.getBruteLoss()
		O.toxloss = AI.toxloss
		O.update_health()
		src.occupant_legacy = O
		if(AI.mind)
			AI.mind.transfer(O)
		AI.name = "Inactive AI"
		AI.real_name = "Inactive AI"
		AI.icon_state = "ai-empty"
		spawn(duration)
			AI.name = O.name
			AI.real_name = O.real_name
			if(O.mind)
				O.mind.transfer(AI)
			AI.control_disabled = 0
			AI.laws = O.laws
			AI.oxyloss = O.getOxyLoss()
			AI.fireloss = O.getFireLoss()
			AI.bruteloss = O.getBruteLoss()
			AI.toxloss = O.toxloss
			AI.update_health()
			qdel(O)
			if (!AI.stat)
				AI.icon_state = "ai"
			else
				AI.icon_state = "ai-crash"
			src.occupant_legacy = cur_occupant
*/

///////////////////////
///// Power stuff /////
///////////////////////

/obj/vehicle/sealed/mecha/proc/has_charge(amount)
	return (get_charge()>=amount)

/obj/vehicle/sealed/mecha/proc/get_charge()
	return call((proc_res["dyngetcharge"]||src), "dyngetcharge")()

/obj/vehicle/sealed/mecha/proc/dyngetcharge()//returns null if no powercell, else returns cell.charge
	if(!src.cell) return
	return max(0, src.cell.charge)

/obj/vehicle/sealed/mecha/proc/use_power(amount)
	return call((proc_res["dynusepower"]||src), "dynusepower")(amount)

/obj/vehicle/sealed/mecha/proc/dynusepower(amount)
	update_cell_alerts()
	var/obj/item/vehicle_component/electrical/EC = internal_components[MECH_ELECTRIC]

	if(EC)
		amount = amount * (2 - EC.get_efficiency()) * EC.charge_cost_mod
	else
		amount *= 5

	if(get_charge())
		cell.use(amount)
		return 1
	return 0

/obj/vehicle/sealed/mecha/proc/give_power(amount)
	update_cell_alerts()
	var/obj/item/vehicle_component/electrical/EC = internal_components[MECH_ELECTRIC]

	if(!EC)
		amount /= 4
	else
		amount *= EC.get_efficiency()

	if(!isnull(get_charge()))
		cell.give(amount)
		return 1
	return 0

//This is for mobs mostly.
/obj/vehicle/sealed/mecha/attack_generic(var/mob/user, var/damage, var/attack_message)

	var/obj/item/vehicle_component/armor/ArmC = internal_components[MECH_ARMOR]

	var/temp_deflect_chance = deflect_chance
	var/temp_damage_minimum = damage_minimum

	if(!ArmC)
		temp_deflect_chance = 1
		temp_damage_minimum = 0

	else
		temp_deflect_chance = round(ArmC.get_efficiency() * ArmC.deflect_chance + (defence_mode ? 25 : 0))
		temp_damage_minimum = round(ArmC.get_efficiency() * ArmC.damage_minimum)

	user.setClickCooldownLegacy(user.get_attack_speed_legacy())
	if(!damage)
		return 0

	src.log_message("Attacked. Attacker - [user].",1)
	user.do_attack_animation(src)

	if(prob(temp_deflect_chance))//Deflected
		src.log_append_to_last("Armor saved.")
		src.occupant_message("<span class='notice'>\The [user]'s attack is stopped by the armor.</span>")
		visible_message("<span class='notice'>\The [user] rebounds off [src.name]'s armor!</span>")
		user.attack_log += "\[[time_stamp()]\] <font color='red'>attacked [src.name]</font>"
		playsound(src, 'sound/weapons/slash.ogg', 50, 1, -1)

	else if(damage < temp_damage_minimum)//Pathetic damage levels just don't harm MECH.
		src.occupant_message("<span class='notice'>\The [user]'s doesn't dent \the [src] paint.</span>")
		src.visible_message("\The [user]'s attack doesn't dent \the [src] armor")
		src.log_append_to_last("Armor saved.")
		playsound(src, 'sound/effects/Glasshit.ogg', 50, 1)
		return

	else
		src.take_damage_legacy(damage)	//Apply damage - The take_damage_legacy() proc handles armor values
		if(damage > internal_damage_minimum)	//Only decently painful attacks trigger a chance of mech damage.
			src.check_for_internal_damage(list(MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST))
		visible_message("<span class='danger'>[user] [attack_message] [src]!</span>")
		user.attack_log += "\[[time_stamp()]\] <font color='red'>attacked [src.name]</font>"

	return 1

//////////////////////////////////////////
////////  Mecha global iterators  ////////
//////////////////////////////////////////

/// Normalizing cabin air temperature to 20 degrees celcius.
/datum/global_iterator/mecha_preserve_temp
	delay = 20

/datum/global_iterator/mecha_preserve_temp/process(obj/vehicle/sealed/mecha/mecha)
	if(mecha.cabin_air && mecha.cabin_air.volume > 0)
		var/delta = mecha.cabin_air.temperature - T20C
		mecha.cabin_air.temperature -= max(-10, min(10, round(delta/4,0.1)))
	return

/datum/global_iterator/mecha_tank_give_air
	delay = 15

/datum/global_iterator/mecha_tank_give_air/process(var/obj/vehicle/sealed/mecha/mecha)
	if(mecha.internal_tank)
		var/datum/gas_mixture/tank_air = mecha.internal_tank.return_air()
		var/datum/gas_mixture/cabin_air = mecha.cabin_air

		var/release_pressure = mecha.internal_tank_valve
		var/cabin_pressure = cabin_air.return_pressure()
		var/pressure_delta = min(release_pressure - cabin_pressure, (tank_air.return_pressure() - cabin_pressure)/2)
		var/transfer_moles = 0
		if(pressure_delta > 0) //cabin pressure lower than release pressure
			if(tank_air.temperature > 0)
				transfer_moles = pressure_delta*cabin_air.volume/(cabin_air.temperature * R_IDEAL_GAS_EQUATION)
				var/datum/gas_mixture/removed = tank_air.remove(transfer_moles)
				cabin_air.merge(removed)
		else if(pressure_delta < 0) //cabin pressure higher than release pressure
			var/datum/gas_mixture/t_air = mecha.loc.return_air()
			pressure_delta = cabin_pressure - release_pressure
			if(t_air)
				pressure_delta = min(cabin_pressure - t_air.return_pressure(), pressure_delta)
			if(pressure_delta > 0) //if location pressure is lower than cabin pressure
				transfer_moles = pressure_delta*cabin_air.volume/(cabin_air.temperature * R_IDEAL_GAS_EQUATION)
				var/datum/gas_mixture/removed = cabin_air.remove(transfer_moles)
				if(t_air)
					t_air.merge(removed)
				else //just delete the cabin gas, we're in space or some shit
					qdel(removed)
	else
		return stop()
	return

/datum/global_iterator/mecha_intertial_movement //inertial movement in space
	delay = 7

/datum/global_iterator/mecha_intertial_movement/process(var/obj/vehicle/sealed/mecha/mecha as obj,direction)
	if(direction)
		if(!step(mecha, direction)||mecha.check_for_support())
			src.stop()
		mecha.handle_equipment_movement()
	else
		src.stop()
	return

/datum/global_iterator/mecha_internal_damage // processing internal damage

/datum/global_iterator/mecha_internal_damage/process(var/obj/vehicle/sealed/mecha/mecha)
	if(!mecha.hasInternalDamage())
		return stop()
	if(mecha.hasInternalDamage(MECHA_INT_FIRE))
		if(!mecha.hasInternalDamage(MECHA_INT_TEMP_CONTROL) && prob(5))
			mecha.clearInternalDamage(MECHA_INT_FIRE)
		if(mecha.internal_tank)
			if(mecha.internal_tank.return_pressure()>mecha.internal_tank.maximum_pressure && !(mecha.hasInternalDamage(MECHA_INT_TANK_BREACH)))
				mecha.setInternalDamage(MECHA_INT_TANK_BREACH)
			var/datum/gas_mixture/int_tank_air = mecha.internal_tank.return_air()
			if(int_tank_air && int_tank_air.volume>0) //heat the air_contents
				int_tank_air.temperature = min(6000+T0C, int_tank_air.temperature+rand(10,15))
		if(mecha.cabin_air && mecha.cabin_air.volume>0)
			mecha.cabin_air.temperature = min(6000+T0C, mecha.cabin_air.temperature+rand(10,15))
			if(mecha.cabin_air.temperature>mecha.max_temperature/2)
				mecha.take_damage_legacy(4/round(mecha.max_temperature/mecha.cabin_air.temperature,0.1),"fire")	//The take_damage_legacy() proc handles armor values
	if(mecha.hasInternalDamage(MECHA_INT_TEMP_CONTROL)) //stop the mecha_preserve_temp loop datum
		mecha.pr_int_temp_processor.stop()
	if(mecha.hasInternalDamage(MECHA_INT_TANK_BREACH)) //remove some air from internal tank
		if(mecha.internal_tank)
			var/datum/gas_mixture/int_tank_air = mecha.internal_tank.return_air()
			var/datum/gas_mixture/leaked_gas = int_tank_air.remove_ratio(0.10)
			if(mecha.loc && hascall(mecha.loc,"assume_air"))
				mecha.loc.assume_air(leaked_gas)
			else
				qdel(leaked_gas)
	if(mecha.hasInternalDamage(MECHA_INT_SHORT_CIRCUIT))
		if(mecha.get_charge())
			mecha.spark_system.start()
			mecha.cell.charge -= min(20,mecha.cell.charge)
			mecha.cell.maxcharge -= min(20,mecha.cell.maxcharge)
	return


/////////////

/obj/vehicle/sealed/mecha/cloak()
	. = ..()
	if(occupant_legacy && occupant_legacy.client && cloaked_selfimage)
		occupant_legacy.client.images += cloaked_selfimage

/obj/vehicle/sealed/mecha/uncloak()
	if(occupant_legacy && occupant_legacy.client && cloaked_selfimage)
		occupant_legacy.client.images -= cloaked_selfimage
	return ..()


//debug
/*
/obj/vehicle/sealed/mecha/verb/test_int_damage()
	set name = "Test internal damage"
	set category = "Exosuit Interface"
	set src in view(0)
	if(!occupant_legacy) return
	if(usr!=occupant_legacy)
		return
	var/output = {"<html>
						<head>
						</head>
						<body>
						<h3>Set:</h3>
						<a href='?src=\ref[src];debug=1;set_i_dam=[MECHA_INT_FIRE]'>MECHA_INT_FIRE</a><br />
						<a href='?src=\ref[src];debug=1;set_i_dam=[MECHA_INT_TEMP_CONTROL]'>MECHA_INT_TEMP_CONTROL</a><br />
						<a href='?src=\ref[src];debug=1;set_i_dam=[MECHA_INT_SHORT_CIRCUIT]'>MECHA_INT_SHORT_CIRCUIT</a><br />
						<a href='?src=\ref[src];debug=1;set_i_dam=[MECHA_INT_TANK_BREACH]'>MECHA_INT_TANK_BREACH</a><br />
						<a href='?src=\ref[src];debug=1;set_i_dam=[MECHA_INT_CONTROL_LOST]'>MECHA_INT_CONTROL_LOST</a><br />
						<hr />
						<h3>Clear:</h3>
						<a href='?src=\ref[src];debug=1;clear_i_dam=[MECHA_INT_FIRE]'>MECHA_INT_FIRE</a><br />
						<a href='?src=\ref[src];debug=1;clear_i_dam=[MECHA_INT_TEMP_CONTROL]'>MECHA_INT_TEMP_CONTROL</a><br />
						<a href='?src=\ref[src];debug=1;clear_i_dam=[MECHA_INT_SHORT_CIRCUIT]'>MECHA_INT_SHORT_CIRCUIT</a><br />
						<a href='?src=\ref[src];debug=1;clear_i_dam=[MECHA_INT_TANK_BREACH]'>MECHA_INT_TANK_BREACH</a><br />
						<a href='?src=\ref[src];debug=1;clear_i_dam=[MECHA_INT_CONTROL_LOST]'>MECHA_INT_CONTROL_LOST</a><br />
 					   </body>
						</html>"}

	occupant_legacy << browse(output, "window=ex_debug")
	//src.integrity = initial(src.integrity)/2.2
	//src.check_for_internal_damage(list(MECHA_INT_FIRE,MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST))
	return
*/

/obj/vehicle/sealed/mecha/proc/update_cell_alerts()
	if(occupant_legacy && cell)
		var/cellcharge = cell.charge/cell.maxcharge
		switch(cellcharge)
			if(0.75 to INFINITY)
				occupant_legacy.clear_alert("charge")
			if(0.5 to 0.75)
				occupant_legacy.throw_alert("charge", /atom/movable/screen/alert/lowcell, 1)
			if(0.25 to 0.5)
				occupant_legacy.throw_alert("charge", /atom/movable/screen/alert/lowcell, 2)
			if(0.01 to 0.25)
				occupant_legacy.throw_alert("charge", /atom/movable/screen/alert/lowcell, 3)
			else
				occupant_legacy.throw_alert("charge", /atom/movable/screen/alert/emptycell)

/obj/vehicle/sealed/mecha/proc/update_damage_alerts()
	if(occupant_legacy)
		var/integrity = src.integrity/initial(src.integrity)*100
		switch(integrity)
			if(30 to 45)
				occupant_legacy.throw_alert("mech damage", /atom/movable/screen/alert/low_mech_integrity, 1)
			if(15 to 35)
				occupant_legacy.throw_alert("mech damage", /atom/movable/screen/alert/low_mech_integrity, 2)
			if(-INFINITY to 15)
				occupant_legacy.throw_alert("mech damage", /atom/movable/screen/alert/low_mech_integrity, 3)
			else
				occupant_legacy.clear_alert("mech damage")

// Various sideways-defined get_cells
/obj/vehicle/sealed/mecha/get_cell(inducer)
	return cell

//* Entry / Exit *//

/obj/vehicle/sealed/mecha/occupant_added(mob/adding, datum/event_args/actor/actor, control_flags, silent)
	. = ..()
	if(occupant_legacy)
		stack_trace("how did we get another?")
		return

	var/mob/living/carbon/human/H = adding

	if(istype(H) && H.client && (H in range(1)))
		H.stop_pulling()
		H.forceMove(src)
		H.update_perspective()
		occupant_legacy = H
		add_fingerprint(H)
		log_append_to_last("[H] moved in as pilot.")
		update_icon()
		if(occupant_legacy.hud_used)
			minihud = new (occupant_legacy.hud_used, src)

	GrantActions(occupant_legacy, 1)

	//This part removes all the verbs if you don't have them the _possible on your mech. This is a little clunky, but it lets you just add that to any mech.
	//And it's not like this 10yo code wasn't clunky before.
	if(!smoke_possible)			//Can't use smoke? No verb for you.
		remove_obj_verb(src, /obj/vehicle/sealed/mecha/verb/toggle_smoke)
	if(!thrusters_possible)		//Can't use thrusters? No verb for you.
		remove_obj_verb(src, /obj/vehicle/sealed/mecha/verb/toggle_thrusters)
	if(!defence_mode_possible)	//Do i need to explain everything?
		remove_obj_verb(src, /obj/vehicle/sealed/mecha/verb/toggle_defence_mode)
	if(!overload_possible)
		remove_obj_verb(src, /obj/vehicle/sealed/mecha/verb/toggle_overload)
	if(!zoom_possible)
		remove_obj_verb(src, /obj/vehicle/sealed/mecha/verb/toggle_zoom)
	if(!phasing_possible)
		remove_obj_verb(src, /obj/vehicle/sealed/mecha/verb/toggle_phasing)
	if(!switch_dmg_type_possible)
		remove_obj_verb(src, /obj/vehicle/sealed/mecha/verb/switch_damtype)
	if(!cloak_possible)
		remove_obj_verb(src, /obj/vehicle/sealed/mecha/verb/toggle_cloak)

	update_cell_alerts()
	update_damage_alerts()
	setDir(dir_in)
	playsound(src, 'sound/machines/door/windowdoor.ogg', 50, 1)
	if(occupant_legacy.client && cloaked_selfimage)
		occupant_legacy.client.images += cloaked_selfimage
	play_entered_noise(occupant_legacy)

/obj/vehicle/sealed/mecha/occupant_removed(mob/removing, datum/event_args/actor/actor, control_flags, silent)
	. = ..()
	QDEL_NULL(minihud)
	RemoveActions(removing, human_occupant=1)

	log_message("[removing] moved out.")
	removing << browse(null, "window=exosuit")
	if(removing.client && cloaked_selfimage)
		removing.client.images -= cloaked_selfimage
	// if(istype(mob_container, /obj/item/mmi))
	// 	var/obj/item/mmi/mmi = mob_container
	// 	if(mmi.brainmob)
	// 		removing.forceMove(mmi)
	// 	mmi.mecha = null
	// 	removing.mobility_flags = NONE
	removing.clear_alert("charge")
	removing.clear_alert("mech damage")

	if(occupant_legacy == removing)
		occupant_legacy = null

	update_appearance()
	setDir(dir_in)

	if(removing.client)
		removing.client.view = world.view
		src.zoom = 0

	strafing = 0

//* Action Datums - /datum/action/vehicle/mecha *//

/datum/action/vehicle/mecha
	target_type = /obj/vehicle/sealed/mecha
	background_icon_state = "mecha"
	button_icon = 'icons/screen/actions/mecha.dmi'

	required_control_flags = NONE

/datum/action/vehicle/mecha/eject
	name = "Eject"
	desc = "Eject from your mecha."
	button_icon_state = "eject"

	required_control_flags = VEHICLE_CONTROL_EXIT

/datum/action/vehicle/mecha/eject/invoke_target(obj/vehicle/sealed/mecha/target, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	target.mob_try_exit(actor.performer, actor)
