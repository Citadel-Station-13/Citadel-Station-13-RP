/obj/item/vehicle_module/lazy/legacy/tool/sleeper
	name = "mounted sleeper"
	desc = "A sleeper. Mountable to an exosuit. (Can be attached to: Medical Exosuits)"
	icon = 'icons/obj/medical/cryogenic2.dmi'
	icon_state = "sleeper_0"
	origin_tech = list(TECH_DATA = 2, TECH_BIO = 3)
	energy_drain = 20
	range = MELEE
	equip_cooldown = 30
	ui_component = "Sleeper"
	var/mob/living/carbon/human/occupant_legacy = null
	var/stasis_level = 0 //Every 'this' life ticks are applied to the mob (when life_ticks%stasis_level == 1)
	var/stasis_choices = list("Complete (1%)" = 100, "Deep (10%)" = 10, "Moderate (20%)" = 5, "Light (50%)" = 2, "None (100%)" = 0)
	var/filtering = FALSE
	var/pumping = FALSE
	var/dialysis_reagent_filter_flags = ~REAGENT_FILTER_NO_COMMON_BIOANALYSIS

/obj/item/vehicle_module/lazy/legacy/tool/sleeper/Destroy()
	// TODO: admin delete wrapper for mechs that drop mobs, we shouldn't be dropping shit on Destroy().
	for(var/atom/movable/AM in src)
		AM.forceMove(get_turf(src))
	return ..()

/obj/item/vehicle_module/lazy/legacy/tool/sleeper/on_install(obj/vehicle/vehicle, datum/event_args/actor/actor, silent)
	..()
	START_PROCESSING(SSobj, src)

/obj/item/vehicle_module/lazy/legacy/tool/sleeper/on_uninstall(obj/vehicle/vehicle, datum/event_args/actor/actor, silent)
	..()
	STOP_PROCESSING(SSobj, src)

/obj/item/vehicle_module/lazy/legacy/tool/sleeper/action(var/mob/living/carbon/human/target)
	if(!action_checks(target))
		return
	if(!istype(target))
		return
	if(target.buckled)
		occupant_message("[target] will not fit into the sleeper because they are buckled to [target.buckled].")
		return
	if(occupant_legacy)
		occupant_message("The sleeper is already occupied")
		return
	if(target.has_buckled_mobs())
		occupant_message(SPAN_WARNING("\The [target] has other entities attached to it. Remove them first."))
		return
	occupant_message("You start putting [target] into [src].")
	chassis.visible_message("[chassis] starts putting [target] into the [src].")
	var/C = chassis.loc
	var/T = target.loc
	if(do_after_cooldown(target))
		if(chassis.loc!=C || target.loc!=T)
			return
		if(occupant_legacy)
			occupant_message(SPAN_DANGER("<B>The sleeper is already occupied!</B>"))
			return
		target.forceMove(src)
		target.update_perspective()
		occupant_legacy = target
		set_ready_state(0)
		occupant_message("<font color='blue'>[target] successfully loaded into [src]. Life support functions engaged.</font>")
		chassis.visible_message("[chassis] loads [target] into [src].")

/obj/item/vehicle_module/lazy/legacy/tool/sleeper/proc/go_out()
	if(!occupant_legacy)
		return
	occupant_legacy.forceMove(get_turf(src))
	occupant_legacy.update_perspective()
	occupant_message("[occupant_legacy] ejected. Life support functions disabled.")
	occupant_legacy.Stasis(0)
	occupant_legacy = null
	set_ready_state(1)

/obj/item/vehicle_module/lazy/legacy/tool/sleeper/detach()
	if(occupant_legacy)
		occupant_message("Unable to detach [src] - equipment occupied.")
		return
	return ..()

/obj/item/vehicle_module/lazy/legacy/tool/sleeper/Topic(href,href_list)
	if(..())
		return TRUE
	if(href_list["change_stasis"])
		var/new_stasis = input("Levels deeper than 50% stasis level will render the patient unconscious.","Stasis Level") as null|anything in stasis_choices
		if(new_stasis && CanUseTopic(usr, default_state) == UI_INTERACTIVE)
			stasis_level = stasis_choices[new_stasis]
	return TRUE

/obj/item/vehicle_module/lazy/legacy/tool/sleeper/proc/encode_occupant_ui_data()
	if(!istype(occupant_legacy))
		return null
	. = list()
	.["damBrute"] = occupant_legacy.getActualBruteLoss()
	.["damBurn"] = occupant_legacy.getActualFireLoss()
	.["damOxy"] = occupant_legacy.getOxyLoss()
	.["damTox"] = occupant_legacy.getToxLoss()
	.["pulse"] = occupant_legacy.get_pulse(GETPULSE_TOOL)
	.["health"] = occupant_legacy.health
	.["maxHealth"] = occupant_legacy.getMaxHealth()
	var/stat_enum
	switch(occupant_legacy.stat)
		if(CONSCIOUS)
			stat_enum = "conscious"
		if(UNCONSCIOUS)
			stat_enum = "unconscious"
		if(DEAD)
			stat_enum = "dead"
		else
			stat_enum = "dead"
	.["stat"] = stat_enum

/obj/item/vehicle_module/lazy/legacy/tool/sleeper/proc/update_occupant_ui_data()
	vehicle_ui_module_push(data = list("occupant" = encode_occupant_ui_data()))

/obj/item/vehicle_module/lazy/legacy/tool/sleeper/vehicle_ui_module_act(action, list/params, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	switch(action)
		if("stasisLevel")
			vehicle_log_for_admins(
				actor,
				"setStasis",
				list(
					"level" = ,
				)
			)
			#warn impl
			return TRUE
		if("setPumpActive")
			var/active = !!params["active"]
			if(pumping == active)
				return TRUE
			set_pumping_active(active)
			vehicle_log_for_admins(
				actor,
				"setPump",
				list(
					"state" = pumping,
				)
			)
			return TRUE
		if("setDialysisActive")
			var/active = !!params["active"]
			if(filtering == active)
				return TRUE
			set_filtering_active(active)
			vehicle_log_for_admins(
				actor,
				"setFilter",
				list(
					"state" = filtering,
				)
			)
			return TRUE
		if("eject")
			if(!occupant_legacy)
				update_occupant_ui_data()
				return TRUE
			vehicle_log_for_admins(
				actor,
				"ejected",
				list(
					"occupant" = "[occupant_legacy]",
				),
			)
			go_out()
			update_occupant_ui_data()
			return TRUE


/obj/item/vehicle_module/lazy/legacy/tool/sleeper/vehicle_ui_module_data()
	. = ..()
	.["occupant"] = encode_occupant_ui_data()
	.["filteringStomach"] = pumping
	.["filteringBlood"] = filtering

/obj/item/vehicle_module/lazy/legacy/tool/sleeper/nano_ui_interact(var/mob/user, var/ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = outside_state)
	var/data[0]

	var/stasis_level_name = "Error!"
	for(var/N in stasis_choices)
		if(stasis_choices[N] == stasis_level)
			stasis_level_name = N
			break
	data["stasis"] = stasis_level_name

/obj/item/vehicle_module/lazy/legacy/tool/sleeper/proc/set_filtering_active(active)
	if(filtering == active)
		return TRUE
	filtering = active
	vehicle_ui_module_push(data = list("filteringBlood" = filtering))
	return TRUE

/obj/item/vehicle_module/lazy/legacy/tool/sleeper/proc/set_pumping_active(active)
	if(pumping == active)
		return TRUE
	pumping = active
	vehicle_ui_module_push(data = list("filteringStomach" = pumping))
	return TRUE

/obj/item/vehicle_module/lazy/legacy/tool/sleeper/process(delta_time)
	var/obj/item/vehicle_module/lazy/legacy/tool/sleeper/S = src
	if(!S.chassis)
		return
	#warn power draw?
	if(!S.chassis.has_charge(S.energy_drain))
		return
	var/mob/living/carbon/human/M = S.occupant_legacy
	if(!M)
		return
	if(S.stasis_level)
		M.Stasis(S.stasis_level)
		S.chassis.use_power(S.energy_drain)
	if(S.filtering > 0)
		// filter 3 units per chem-type inside them, or remaining volume, whichever is lesser
		// we will also pump out 1/3 of that volume as their blood.
		var/filtered_volume = M.reagents?.filter_to_void(
			length(M.reagents.reagent_volumes) * 3,
			dialysis_reagent_filter_flags
		)
		M.erase_blood(filtered_volume * (1 / 3))
		S.chassis.use_power(S.energy_drain)
	if(S.pumping > 0)
		// filter 3 units per chem-type inside them, or remaining volume, whichever is lesser
		M.ingested?.filter_to_void(
			length(M.ingested.reagent_volumes) * 3,
			dialysis_reagent_filter_flags,
		)
		S.chassis.use_power(S.energy_drain)
	update_occupant_ui_data()

/obj/item/vehicle_module/lazy/legacy/tool/sleeper/verb/eject()
	set name = "Sleeper Eject"
	set category = "Exosuit Interface"
	set src = usr.loc
	set popup_menu = 0
	if(usr!=src.occupant_legacy || usr.stat == 2)
		return
	if(!src || !usr || !occupant_legacy || (occupant_legacy != usr)) //Check if someone's released/replaced/bombed him already
		return
	go_out()//and release him from the eternal prison.
