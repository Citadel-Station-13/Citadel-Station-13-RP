/**
 * constructor; pass in a specieslike resolver as second argument to set
 *
 * specieslike resolver = species datum, id, path, or name.
 */
/mob/living/carbon/human/Initialize(mapload, datum/species/specieslike)
	. = ..()

	if(!dna)
		dna = new /datum/dna(null)
		// Species name is handled by set_species()

	if(specieslike)
		set_species(specieslike, force = TRUE, regen_icons = FALSE)
	else
		reset_species(force = TRUE)

	if(!species)
		stack_trace("Why is there no species? Resetting to human.")	// NO NO, YOU DONT GET TO CHICKEN OUT, SET_SPECIES WAS CALLED AND YOU BETTER HAVE ONE
		// no you don't get to get away
		set_species(/datum/species/human, force = TRUE, regen_icons = FALSE)

	real_name = species.get_random_name(gender)
	name = real_name
	if(mind)
		mind.name = real_name

	nutrition = rand(200,400)
	hydration = rand(200,400)

	AddComponent(/datum/component/personal_crafting)

	human_mob_list |= src
	hide_underwear.Cut()
	for(var/category in GLOB.global_underwear.categories_by_name)
		hide_underwear[category] = FALSE

	if(dna)
		dna.ready_dna(src)
		dna.real_name = real_name
		sync_organ_dna()

	init_world_bender_hud()

	if(mapload)
		return INITIALIZE_HINT_LATELOAD

	// rebuild everything
	regenerate_icons()
	update_transform()

//! WARNING SHITCODE REMOVE LATER
/mob/living/carbon/human/LateInitialize()
	. = ..()
	regenerate_icons()
	update_transform()

/mob/living/carbon/human/Destroy()
	human_mob_list -= src
	for(var/organ in organs)
		qdel(organ)
	QDEL_NULL(nif)
	QDEL_LIST_NULL(vore_organs)
	cleanup_world_bender_hud()
	return ..()

/mob/living/carbon/human/prepare_data_huds()
	//Update med hud images...
	. = ..()
	//...sec hud images...
	update_hud_sec_implants()
	update_hud_sec_job()
	update_hud_sec_status()
	//...and display them.
	add_to_all_human_data_huds()

/mob/living/carbon/human/Stat()
	..()
	if(statpanel("Status"))
		stat("Intent:", "[a_intent]")
		stat("Move Mode:", "[m_intent]")
		if(SSemergencyshuttle)
			var/eta_status = SSemergencyshuttle.get_status_panel_eta()
			if(eta_status)
				stat(null, eta_status)

		if (internal)
			if (!internal.air_contents)
				qdel(internal)
			else
				stat("Internal Atmosphere Info", internal.name)
				stat("Tank Pressure", internal.air_contents.return_pressure())
				stat("Distribution Pressure", internal.distribute_pressure)

		var/obj/item/organ/internal/xenos/plasmavessel/P = internal_organs_by_name[O_PLASMA] //Xenomorphs. Mech.
		if(P)
			stat(null, "Phoron Stored: [P.stored_plasma]/[P.max_plasma]")


		if(back && istype(back,/obj/item/rig))
			var/obj/item/rig/suit = back
			var/cell_status = "ERROR"
			if(suit.cell) cell_status = "[suit.cell.charge]/[suit.cell.maxcharge]"
			stat(null, "Suit charge: [cell_status]")

		if(mind)
			if(mind.changeling)
				stat("Chemical Storage", mind.changeling.chem_charges)
				stat("Genetic Damage Time", mind.changeling.geneticdamage)
				stat("Re-Adaptations", "[mind.changeling.readapts]/[mind.changeling.max_readapts]")
	if(species)
		species.Stat(src)

/mob/living/carbon/human/legacy_ex_act(severity)
	if(!blinded)
		flash_eyes()

	var/shielded = 0
	var/b_loss = null
	var/f_loss = null
	switch (severity)
		if (1.0)
			b_loss += 500
			if (!prob(getarmor(null, "bomb")))
				gib()
				return
			else
				var/atom/target = get_edge_target_turf(src, get_dir(src, get_step_away(src, src)))
				throw_at_old(target, 200, 4)
			//return
//				var/atom/target = get_edge_target_turf(user, get_dir(src, get_step_away(user, src)))
				//user.throw_at_old(target, 200, 4)

		if (2.0)
			if (!shielded)
				b_loss += 60

			f_loss += 60

			if (prob(getarmor(null, "bomb")))
				b_loss = b_loss/1.5
				f_loss = f_loss/1.5

			if (!get_ear_protection() >= 2)
				ear_damage += 30
				ear_deaf += 120
			if (prob(70) && !shielded)
				Paralyse(10)

		if(3.0)
			b_loss += 30
			if (prob(getarmor(null, "bomb")))
				b_loss = b_loss/2
			if (!get_ear_protection() >= 2)
				ear_damage += 15
				ear_deaf += 60
			if (prob(50) && !shielded)
				Paralyse(10)

	var/update = 0

	// focus most of the blast on one organ
	var/obj/item/organ/external/take_blast = pick(organs)
	update |= take_blast.take_damage(b_loss * 0.9, f_loss * 0.9, used_weapon = "Explosive blast")

	// distribute the remaining 10% on all limbs equally
	b_loss *= 0.1
	f_loss *= 0.1

	var/weapon_message = "Explosive Blast"

	for(var/obj/item/organ/external/temp in organs)
		switch(temp.organ_tag)
			if(BP_HEAD)
				update |= temp.take_damage(b_loss * 0.2, f_loss * 0.2, used_weapon = weapon_message)
			if(BP_TORSO)
				update |= temp.take_damage(b_loss * 0.4, f_loss * 0.4, used_weapon = weapon_message)
			else
				update |= temp.take_damage(b_loss * 0.05, f_loss * 0.05, used_weapon = weapon_message)
	if(update)	UpdateDamageIcon()

/mob/living/carbon/human/proc/implant_loyalty(override = FALSE) // Won't override by default.
	if(!config_legacy.use_loyalty_implants && !override) return // Nuh-uh.

	var/obj/item/implant/loyalty/L = new/obj/item/implant/loyalty(src)
	if(L.handle_implant(src, BP_HEAD))
		L.post_implant(src)

/mob/living/carbon/human/proc/is_loyalty_implanted()
	for(var/L in src.contents)
		if(istype(L, /obj/item/implant/loyalty))
			for(var/obj/item/organ/external/O in src.organs)
				if(L in O.implants)
					return 1
	return 0

/mob/living/carbon/human/restrained()
	if (handcuffed)
		return 1
	if (istype(wear_suit, /obj/item/clothing/suit/straight_jacket))
		return 1
	return 0

/mob/living/carbon/human/var/co2overloadtime = null
/mob/living/carbon/human/var/temperature_resistance = T0C+75

// called when something steps onto a human
// this handles mobs on fire - mulebot and vehicle code has been relocated to /mob/living/Crossed()
/mob/living/carbon/human/Crossed(var/atom/movable/AM)
	. = ..()
	if(AM.is_incorporeal())
		return

	spread_fire(AM)

// Get rank from ID, ID inside PDA, PDA, ID in wallet, etc.
/mob/living/carbon/human/proc/get_authentification_rank(var/if_no_id = "No id", var/if_no_job = "No job")
	var/obj/item/pda/pda = wear_id
	if (istype(pda))
		if (pda.id)
			return pda.id.rank ? pda.id.rank : if_no_job
		else
			return pda.ownrank
	else
		var/obj/item/card/id/id = get_idcard()
		if(id)
			return id.rank ? id.rank : if_no_job
		else
			return if_no_id

//gets assignment from ID or ID inside PDA or PDA itself
//Useful when player do something with computers
/mob/living/carbon/human/proc/get_assignment(var/if_no_id = "No id", var/if_no_job = "No job")
	var/obj/item/pda/pda = wear_id
	if (istype(pda))
		if (pda.id)
			return pda.id.assignment
		else
			return pda.ownjob
	else
		var/obj/item/card/id/id = get_idcard()
		if(id)
			return id.assignment ? id.assignment : if_no_job
		else
			return if_no_id

//gets name from ID or ID inside PDA or PDA itself
//Useful when player do something with computers
/mob/living/carbon/human/proc/get_authentification_name(var/if_no_id = "Unknown")
	var/obj/item/pda/pda = wear_id
	if (istype(pda))
		if (pda.id)
			return pda.id.registered_name
		else
			return pda.owner
	else
		var/obj/item/card/id/id = get_idcard()
		if(id)
			return id.registered_name
		else
			return if_no_id

//repurposed proc. Now it combines get_id_name() and get_face_name() to determine a mob's name variable. Made into a seperate proc as it'll be useful elsewhere
/mob/living/carbon/human/proc/get_visible_name()
	if( wear_mask && (wear_mask.flags_inv&HIDEFACE) )	//Wearing a mask which hides our face, use id-name if possible
		return get_id_name("Unknown")
	if( head && (head.flags_inv&HIDEFACE) )
		return get_id_name("Unknown")		//Likewise for hats
	var/face_name = get_face_name()
	var/id_name = get_id_name("")
	if((face_name == "Unknown") && id_name && (id_name != face_name))
		return "[face_name] (as [id_name])"
	return face_name

//Returns "Unknown" if facially disfigured and real_name if not. Useful for setting name when polyacided or when updating a human's name variable
/mob/living/carbon/human/proc/get_face_name()
	var/obj/item/organ/external/head = get_organ(BP_HEAD)
	if(!head || head.disfigured || head.is_stump() || !real_name || (MUTATION_HUSK in mutations) )	//disfigured. use id-name if possible
		return "Unknown"
	return real_name

//gets name from ID or PDA itself, ID inside PDA doesn't matter
//Useful when player is being seen by other mobs
/mob/living/carbon/human/proc/get_id_name(var/if_no_id = "Unknown")
	. = if_no_id
	if(istype(wear_id,/obj/item/pda))
		var/obj/item/pda/P = wear_id
		return P.owner
	if(wear_id)
		var/obj/item/card/id/I = wear_id.GetID()
		if(I)
			return I.registered_name
	return

//gets ID card object from special clothes slot or null.
/mob/living/carbon/human/proc/get_idcard()
	if(wear_id)
		return wear_id.GetID()

//Removed the horrible safety parameter. It was only being used by ninja code anyways.
//Now checks siemens_coefficient of the affected area by default
/mob/living/carbon/human/electrocute_act(var/shock_damage, var/obj/source, var/base_siemens_coeff = 1.0, var/def_zone = null)

	if(status_flags & GODMODE)	return 0	//godmode

	if (!def_zone)
		def_zone = pick("l_hand", "r_hand")

	if(species.siemens_coefficient == -1)
		if(stored_shock_by_ref["\ref[src]"])
			stored_shock_by_ref["\ref[src]"] += shock_damage
		else
			stored_shock_by_ref["\ref[src]"] = shock_damage
		return

	var/obj/item/organ/external/affected_organ = get_organ(check_zone(def_zone))
	var/siemens_coeff = base_siemens_coeff * get_siemens_coefficient_organ(affected_organ)
	if(fire_stacks < 0) // Water makes you more conductive.
		siemens_coeff *= 1.5

	return ..(shock_damage, source, siemens_coeff, def_zone)

/mob/living/carbon/human/Topic(href, href_list)
	if (href_list["mach_close"])
		var/t1 = text("window=[]", href_list["mach_close"])
		unset_machine()
		src << browse(null, t1)

	if(href_list["ooc_notes"])
		src.Examine_OOC()

	if (href_list["criminal"])
		if(hasHUD(usr,"security"))

			var/modified = 0
			var/perpname = "wot"
			var/obj/item/card/id/I = GetIdCard()
			if(I)
				perpname = I.registered_name
			else
				perpname = name

			if(perpname)
				for (var/datum/data/record/E in data_core.general)
					if (E.fields["name"] == perpname)
						for (var/datum/data/record/R in data_core.security)
							if (R.fields["id"] == E.fields["id"])

								var/setcriminal = input(usr, "Specify a new criminal status for this person.", "Security HUD", R.fields["criminal"]) in list("None", "*Arrest*", "Incarcerated", "Parolled", "Released", "Cancel")

								if(hasHUD(usr, "security"))
									if(setcriminal != "Cancel")
										R.fields["criminal"] = setcriminal
										modified = 1
										update_hud_sec_status()

			if(!modified)
				to_chat(usr, "<font color='red'>Unable to locate a data core entry for this person.</font>")

	if (href_list["secrecord"])
		if(hasHUD(usr,"security"))
			var/perpname = "wot"
			var/read = 0

			var/obj/item/card/id/I = GetIdCard()
			if(I)
				perpname = I.registered_name
			else
				perpname = name
			for (var/datum/data/record/E in data_core.general)
				if (E.fields["name"] == perpname)
					for (var/datum/data/record/R in data_core.security)
						if (R.fields["id"] == E.fields["id"])
							if(hasHUD(usr,"security"))
								to_chat(usr, "<b>Name:</b> [R.fields["name"]]	<b>Criminal Status:</b> [R.fields["criminal"]]")
								to_chat(usr, "<b>Minor Crimes:</b> [R.fields["mi_crim"]]")
								to_chat(usr, "<b>Details:</b> [R.fields["mi_crim_d"]]")
								to_chat(usr, "<b>Major Crimes:</b> [R.fields["ma_crim"]]")
								to_chat(usr, "<b>Details:</b> [R.fields["ma_crim_d"]]")
								to_chat(usr, "<b>Notes:</b> [R.fields["notes"]]")
								to_chat(usr, "<a href='?src=\ref[src];secrecordComment=`'>\[View Comment Log\]</a>")
								read = 1

			if(!read)
				to_chat(usr, "<font color='red'>Unable to locate a data core entry for this person.</font>")

	if (href_list["secrecordComment"])
		if(hasHUD(usr,"security"))
			var/perpname = "wot"
			var/read = 0

			var/obj/item/card/id/I = GetIdCard()
			if(I)
				perpname = I.registered_name
			else
				perpname = name
			for (var/datum/data/record/E in data_core.general)
				if (E.fields["name"] == perpname)
					for (var/datum/data/record/R in data_core.security)
						if (R.fields["id"] == E.fields["id"])
							if(hasHUD(usr,"security"))
								read = 1
								var/counter = 1
								while(R.fields[text("com_[]", counter)])
									to_chat(usr, text("[]", R.fields[text("com_[]", counter)]))
									counter++
								if (counter == 1)
									to_chat(usr, "No comment found")
								to_chat(usr, "<a href='?src=\ref[src];secrecordadd=`'>\[Add comment\]</a>")

			if(!read)
				to_chat(usr, "<font color='red'>Unable to locate a data core entry for this person.</font>")

	if (href_list["secrecordadd"])
		if(hasHUD(usr,"security"))
			var/perpname = "wot"
			var/obj/item/card/id/I = GetIdCard()
			if(I)
				perpname = I.registered_name
			else
				perpname = name
			for (var/datum/data/record/E in data_core.general)
				if (E.fields["name"] == perpname)
					for (var/datum/data/record/R in data_core.security)
						if (R.fields["id"] == E.fields["id"])
							if(hasHUD(usr,"security"))
								var/t1 = sanitize(input("Add Comment:", "Sec. records", null, null)  as message)
								if ( !(t1) || usr.stat || usr.restrained() || !(hasHUD(usr,"security")) )
									return
								var/counter = 1
								while(R.fields[text("com_[]", counter)])
									counter++
								if(istype(usr,/mob/living/carbon/human))
									var/mob/living/carbon/human/U = usr
									R.fields[text("com_[counter]")] = text("Made by [U.get_authentification_name()] ([U.get_assignment()]) on [time2text(world.realtime, "DDD MMM DD hh:mm:ss")], [game_year]<BR>[t1]")
								if(istype(usr,/mob/living/silicon/robot))
									var/mob/living/silicon/robot/U = usr
									R.fields[text("com_[counter]")] = text("Made by [U.name] ([U.modtype] [U.braintype]) on [time2text(world.realtime, "DDD MMM DD hh:mm:ss")], [game_year]<BR>[t1]")

	if (href_list["medical"])
		if(hasHUD(usr,"medical"))
			var/perpname = "wot"
			var/modified = 0

			var/obj/item/card/id/I = GetIdCard()
			if(I)
				perpname = I.registered_name
			else
				perpname = name

			for (var/datum/data/record/E in data_core.general)
				if (E.fields["name"] == perpname)
					for (var/datum/data/record/R in data_core.general)
						if (R.fields["id"] == E.fields["id"])

							var/setmedical = input(usr, "Specify a new medical status for this person.", "Medical HUD", R.fields["p_stat"]) in list("*SSD*", "*Deceased*", "Physically Unfit", "Active", "Disabled", "Cancel")

							if(hasHUD(usr,"medical"))
								if(setmedical != "Cancel")
									R.fields["p_stat"] = setmedical
									modified = 1
									if(GLOB.PDA_Manifest.len)
										GLOB.PDA_Manifest.Cut()

									spawn()
										if(istype(usr,/mob/living/carbon/human))
											var/mob/living/carbon/human/U = usr
											U.handle_regular_hud_updates()
										if(istype(usr,/mob/living/silicon/robot))
											var/mob/living/silicon/robot/U = usr
											U.handle_regular_hud_updates()

			if(!modified)
				to_chat(usr, "<font color='red'>Unable to locate a data core entry for this person.</font>")

	if (href_list["medrecord"])
		if(hasHUD(usr,"medical"))
			var/perpname = "wot"
			var/read = 0

			var/obj/item/card/id/I = GetIdCard()
			if(I)
				perpname = I.registered_name
			else
				perpname = name
			for (var/datum/data/record/E in data_core.general)
				if (E.fields["name"] == perpname)
					for (var/datum/data/record/R in data_core.medical)
						if (R.fields["id"] == E.fields["id"])
							if(hasHUD(usr,"medical"))
								to_chat(usr, "<b>Name:</b> [R.fields["name"]]	<b>Blood Type:</b> [R.fields["b_type"]]")
								to_chat(usr, "<b>DNA:</b> [R.fields["b_dna"]]")
								to_chat(usr, "<b>Minor Disabilities:</b> [R.fields["mi_dis"]]")
								to_chat(usr, "<b>Details:</b> [R.fields["mi_dis_d"]]")
								to_chat(usr, "<b>Major Disabilities:</b> [R.fields["ma_dis"]]")
								to_chat(usr, "<b>Details:</b> [R.fields["ma_dis_d"]]")
								to_chat(usr, "<b>Notes:</b> [R.fields["notes"]]")
								to_chat(usr, "<a href='?src=\ref[src];medrecordComment=`'>\[View Comment Log\]</a>")
								read = 1

			if(!read)
				to_chat(usr, "<font color='red'>Unable to locate a data core entry for this person.</font>")

	if (href_list["medrecordComment"])
		if(hasHUD(usr,"medical"))
			var/perpname = "wot"
			var/read = 0

			var/obj/item/card/id/I = GetIdCard()
			if(I)
				perpname = I.registered_name
			else
				perpname = name
			for (var/datum/data/record/E in data_core.general)
				if (E.fields["name"] == perpname)
					for (var/datum/data/record/R in data_core.medical)
						if (R.fields["id"] == E.fields["id"])
							if(hasHUD(usr,"medical"))
								read = 1
								var/counter = 1
								while(R.fields[text("com_[]", counter)])
									to_chat(usr, text("[]", R.fields[text("com_[]", counter)]))
									counter++
								if (counter == 1)
									to_chat(usr, "No comment found")
								to_chat(usr, "<a href='?src=\ref[src];medrecordadd=`'>\[Add comment\]</a>")

			if(!read)
				to_chat(usr, "<font color='red'>Unable to locate a data core entry for this person.</font>")

	if (href_list["medrecordadd"])
		if(hasHUD(usr,"medical"))
			var/perpname = "wot"
			var/obj/item/card/id/I = GetIdCard()
			if(I)
				perpname = I.registered_name
			else
				perpname = name
			for (var/datum/data/record/E in data_core.general)
				if (E.fields["name"] == perpname)
					for (var/datum/data/record/R in data_core.medical)
						if (R.fields["id"] == E.fields["id"])
							if(hasHUD(usr,"medical"))
								var/t1 = sanitize(input("Add Comment:", "Med. records", null, null)  as message)
								if ( !(t1) || usr.stat || usr.restrained() || !(hasHUD(usr,"medical")) )
									return
								var/counter = 1
								while(R.fields[text("com_[]", counter)])
									counter++
								if(istype(usr,/mob/living/carbon/human))
									var/mob/living/carbon/human/U = usr
									R.fields[text("com_[counter]")] = text("Made by [U.get_authentification_name()] ([U.get_assignment()]) on [time2text(world.realtime, "DDD MMM DD hh:mm:ss")], [game_year]<BR>[t1]")
								if(istype(usr,/mob/living/silicon/robot))
									var/mob/living/silicon/robot/U = usr
									R.fields[text("com_[counter]")] = text("Made by [U.name] ([U.modtype] [U.braintype]) on [time2text(world.realtime, "DDD MMM DD hh:mm:ss")], [game_year]<BR>[t1]")

	if (href_list["lookitem"])
		var/obj/item/I = locate(href_list["lookitem"])
		if(get_dist(src, get_turf(I)) > 7)
			return
		src.examinate(I)

	if (href_list["lookmob"])
		var/mob/M = locate(href_list["lookmob"])
		if(get_dist(src, get_turf(M)) > 7)
			return
		src.examinate(M)

	if (href_list["clickitem"])
		var/obj/item/I = locate(href_list["clickitem"])
		if(get_dist(src, get_turf(I)) > 7)
			return
		if(src.client)
			src.ClickOn(I)

	if (href_list["flavor_change"])
		if(usr != src)
			return
		switch(href_list["flavor_change"])
			if("done")
				src << browse(null, "window=flavor_changes")
				return
			if("general")
				var/msg = sanitize(input(usr,"Update the general description of your character. This will be shown regardless of clothing.","Flavor Text",html_decode(flavor_texts[href_list["flavor_change"]])) as message, extra = 0)
				flavor_texts[href_list["flavor_change"]] = msg
				return
			else
				var/msg = sanitize(input(usr,"Update the flavor text for your [href_list["flavor_change"]].","Flavor Text",html_decode(flavor_texts[href_list["flavor_change"]])) as message, extra = 0)
				flavor_texts[href_list["flavor_change"]] = msg
				set_flavor()
				return
	..()
	return

///eyecheck()
///Returns a number between -1 to 2
/mob/living/carbon/human/eyecheck()

	var/obj/item/organ/internal/eyes/I

	if(internal_organs_by_name[O_EYES]) // Eyes are fucked, not a 'weak point'.
		I = internal_organs_by_name[O_EYES]
		if(I.is_broken())
			return FLASH_PROTECTION_MAJOR
	else if(!species.dispersed_eyes) // They can't be flashed if they don't have eyes, or widespread sensing surfaces.
		return FLASH_PROTECTION_MAJOR

	var/number = get_equipment_flash_protection()
	if(I)
		number = I.get_total_protection(number)
		I.additional_flash_effects(number)
	return number

/mob/living/carbon/human/flash_eyes(var/intensity = FLASH_PROTECTION_MODERATE, override_blindness_check = FALSE, affect_silicon = FALSE, visual = FALSE, type = /atom/movable/screen/fullscreen/tiled/flash)
	if(internal_organs_by_name[O_EYES]) // Eyes are fucked, not a 'weak point'.
		var/obj/item/organ/internal/eyes/I = internal_organs_by_name[O_EYES]
		I.additional_flash_effects(intensity)
	return ..()

#define add_clothing_protection(A)	\
	var/obj/item/clothing/C = A; \
	flash_protection += C.flash_protection; \

/mob/living/carbon/human/proc/get_equipment_flash_protection()
	var/flash_protection = 0

	if(istype(src.head, /obj/item/clothing/head))
		add_clothing_protection(head)
	if(istype(src.glasses, /obj/item/clothing/glasses))
		add_clothing_protection(glasses)
	if(istype(src.wear_mask, /obj/item/clothing/mask))
		add_clothing_protection(wear_mask)

	return flash_protection

#undef add_clothing_protection

//Used by various things that knock people out by applying blunt trauma to the head.
//Checks that the species has a "head" (brain containing organ) and that hit_zone refers to it.
/mob/living/carbon/human/proc/headcheck(var/target_zone, var/brain_tag = "brain")

	var/obj/item/organ/affecting = internal_organs_by_name[brain_tag]

	target_zone = check_zone(target_zone)
	if(!affecting || affecting.parent_organ != target_zone)
		return 0

	//if the parent organ is significantly larger than the brain organ, then hitting it is not guaranteed
	var/obj/item/organ/parent = get_organ(target_zone)
	if(!parent)
		return 0

	if(parent.w_class > affecting.w_class + 1)
		return prob(100 / 2**(parent.w_class - affecting.w_class - 1))

	return 1

/mob/living/carbon/human/IsAdvancedToolUser(silent)
	if(feral)
		to_chat(src, "<span class='warning'>Your primitive mind can't grasp the concept of that thing.</span>")
		return 0
	if(species.has_fine_manipulation)
		return 1
	if(!silent)
		to_chat(src, "<span class='warning'>You don't have the dexterity to use that!</span>")
	return 0

/mob/living/carbon/human/abiotic(full_body)
	if(full_body)
		if(item_considered_abiotic(head))
			return TRUE
		if(item_considered_abiotic(w_uniform))
			return TRUE
		if(item_considered_abiotic(wear_suit))
			return TRUE
		if(item_considered_abiotic(glasses))
			return TRUE
		if(item_considered_abiotic(l_ear))
			return TRUE
		if(item_considered_abiotic(shoes))
			return TRUE
		if(item_considered_abiotic(gloves))
			return TRUE
	return ..()

/mob/living/carbon/human/proc/check_dna()
	dna.check_integrity(src)

/mob/living/carbon/human/get_species_name(examine)
	// no more species check, if we runtime, fuck you, fix your bugs.
	return examine? species.get_examine_name() : species.get_display_name()

/mob/living/carbon/human/get_true_species_name()
	return species.get_true_name()

/mob/living/carbon/human/proc/play_xylophone()
	if(!src.xylophone)
		var/datum/gender/T = GLOB.gender_datums[get_visible_gender()]
		visible_message("<font color='red'>\The [src] begins playing [T.his] ribcage like a xylophone. It's quite spooky.</font>","<font color=#4F49AF>You begin to play a spooky refrain on your ribcage.</font>","<font color='red'>You hear a spooky xylophone melody.</font>")
		var/song = pick('sound/effects/xylophone1.ogg','sound/effects/xylophone2.ogg','sound/effects/xylophone3.ogg')
		playsound(loc, song, 50, 1, -1)
		xylophone = 1
		spawn(1200)
			xylophone=0
	return

/mob/living/proc/check_has_mouth()
	return 1

/mob/living/carbon/human/check_has_mouth()
	// Todo, check stomach organ when implemented.
	var/obj/item/organ/external/head/H = get_organ(BP_HEAD)
	if(!H || !H.can_intake_reagents)
		return 0
	return 1

/mob/living/carbon/human/proc/morph()
	set name = "Morph"
	set category = "Superpower"

	if(!(MUTATION_MORPH in mutations))
		src.verbs -= /mob/living/carbon/human/proc/morph
		return

	var/new_facial = input("Please select facial hair color.", "Character Generation",rgb(r_facial,g_facial,b_facial)) as color
	if(new_facial)
		r_facial = hex2num(copytext(new_facial, 2, 4))
		g_facial = hex2num(copytext(new_facial, 4, 6))
		b_facial = hex2num(copytext(new_facial, 6, 8))

	var/new_hair = input("Please select hair color.", "Character Generation",rgb(r_hair,g_hair,b_hair)) as color
	if(new_facial)
		r_hair = hex2num(copytext(new_hair, 2, 4))
		g_hair = hex2num(copytext(new_hair, 4, 6))
		b_hair = hex2num(copytext(new_hair, 6, 8))

	var/new_eyes = input("Please select eye color.", "Character Generation",rgb(r_eyes,g_eyes,b_eyes)) as color
	if(new_eyes)
		r_eyes = hex2num(copytext(new_eyes, 2, 4))
		g_eyes = hex2num(copytext(new_eyes, 4, 6))
		b_eyes = hex2num(copytext(new_eyes, 6, 8))
		update_eyes()

	// hair
	var/list/all_hairs = typesof(/datum/sprite_accessory/hair) - /datum/sprite_accessory/hair
	var/list/hairs = list()

	// loop through potential hairs
	for(var/x in all_hairs)
		var/datum/sprite_accessory/hair/H = new x // create new hair datum based on type x
		hairs.Add(H.name) // add hair name to hairs
		qdel(H) // delete the hair after it's all done

	var/new_style = input("Please select hair style", "Character Generation",h_style)  as null|anything in hairs

	// if new style selected (not cancel)
	if (new_style)
		h_style = new_style

	// facial hair
	var/list/all_fhairs = typesof(/datum/sprite_accessory/facial_hair) - /datum/sprite_accessory/facial_hair
	var/list/fhairs = list()

	for(var/x in all_fhairs)
		var/datum/sprite_accessory/facial_hair/H = new x
		fhairs.Add(H.name)
		qdel(H)

	new_style = input("Please select facial style", "Character Generation",f_style)  as null|anything in fhairs

	if(new_style)
		f_style = new_style

	var/new_gender = alert(usr, "Please select gender.", "Character Generation", "Male", "Female", "Neutral")
	if (new_gender)
		if(new_gender == "Male")
			gender = MALE
		else if(new_gender == "Female")
			gender = FEMALE
		else
			gender = NEUTER
	regenerate_icons()
	check_dna()
	var/datum/gender/T = GLOB.gender_datums[get_visible_gender()]
	visible_message("<font color=#4F49AF>\The [src] morphs and changes [T.his] appearance!</font>", "<font color=#4F49AF>You change your appearance!</font>", "<font color='red'>Oh, god!  What the hell was that?  It sounded like flesh getting squished and bone ground into a different shape!</font>")

/mob/living/carbon/human/proc/remotesay()
	set name = "Project mind"
	set category = "Superpower"

	if(!(MUTATION_REMOTE_TALK in src.mutations))
		src.verbs -= /mob/living/carbon/human/proc/remotesay
		return

	var/list/creatures = list()
	for(var/mob/living/carbon/h in GLOB.mob_list)
		creatures += h
	var/mob/target = input("Who do you want to project your mind to ?") as null|anything in creatures
	if (isnull(target))
		return

	var/say = sanitize(input("What do you wish to say"))
	if(MUTATION_REMOTE_TALK in target.mutations)
		target.show_message("<font color=#4F49AF> You hear [src.real_name]'s voice: [say]</font>")
	else
		target.show_message("<font color=#4F49AF> You hear a voice that seems to echo around the room: [say]</font>")
	usr.show_message("<font color=#4F49AF> You project your mind into [target.real_name]: [say]</font>")
	log_say("(TPATH to [key_name(target)]) [say]",src)
	for(var/mob/observer/dead/G in GLOB.mob_list)
		G.show_message("<i>Telepathic message from <b>[src]</b> to <b>[target]</b>: [say]</i>")

/mob/living/carbon/human/proc/remoteobserve()
	set name = "Remote View"
	set category = "Superpower"

	if(stat!=CONSCIOUS)
		remoteview_target = null
		reset_perspective()
		return

	if(!(MUTATION_REMOTE_VIEW in src.mutations))
		remoteview_target = null
		reset_perspective()
		src.verbs -= /mob/living/carbon/human/proc/remoteobserve
		return

	if(IsRemoteViewing())
		to_chat(src, SPAN_NOTICE("You stop looking through another perspective."))
		remoteview_target = null
		reset_perspective()
		return

	var/list/mob/creatures = list()

	for(var/mob/living/carbon/h in GLOB.mob_list)
		var/turf/temp_turf = get_turf(h)
		if((temp_turf.z != 1 && temp_turf.z != 5) || h.stat!=CONSCIOUS) //Not on mining or the station. Or dead
			continue
		creatures += h

	var/mob/target = input ("Who do you want to project your mind to ?") as mob in creatures

	if (target)
		remoteview_target = target
		reset_perspective(target)
	else
		remoteview_target = null
		reset_perspective()

/mob/living/carbon/human/get_visible_gender()
	if(wear_suit && wear_suit.flags_inv & HIDEJUMPSUIT && ((head && head.flags_inv & HIDEMASK) || wear_mask))
		return PLURAL //plural is the gender-neutral default
	if(species)
		if(species.ambiguous_genders)
			return PLURAL // regardless of what you're wearing, your gender can't be figured out
	return get_gender()

/mob/living/carbon/human/proc/increase_germ_level(n)
	if(gloves)
		gloves.germ_level += n
	else
		germ_level += n

/mob/living/carbon/human/revive()

	if(should_have_organ(O_HEART))
		vessel.add_reagent("blood",species.blood_volume-vessel.total_volume)
		fixblood()

	species.create_organs(src) // Reset our organs/limbs.
	restore_all_organs()       // Reapply robotics/amputated status from preferences.

	if(!client || !key) //Don't boot out anyone already in the mob.
		for (var/obj/item/organ/internal/brain/H in GLOB.all_brain_organs)
			if(H.brainmob)
				if(H.brainmob.real_name == src.real_name)
					if(H.brainmob.mind)
						H.brainmob.mind.transfer_to(src)
						qdel(H)

	// Reapply markings/appearance from prefs for player mobs
	if(client) //just to be sure
		client.prefs.copy_to(src)
		if(dna)
			dna.ResetUIFrom(src)
			sync_organ_dna()

	for (var/ID in virus2)
		var/datum/disease2/disease/V = virus2[ID]
		V.cure(src)

	losebreath = 0

	..()

/mob/living/carbon/human/proc/is_lung_ruptured()
	var/obj/item/organ/internal/lungs/L = internal_organs_by_name[O_LUNGS]
	return L && L.is_bruised()

/mob/living/carbon/human/proc/rupture_lung()
	var/obj/item/organ/internal/lungs/L = internal_organs_by_name[O_LUNGS]

	if(L)
		L.rupture()

/*
/mob/living/carbon/human/verb/simulate()
	set name = "sim"
	set background = 1

	var/damage = input("Wound damage","Wound damage") as num

	var/germs = 0
	var/tdamage = 0
	var/ticks = 0
	while (germs < 2501 && ticks < 100000 && round(damage/10)*20)
		log_misc("VIRUS TESTING: [ticks] : germs [germs] tdamage [tdamage] prob [round(damage/10)*20]")
		ticks++
		if (prob(round(damage/10)*20))
			germs++
		if (germs == 100)
			to_chat(world, "Reached stage 1 in [ticks] ticks")
		if (germs > 100)
			if (prob(10))
				damage++
				germs++
		if (germs == 1000)
			to_chat(world, "Reached stage 2 in [ticks] ticks")
		if (germs > 1000)
			damage++
			germs++
		if (germs == 2500)
			to_chat(world, "Reached stage 3 in [ticks] ticks")
	to_chat(world, "Mob took [tdamage] tox damage")
*/
//returns 1 if made bloody, returns 0 otherwise

/mob/living/carbon/human/add_blood(mob/living/carbon/human/M as mob)
	if (!..())
		return 0
	//if this blood isn't already in the list, add it
	if(istype(M))
		if(!blood_DNA[M.dna.unique_enzymes])
			blood_DNA[M.dna.unique_enzymes] = M.dna.b_type
	hand_blood_color = blood_color
	update_bloodied()
	verbs += /mob/living/carbon/human/proc/bloody_doodle
	return 1 //we applied blood to the item

/mob/living/carbon/human/proc/get_full_print()
	if(!dna ||!dna.uni_identity)
		return
	return md5(dna.uni_identity)

/mob/living/carbon/human/clean_blood(var/washshoes)
	. = ..()

	gunshot_residue = null

	//Always do hands (or whatever's on our hands)
	if(gloves)
		gloves.clean_blood()
		update_inv_gloves()
		gloves.germ_level = 0
	else
		bloody_hands = 0
		germ_level = 0

	//Sometimes do shoes if asked (or feet if no shoes)
	if(washshoes && shoes)
		shoes.clean_blood()
		update_inv_shoes()
		shoes.germ_level = 0
	else if(washshoes && (feet_blood_color || LAZYLEN(feet_blood_DNA)))
		LAZYCLEARLIST(feet_blood_DNA)
		feet_blood_DNA = null
		feet_blood_color = null

	update_bloodied()

/mob/living/carbon/human/get_visible_implants(var/class = 0)

	var/list/visible_implants = list()
	for(var/obj/item/organ/external/organ in src.organs)
		for(var/obj/item/O in organ.implants)
			if(!istype(O,/obj/item/implant) && (O.w_class > class) && !istype(O,/obj/item/material/shard/shrapnel) && !istype(O, /obj/item/nif))
				visible_implants += O

	return(visible_implants)

/mob/living/carbon/human/embedded_needs_process()
	for(var/obj/item/organ/external/organ in src.organs)
		for(var/obj/item/O in organ.implants)
			if(!istype(O, /obj/item/implant)) //implant type items do not cause embedding effects, see handle_embedded_objects()
				return 1
	return 0

/mob/living/carbon/human/proc/handle_embedded_objects()

	for(var/obj/item/organ/external/organ in src.organs)
		if(organ.splinted) //Splints prevent movement.
			continue
		for(var/obj/item/O in organ.implants)
			if(istype(O, /obj/item/melee/spike) && prob(20))
				embed_object_pain(organ, O)
			if(!istype(O,/obj/item/implant) && prob(5)) //Moving with things stuck in you could be bad.
				embed_object_pain(organ, O)

/mob/living/carbon/human/proc/embed_object_pain(var/obj/item/organ/external/organ, var/obj/item/O)
	// All kinds of embedded objects cause bleeding.
	if(!can_feel_pain(organ.organ_tag))
		to_chat(src, "<span class='warning'>You feel [O] moving inside your [organ.name].</span>")
	else
		var/msg = pick( \
			"<span class='warning'>A spike of pain jolts your [organ.name] as you bump [O] inside.</span>", \
			"<span class='warning'>Your movement jostles [O] in your [organ.name] painfully.</span>", \
			"<span class='warning'>Your movement jostles [O] in your [organ.name] painfully.</span>")
		custom_pain(msg, 40)
	if(istype(O, /obj/item/melee/spike))
		organ.take_damage(rand(3,9), 0, 0) // it has spikes on it it's going to stab you
		to_chat(src, "<span class='danger'>The edges of [O] in your [organ.name] are not doing you any favors.</span>")
		Weaken(2) // having a very jagged stick jammed into your bits is Bad for your health
	organ.take_damage(rand(1,3), 0, 0)
	if(!(organ.robotic >= ORGAN_ROBOT) && (should_have_organ(O_HEART))) //There is no blood in protheses.
		organ.status |= ORGAN_BLEEDING

/mob/living/carbon/human/verb/check_pulse()
	set category = "Object"
	set name = "Check pulse"
	set desc = "Approximately count somebody's pulse. Requires you to stand still at least 6 seconds."
	set src in view(1)
	var/self = 0

	if(usr.stat || usr.restrained() || !isliving(usr)) return

	var/datum/gender/TU = GLOB.gender_datums[usr.get_visible_gender()]
	var/datum/gender/T = GLOB.gender_datums[get_visible_gender()]

	if(usr == src)
		self = 1
	if(!self)
		usr.visible_message("<span class='notice'>[usr] kneels down, puts [TU.his] hand on [src]'s wrist and begins counting [T.his] pulse.</span>",\
		"You begin counting [src]'s pulse")
	else
		usr.visible_message("<span class='notice'>[usr] begins counting [T.his] pulse.</span>",\
		"You begin counting your pulse.")

	if(src.pulse)
		to_chat(usr, "<span class='notice'>[self ? "You have a" : "[src] has a"] pulse! Counting...</span>")
	else
		to_chat(usr, "<span class='danger'>[src] has no pulse!</span>")	//it is REALLY UNLIKELY that a dead person would check his own pulse
		return

	to_chat(usr, "You must[self ? "" : " both"] remain still until counting is finished.")
	if(do_mob(usr, src, 60))
		to_chat(usr, "<span class='notice'>[self ? "Your" : "[src]'s"] pulse is [src.get_pulse(GETPULSE_HAND)].</span>")
	else
		to_chat(usr, "<span class='warning'>You failed to check the pulse. Try again.</span>")

/**
 * Sets a human mob's species.
 *
 * todo: no more using anything id, and MAYBE path/direct datum; we really don't like names,
 * todo: and things generally shouldn't be making species datums.
 *
 * @param
 * - specieslike - species instance, id, typepath, or name; if null, we reset species to dna.
 * - regen_icons - immediately update icons?
 * - force - change even if we are already that species **by type**
 * - skip - skip most ops that aren't apply or remove which are required for instance cleanup. do not do this unless you absolutely know what you are doing.
 * - example - dumbshit argument used for vore transformations to copy necessary data, why tf is this not done in the vore module? //TODO: REMOVE.
 */
/mob/living/carbon/human/proc/set_species(datum/species/specieslike, regen_icons = TRUE, force = FALSE, skip, mob/living/carbon/human/example)
	ASSERT(specieslike)
	// resolve id
	var/resolved_id
	var/datum/species/resolving
	if(istype(specieslike))
		resolving = specieslike
	else
		resolving = SScharacters.resolve_species(specieslike)
	ASSERT(istype(resolving))
	resolved_id = resolving.uid
	if(!force && (species?.uid == resolved_id))
		return

	var/datum/species/S

	// provided? if so, set
	// (and hope to god the provider isn't stupid and didn't quantum entangle a datum)
	// if not provided, make a new one
	if(istype(specieslike))
		if(SScharacters.species_paths[specieslike.type] == specieslike)
			CRASH("attempted to set species to static datum")
		S = specieslike
	else
		S = SScharacters.construct_species_path(resolving.type)

	// clean up old species
	if(istype(species))
		species.on_remove(src)

	// set
	species = S
	. = TRUE

	// apply new species, create organs, do post spawn stuff even though we're presumably not spawning half the time
	// i seriously hate vorecode
	species.on_apply(src)

	// set our has hands
	has_hands = (species && species.hud)? species.hud.has_hands : TRUE

	// until we unfuck hud datums, this will force reload our entire hud
	if(hud_used)
		qdel(hud_used) //remove the hud objects
	hud_used = new /datum/hud(src)
	// todo: this is awful lol
	if(plane_holder && client)
		client.screen |= plane_holder.plane_masters

	// skip the rest
	if(skip)
		return

	species.create_organs(src)
	species.create_blood(src)
	species.handle_post_spawn(src)
	species.update_attack_types() // Required for any trait that updates unarmed_types in setup.
	updatehealth()	// uh oh stinky - some species just have more/less maxhealth, this is a shit fix imo but deal with it for now ~silicons

	// Rebuild the HUD. If they aren't logged in then login() should reinstantiate it for them.
	update_hud()

	if(LAZYLEN(descriptors))
		descriptors = null

	if(LAZYLEN(species.descriptors))
		descriptors = list()
		for(var/desctype in species.descriptors)
			var/datum/mob_descriptor/descriptor = species.descriptors[desctype]
			descriptors[desctype] = descriptor.default_value

	// dumb shit transformation shit here
	if(example)
		if(!(example == src))
			r_skin = example.r_skin
			g_skin = example.g_skin
			b_skin = example.b_skin

	if(regen_icons)
		//A slew of bits that may be affected by our species change
		regenerate_icons()
		update_transform()

/**
 * resets our species to default with this priority:
 *
 * 1. dna species
 * 2. species var (aka prototype species)
 * 3. human
 */
/mob/living/carbon/human/proc/reset_species(force)
	if(dna?.species)
		return set_species(dna.species, force = force)
	else if(ispath(species))
		return set_species(species, force = force)
	else
		return set_species(/datum/species/human, force = force)

/mob/living/carbon/human/proc/bloody_doodle()
	set category = "IC"
	set name = "Write in blood"
	set desc = "Use blood on your hands to write a short message on the floor or a wall, murder mystery style."

	if (src.stat)
		return

	if (usr != src)
		return 0 //something is terribly wrong

	if (!bloody_hands)
		verbs -= /mob/living/carbon/human/proc/bloody_doodle

	if (src.gloves)
		to_chat(src, "<span class='warning'>Your [src.gloves] are getting in the way.</span>")
		return

	var/turf/simulated/T = src.loc
	if (!istype(T)) //to prevent doodling out of mechs and lockers
		to_chat(src, "<span class='warning'>You cannot reach the floor.</span>")
		return

	var/direction = input(src,"Which way?","Tile selection") as anything in list("Here","North","South","East","West")
	if (direction != "Here")
		T = get_step(T,text2dir(direction))
	if (!istype(T))
		to_chat(src, "<span class='warning'>You cannot doodle there.</span>")
		return

	var/num_doodles = 0
	for (var/obj/effect/debris/cleanable/blood/writing/W in T)
		num_doodles++
	if (num_doodles > 4)
		to_chat(src, "<span class='warning'>There is no space to write on!</span>")
		return

	var/max_length = bloody_hands * 30 //tweeter style

	var/message = sanitize(input("Write a message. It cannot be longer than [max_length] characters.","Blood writing", ""))

	if (message)
		var/used_blood_amount = round(length(message) / 30, 1)
		bloody_hands = max(0, bloody_hands - used_blood_amount) //use up some blood

		if (length(message) > max_length)
			message += "-"
			to_chat(src, "<span class='warning'>You ran out of blood to write with!</span>")

		var/obj/effect/debris/cleanable/blood/writing/W = new(T)
		W.basecolor = (hand_blood_color) ? hand_blood_color : "#A10808"
		W.update_icon()
		W.message = message
		W.add_fingerprint(src)

/mob/living/carbon/human/emp_act(severity)
	if(isSynthetic())
		switch(severity)
			if(1)
				Confuse(10)
			if(2)
				Confuse(7)
			if(3)
				Confuse(5)
			if(4)
				Confuse(2)
		flash_eyes()
		to_chat(src, "<font align='center' face='fixedsys' size='10' color='red'><B>*BZZZT*</B></font>")
		to_chat(src, "<font face='fixedsys'><span class='danger'>Warning: Electromagnetic pulse detected.</span></font>")
		to_chat(src, "<font face='fixedsys'><span class='danger'>Warning: Navigation systems offline. Restarting...</span></font>")
		..()


/mob/living/carbon/human/can_inject(var/mob/user, var/error_msg, var/target_zone, var/ignore_thickness = FALSE)
	. = 1

	if(!target_zone)
		if(!user)
			target_zone = pick(BP_TORSO,BP_TORSO,BP_TORSO,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_HEAD)
		else
			target_zone = user.zone_sel.selecting

	var/obj/item/organ/external/affecting = get_organ(target_zone)
	var/fail_msg
	if(!affecting)
		. = 0
		fail_msg = "They are missing that limb."
	else if (affecting.robotic == ORGAN_ROBOT)
		. = 0
		fail_msg = "That limb is robotic."
	else if (affecting.robotic >= ORGAN_LIFELIKE)
		. = 0
		fail_msg = "Your needle refuses to penetrate more than a short distance..."
	else if (affecting.thick_skin && prob(70 - round(affecting.brute_dam + affecting.burn_dam / 2)))	// Allows transplanted limbs with thick skin to maintain their resistance.
		. = 0
		fail_msg = "Your needle fails to penetrate \the [affecting]'s thick hide..."
	else
		switch(target_zone)
			if(BP_HEAD) //If targeting head, check helmets
				if(head && (head.clothing_flags & THICKMATERIAL) && !ignore_thickness && !istype(head, /obj/item/clothing/head/helmet/space)) //If they're wearing a head piece, if that head piece is thick, the injector doesn't bypass thickness, and that headpiece isn't a space helmet with an injection port - it fails
					. = 0
			else //Otherwise, if not targeting head, check the suit
				if(wear_suit && (wear_suit.clothing_flags & THICKMATERIAL) && !ignore_thickness&& !istype(wear_suit, /obj/item/clothing/suit/space)) //If they're wearing a suit piece, if that suit piece is thick, the injector doesn't bypass thickness, and that suit isn't a space suit with an injection port - it fails
					. = 0
	if(!. && error_msg && user)
		if(!fail_msg)
			fail_msg = "There is no exposed flesh or thin material [target_zone == BP_HEAD ? "on their head" : "on their body"] to inject into."
		to_chat(user, "<span class='alert'>[fail_msg]</span>")

/mob/living/carbon/human/print_flavor_text(var/shrink = 1)
	var/list/equipment = list(src.head,src.wear_mask,src.glasses,src.w_uniform,src.wear_suit,src.gloves,src.shoes)
	var/head_exposed = 1
	var/face_exposed = 1
	var/eyes_exposed = 1
	var/torso_exposed = 1
	var/arms_exposed = 1
	var/legs_exposed = 1
	var/hands_exposed = 1
	var/feet_exposed = 1

	for(var/obj/item/clothing/C in equipment)
		if(C.body_parts_covered & HEAD)
			head_exposed = 0
		if(C.body_parts_covered & FACE)
			face_exposed = 0
		if(C.body_parts_covered & EYES)
			eyes_exposed = 0
		if(C.body_parts_covered & UPPER_TORSO)
			torso_exposed = 0
		if(C.body_parts_covered & ARMS)
			arms_exposed = 0
		if(C.body_parts_covered & HANDS)
			hands_exposed = 0
		if(C.body_parts_covered & LEGS)
			legs_exposed = 0
		if(C.body_parts_covered & FEET)
			feet_exposed = 0

	flavor_text = ""
	for (var/T in flavor_texts)
		if(flavor_texts[T] && flavor_texts[T] != "")
			if((T == "general") || (T == "head" && head_exposed) || (T == "face" && face_exposed) || (T == "eyes" && eyes_exposed) || (T == "torso" && torso_exposed) || (T == "arms" && arms_exposed) || (T == "hands" && hands_exposed) || (T == "legs" && legs_exposed) || (T == "feet" && feet_exposed))
				flavor_text += flavor_texts[T]
				flavor_text += "\n\n"
	if(!shrink)
		return flavor_text
	else
		return ..()

/mob/living/carbon/human/getDNA()
	if(species.species_flags & NO_SCAN)
		return null
	if(isSynthetic())
		return
	..()

/mob/living/carbon/human/setDNA()
	if(species.species_flags & NO_SCAN)
		return
	if(isSynthetic())
		return
	..()

/mob/living/carbon/human/has_brain()
	if(internal_organs_by_name[O_BRAIN])
		var/obj/item/organ/brain = internal_organs_by_name[O_BRAIN]
		if(brain && istype(brain))
			return 1
	return 0

/mob/living/carbon/human/has_eyes()
	if(internal_organs_by_name[O_EYES])
		var/obj/item/organ/eyes = internal_organs_by_name[O_EYES]
		if(eyes && istype(eyes) && !(eyes.status & ORGAN_CUT_AWAY))
			return 1
	return 0

/mob/living/carbon/human/slip(var/slipped_on, stun_duration=8)
	var/list/equipment = list(src.w_uniform,src.wear_suit,src.shoes)
	var/footcoverage_check = FALSE
	for(var/obj/item/clothing/C in equipment)
		if(C.body_parts_covered & FEET)
			footcoverage_check = TRUE
			break
	if((species.species_flags & NO_SLIP && !footcoverage_check) || (shoes && (shoes.clothing_flags & NOSLIP))) //Footwear negates a species' natural traction.
		return 0
	if(..(slipped_on,stun_duration))
		return 1

/mob/living/carbon/human/proc/relocate()
	set category = "Object"
	set name = "Relocate Joint"
	set desc = "Pop a joint back into place. Extremely painful."
	set src in view(1)

	if(!isliving(usr) || !usr.canClick())
		return

	usr.setClickCooldown(20)

	if(usr.stat > 0)
		to_chat(usr, "You are unconcious and cannot do that!")
		return

	if(usr.restrained())
		to_chat(usr, "You are restrained and cannot do that!")
		return

	var/mob/S = src
	var/mob/U = usr
	var/self = null
	if(S == U)
		self = 1 // Removing object from yourself.

	var/list/limbs = list()
	for(var/limb in organs_by_name)
		var/obj/item/organ/external/current_limb = organs_by_name[limb]
		if(current_limb && current_limb.dislocated > 0 && !current_limb.is_parent_dislocated()) //if the parent is also dislocated you will have to relocate that first
			limbs |= current_limb
	var/obj/item/organ/external/current_limb = input(usr,"Which joint do you wish to relocate?") as null|anything in limbs

	if(!current_limb)
		return

	if(self)
		to_chat(src, "<span class='warning'>You brace yourself to relocate your [current_limb.joint]...</span>")
	else
		to_chat(U, "<span class='warning'>You begin to relocate [S]'s [current_limb.joint]...</span>")

	if(!do_after(U, 30))
		return
	if(!current_limb || !S || !U)
		return

	if(self)
		to_chat(src, "<span class='danger'>You pop your [current_limb.joint] back in!</span>")
	else
		to_chat(U, "<span class='danger'>You pop [S]'s [current_limb.joint] back in!</span>")
		to_chat(S, "<span class='danger'>[U] pops your [current_limb.joint] back in!</span>")
	current_limb.relocate()

/mob/living/carbon/human/Check_Shoegrip()
	if(shoes && (shoes.clothing_flags & NOSLIP) && istype(shoes, /obj/item/clothing/shoes/magboots))  //magboots + dense_object = no floating
		return 1
	if(flying) // Checks to see if they have wings and are flying.
		return 1
	return 0

/mob/living/carbon/human/can_stand_overridden()
	if(wearing_rig && wearing_rig.ai_can_move_suit(check_for_ai = 1))
		// Actually missing a leg will screw you up. Everything else can be compensated for.
		for(var/limbcheck in list("l_leg","r_leg"))
			var/obj/item/organ/affecting = get_organ(limbcheck)
			if(!affecting)
				return 0
		return 1
	return 0

/mob/living/carbon/human/verb/toggle_underwear()
	set name = "Toggle Underwear"
	set desc = "Shows/hides selected parts of your underwear."
	set category = "Object"

	if(stat) return
	var/datum/category_group/underwear/UWC = input(usr, "Choose underwear:", "Show/hide underwear") as null|anything in GLOB.global_underwear.categories
	if(!UWC) return
	var/datum/category_item/underwear/UWI = all_underwear[UWC.name]
	if(!UWI || UWI.name == "None")
		to_chat(src, "<span class='notice'>You do not have [UWC.gender==PLURAL ? "[UWC.display_name]" : "a [UWC.display_name]"].</span>")
		return
	hide_underwear[UWC.name] = !hide_underwear[UWC.name]
	update_underwear(1)
	to_chat(src, "<span class='notice'>You [hide_underwear[UWC.name] ? "take off" : "put on"] your [UWC.display_name].</span>")
	return

/mob/living/carbon/human/verb/pull_punches()
	set name = "Pull Punches"
	set desc = "Try not to hurt them."
	set category = "IC"

	if(stat) return
	pulling_punches = !pulling_punches
	to_chat(src, "<span class='notice'>You are now [pulling_punches ? "pulling your punches" : "not pulling your punches"].</span>")
	return

/mob/living/carbon/human/should_have_organ(var/organ_check)

	var/obj/item/organ/external/affecting
	if(organ_check in list(O_HEART, O_LUNGS))
		affecting = organs_by_name[BP_TORSO]
	else if(organ_check in list(O_LIVER, O_KIDNEYS))
		affecting = organs_by_name[BP_GROIN]

	if(affecting && (affecting.robotic >= ORGAN_ROBOT))
		return 0
	return (species && species.has_organ[organ_check])

/mob/living/carbon/human/can_feel_pain(var/obj/item/organ/check_organ)
	if(isSynthetic())
		return 0
	for(var/datum/modifier/M in modifiers)
		if(M.pain_immunity == TRUE)
			return 0
	if(check_organ)
		if(!istype(check_organ))
			return 0
		return check_organ.organ_can_feel_pain()
	return !(species.species_flags & NO_PAIN)

/mob/living/carbon/human/is_sentient()
	if(get_FBP_type() == FBP_DRONE)
		return FALSE
	return ..()

/mob/living/carbon/human/is_muzzled()
	return (wear_mask && (istype(wear_mask, /obj/item/clothing/mask/muzzle) || istype(src.wear_mask, /obj/item/grenade)))

/mob/living/carbon/human/get_fire_icon_state()
	return species.fire_icon_state

// Called by job_controller.  Makes drones start with a permit, might be useful for other people later too.
/mob/living/carbon/human/equip_post_job()
	var/braintype = get_FBP_type()
	if(braintype == FBP_DRONE)
		var/turf/T = get_turf(src)
		var/obj/item/clothing/accessory/permit/drone/permit = new(T)
		permit.set_name(real_name)
		equip_to_appropriate_slot(permit) // If for some reason it can't find room, it'll still be on the floor.

/mob/living/carbon/human/proc/update_icon_special() //For things such as teshari hiding and whatnot.
	if(status_flags & HIDING) // Hiding? Carry on.
		// Stunned/knocked down by something that isn't the rest verb? Note: This was tried with INCAPACITATION_STUNNED, but that refused to work.
		if(stat == DEAD || paralysis || weakened || stunned || restrained() || buckled || LAZYLEN(grabbed_by) || has_buckled_mobs())
			reveal(null)
		else
			set_base_layer(HIDING_LAYER)

/**
 * Shows species in tooltips and examine.
 *
 * Get custom species name if set, otherwise use the species name
 * Beepboops get extra special text based on gender if obviously beepboop
 * Else species name
 */
/mob/living/carbon/human/proc/get_display_species()
	var/species_name = src.custom_species ? custom_species : species.get_examine_name()
	switch(gender) //Not identifying_gender as this is relating to physical traits.
		if(MALE)
			return "[looksSynthetic() ? "[species_name] Android" : species_name]"
		if(FEMALE)
			return "[looksSynthetic() ? "[species_name] Gynoid" : species_name]"
		if(NEUTER, PLURAL)
			return "[looksSynthetic() ? "Synthetic [species_name]" : species_name]"
		else
			return SPAN_WARNING("Unknown")

/mob/living/carbon/human/get_nametag_name(mob/user)
	return name //Could do fancy stuff here?

/mob/living/carbon/human/get_nametag_desc(mob/user)
	var/msg = ""
	if(hasHUD(user,"security"))
		//Try to find their name
		var/perpname
		var/obj/item/card/id/I = GetIdCard()
		if(I)
			perpname = I.registered_name
		else
			perpname = name
		//Try to find their record
		var/criminal = "None"
		if(perpname)
			var/datum/data/record/G = find_general_record("name", perpname)
			if(G)
				var/datum/data/record/S = find_security_record("id", G.fields["id"])
				if(S)
					criminal = S.fields["criminal"]
		//If it's interesting, append
		if(criminal != "None")
			msg += "([criminal]) "

	if(hasHUD(user,"medical"))
		msg += "(Health: [round((health/getMaxHealth())*100)]%) "

	msg += get_display_species()
	return msg

//Crazy alternate human stuff
/mob/living/carbon/human/proc/init_world_bender_hud()
	var/animal = pick("cow","chicken_brown", "chicken_black", "chicken_white", "chick", "mouse_brown", "mouse_gray", "mouse_white", "lizard", "cat2", "goose", "penguin")
	var/image/img = image('icons/mob/animal.dmi', src, animal)
	// hud refactor when
	img.override = TRUE
	LAZYINITLIST(hud_list)
	hud_list[WORLD_BENDER_ANIMAL_HUD] = img
	var/datum/atom_hud/world_bender/animals/A = GLOB.huds[WORLD_BENDER_HUD_ANIMALS]
	A.add_to_hud(src)

/mob/living/carbon/human/proc/cleanup_world_bender_hud()
	var/datum/atom_hud/world_bender/animals/A = GLOB.huds[WORLD_BENDER_HUD_ANIMALS]
	A.remove_from_hud(src)

/mob/living/carbon/human/get_mob_riding_slots()
	return list(back, head, wear_suit)

/mob/living/carbon/human/inducer_scan(obj/item/inducer/I, list/things_to_induce = list(), inducer_flags)
	. = ..()
	if(isSynthetic())
		things_to_induce += src

/mob/living/carbon/human/inducer_act(obj/item/inducer/I, amount, inducer_flags)
	. = ..()
	if(!isSynthetic())
		return
	var/needed = (species.max_nutrition - nutrition)
	if(needed <= 0)
		return
	var/got = min((((amount * GLOB.cellrate) / SYNTHETIC_NUTRITION_KJ_PER_UNIT) * SYNTHETIC_NUTRITION_INDUCER_CHEAT_FACTOR), needed)
	adjust_nutrition(got)
	return (got * SYNTHETIC_NUTRITION_KJ_PER_UNIT) / GLOB.cellrate / SYNTHETIC_NUTRITION_INDUCER_CHEAT_FACTOR

/mob/living/carbon/human/can_wield_item(obj/item/W)
	//Since teshari are small by default, they have different logic to allow them to use certain guns despite that.
	//If any other species need to adapt for this, you can modify this proc with a list instead
	if(istype(species, /datum/species/teshari))
		return !W.heavy //return true if it is not heavy, false if it is heavy
	else return ..()

/mob/living/carbon/human/set_nutrition(amount)
	nutrition = clamp(amount, 0, species.max_nutrition * 1.5)

/mob/living/carbon/human/get_bullet_impact_effect_type(var/def_zone)
	var/obj/item/organ/external/E = get_organ(def_zone)
	if(!E || E.is_stump())
		return BULLET_IMPACT_NONE
	if(BP_IS_ROBOTIC(E))
		return BULLET_IMPACT_METAL
	return BULLET_IMPACT_MEAT

/mob/living/carbon/human/reduce_cuff_time()
	if(istype(gloves, /obj/item/clothing/gloves/gauntlets/rig))
		return 2
	return ..()

/mob/living/carbon/human/check_obscured_slots()
	. = ..()
	if(wear_suit)
		if(wear_suit.flags_inv & HIDEGLOVES)
			LAZYOR(., SLOT_GLOVES)
		if(wear_suit.flags_inv & HIDEJUMPSUIT)
			LAZYOR(., SLOT_ICLOTHING)
		if(wear_suit.flags_inv & HIDESHOES)
			LAZYOR(., SLOT_FEET)

//! Pixel Offsets
/mob/living/carbon/human/get_centering_pixel_x_offset(dir, atom/aligning)
	. = ..()
	// uh oh stinky
	if(!isTaurTail(tail_style) || !(dir & (EAST|WEST)))
		return
	// groan
	. += ((size_multiplier * icon_scale_x) - 1) * ((dir & EAST)? -16 : 16)
