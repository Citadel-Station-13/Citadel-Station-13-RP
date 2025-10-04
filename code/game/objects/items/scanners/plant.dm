/obj/item/plant_analyzer
	name = "plant analyzer"
	icon = 'icons/obj/device.dmi'
	icon_state = "hydro"
	item_state = "analyzer"
	var/datum/seed/last_seed
	var/list/last_reagents
	w_class = WEIGHT_CLASS_SMALL

/obj/item/plant_analyzer/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	ui_interact(user)

/obj/item/plant_analyzer/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PlantAnalyzer", name)
		ui.open()

/obj/item/plant_analyzer/ui_state()
	return GLOB.inventory_state

/obj/item/plant_analyzer/ui_data(mob/user, datum/tgui/ui)
	var/list/data = ..()

	var/datum/seed/grown_seed = locate(last_seed)
	if(!istype(grown_seed))
		return list("no_seed" = TRUE)

	data["no_seed"] = FALSE
	data["seed"] = grown_seed.get_tgui_analyzer_data(user)
	data["reagents"] = last_reagents

	return data

/obj/item/plant_analyzer/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	if(..())
		return TRUE

	switch(action)
		if("print")
			print_report(usr)
			return TRUE
		if("close")
			last_seed = null
			last_reagents = null
			return TRUE

/obj/item/plant_analyzer/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	if(!(clickchain_flags & CLICKCHAIN_HAS_PROXIMITY))
		return

	var/datum/seed/grown_seed
	var/datum/reagent_holder/grown_reagents
	if(istype(target,/obj/structure/table))
		return ..()
	else if(istype(target,/obj/item/reagent_containers/food/snacks/grown))

		var/obj/item/reagent_containers/food/snacks/grown/G = target
		grown_seed = SSplants.seeds[G.plantname]
		grown_reagents = G.reagents

	else if(istype(target,/obj/item/grown))

		var/obj/item/grown/G = target
		grown_seed = SSplants.seeds[G.plantname]
		grown_reagents = G.reagents

	else if(istype(target,/obj/item/seeds))

		var/obj/item/seeds/S = target
		grown_seed = S.seed

	else if(istype(target,/obj/machinery/portable_atmospherics/hydroponics))

		var/obj/machinery/portable_atmospherics/hydroponics/H = target
		if(H.frozen == 1)
			to_chat(user, "<span class='warning'>Disable the cryogenic freezing first!</span>")
			return
		grown_seed = H.seed
		grown_reagents = H.reagents

	if(!grown_seed)
		to_chat(user, "<span class='danger'>[src] can tell you nothing about \the [target].</span>")
		return

	last_seed = REF(grown_seed)

	user.visible_message("<span class='notice'>[user] runs the scanner over \the [target].</span>")

	last_reagents = list()
	for(var/reagent_id in grown_reagents?.reagent_volumes)
		var/datum/reagent/R = SSchemistry.fetch_reagent(reagent_id)
		last_reagents.Add(list(list(
			"name" = R.name,
			"volume" = grown_reagents.get_reagent_amount(R.id),
		)))

	ui_interact(user)

/obj/item/plant_analyzer/proc/print_report_verb()
	set name = "Print Plant Report"
	set category = VERB_CATEGORY_OBJECT
	set src = usr

	if(usr.stat || usr.restrained() || usr.lying)
		return
	print_report(usr)

/obj/item/plant_analyzer/proc/print_report(var/mob/living/user)
	var/datum/seed/grown_seed = locate(last_seed)
	if(!istype(grown_seed))
		to_chat(user, SPAN_WARNING("There is no scan data to print."))
		return

	var/form_title = "[grown_seed.seed_name] (#[grown_seed.uid])"
	var/dat = "<h3>Plant data for [form_title]</h3>"
	dat += "<h2>General Data</h2>"
	dat += "<table>"
	dat += "<tr><td><b>Endurance</b></td><td>[grown_seed.get_trait(TRAIT_ENDURANCE)]</td></tr>"
	dat += "<tr><td><b>Yield</b></td><td>[grown_seed.get_trait(TRAIT_YIELD)]</td></tr>"
	dat += "<tr><td><b>Maturation time</b></td><td>[grown_seed.get_trait(TRAIT_MATURATION)]</td></tr>"
	dat += "<tr><td><b>Production time</b></td><td>[grown_seed.get_trait(TRAIT_PRODUCTION)]</td></tr>"
	dat += "<tr><td><b>Potency</b></td><td>[grown_seed.get_trait(TRAIT_POTENCY)]</td></tr>"
	dat += "</table>"

	if(LAZYLEN(last_reagents))
		dat += "<h2>Reagent Data</h2>"
		dat += "<br>This sample contains: "
		for(var/i in 1 to LAZYLEN(last_reagents))
			dat += "<br>- [last_reagents[i]["name"]], [last_reagents[i]["volume"]] unit(s)"

	dat += "<h2>Other Data</h2>"

	var/list/ui_data = grown_seed.get_tgui_analyzer_data()

	dat += jointext(ui_data["trait_info"], "<br>\n")

	var/obj/item/paper/P = new /obj/item/paper(get_turf(src))
	P.name = "paper - [form_title]"
	P.info = "[dat]"
	if(istype(user,/mob/living/carbon/human))
		user.put_in_hands(P)
	user.visible_message("\The [src] spits out a piece of paper.")
	return
