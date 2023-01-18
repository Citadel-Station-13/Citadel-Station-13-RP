/proc/count_drones()
	var/drones = 0
	for(var/mob/living/silicon/robot/drone/D in GLOB.player_list)
		drones++
	return drones

/proc/count_matriarchs()
	var/matriarchs = 0
	for(var/mob/living/silicon/robot/drone/construction/matriarch/M in GLOB.player_list)
		matriarchs++
	return matriarchs

/obj/machinery/drone_fabricator
	name = "drone fabricator"
	desc = "A large automated factory for producing maintenance drones."
	icon = 'icons/obj/machines/fabricators/industrial_fab.dmi'
	icon_state = "industrial"
	base_icon_state = "industrial"

	appearance_flags = 0

	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 20
	active_power_usage = 5000
	var/printing = FALSE
	var/fabricator_tag = "Upper Level"
	var/drone_progress = 0
	var/produce_drones = 2
	var/time_last_drone = 500
	var/drone_type = /mob/living/silicon/robot/drone
	var/is_spawn_safe = TRUE

/obj/machinery/drone_fabricator/derelict
	name = "construction drone fabricator"
	fabricator_tag = "Upper Level Construction"
	drone_type = /mob/living/silicon/robot/drone/construction
	is_spawn_safe = FALSE

/obj/machinery/drone_fabricator/mining
	name = "mining drone fabricator"
	fabricator_tag = "Upper Level Mining"
	drone_type = /mob/living/silicon/robot/drone/mining

/obj/machinery/drone_fabricator/matriarch
	name = "matriarch drone fabricator"
	fabricator_tag = "Upper Level Matriarch"
	drone_type = /mob/living/silicon/robot/drone/construction/matriarch

/obj/machinery/drone_fabricator/update_icon_state()
	. = ..()
	if(machine_stat & NOPOWER || !produce_drones)
		icon_state = "[base_icon_state]-off"
	else if(printing)
		icon_state = "[base_icon_state]-active"
	else
		icon_state = base_icon_state

/obj/machinery/drone_fabricator/update_overlays()
	. = ..()
	cut_overlays()
	if(panel_open)
		add_overlay("[base_icon_state]-panel")

/obj/machinery/drone_fabricator/process(delta_time)

	if(SSticker.current_state < GAME_STATE_PLAYING)
		return

	if(drone_progress >= 100)
		printing = FALSE
		update_appearance()
		return

	printing = TRUE
	var/elapsed = world.time - time_last_drone
	drone_progress = round((elapsed/config_legacy.drone_build_time)*100)

	if(drone_progress >= 100)
		visible_message("\The [src] voices a strident beep, indicating a drone chassis is prepared.")

	update_appearance()

/obj/machinery/drone_fabricator/examine(mob/user)
	. = ..()
	if(produce_drones && drone_progress >= 100 && istype(user,/mob/observer/dead) && config_legacy.allow_drone_spawn && count_drones() < config_legacy.max_maint_drones)
		. += "<BR><B>A drone is prepared. Select 'Join As Drone' from the Ghost tab to spawn as a maintenance drone.</B>"
	if(!is_spawn_safe)
		. += "<BR> It seems this fabricator has gone into safety lockdown, maybe you can reset it."

/obj/machinery/drone_fabricator/proc/create_drone(var/client/player)

	if(machine_stat & NOPOWER)
		return

	if(!produce_drones || !config_legacy.allow_drone_spawn || count_drones() >= config_legacy.max_maint_drones)
		return

	if((drone_type == /mob/living/silicon/robot/drone/construction/matriarch) && (count_matriarchs() > 0))
		return

	if(player && !istype(player.mob,/mob/observer/dead))
		return

	visible_message("\The [src] churns and grinds as it lurches into motion, disgorging a shiny new drone after a few moments.")
	flick("h_lathe_leave",src)
	drone_progress = 0

	time_last_drone = world.time

	var/mob/living/silicon/robot/drone/new_drone = new drone_type(get_turf(src))
	if(player)
		announce_ghost_joinleave(player, 0, "They have taken control over a maintenance drone.")
		if(player.mob && player.mob.mind) player.mob.mind.reset()
		new_drone.transfer_personality(player)
		assign_drone_to_matrix(new_drone, "[GLOB.using_map.company_name]")

	return new_drone

/mob/observer/dead/verb/join_as_drone()

	set category = "Ghost"
	set name = "Join As Drone"
	set desc = "If there is a powered, enabled fabricator in the game world with a prepared chassis, join as a maintenance drone."

	if(SSticker.current_state < GAME_STATE_PLAYING)
		to_chat(src, "<span class='danger'>The game hasn't started yet!</span>")
		return

	if(!(config_legacy.allow_drone_spawn))
		to_chat(src, "<span class='danger'>That verb is not currently permitted.</span>")
		return

	if (!src.stat)
		return

	if (usr != src)
		return 0 //something is terribly wrong

	if(jobban_isbanned(src,"Cyborg"))
		to_chat(usr, "<span class='danger'>You are banned from playing synthetics and cannot spawn as a drone.</span>")
		return

	if(!MayRespawn(1))
		return

	var/deathtime = world.time - src.timeofdeath
	var/deathtimeminutes = round(deathtime / (1 MINUTE))
	var/pluralcheck = "minute"
	if(deathtimeminutes == 0)
		pluralcheck = ""
	else if(deathtimeminutes == 1)
		pluralcheck = " [deathtimeminutes] minute and"
	else if(deathtimeminutes > 1)
		pluralcheck = " [deathtimeminutes] minutes and"
	var/deathtimeseconds = round((deathtime - deathtimeminutes * 1 MINUTE) / 10,1)

	if (deathtime < 5 MINUTES)
		to_chat(usr, "You have been dead for[pluralcheck] [deathtimeseconds] seconds.")
		to_chat(usr, "You must wait 5 minutes to respawn as a drone!")
		return

	var/list/all_fabricators = list()
	for(var/obj/machinery/drone_fabricator/DF in GLOB.machines)
		if(DF.machine_stat & NOPOWER || !DF.produce_drones)
			continue
		if(!DF.is_spawn_safe)
			continue
		if(DF.drone_progress >= 100)
			all_fabricators[DF.fabricator_tag] = DF

	if(!all_fabricators.len)
		to_chat(src, "<span class='danger'>There are no available drone spawn points, sorry.</span>")
		return

	var/choice = input(src,"Which fabricator do you wish to use?") as null|anything in all_fabricators
	if(choice)
		var/obj/machinery/drone_fabricator/chosen_fabricator = all_fabricators[choice]
		chosen_fabricator.create_drone(src.client)

/obj/machinery/drone_fabricator/attack_hand(mob/user)
	if(!is_spawn_safe)
		is_spawn_safe = TRUE
		to_chat(user, "You inform the fabricator that it is safe for drones to roam around.")
