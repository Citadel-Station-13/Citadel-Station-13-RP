
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
	anchored = TRUE
	integrity_flags = INTEGRITY_ACIDPROOF | INTEGRITY_FIREPROOF
	integrity = 300
	integrity_max = 300
	integrity_failure = 0
	/// Icon draw layer.
	layer = MOB_LAYER
	enter_delay = 4 SECONDS
	emulate_door_bumps = TRUE

	//* legacy below

	/// Mech type for resetting icon. Only used for reskinning kits (see custom items).
	var/initial_icon = null
	/// How many points of slowdown are negated from equipment? Added to the mech's base step_in.
	var/encumbrance_gap = 1
	/// What direction will the mech face when entered/powered on? Defaults to South.
	var/dir_in = 2
	var/step_energy_drain = 10

	var/obj/item/cell/cell
	var/state = MECHA_OPERATING
	var/last_message = 0
	#warn enable ID upload if just built
	var/add_req_access = FALSE
	#warn enable maint if just built
	var/maint_access = FALSE
	/// Stores proc owners, like proc_res["functionname"] = owner reference.
	var/list/proc_res = list()
	var/datum/effect_system/spark_spread/spark_system = new
	var/force = 0

	var/mech_faction = null
	/// It's simple. If it's 0, no one entered it yet. Otherwise someone entered it at least once.
	var/firstactivation = 0

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

	var/wreckage

	/// outgoing melee damage (legacy var)
	var/damtype = DAMAGE_TYPE_BRUTE

	var/static/image/radial_image_eject = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_eject")
	var/static/image/radial_image_airtoggle = image(icon= 'icons/mob/radial.dmi', icon_state = "radial_airtank")
	var/static/image/radial_image_lighttoggle = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_light")
	var/static/image/radial_image_statpanel = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_examine2")

	//* Legacy - Actions *//
	var/datum/mini_hud/mech/minihud

	/// Same as above. Don't forget to GRANT the verb&actions if you want everything to work proper.
	var/overload_possible = 0
	/// Are our legs overloaded.
	var/overload = 0
	/// How much extra energy you use when use the L E G.
	var/overload_coeff = 1

	var/zoom = 0
	var/zoom_possible = 0

	/// Are we currently phasing.
	var/phasing = 0
	/// This is to allow phasing.
	var/phasing_possible = 0
	/// This is an internal check during the relevant procs.
	var/can_phase = TRUE
	var/phasing_energy_drain = 200

	/// Can you switch damage type? It is mostly for the Phazon and its children.
	var/switch_dmg_type_possible = 0

//All of those are for the HUD buttons in the top left. See Grant and Remove procs in mecha_actions.

	var/datum/action/mecha/mech_toggle_internals/internals_action
	var/datum/action/mecha/mech_toggle_lights/lights_action
	var/datum/action/mecha/mech_view_stats/stats_action
	var/datum/action/mecha/strafe/strafing_action

	var/datum/action/mecha/mech_overload_mode/overload_action
	var/datum/action/mecha/mech_zoom/zoom_action
	var/datum/action/mecha/mech_cycle_equip/cycle_action
	var/datum/action/mecha/mech_switch_damtype/switch_damtype_action
	var/datum/action/mecha/mech_toggle_phasing/phasing_action

	//* Legacy *//
	/// the first controller in us
	var/mob/occupant_legacy

/obj/vehicle/sealed/mecha/Initialize(mapload)
	internals_action = new(src)
	lights_action = new(src)
	stats_action = new(src)
	strafing_action = new(src)

	overload_action = new(src)
	zoom_action = new(src)
	cycle_action = new(src)
	switch_damtype_action = new(src)
	phasing_action = new(src)
	. = ..()
	update_transform()

	icon_state += "-open"
	add_radio()
	add_cabin()
	if(!add_airtank()) //we check this here in case mecha does not have an internal tank available by default - WIP
		removeVerb(/obj/vehicle/sealed/mecha/verb/connect_to_port)
		removeVerb(/obj/vehicle/sealed/mecha/verb/toggle_internal_tank)

	spark_system.set_up(2, 0, src)
	spark_system.attach(src)

	add_cell()
	removeVerb(/obj/vehicle/sealed/mecha/verb/disconnect_from_port)
	log_message("[src.name] created.")

/obj/vehicle/sealed/mecha/Destroy()
	src.legacy_eject_occupant()
	for(var/mob/M in src) //Be Extra Sure
		M.forceMove(get_turf(src))
		if(M != src.occupant_legacy)
			step_rand(M)

	if(prob(30))
		explosion(get_turf(loc), 0, 0, 1, 3)

	if(wreckage)
		var/obj/effect/decal/mecha_wreckage/WR = new wreckage(loc)
		for(var/obj/item/vehicle_module/lazy/legacy/mod as anything in modules)
			if(!mod.can_be_removed())
				continue
			if(!prob(30))
				continue
			uninstall_module(mod, null, TRUE, TRUE, WR)
			WR.crowbar_salvage += mod
			mod.equip_ready = TRUE

		for(var/obj/item/vehicle_component/comp as anything in components)
			if(!comp.can_be_removed())
				continue
			uninstall_component(comp, null, TRUE, TRUE, WR)
			comp.damage_part(rand(10, 20))
			comp.detach()
			WR.crowbar_salvage += comp
		if(cell)
			WR.crowbar_salvage += cell
			cell.forceMove(WR)
			cell.charge = rand(0, cell.charge)
			cell = null
		if(internal_tank)
			WR.crowbar_salvage += internal_tank
			internal_tank.forceMove(WR)
			internal_tank = null
	else
		QDEL_NULL(cell)
		QDEL_NULL(internal_tank)

	QDEL_NULL(spark_system)
	QDEL_NULL(minihud)

	return ..()

/obj/vehicle/sealed/mecha/on_drop_vehicle_contents(atom/where)
	..()
	for(var/atom/movable/cargo in cargo_held)
		cargo.forceMove(where)
		step_rand()
	cargo_held = null

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

/obj/vehicle/sealed/mecha/hear_talk(mob/M, list/message_pieces, verb)
	if(M == occupant_legacy && radio.broadcasting)
		radio.talk_into(M, message_pieces)

#warn nuke this
/obj/vehicle/sealed/mecha/proc/click_action(atom/target,mob/user, params)
	if(!src.occupant_legacy || src.occupant_legacy != user )
		return
	if(user.stat)
		return
	if(state)
		occupant_message("<font color='red'>Maintenance protocols in effect</font>")
		return

	if(phasing)//Phazon and other mechs with phasing.
		src.occupant_message("Unable to interact with objects while phasing")//Haha dumbass.
		return

	if(!get_charge())
		return
	if(src == target)
		return
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

#warn nuke this
/obj/vehicle/sealed/mecha/relaymove(mob/user,direction)
	if(user != src.occupant_legacy) //While not "realistic", this piece is player friendly.
		if(istype(user,/mob/living/carbon/brain))
			to_chat(user, "<span class='warning'>You try to move, but you are not the pilot! The exosuit doesn't respond.</span>")
			return 0
		user.forceMove(get_turf(src))
		to_chat(user, "You climb out from [src]")
		return 0
	if(zoom)
		if(world.time - last_message > 20)
			src.occupant_message("Unable to move while in zoom mode.")
			last_message = world.time
		return 0
	if(connected_port)
		if(world.time - last_message > 20)
			src.occupant_message("<span class='warning'>Unable to move while connected to the air system port</span>")
			last_message = world.time
		return 0
	if(!has_charge(step_energy_drain))
		return 0
	if(state)
		occupant_message("<span class='warning'>Maintenance protocols in effect</span>")
		return 0
	return domove(direction)

/obj/vehicle/sealed/mecha/proc/can_ztravel()
	for(var/obj/item/vehicle_module/lazy/legacy/tool/jetpack/jp in equipment)
		return jp.equip_ready
	return FALSE

/obj/vehicle/sealed/mecha/proc/domove(direction)
	return call((proc_res["dyndomove"]||src), "dyndomove")(direction)

/obj/vehicle/sealed/mecha/proc/get_step_delay()
	var/tally = 0

	if(LAZYLEN(equipment))
		for(var/obj/item/vehicle_module/lazy/legacy/ME in equipment)
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

	var/obj/item/vehicle_component/mecha_actuator/actuator = internal_components[MECH_ACTUATOR]

	if(!actuator)	// Relying purely on hydraulic pumps. You're going nowhere fast.
		tally = 2 SECONDS

		return tally

	tally += 0.5 SECONDS * (1 - actuator.get_efficiency())	// Damaged actuators run slower, slowing as damage increases beyond its threshold.

	#warn deal with strafing
	if(strafing)
		tally = round(tally * actuator.strafing_multiplier)

	if(overload)	// At the end, because this would normally just make the mech *slower* since tally wasn't starting at 0.
		tally = min(1, round(tally/2))

	return max(1, round(tally, 0.1))	// Round the total to the nearest 10th. Can't go lower than 1 tick. Even humans have a delay longer than that.

/obj/vehicle/sealed/mecha/proc/dyndomove(direction)
	if(src.pr_inertial_movement.active())
		return 0
	if(!has_charge(step_energy_drain))
		return 0

	var/atom/oldloc = loc

	if(zoom)//:eyes:
		if(world.time - last_message > 20)
			src.occupant_message("Unable to move while in zoom mode.")
			last_message = world.time
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

	if(move_result)
		can_move = 0
		use_power(step_energy_drain)
		if(istype(src.loc, /turf/space))
			if(!src.check_for_support())
				src.pr_inertial_movement.start(list(src,direction))
		sleep(get_step_delay() * ((ISDIAGONALDIR(direction) && (get_dir(oldloc, loc) == direction))? SQRT_2 : 1))
		can_move = 1
		return 1
	return 0

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
			var/obj/item/vehicle_module/lazy/legacy/destr = SAFEPICK(equipment)
			if(destr)
				destr.destroy()

/obj/vehicle/sealed/mecha/proc/setInternalDamage(int_dam_flag)
	internal_damage |= int_dam_flag
	log_append_to_last("Internal damage of type [int_dam_flag].",1)
	occupant_legacy << sound('sound/mecha/internaldmgalarm.ogg',volume=50) //Better sounding.

/obj/vehicle/sealed/mecha/proc/clearInternalDamage(int_dam_flag)
	internal_damage &= ~int_dam_flag
	switch(int_dam_flag)
		if(MECHA_INT_TEMP_CONTROL)
			occupant_message("<font color='blue'><b>Life support system reactivated.</b></font>")
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

/obj/vehicle/sealed/mecha/proc/components_handle_damage(var/damage, var/type = DAMAGE_TYPE_BRUTE)
	var/obj/item/vehicle_component/plating/armor/AC = internal_components[MECH_ARMOR]

	if(AC)
		var/armor_efficiency = AC.get_efficiency()
		var/damage_change = armor_efficiency * (damage * 0.5) * AC.damage_absorption[type]
		AC.damage_part(damage_change, type)
		damage -= damage_change

	var/obj/item/vehicle_component/plating/hull/HC = internal_components[MECH_HULL]

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

/obj/vehicle/sealed/mecha/proc/dynbulletdamage(var/obj/projectile/Proj)
	var/obj/item/vehicle_component/plating/armor/ArmC = internal_components[MECH_ARMOR]

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
		temp_deflect_chance = round(ArmC.get_efficiency() * ArmC.deflect_chance)
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
		for(var/obj/item/vehicle_module/lazy/legacy/ME in equipment)
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

/obj/vehicle/sealed/mecha/emp_act(severity)
	if(get_charge())
		use_power((cell.charge/2)/severity)
		take_damage_legacy(50 / severity,"energy")
	src.log_message("EMP detected",1)
	if(prob(80))
		check_for_internal_damage(list(MECHA_INT_FIRE,MECHA_INT_TEMP_CONTROL,MECHA_INT_CONTROL_LOST,MECHA_INT_SHORT_CIRCUIT),1)

/obj/vehicle/sealed/mecha/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature>src.max_temperature)
		src.log_message("Exposed to dangerous temperature.",1)
		src.take_damage_legacy(5,"fire")	//The take_damage_legacy() proc handles armor values
		src.check_for_internal_damage(list(MECHA_INT_FIRE, MECHA_INT_TEMP_CONTROL))

/obj/vehicle/sealed/mecha/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/kit/paint))
		var/obj/item/kit/paint/P = W
		P.customize(src, user)
		return
	if(istype(W, /obj/item/robotanalyzer))
		var/obj/item/robotanalyzer/RA = W
		RA.do_scan(src, user)
		return

	#warn deal with
	if(istype(W, /obj/item/vehicle_module))
		var/obj/item/vehicle_module/lazy/legacy/E = W
		if(E.can_attach(src))
			if(!user.attempt_insert_item_for_installation(E, src))
				return
			E.attach(src)
			user.visible_message("[user] attaches [W] to [src]", "You attach [W] to [src]")
		else
			to_chat(user, "You were unable to attach [W] to [src]")
		return

	#warn deal with
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
		return ..()

/obj/vehicle/sealed/mecha/return_air()
	RETURN_TYPE(/datum/gas_mixture)
	// TODO: penalize for life support being damaged. proper cabin air sim?
	if(use_internal_tank)
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

/obj/vehicle/sealed/mecha/verb/connect_to_port()
	set name = "Connect to port"
	set category = "Exosuit Interface"
	set src = usr.loc
	set popup_menu = 0

	if(!occupant_legacy)
		return

	if(usr != occupant_legacy)
		return

	var/obj/item/vehicle_component/mecha_gas/GC = internal_components[MECH_GAS]
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

/obj/vehicle/sealed/mecha/verb/toggle_internal_tank()
	set name = "Toggle internal airtank usage"
	set category = "Exosuit Interface"
	set src = usr.loc
	set popup_menu = 0
	internal_tank()

/obj/vehicle/sealed/mecha/proc/internal_tank()
	if(usr != src.occupant_legacy)
		return

	var/obj/item/vehicle_component/mecha_gas/GC = internal_components[MECH_GAS]
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

/obj/vehicle/sealed/mecha/mob_can_enter(mob/entering, datum/event_args/actor/actor, silent, suppressed)
	if (src.occupant_legacy)
		to_chat(actor.initiator, "<span class='danger'>The [src.name] is already occupied!</span>")
		return FALSE
	var/passed
	if(src.operation_allowed(entering))
		passed = 1
	if(!passed)
		to_chat(actor.initiator, "<span class='warning'>Access denied</span>")
		src.log_append_to_last("Permission denied.")
		return FALSE
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

#warn nuke this
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

	var/output_text = {"[report_internal_damage()]
						<b>Powercell charge: </b>[isnull(cell_charge)?"No powercell installed":"[cell.percent()]%"]<br>
						<b>Air source: </b>[use_internal_tank?"Internal Airtank":"Environment"]<br>
						<b>Airtank pressure: </b>[tank_pressure]kPa<br>
						<b>Airtank temperature: </b>[tank_temperature]K|[tank_temperature - T0C]&deg;C<br>
						<b>Cabin pressure: </b>[cabin_pressure>WARNING_HIGH_PRESSURE ? "<font color='red'>[cabin_pressure]</font>": cabin_pressure]kPa<br>
						<b>Cabin temperature: </b> [return_temperature()]K|[return_temperature() - T0C]&deg;C<br>
						<b>Lights: </b>[lights?"on":"off"]<br>
					"}

	if(overload_possible)
		output_text += "<b>Leg actuators overload: [overload?"on":"off"]</b><br>"

//Cargo components. Keep this last otherwise it does weird alignment issues.
	output_text += "<b>Cargo Compartment Contents:</b><div style=\"margin-left: 15px;\">"
	if(src.cargo.len)
		for(var/obj/O in src.cargo)
			output_text += "<a href='?src=\ref[src];drop_from_cargo=\ref[O]'>Unload</a> : [O]<br>"
	else
		output_text += "Nothing"
	output_text += "</div>"
	return output_text

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
	if (locate(/obj/item/vehicle_module/lazy/legacy/tool/passenger) in contents)
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

/obj/vehicle/sealed/mecha/proc/occupant_message(message as text)
	if(message)
		if(src.occupant_legacy && src.occupant_legacy.client)
			to_chat(src.occupant_legacy, "[icon2html(src, world)] [message]")

// LEGACY, NULL-OPPED WHILE WE FIGURE OUT WHAT WE WANT FOR MECH LOGS.
/obj/vehicle/sealed/mecha/proc/log_message(message as text,red=null)
	return

// LEGACY, NULL-OPPED WHILE WE FIGURE OUT WHAT WE WANT FOR MECH LOGS.
/obj/vehicle/sealed/mecha/proc/log_append_to_last(message as text,red=null)
	return

/obj/vehicle/sealed/mecha/Topic(href, href_list)
	..()
	var/datum/topic_input/top_filter = new /datum/topic_input(href,href_list)
	if (href_list["toggle_zoom"])
		src.zoom()
	if(href_list["switch_damtype"])
		src.switch_damtype()
	if(href_list["phasing"])
		src.phasing()
	if(href_list["port_disconnect"])
		src.disconnect_from_port()
		return
	if (href_list["port_connect"])
		src.connect_to_port()
		return
	if (href_list["toggle_id_upload"])
		if(usr != src.occupant_legacy)	return
		add_req_access = !add_req_access
		return
	if(href_list["toggle_maint_access"])
		if(usr != src.occupant_legacy)	return
		if(state)
			occupant_message("<font color='red'>Maintenance protocols in effect</font>")
			return
		maint_access = !maint_access
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
		for (var/obj/item/vehicle_module/lazy/legacy/tool/passenger/P in contents)
			if (P.occupant_legacy)
				passengers["[P.occupant_legacy]"] = P

		if (!passengers)
			to_chat(user, "<span class='warning'>There are no passengers to remove.</span>")
			return

		var/pname = input(user, "Choose a passenger to forcibly remove.", "Forcibly Remove Passenger") as null|anything in passengers

		if (!pname)
			return

		var/obj/item/vehicle_module/lazy/legacy/tool/passenger/P = passengers[pname]
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
		else
			src.occupant_message("<font color='red'>Recalibration failed.</font>")
	if(href_list["drop_from_cargo"])
		var/obj/O = locate(href_list["drop_from_cargo"])
		if(O && (O in src.cargo))
			src.occupant_message("<span class='notice'>You unload [O].</span>")
			O.forceMove(get_turf(src))
			src.cargo -= O
			var/turf/T = get_turf(O)
			if(T)
				T.Entered(O)

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
	var/obj/item/vehicle_component/mecha_electrical/EC = internal_components[MECH_ELECTRIC]

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
	var/obj/item/vehicle_component/mecha_electrical/EC = internal_components[MECH_ELECTRIC]

	if(!EC)
		amount /= 4
	else
		amount *= EC.get_efficiency()

	if(!isnull(get_charge()))
		cell.give(amount)
		return 1
	return 0

/obj/vehicle/sealed/mecha/proc/legacy_air_flow_step()
	var/obj/vehicle/sealed/mecha/mecha = src
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

/obj/vehicle/sealed/mecha/proc/legacy_internal_damage_step()
	var/obj/vehicle/sealed/mecha/mecha = src
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

/obj/vehicle/sealed/mecha/cloak()
	. = ..()
	if(occupant_legacy && occupant_legacy.client && cloaked_selfimage)
		occupant_legacy.client.images += cloaked_selfimage

/obj/vehicle/sealed/mecha/uncloak()
	if(occupant_legacy && occupant_legacy.client && cloaked_selfimage)
		occupant_legacy.client.images -= cloaked_selfimage
	return ..()

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

/obj/vehicle/sealed/mecha/occupant_added(mob/adding, datum/event_args/actor/actor, control_flags, silent)
	. = ..()
	if(occupant_legacy)
		stack_trace("how did we get another?")
		return

	var/mob/living/carbon/human/H = adding
	occupant_legacy = H
	add_fingerprint(H)
	log_append_to_last("[H] moved in as pilot.")
	update_icon()
	if(occupant_legacy.hud_used)
		minihud = new (occupant_legacy.hud_used, src)

	GrantActions(occupant_legacy, 1)

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
