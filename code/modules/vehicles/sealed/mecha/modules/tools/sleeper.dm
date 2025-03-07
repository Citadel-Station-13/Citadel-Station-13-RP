/obj/item/vehicle_module/tool/sleeper
	name = "mounted sleeper"
	desc = "A sleeper. Mountable to an exosuit. (Can be attached to: Medical Exosuits)"
	icon = 'icons/obj/medical/cryogenic2.dmi'
	icon_state = "sleeper_0"
	origin_tech = list(TECH_DATA = 2, TECH_BIO = 3)
	energy_drain = 20
	range = MELEE
	equip_cooldown = 30
	mech_flags = EXOSUIT_MODULE_MEDICAL
	var/mob/living/carbon/human/occupant_legacy = null
	var/datum/global_iterator/pr_mech_sleeper
	var/inject_amount = 5
	required_type = list(/obj/vehicle/sealed/mecha/medical)
	salvageable = FALSE
	allow_duplicate = TRUE
	var/list/available_chemicals = list()
	var/list/base_chemicals = list("inaprovaline" = "Inaprovaline", "paracetamol" = "Paracetamol", "anti_toxin" = "Dylovene", "dexalin" = "Dexalin")
	var/stasis_level = 0 //Every 'this' life ticks are applied to the mob (when life_ticks%stasis_level == 1)
	var/stasis_choices = list("Complete (1%)" = 100, "Deep (10%)" = 10, "Moderate (20%)" = 5, "Light (50%)" = 2, "None (100%)" = 0)
	var/filtering = FALSE
	var/pumping = FALSE

/obj/item/vehicle_module/tool/sleeper/Initialize(mapload)
	. = ..()
	pr_mech_sleeper = new /datum/global_iterator/mech_sleeper(list(src),0)
	pr_mech_sleeper.set_delay(equip_cooldown)
	return

/obj/item/vehicle_module/tool/sleeper/Destroy()
	qdel(pr_mech_sleeper)
	for(var/atom/movable/AM in src)
		AM.forceMove(get_turf(src))
	return ..()

/obj/item/vehicle_module/tool/sleeper/Exit(atom/movable/O)
	return FALSE

/obj/item/vehicle_module/tool/sleeper/action(var/mob/living/carbon/human/target)
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
		/*
		if(target.client)
			target.client.perspective = EYE_PERSPECTIVE
			target.client.eye = chassis
		*/
		set_ready_state(0)
		pr_mech_sleeper.start()
		occupant_message("<font color='blue'>[target] successfully loaded into [src]. Life support functions engaged.</font>")
		chassis.visible_message("[chassis] loads [target] into [src].")
		log_message("[target] loaded. Life support functions engaged.")
	return

/obj/item/vehicle_module/tool/sleeper/proc/go_out()
	if(!occupant_legacy)
		return
	occupant_legacy.forceMove(get_turf(src))
	occupant_legacy.update_perspective()
	occupant_message("[occupant_legacy] ejected. Life support functions disabled.")
	log_message("[occupant_legacy] ejected. Life support functions disabled.")
	/*
	if(occupant_legacy.client)
		occupant_legacy.client.eye = occupant_legacy.client.mob
		occupant_legacy.client.perspective = MOB_PERSPECTIVE
	*/
	occupant_legacy.Stasis(0)
	occupant_legacy = null
	pr_mech_sleeper.stop()
	set_ready_state(1)

/obj/item/vehicle_module/tool/sleeper/detach()
	if(occupant_legacy)
		occupant_message("Unable to detach [src] - equipment occupied.")
		return
	pr_mech_sleeper.stop()
	return ..()

/obj/item/vehicle_module/tool/sleeper/get_equip_info()
	var/output = ..()
	if(output)
		var/temp = ""
		if(occupant_legacy)
			temp = "<br />\[Occupant: [occupant_legacy] (Health: [occupant_legacy.health]%)\]<br /><a href='?src=\ref[src];view_stats=1'>View stats</a>|<a href='?src=\ref[src];eject=1'>Eject</a>"
		return "[output] [temp]"
	return

/obj/item/vehicle_module/tool/sleeper/Topic(href,href_list)
	if(..())
		return TRUE
	if(href_list["view_stats"])
		nano_ui_interact(usr)
	if(href_list["eject"])
		go_out()
	if(href_list["sleeper_filter"])
		if(filtering != text2num(href_list["sleeper_filter"]))
			toggle_filter()
	if(href_list["pump"])
		if(pumping != text2num(href_list["pump"]))
			toggle_pump()
	if(href_list["chemical"] && href_list["amount"])
		if(occupant_legacy && occupant_legacy.stat != DEAD)
			if(href_list["chemical"] in available_chemicals) // Your hacks are bad and you should feel bad
				inject_chemical(href_list["chemical"], text2num(href_list["amount"]))
	if(href_list["change_stasis"])
		var/new_stasis = input("Levels deeper than 50% stasis level will render the patient unconscious.","Stasis Level") as null|anything in stasis_choices
		if(new_stasis && CanUseTopic(usr, default_state) == UI_INTERACTIVE)
			stasis_level = stasis_choices[new_stasis]

	return TRUE

/obj/item/vehicle_module/tool/sleeper/nano_ui_interact(var/mob/user, var/ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = outside_state)
	var/data[0]
	if(chassis.cell.charge)
		data["power"] = TRUE
	else
		data["power"] = FALSE
	available_chemicals.Cut()
	available_chemicals = base_chemicals.Copy()
	var/obj/item/vehicle_module/tool/syringe_gun/SG = locate(/obj/item/vehicle_module/tool/syringe_gun) in chassis
	if(SG)
		available_chemicals += SG.known_reagents.Copy()
		uniqueList_inplace(available_chemicals)

	var/list/reagents = list()
	for(var/T in available_chemicals)
		var/list/reagent = list()
		reagent["id"] = T
		reagent["name"] = available_chemicals[T]
		if(occupant_legacy)
			reagent["amount"] = occupant_legacy.reagents.get_reagent_amount(T)
		reagents += list(reagent)
	data["reagents"] = reagents.Copy()

	if(occupant_legacy)
		data["occupant"] = 1
		switch(occupant_legacy.stat)
			if(CONSCIOUS)
				data["stat"] = "Conscious"
			if(UNCONSCIOUS)
				data["stat"] = "Unconscious"
			if(DEAD)
				data["stat"] = "<font color='red'>Dead</font>"
		data["health"] = occupant_legacy.health
		data["maxHealth"] = occupant_legacy.getMaxHealth()
		if(iscarbon(occupant_legacy))
			var/mob/living/carbon/C = occupant_legacy
			data["pulse"] = C.get_pulse(GETPULSE_TOOL)
		data["brute"] = occupant_legacy.getBruteLoss()
		data["burn"] = occupant_legacy.getFireLoss()
		data["oxy"] = occupant_legacy.getOxyLoss()
		data["tox"] = occupant_legacy.getToxLoss()
	else
		data["occupant"] = 0
	data["beaker"] = -1
	data["filtering"] = filtering
	data["pump"] = pumping

	var/stasis_level_name = "Error!"
	for(var/N in stasis_choices)
		if(stasis_choices[N] == stasis_level)
			stasis_level_name = N
			break
	data["stasis"] = stasis_level_name

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "sleeper.tmpl", "Sleeper UI", 600, 600, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/item/vehicle_module/tool/sleeper/proc/inject_chemical(chemical, amount)
	if(occupant_legacy && occupant_legacy.reagents)
		occupant_message("Injecting [occupant_legacy] with [amount] units of [chemical].")
		log_message("Injecting [occupant_legacy] with [amount] units of [chemical].")
		occupant_legacy.reagents.add_reagent(chemical,amount)
		chassis.use_power(DYNAMIC_J_TO_CELL_UNITS(amount * CHEM_SYNTH_ENERGY))


/obj/item/vehicle_module/tool/sleeper/verb/eject()
	set name = "Sleeper Eject"
	set category = "Exosuit Interface"
	set src = usr.loc
	set popup_menu = 0
	if(usr!=src.occupant_legacy || usr.stat == 2)
		return
	if(!src || !usr || !occupant_legacy || (occupant_legacy != usr)) //Check if someone's released/replaced/bombed him already
		return
	go_out()//and release him from the eternal prison.

/obj/item/vehicle_module/tool/sleeper/proc/toggle_filter()
	if(!occupant_legacy)
		filtering = 0
		return
	filtering = !filtering

/obj/item/vehicle_module/tool/sleeper/proc/toggle_pump()
	if(!occupant_legacy)
		pumping = 0
		return
	pumping = !pumping

/datum/global_iterator/mech_sleeper
	var/dialysis_reagent_filter_flags = ~REAGENT_FILTER_NO_COMMON_BIOANALYSIS

/datum/global_iterator/mech_sleeper/process(var/obj/item/vehicle_module/tool/sleeper/S)
	if(!S.chassis)
		S.set_ready_state(1)
		return stop()
	if(!S.chassis.has_charge(S.energy_drain))
		S.set_ready_state(1)
		S.log_message("Deactivated.")
		S.occupant_message("[src] deactivated - no power.")
		return stop()
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
	return
