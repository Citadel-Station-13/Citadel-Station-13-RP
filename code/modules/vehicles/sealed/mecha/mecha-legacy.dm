#define MELEE 1
#define RANGED 2
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
	/// What direction will the mech face when entered/powered on? Defaults to South.
	var/dir_in = 2

	var/state = MECHA_OPERATING
	#warn enable ID upload if just built
	var/add_req_access = FALSE
	#warn enable maint if just built
	var/maint_access = FALSE
	var/datum/effect_system/spark_spread/spark_system = new

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

	var/static/image/radial_image_eject = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_eject")
	var/static/image/radial_image_airtoggle = image(icon= 'icons/mob/radial.dmi', icon_state = "radial_airtank")
	var/static/image/radial_image_lighttoggle = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_light")
	var/static/image/radial_image_statpanel = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_examine2")

	//* Legacy - Actions *//
	var/datum/mini_hud/mech/minihud

	var/zoom = 0
	var/zoom_possible = 0

	/// Are we currently phasing.
	var/phasing = 0
	/// This is to allow phasing.
	var/phasing_possible = 0
	/// This is an internal check during the relevant procs.
	var/can_phase = TRUE
	var/phasing_energy_drain = 200

//All of those are for the HUD buttons in the top left. See Grant and Remove procs in mecha_actions.
	var/datum/action/mecha/mech_toggle_internals/internals_action
	var/datum/action/mecha/mech_toggle_lights/lights_action
	var/datum/action/mecha/mech_view_stats/stats_action
	var/datum/action/mecha/strafe/strafing_action

	var/datum/action/mecha/mech_zoom/zoom_action
	var/datum/action/mecha/mech_cycle_equip/cycle_action
	var/datum/action/mecha/mech_toggle_phasing/phasing_action

	//* Legacy *//
	/// the first controller in us
	var/mob/occupant_legacy

/obj/vehicle/sealed/mecha/Initialize(mapload)
	internals_action = new(src)
	lights_action = new(src)
	stats_action = new(src)
	strafing_action = new(src)

	zoom_action = new(src)
	cycle_action = new(src)
	phasing_action = new(src)
	. = ..()
	update_transform()

	icon_state += "-open"
	add_radio()
	add_cabin()
	add_airtank()

	spark_system.set_up(2, 0, src)
	spark_system.attach(src)

/obj/vehicle/sealed/mecha/atom_destruction()
	if(prob(30))
		explosion(get_turf(loc), 0, 0, 1, 3)
	return ..()

/obj/vehicle/sealed/mecha/Destroy()
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
			comp.run_damage_instance(rand(20, 40), DAMAGE_TYPE_BRUTE, 4.5, ARMOR_BOMB)
			WR.crowbar_salvage += comp
		if(power_cell)
			WR.crowbar_salvage += power_cell
			power_cell.forceMove(WR)
			power_cell.charge = rand(0, power_cell.charge)
			power_cell = null
		if(internal_tank)
			WR.crowbar_salvage += internal_tank
			internal_tank.forceMove(WR)
			internal_tank = null
	else
		QDEL_NULL(power_cell)
		QDEL_NULL(internal_tank)

	QDEL_NULL(spark_system)
	QDEL_NULL(minihud)

	return ..()

/obj/vehicle/sealed/mecha/drain_energy(datum/actor, amount, flags)
	if(!power_cell)
		return 0
	return power_cell.drain_energy(actor, amount, flags)

/obj/vehicle/sealed/mecha/can_drain_energy(datum/actor, amount)
	return TRUE

/obj/vehicle/sealed/mecha/proc/add_airtank()
	internal_tank = new /obj/machinery/portable_atmospherics/canister/air(src)
	return internal_tank

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

/obj/vehicle/sealed/mecha/proc/check_for_support()
	var/list/things = orange(1, src)

	if(locate(/obj/structure/grille) in things || locate(/obj/structure/lattice) in things || locate(/turf/simulated) in things || locate(/turf/unsimulated) in things)
		return 1
	else
		return 0

/obj/vehicle/sealed/mecha/hear_talk(mob/M, list/message_pieces, verb)
	if(M == occupant_legacy && radio.broadcasting)
		radio.talk_into(M, message_pieces)

#warn this
/obj/vehicle/sealed/mecha/proc/interface_action(obj/machinery/target)
	if(istype(target, /obj/machinery/access_button) || istype(target, /obj/machinery/button/remote/blast_door))
		src.occupant_message("<span class='notice'>Interfacing with [target].</span>")
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
			return UI_INTERACTIVE
		if(src_object in view(2, src))
			return UI_UPDATE //if they're close enough, allow the occupant_legacy to see the screen through the viewport or whatever.

/obj/vehicle/sealed/mecha/proc/can_ztravel()
	for(var/obj/item/vehicle_module/lazy/legacy/tool/jetpack/jp in equipment)
		return jp.equip_ready
	return FALSE

/obj/vehicle/sealed/mecha/proc/get_step_delay()
	var/tally = 0

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
	var/atom/oldloc = loc

	if(overload)//Check if you have leg overload
		integrity--
		if(integrity < initial(integrity) - initial(integrity)/3)
			overload = 0
			src.occupant_message("<font color='red'>Leg actuators damage threshold exceded. Disabling overload.</font>")
	var/move_result = 0
	//Up/down zmove
	if(direction & UP || direction & DOWN)
		if(!can_ztravel())
			occupant_message("<span class='warning'>Your vehicle lacks the capacity to move in that direction!</span>")
			return FALSE
	return 0

/obj/vehicle/sealed/mecha/Bump(atom/obstacle)
	// TODO: refactor phasing.
	if(phasing && (estimate_cell_power_remaining() >= phasing_energy_drain))
		var/atom/current = loc
		var/into_dir = get_dir(current, obstacle)
		spawn()
			if(loc == current)
				if((estimate_cell_power_remaining() >= phasing_energy_drain) && can_phase)
					can_phase = FALSE
					flick("[initial_icon]-phase", src)
					forceMove(into_dir)
					src.use_power(phasing_energy_drain)
					sleep(get_step_delay() * 3)
					can_phase = TRUE
					occupant_message("Phased through [obstacle].")
	else
		..()

/obj/vehicle/sealed/mecha/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature>src.max_temperature)
		src.take_damage_legacy(5,"fire")	//The take_damage_legacy() proc handles armor values
		src.check_for_internal_damage(list(MECHA_INT_FIRE, MECHA_INT_TEMP_CONTROL))

#warn impl
/obj/vehicle/sealed/mecha/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/vehicle_tracking_beacon))
		if(!user.attempt_insert_item_for_installation(W, src))
			return
		user.visible_message("[user] attaches [W] to [src].", "You attach [W] to [src]")
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

/obj/vehicle/sealed/mecha/Topic(href, href_list)
	..()
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
		return
	if(href_list["repair_int_control_lost"])
		if(usr != src.occupant_legacy)	return
		src.occupant_message("Recalibrating coordination system.")
		var/T = src.loc
		sleep(100)
		if(T == src.loc)
			src.clearInternalDamage(MECHA_INT_CONTROL_LOST)
			src.occupant_message("<font color='blue'>Recalibration successful.</font>")
		else
			src.occupant_message("<font color='red'>Recalibration failed.</font>")

//* STOP USING THIS. *//
/obj/vehicle/sealed/mecha/proc/has_charge(amount)
	return estimate_cell_power_remaining() >= amount

//* STOP USING THIS. *//
/obj/vehicle/sealed/mecha/proc/get_charge()
	return estimate_cell_power_remaining()

//* STOP USING THIS. *//
/obj/vehicle/sealed/mecha/proc/use_power(amount)
	update_cell_alerts()
	return draw_sourced_power_oneoff("misc", "misc", DYNAMIC_CELL_UNITS_TO_J(amount))

//* STOP USING THIS. *//
/obj/vehicle/sealed/mecha/proc/give_power(amount)
	update_cell_alerts()
	return power_cell?.give(amount)

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
	#warn slightly smarter control please
	#warn if temp controller is up, try to stabilize

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

/obj/vehicle/sealed/mecha/cloak()
	. = ..()
	if(occupant_legacy && occupant_legacy.client && cloaked_selfimage)
		occupant_legacy.client.images += cloaked_selfimage

/obj/vehicle/sealed/mecha/uncloak()
	if(occupant_legacy && occupant_legacy.client && cloaked_selfimage)
		occupant_legacy.client.images -= cloaked_selfimage
	return ..()

/obj/vehicle/sealed/mecha/proc/update_cell_alerts()
	if(occupant_legacy && power_cell)
		var/cellcharge = power_cell.maxcharge && (power_cell.charge / power_cell.maxcharge)
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

/obj/vehicle/sealed/mecha/occupant_added(mob/adding, datum/event_args/actor/actor, control_flags, silent)
	. = ..()
	if(occupant_legacy)
		stack_trace("how did we get another?")
		return

	var/mob/living/carbon/human/H = adding
	occupant_legacy = H
	add_fingerprint(H)
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
