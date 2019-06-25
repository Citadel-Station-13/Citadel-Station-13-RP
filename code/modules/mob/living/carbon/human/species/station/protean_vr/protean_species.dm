#define DAM_SCALE_FACTOR 0.01
#define PLASTIC_PER_TICK 150
/datum/species/protean
	name =             SPECIES_PROTEAN
	name_plural =      "Proteans"
	blurb =            "Proteans are the extreme application of physics at the nanite level. Expensive and slow to construct, \
						they are made of massive amounts of nanites constructed from carbon, or in-game, plastic. \
						Protean circuitry is based off of graphene and is highly conductive. Fullerene is the structure that holds the shape togeather,\
						and has a low melting point but high resistance to pressure."
	show_ssd =         "totally quiescent"
	death_message =    "rapidly loses cohesion, dissolving into a cloud of colorful liquids..."
	knockout_message = "collapses inwards, forming a disordered puddle of gray goo."
	remains_type = /obj/effect/decal/cleanable/ash

	blood_color = "#505050" //This is the same as the 80,80,80 below, but in hex
	flesh_color = "#505050"
	base_color = "#FFFFFF" //Color mult, start out with this

	flags =            NO_SCAN | NO_SLIP | NO_MINOR_CUT | NO_HALLUCINATION | NO_INFECT | NO_PAIN | IS_SLIME
	appearance_flags = HAS_SKIN_COLOR | HAS_EYE_COLOR | HAS_HAIR_COLOR | HAS_UNDERWEAR | HAS_LIPS
	spawn_flags		 = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED
	health_hud_intensity = 2
	num_alternate_languages = 3
	assisted_langs = list(LANGUAGE_ROOTLOCAL, LANGUAGE_ROOTGLOBAL, LANGUAGE_VOX)
	color_mult = TRUE

	breath_type = null
	poison_type = null

	virus_immune =	1
	blood_volume =	0
	min_age =		18
	max_age =		200
	brute_mod =		0.40 //Brute isn't very effective, they're made of dust, bump down to 0.2 after revive coded
	burn_mod =		1.5 //Burn, is more effective due to Graphene conduits. Until revive is coded in, then may bump proteans back to original 2 value
	oxy_mod =		0

	cold_level_1 = 280 //Default 260 - Lower is better
	cold_level_2 = 220 //Default 200
	cold_level_3 = 130 //Default 120

	heat_level_1 = 552 //Default 360
	heat_level_2 = 553 //Default 400
	heat_level_3 = 570 //Default 1000
	heat_discomfort_level = 552

	//melting point of Fullerene is 553K. Proteans take minor damage slightly below it. They start taking massive damage VERY fast above it,
	//Proteans start melting literally >553K on the inside
	//Graphene has an insane melting point but there's nothing holding them in place.


	//Space doesn't bother them
	hazard_low_pressure = -1
	hazard_high_pressure = 1000 //Proteans laugh at high pressures other synths cant. Fullerene is highly fluid and graphine would shift along with it.
	//I would code in something like pressure causing slowdown.

	//Cold does  affect them, but it's done in special ways below
	cold_level_1 = -INFINITY
	cold_level_2 = -INFINITY
	cold_level_3 = -INFINITY


	body_temperature =      283 //10C

	siemens_coefficient =   1.7 //Very bad zappy times, balance from 2.0 to insta perma lock. Compromise due to the fact that one would assume the 'wiring' would be more like human nerves.
	rarity_value =          5 //antag use.

	genders = list(MALE, FEMALE, NEUTER, PLURAL)

	darksight = 3 // Equivalent to the minor trait

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

	heat_discomfort_strings = list("A sensor reminds you are nearing the  maximum safe operation tempature is below 553 Kelvin")
	cold_discomfort_strings = list("A warning regarding your efficency in these low tempatures is displayed.")

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
		/mob/living/carbon/human/proc/shapeshifter_select_ears
		)

	var/global/list/abilities = list()

	var/monochromatic = FALSE //IGNORE ME

/datum/species/protean/New()
	..()
	if(!LAZYLEN(abilities))
		var/list/powertypes = subtypesof(/obj/effect/protean_ability)
		for(var/path in powertypes)
			abilities += new path()

/datum/species/protean/create_organs(var/mob/living/carbon/human/H)
	var/obj/item/device/nif/saved_nif = H.nif
	if(saved_nif)
		H.nif.unimplant(H) //Needs reference to owner to unimplant right.
		H.nif.forceMove(null)
	..()
	if(saved_nif)
		saved_nif.quick_implant(H)

/datum/species/protean/get_bodytype(var/mob/living/carbon/human/H)
	if(H)
		return H.impersonate_bodytype || ..()
	return ..()

/datum/species/protean/handle_post_spawn(var/mob/living/carbon/human/H)
	..()
	H.synth_color = TRUE

/datum/species/protean/equip_survival_gear(var/mob/living/carbon/human/H)
	var/obj/item/stack/material/plastic/metal_stack = new()
	metal_stack.amount = 10

	var/obj/item/clothing/accessory/permit/nanotech/permit = new()
	permit.set_name(H.real_name)

	if(H.backbag == 1) //Somewhat misleading, 1 == no bag (not boolean)
		H.equip_to_slot_or_del(permit, slot_l_hand)
		H.equip_to_slot_or_del(metal_stack, slot_r_hand)
	else
		H.equip_to_slot_or_del(permit, slot_in_backpack)
		H.equip_to_slot_or_del(metal_stack, slot_in_backpack)

	spawn(0) //Let their real nif load if they have one
		if(!H.nif)
			var/obj/item/device/nif/bioadap/new_nif = new()
			new_nif.quick_implant(H)
		else
			H.nif.durability = rand(21,25)

/datum/species/protean/hug(var/mob/living/carbon/human/H, var/mob/living/target)
	return ..() //Wut

/datum/species/protean/get_blood_colour(var/mob/living/carbon/human/H)
	return rgb(80,80,80,230)

/datum/species/protean/get_flesh_colour(var/mob/living/carbon/human/H)
	return rgb(80,80,80,230)

/datum/species/protean/handle_death(var/mob/living/carbon/human/H)
	to_chat(H,"<span class='warning'>You died as a Protean. Please sit out of the round for at least 30 minutes before respawning, to represent the time it would take to ship a new-you to the station.</span>")
	spawn(1) //This spawn is here so that if the protean_blob calls qdel, it doesn't try to gib the humanform.
		if(H)
			H.gib()

/datum/species/protean/handle_environment_special(var/mob/living/carbon/human/H)
	if((H.getActualBruteLoss() + H.getActualFireLoss()) > H.maxHealth*0.5 && isturf(H.loc)) //So, only if we're not a blob (we're in nullspace) or in someone (or a locker, really, but whatever)
		H.nano_intoblob()
		return ..() //Any instakill shot runtimes since there are no organs after this. No point to not skip these checks, going to nullspace anyway.

	var/obj/item/organ/internal/nano/refactory/refactory = locate() in H.internal_organs
	if(refactory && !(refactory.status & ORGAN_DEAD))

		//MHydrogen adds speeeeeed
		if(refactory.get_stored_material("mhydrogen") >= PLASTIC_PER_TICK)
			H.add_modifier(/datum/modifier/protean/mhydrogen, origin = refactory)

		//Platinum reduces burn damage, but slows down slightly to comp
		if(refactory.get_stored_material("platinum") >= PLASTIC_PER_TICK)
			H.add_modifier(/datum/modifier/protean/platinum, origin = refactory)
		//plasteel mark two. Electrifying bogaloo
		if(refactory.get_stored_material("uranium") >= PLASTIC_PER_TICK)
			H.add_modifier(/datum/modifier/protean/platinum, origin = refactory)

		//Diamond adds burn armor
		if(refactory.get_stored_material("diamond") >= PLASTIC_PER_TICK)
			H.add_modifier(/datum/modifier/protean/diamond, origin = refactory)

	return ..()



/datum/species/protean/get_additional_examine_text(var/mob/living/carbon/human/H)
	return ..() //Hmm, what could be done here?

/datum/species/protean/Stat(var/mob/living/carbon/human/H)
	..()
	if(statpanel("Protean"))
		var/obj/item/organ/internal/nano/refactory/refactory = H.nano_get_refactory()
		if(refactory && !(refactory.status & ORGAN_DEAD))
			stat(null, "- -- --- Refactory Metal Storage --- -- -")
			var/max = refactory.max_storage
			for(var/material in refactory.materials)
				var/amount = refactory.get_stored_material(material)
				stat("[capitalize(material)]", "[amount]/[max]")
		else
			stat(null, "- -- --- REFACTORY ERROR! --- -- -")

		stat(null, "- -- --- Abilities (Shift+LMB Examines) --- -- -")
		for(var/ability in abilities)
			var/obj/effect/protean_ability/A = ability
			stat("[A.ability_name]",A.atom_button_text())

// Various modifiers
/datum/modifier/protean
	stacks = MODIFIER_STACK_FORBID
	var/material_use = PLASTIC_PER_TICK
	var/material_name = DEFAULT_TABLE_MATERIAL

/datum/modifier/protean/on_applied()
	. = ..()
	if(holder.temporary_form)
		to_chat(holder.temporary_form,on_created_text)

/datum/modifier/protean/on_expire()
	. = ..()
	if(holder.temporary_form)
		to_chat(holder.temporary_form,on_expired_text)

/datum/modifier/protean/check_if_valid()
	//No origin set
	if(!istype(origin))
		expire()

	//No refactory
	var/obj/item/organ/internal/nano/refactory/refactory = origin.resolve()
	if(!istype(refactory) || refactory.status & ORGAN_DEAD)
		expire()

	//Out of materials
	if(!refactory.use_stored_material(material_name,material_use))
		expire()

/datum/modifier/protean/mhydrogen
	name = "Protean Effect - M.Hydrogen"
	desc = "You're affected by the presence of metallic hydrogen."

	on_created_text = "<span class='notice'>You feel yourself accelerate, the metallic hydrogen increasing your speed temporarily.</span>"
	on_expired_text = "<span class='notice'>Your refactory finishes consuming the metallic hydrogen, and you return to normal speed.</span>"

	material_name = "mhydrogen"
	//slight buff. Mhydrogen very rare, usually miners have to go out of their way to get it with the large drill.
	slowdown = -1
	disable_duration_percent = 0.80


 /datum/modifier/protean/platinum // first balance attempt. Trying to make this like previous plasteel without the broken 50% brute mod on 0.2 base brute damaage.
	name = "Protean Effect - Platinum"
	desc = "You're affected by the presence of platinum."

	on_created_text = "<span class='notice'>You feel yourself become slightly more resistant to causes of system instability.</span>"
	on_expired_text = "<span class='notice'>Your refactory finishes consuming the platinum, and you return to your normal nanites.</span>"

	material_name = "platinum"

	slowdown = 0.3						//itsss heavyy, may change to 1... Need to test slowdown more
	incoming_tox_damage_percent	= 0.7		//shielding due to atomic weight.
	incoming_fire_damage_percent = 1.5 //see below.
	disable_duration_percent = 2 // You just covered yourself with fucking conductive metal dumbass. Nice job. Compensate for lack of siemens coefficent mod in modifiers


/datum/modifier/protean/uranium // New damage modifier. Is has lots of drawbacks. Good luck hunting in the zone stalker (No its just a nerfed plasteel)
	name = "Protean Effect - Uranium"
	desc = "You're affected by the presence of uranium."

	on_created_text = "<span class='notice'>You feel yourself become slightly heavier.</span>"
	on_expired_text = "<span class='notice'>Your refactory finishes consuming the uranium, and you return to your normal nanites.</span>"

	material_name = "uranium"
	slowdown = 1.5					//itsss heavyy, may change to 1 or 2... Need to test slowdown more
	incoming_tox_damage_percent	= 2		//You just ate a radioactive item. Good job.
	attack_speed_percent = 0.66			// Attack at 2/3 the normal delay.
	outgoing_melee_damage_percent = 1.5		// 50% more damage from melee.
	disable_duration_percent = 1.25			// Disables only last 125% as long.
	evasion = -45	//Can't dodge if you can't move.
	slowdown = 1					//itsss heavyy,




/datum/modifier/protean/diamond
	name = "Protean Effect - Diamond"
	desc = "You're affected by the presence of diamond."

	on_created_text = "<span class='notice'>You feel yourself become more reflective, able to resist heat and fire better for a time.</span>"
	on_expired_text = "<span class='notice'>Your refactory finishes consuming the diamond, and you return to your normal nanites.</span>"

	material_name = "diamond"

	incoming_fire_damage_percent = 0.5
	//nerf due to changes of base burn %

/datum/modifier/protean/plastic
	name = "Protean Effect - Plastic"
	desc = "You're affected by the presence of plastic."

	on_created_text = "<span class='notice'>You feel new nanites being produced from your stockpile of plastic, healing you slowly.</span>"
	on_expired_text = "<span class='notice'>Your plastic supply has either run out, or is no longer needed, and your healing stops.</span>"

	material_name = "plastic"

/datum/modifier/protean/plastic/tick()
	..()
	holder.adjustBruteLoss(-10,include_robo = TRUE) //Looks high, but these ARE modified by species resistances, so this is really 20% of this
	holder.adjustFireLoss(-1,include_robo = TRUE) //And this is really double this
	var/mob/living/carbon/human/H = holder
	for(var/organ in H.internal_organs)
		var/obj/item/organ/O = organ
		// Fix internal damage
		if(O.damage > 0)
			O.damage = max(0,O.damage-1)
		// If not damaged, but dead, fix it
		else if(O.status & ORGAN_DEAD)
			O.status &= ~ORGAN_DEAD //Unset dead if we repaired it entirely

// PAN Card
/obj/item/clothing/accessory/permit/nanotech
	name = "\improper P.A.N. card"
	desc = "This is a 'Permit for Advanced Nanotechnology' card. It allows the owner to possess and operate advanced nanotechnology on NanoTrasen property. It must be renewed on a bi-yearly basis."
	icon = 'icons/obj/card_cit.dmi'
	icon_state = "permit-pan"
/obj/item/clothing/accessory/permit/nanotech/set_name(var/new_name)
	owner = 1
	if(new_name)
		src.name += " ([new_name])"
		desc += "\nRenew before: [time2text(world.timeofday, "Month") +" "+ num2text(text2num(time2text(world.timeofday, "YYYY"))+546)]\nREGISTRANT: [new_name]"

#undef DAM_SCALE_FACTOR
#undef PLASTIC_PER_TICK