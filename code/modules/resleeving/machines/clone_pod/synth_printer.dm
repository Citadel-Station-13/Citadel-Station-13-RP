// TODO: subtype of /clone_pod
/obj/machinery/transhuman/synthprinter
	name = "SynthFab 3000"
	desc = "A rapid fabricator for synthetic bodies.\n <span class='notice'>\[Accepts Upgrades\]</span>"
	catalogue_data = list(///datum/category_item/catalogue/information/organization/vey_med,
						/datum/category_item/catalogue/technology/resleeving)
	icon = 'icons/obj/machines/synthpod.dmi'
	icon_state = "pod_0"
	circuit = /obj/item/circuitboard/transhuman_synthprinter
	density = 1
	anchored = 1

	var/list/stored_material =  list(MAT_STEEL = 30000, MAT_GLASS = 30000)
	var/connected      //What console it's done up with
	var/busy = 0       //Busy cloning
	var/body_cost = 15000  //Cost of a cloned body (metal and glass ea.)
	var/max_res_amount = 30000 //Max the thing can hold
	var/datum/resleeving_body_backup/current_project
	var/broken = 0
	var/burn_value = 45
	var/brute_value = 60

/obj/machinery/transhuman/synthprinter/Initialize(mapload)
	. = ..()
	update_icon()

/obj/machinery/transhuman/synthprinter/RefreshParts()

	//Scanning modules reduce burn rating by 15 each
	var/burn_rating = initial(burn_value)
	for(var/obj/item/stock_parts/scanning_module/SM in component_parts)
		burn_rating = burn_rating - (SM.rating*15)
	burn_value = burn_rating

	//Manipulators reduce brute by 10 each
	var/brute_rating = initial(burn_value)
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		brute_rating = brute_rating - (M.rating*10)
	brute_value = brute_rating

	//Matter bins multiply the storage amount by their rating.
	var/store_rating = initial(max_res_amount)
	for(var/obj/item/stock_parts/matter_bin/MB in component_parts)
		store_rating = store_rating * MB.rating
	max_res_amount = store_rating

/obj/machinery/transhuman/synthprinter/process(delta_time)
	if(machine_stat & NOPOWER)
		if(busy)
			busy = 0
			current_project = null
		update_icon()
		return

	if(busy > 0 && busy <= 95)
		busy += 5

	if(busy >= 100)
		make_body()

	return

/obj/machinery/transhuman/synthprinter/proc/print(var/datum/resleeving_body_backup/BR)
	if(!istype(BR) || busy)
		return 0

	if(stored_material[MAT_STEEL] < body_cost || stored_material["glass"] < body_cost)
		return 0

	current_project = BR
	busy = 5
	update_icon()

	return 1

/obj/machinery/transhuman/synthprinter/proc/make_body()
	//Manage machine-specific stuff
	if(!current_project)
		busy = 0
		update_icon()
		return

	//Get the DNA and generate a new mob
	var/datum/dna2/record/R = current_project.legacy_dna
	var/mob/living/carbon/human/H = new /mob/living/carbon/human(src, R.dna.species)

	//Fix the external organs
	for(var/part in current_project.legacy_limb_data)

		var/status = current_project.legacy_limb_data[part]
		if(status == null) continue //Species doesn't have limb? Child of amputated limb?

		var/obj/item/organ/external/O = H.organs_by_name[part]
		if(!O) continue //Not an organ. Perhaps another amputation removed it already.

		if(status == 1) //Normal limbs
			continue
		else if(status == 0) //Missing limbs
			O.remove_rejuv()
		else if(status) //Anything else is a manufacturer
			O.robotize(status)

	//Then the internal organs
	for(var/part in current_project.legacy_organ_data)

		var/status = current_project.legacy_organ_data[part]
		if(status == null) continue //Species doesn't have organ? Child of missing part?

		var/obj/item/organ/I = H.internal_organs_by_name[part]
		if(!I) continue//Not an organ. Perhaps external conversion changed it already?

		if(status == 0) //Normal organ
			continue
		else if(status == 1) //Assisted organ
			I.mechassist()
		else if(status == 2) //Mechanical organ
			I.robotize()
		else if(status == 3) //Digital organ
			I.digitize()

	//Set the name or generate one
	if(!R.dna.real_name)
		R.dna.real_name = "synth ([rand(0,999)])"
	H.real_name = R.dna.real_name

	//Apply DNA
	H.dna = R.dna.Clone()

	//Apply damage
	H.adjustBruteLoss(brute_value)
	H.adjustFireLoss(burn_value)
	H.update_health()

	//Update appearance, remake icons
	H.UpdateAppearance()
	H.sync_organ_dna()
	H.regenerate_icons()

	H.ooc_notes = current_project.legacy_ooc_notes
	H.flavor_texts = current_project.legacy_dna.flavor.Copy()
	H.resize(current_project.legacy_sizemult)
	H.weight = current_project.legacy_weight
	// place mind lock to prevent body impersonation
	H.resleeving_place_mind_lock(current_project.mind_ref)
	if(current_project.legacy_custom_species_name)
		H.custom_species = current_project.legacy_custom_species_name

	//Suiciding var
	H.suiciding = 0

	//Making double-sure this is not set
	H.mind = null

	//Plonk them here.
	H.regenerate_icons()
	H.loc = get_turf(src)

	//Machine specific stuff at the end
	stored_material[MAT_STEEL] -= body_cost
	stored_material["glass"] -= body_cost
	busy = 0
	update_icon()

	return 1

/obj/machinery/transhuman/synthprinter/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	if((busy == 0) || (machine_stat & NOPOWER))
		return
	to_chat(user, "Current print cycle is [busy]% complete.")
	return

/obj/machinery/transhuman/synthprinter/attackby(obj/item/W, mob/user)
	src.add_fingerprint(user)
	if(busy)
		to_chat(user, "<span class='notice'>\The [src] is busy. Please wait for completion of previous operation.</span>")
		return
	if(default_deconstruction_screwdriver(user, W))
		return
	if(default_deconstruction_crowbar(user, W))
		return
	if(default_part_replacement(user, W))
		return
	if(panel_open)
		to_chat(user, "<span class='notice'>You can't load \the [src] while it's opened.</span>")
		return
	if(!istype(W, /obj/item/stack/material))
		to_chat(user, "<span class='notice'>You cannot insert this item into \the [src]!</span>")
		return

	var/obj/item/stack/material/S = W
	if(!(S.material.name in stored_material))
		to_chat(user, "<span class='warning'>\the [src] doesn't accept [S.material]!</span>")
		return

	var/amnt = S.perunit
	if(stored_material[S.material.name] + amnt <= max_res_amount)
		if(S && S.amount >= 1)
			var/count = 0
			while(stored_material[S.material.name] + amnt <= max_res_amount && S.amount >= 1)
				stored_material[S.material.name] += amnt
				S.use(1)
				count++
			to_chat(user, "You insert [count] [S.name] into \the [src].")
	else
		to_chat(user, "\the [src] cannot hold more [S.name].")

	updateUsrDialog()
	return

/obj/machinery/transhuman/synthprinter/update_icon()
	..()
	icon_state = "pod_0"
	if(busy && !(machine_stat & NOPOWER))
		icon_state = "pod_1"
	else if(broken)
		icon_state = "pod_g"
