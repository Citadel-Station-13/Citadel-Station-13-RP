
#warn below

// TODO: subtype of /clone_pod
/obj/machinery/resleeving/body_printer/synth_fab
	name = "SynthFab 3000"
	desc = "A rapid fabricator for synthetic bodies.\n <span class='notice'>\[Accepts Upgrades\]</span>"
	icon = 'icons/obj/machines/synthpod.dmi'
	icon_state = "pod_0"
	circuit = /obj/item/circuitboard/resleeving/synth_printer

/obj/machinery/resleeving/body_printer/synth_fab/proc/print(var/datum/resleeving_body_backup/BR)

	if(stored_material[MAT_STEEL] < body_cost || stored_material["glass"] < body_cost)
		return 0

	current_project = BR
	busy = 5
	update_icon()

	return 1

/obj/machinery/resleeving/body_printer/synth_fab/proc/make_body()
	//Get the DNA and generate a new mob
	var/datum/dna2/record/R = current_project.legacy_dna
	var/mob/living/carbon/human/H = new /mob/living/carbon/human(src, R.dna.species)

	//Set the name or generate one
	if(!R.dna.real_name)
		R.dna.real_name = "synth ([rand(0,999)])"
	H.real_name = R.dna.real_name

	//Apply DNA
	H.dna = R.dna.Clone()

	//Machine specific stuff at the end
	stored_material[MAT_STEEL] -= body_cost
	stored_material["glass"] -= body_cost
	busy = 0
	update_icon()

	return 1

/obj/machinery/resleeving/body_printer/synth_fab/attackby(obj/item/W, mob/user)
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

/obj/machinery/resleeving/body_printer/synth_fab/update_icon()
	..()
	icon_state = "pod_0"
	if(busy && !(machine_stat & NOPOWER))
		icon_state = "pod_1"
	else if(broken)
		icon_state = "pod_g"
