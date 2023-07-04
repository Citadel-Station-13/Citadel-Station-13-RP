#define DAM_SCALE_FACTOR 0.01
#define METAL_PER_TICK 100

/datum/species/protean
	uid = SPECIES_ID_PROTEAN
	name = SPECIES_PROTEAN
	name_plural = "Proteans"
	category = "Special"
	blurb = "Sometimes very advanced civilizations will produce the ability to swap into manufactured, robotic bodies. And sometimes \
			<i>very</i> advanced civilizations have the option of 'nanoswarm' bodies. Effectively a single robot body comprised \
			of millions of tiny nanites working in concert to maintain cohesion."
	show_ssd = "totally quiescent"
	death_message = "rapidly loses cohesion, dissolving into a cloud of gray dust..."
	knockout_message = "collapses inwards, forming a disordered puddle of gray goo."
	remains_type = /obj/effect/debris/cleanable/ash

	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/punch, /datum/unarmed_attack/bite) // Regular human attack verbs are enough.

	blood_color = "#505050" //This is the same as the 80,80,80 below, but in hex
	flesh_color = "#505050"
	base_color = "#FFFFFF" //Color mult, start out with this

	species_flags =            NO_SCAN | NO_SLIP | NO_MINOR_CUT | NO_HALLUCINATION | NO_INFECT | NO_PAIN | CONTAMINATION_IMMUNE
	species_appearance_flags = HAS_SKIN_COLOR | HAS_EYE_COLOR | HAS_HAIR_COLOR | HAS_UNDERWEAR | HAS_LIPS
	species_spawn_flags		 = SPECIES_SPAWN_CHARACTER | SPECIES_SPAWN_WHITELISTED
	health_hud_intensity = 2
	max_additional_languages = 5  // Let's not make them know every language, past me.
	assisted_langs = list(LANGUAGE_ROOTLOCAL, LANGUAGE_ROOTGLOBAL, LANGUAGE_VOX)
	color_mult = TRUE

	vision_innate = /datum/vision/baseline/species_tier_1

	breath_type = null
	poison_type = null

	virus_immune =	1
	blood_volume =	0
	min_age =		18
	max_age =		200

	total_health =	200
	/// damage to blob
	var/damage_to_blob = 100

	brute_mod =		1
	burn_mod =		1
	oxy_mod =		0
	radiation_mod = 0 // Their blobforms have rad immunity, so it only makes sense that their humanoid forms do too
	toxins_mod =	0 // This is necessary to make them not instantly die to ions/low yield EMPs, also it makes sense as the refactory would reset or repurpose corrupted nanites

	hunger_factor = 0.04 // Better power storage, perhaps? This is not additive. Whoops

	//Space doesn't bother them
	hazard_low_pressure = -1
	hazard_high_pressure = INFINITY //Totally pressure immune - in human form (blobform is also completely pressure/heat immune, bringing them both in line with each other.)


	body_temperature =      290
	item_slowdown_mod = 0.25 // temporary major hardy due to loss of other resistances

	siemens_coefficient =   1.1 // Changed in accordance to the 'what to do now' section of the rework document

	//7rarity_value =          5

	has_organ = list(
		O_BRAIN = /obj/item/organ/internal/mmi_holder/posibrain/nano,
		O_ORCH = /obj/item/organ/internal/nano/orchestrator,
		O_FACT = /obj/item/organ/internal/nano/refactory
		)
	has_limbs = list(
		BP_TORSO =  list("path" = /obj/item/organ/external/chest/unbreakable/nano),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/unbreakable/nano),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/unbreakable/nano),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/unbreakable/nano),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/unbreakable/nano),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/unbreakable/nano),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/unbreakable/nano),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/unbreakable/nano),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/unbreakable/nano),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/unbreakable/nano),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/unbreakable/nano)
		)

	//These verbs are hidden, for hotkey use only
	inherent_verbs = list(
		/mob/living/carbon/human/proc/nano_regenerate, //These verbs are hidden so you can macro them,
		/mob/living/carbon/human/proc/nano_partswap,
		/mob/living/carbon/human/proc/nano_metalnom,
		/mob/living/carbon/human/proc/nano_blobform,
		/mob/living/carbon/human/proc/nano_set_size,
		/mob/living/carbon/human/proc/nano_change_fitting, //These verbs are displayed normally,
		/mob/living/carbon/human/proc/shapeshifter_select_hair,
		/mob/living/carbon/human/proc/shapeshifter_select_hair_colors,
		/mob/living/carbon/human/proc/shapeshifter_select_colour,
		/mob/living/carbon/human/proc/shapeshifter_select_eye_colour,
		/mob/living/carbon/human/proc/shapeshifter_select_gender,
		/mob/living/carbon/human/proc/shapeshifter_select_wings,
		/mob/living/carbon/human/proc/shapeshifter_select_tail,
		/mob/living/carbon/human/proc/shapeshifter_select_ears,
		/mob/living/carbon/human/proc/shapeshifter_select_horns,
		/mob/living/proc/eat_trash,
		/mob/living/carbon/human/proc/succubus_drain,
		/mob/living/carbon/human/proc/succubus_drain_finalize,
		/mob/living/carbon/human/proc/succubus_drain_lethal,
		/mob/living/carbon/human/proc/bloodsuck,
		/mob/living/carbon/human/proc/tie_hair,
		/mob/living/proc/shred_limb,
		/mob/living/carbon/human/proc/tie_hair,
		/mob/living/proc/glow_toggle,
		/mob/living/proc/glow_color,
		/mob/living/carbon/human/proc/lick_wounds,
		/mob/living/carbon/human/proc/rig_transform,
		/mob/living/proc/usehardsuit) //prots get all the special verbs since they can't select traits.

	species_statpanel = TRUE
	var/global/list/protean_abilities = list()
	abilities = list(
		/datum/ability/species/sonar,
		/datum/ability/species/toggle_flight
	)
	var/monochromatic = FALSE //IGNORE ME

/datum/species/protean/New()
	..()
	if(!LAZYLEN(protean_abilities))
		var/list/powertypes = subtypesof(/obj/effect/protean_ability)
		for(var/path in powertypes)
			protean_abilities += new path()

/datum/species/protean/create_organs(var/mob/living/carbon/human/H)
	var/obj/item/nif/saved_nif = H.nif
	if(saved_nif)
		H.nif.unimplant(H) //Needs reference to owner to unimplant right.
		H.nif.moveToNullspace()
	..()
	if(saved_nif)
		saved_nif.quick_implant(H)

/datum/species/protean/get_effective_bodytype(mob/living/carbon/human/H, obj/item/I, slot_id)
	if(H)
		return H.impersonate_bodytype || ..()
	return ..()

/datum/species/protean/get_bodytype_legacy(var/mob/living/carbon/human/H)
	if(H)
		return H.impersonate_bodytype_legacy || ..()
	return ..()

/datum/species/protean/get_worn_legacy_bodytype(mob/living/carbon/human/H)
	return H?.impersonate_bodytype_legacy || ..()

/datum/species/protean/create_organs(mob/living/carbon/human/H)
	H.synth_color = TRUE
	. = ..()

	// todo: this is utter shitcode and will break if we CHECK_TICK in SSticker, and should probably be part of postspawn or something
	spawn(5) //Let their real nif load if they have one
		if(!H.nif)
			var/obj/item/nif/bioadap/new_nif = new()
			new_nif.quick_implant(H)
		else
			H.nif.durability = rand(21,25)

	var/obj/item/hardsuit/protean/prig = new /obj/item/hardsuit/protean(H)
	prig.myprotean = H

/datum/species/protean/equip_survival_gear(var/mob/living/carbon/human/H)
	var/obj/item/storage/box/box = new /obj/item/storage/box/survival/synth(H)
	var/obj/item/stack/material/steel/metal_stack = new(box)
	metal_stack.amount = 3 // Less starting steel due to regen changes
	new /obj/item/fbp_backup_cell(box)
	var/obj/item/clothing/accessory/permit/nanotech/permit = new(box)
	permit.set_name(H.real_name)

	if(H.backbag == 1) //Somewhat misleading, 1 == no bag (not boolean)
		H.equip_to_slot_or_del(box, /datum/inventory_slot_meta/abstract/hand/left)
	else
		H.equip_to_slot_or_del(box, /datum/inventory_slot_meta/abstract/put_in_backpack)

/datum/species/protean/get_blood_colour(var/mob/living/carbon/human/H)
	return rgb(80,80,80,230)

/datum/species/protean/get_flesh_colour(var/mob/living/carbon/human/H)
	return rgb(80,80,80,230)

/datum/species/protean/handle_death(var/mob/living/carbon/human/H, gibbed)		// citadel edit - FUCK YOU ACTUALLY GIB THE MOB AFTER REMOVING IT FROM THE BLOB HOW HARD CAN THIS BE!!
	var/deathmsg = "<span class='userdanger'>You have died as a Protean. You may be revived by nanite chambers (once available), but otherwise, you may roleplay as your disembodied posibrain or respawn on another character.</span>"
	// force eject inv
	H.drop_inventory(TRUE, TRUE, TRUE)
	// force eject v*re
	H.release_vore_contents(TRUE, TRUE)
	if(istype(H.temporary_form, /mob/living/simple_mob/protean_blob))
		var/mob/living/simple_mob/protean_blob/B = H.temporary_form
		to_chat(B, deathmsg)
	else if(!gibbed)
		to_chat(H, deathmsg)
	ASYNC
		if(!QDELETED(H))
			H.gib()

/datum/species/protean/proc/getActualDamage(mob/living/carbon/human/H)
	var/obj/item/organ/external/E = H.get_organ(BP_TORSO)
	return E.brute_dam + E.burn_dam

/datum/species/protean/handle_environment_special(var/mob/living/carbon/human/H)
	if((getActualDamage(H) > damage_to_blob) && isturf(H.loc)) //So, only if we're not a blob (we're in nullspace) or in someone (or a locker, really, but whatever).
		H.nano_intoblob()
		return ..() //Any instakill shot runtimes since there are no organs after this. No point to not skip these checks, going to nullspace anyway.

	var/obj/item/organ/internal/nano/refactory/refactory = locate() in H.internal_organs
	if(refactory && !(refactory.status & ORGAN_DEAD) && refactory.processingbuffs)

		//Steel adds regen
		if(protean_requires_healing(H) && refactory.get_stored_material(MAT_STEEL) >= METAL_PER_TICK)  //  Regen without blobform, though relatively slow compared to blob regen
			H.add_modifier(/datum/modifier/protean/steel, origin = refactory)

	return ..()

/datum/species/protean/get_additional_examine_text(var/mob/living/carbon/human/H)
	return ..() //Hmm, what could be done here?

/datum/species/protean/statpanel_status(client/C, mob/living/carbon/human/H)
	. = ..()
	var/obj/item/organ/internal/nano/refactory/refactory = H.nano_get_refactory()
	if(refactory && !(refactory.status & ORGAN_DEAD))
		STATPANEL_DATA_LINE("- -- --- Refactory Metal Storage --- -- -")
		var/max = refactory.max_storage
		for(var/material in refactory.materials)
			var/amount = refactory.get_stored_material(material)
			STATPANEL_DATA_ENTRY("[capitalize(material)]", "[amount]/[max]")
	else
		STATPANEL_DATA_LINE("- -- --- REFACTORY ERROR! --- -- -")

	STATPANEL_DATA_LINE("- -- --- Abilities (Shift+LMB Examines) --- -- -")
	for(var/ability in protean_abilities)
		var/obj/effect/protean_ability/A = ability
		A.atom_button_text()
		STATPANEL_DATA_CLICK("[icon2html(A, C)] [A.ability_name]", "[A.name]", "\ref[A]")

// Various modifiers
/datum/modifier/protean
	stacks = MODIFIER_STACK_FORBID
	var/material_use = METAL_PER_TICK
	var/material_name = MAT_STEEL

/datum/modifier/protean/on_applied()
	. = ..()
	if(holder.temporary_form)
		to_chat(holder.temporary_form, on_created_text)

/datum/modifier/protean/on_expire()
	. = ..()
	if(holder.temporary_form)
		to_chat(holder.temporary_form, on_expired_text)

/datum/modifier/protean/check_if_valid()
	//No origin set
	if(!istype(origin))
		expire()

	//No refactory or refactory not processing buffs anymore so you can't be permanently buffed while not consuming materials
	var/obj/item/organ/internal/nano/refactory/refactory = origin.resolve()
	if(!istype(refactory) || refactory.status & ORGAN_DEAD || refactory.processingbuffs == FALSE)
		expire()

	// stops you from consuming materials if the toggle is off
	if(!refactory.use_stored_material(material_name,material_use) && refactory.processingbuffs == TRUE)
		expire()

/datum/modifier/protean/steel
	name = "Protean Effect - Steel"
	desc = "You're affected by the presence of steel."

	on_created_text = "<span class='notice'>You feel new nanites being produced from your stockpile of steel, healing you slowly.</span>"
	on_expired_text = "<span class='notice'>Your steel supply has either run out, or is no longer needed, and your healing stops.</span>"

	material_name = MAT_STEEL
	material_use = METAL_PER_TICK / 5		// 5 times weaker

/datum/modifier/protean/steel/check_if_valid()
	if(!protean_requires_healing(holder) || istype(holder.temporary_form, /mob/living/simple_mob/protean_blob))
		expire()
		return
	return ..()

/datum/modifier/protean/steel/tick()
	..()
	var/dt = 2	// put it on param sometime but for now assume 2
	var/mob/living/carbon/human/H = holder
	var/obj/item/organ/external/E = H.get_organ(BP_TORSO)
	var/obj/item/organ/external/HE = H.get_organ(BP_HEAD) // Head for disfigurement
	var/heal = 1 * dt
	var/brute_heal_left = max(0, heal - E.brute_dam)
	var/burn_heal_left = max(0, heal - E.burn_dam)

	E.heal_damage(min(heal, E.brute_dam), min(heal, E.burn_dam), TRUE, TRUE)
	HE.disfigured = 0 // Fix disfigurement, become pretty once more
	// I didn't want to constantly rebuild and lose my markings to stop being an unknown
	holder.adjustBruteLoss(-brute_heal_left, include_robo = TRUE)
	holder.adjustFireLoss(-burn_heal_left, include_robo = TRUE)
	holder.adjustToxLoss(-3.6) // With them now having tox immunity, this is redundant, along with the rad regen, but I'm keeping it in, in case they do somehow get some system instability
	holder.radiation = max(RAD_MOB_CURE_PROTEAN_REGEN)


/proc/protean_requires_healing(mob/living/carbon/human/H)
	if(!istype(H))
		return FALSE
	return H.getActualBruteLoss() || H.getActualFireLoss() || H.getToxLoss()

// PAN Card
/obj/item/clothing/accessory/permit/nanotech
	name = "\improper P.A.N. card"
	desc = "This is a 'Permit for Advanced Nanotechnology' card. It allows the owner to possess and operate advanced nanotechnology on NanoTrasen property. It must be renewed on a monthly basis."
	icon = 'icons/obj/card_cit.dmi'
	icon_state = "permit-pan"
/obj/item/clothing/accessory/permit/nanotech/set_name(var/new_name)
	owner = 1
	if(new_name)
		src.name += " ([new_name])"
		desc += "\nVALID THROUGH END OF: [time2text(world.timeofday, "Month") +" "+ num2text(text2num(time2text(world.timeofday, "YYYY"))+544)]\nREGISTRANT: [new_name]"

/mob/living/carbon/human/proc/rig_transform()
	set name = "Modify Form - Hardsuit"
	set desc = "Allows a protean to solidify its form into one extremely similar to a hardsuit."
	set category = "Abilities"

	if(istype(loc, /obj/item/hardsuit/protean))
		var/obj/item/hardsuit/protean/prig = loc
		src.forceMove(get_turf(prig))
		prig.forceMove(src)
		return

	if(isturf(loc))
		var/obj/item/hardsuit/protean/prig = locate() in contents
		if(prig)
			prig.forceMove(get_turf(src))
			src.forceMove(prig)
			return

#undef DAM_SCALE_FACTOR
#undef METAL_PER_TICK
