/datum/species/phoronoid
	uid = SPECIES_ID_PHORONOID
	id = SPECIES_ID_PHORONOID
	name = SPECIES_PHORONOID
	name_plural = "Phoronoids"
	default_bodytype = BODYTYPE_PHORONOID

	icobase      = 'icons/mob/species/phoronoid/body.dmi'
	deform       = 'icons/mob/species/phoronoid/body.dmi'
	preview_icon = 'icons/mob/species/phoronoid/preview.dmi'
	husk_icon    = 'icons/mob/species/phoronoid/husk.dmi'

	intrinsic_languages = list(LANGUAGE_ID_PHORONOID, LANGUAGE_ID_PHORONOID_CONLANG)
	max_additional_languages = 3
	name_language = null // name randomisers are fucking weird

	unarmed_types = list(/datum/melee_attack/unarmed/stomp, /datum/melee_attack/unarmed/kick, /datum/melee_attack/unarmed/punch)
	blurb = {"
	Phoronoids are a race rarely seen by most, tending to keep to themselves throughout known space.
	These curious skeleton-folk react violently with oxygen, catching alight in the normal concentration needed for humans.
	Luckily, they come equipped with specialised suits, keeping oxygen out and phoron in.
	"}

	max_age = 180
	health_hud_intensity = 1.5
	//rarity_value = 5
	blood_color = "#FC2BC5"

	species_flags = NO_SCAN | NO_PAIN | NO_MINOR_CUT | CONTAMINATION_IMMUNE
	species_spawn_flags = SPECIES_SPAWN_WHITELISTED | SPECIES_SPAWN_CHARACTER
	species_appearance_flags = HAS_EYE_COLOR

	show_ssd = "completely motionless"

	blood_volume   = 560
	hunger_factor  = 0
	metabolic_rate = 1

	virus_immune = TRUE

	brute_mod     = 1
	burn_mod      = 1.2
	oxy_mod       = 1.2
	toxins_mod    = 0 // blackmajor "encouraged" it
	radiation_mod = 1
	flash_mod     = 2
	chemOD_mod    = 1 // turns out this is just damage

	breath_type = GAS_ID_PHORON
	poison_type = GAS_ID_OXYGEN
	siemens_coefficient = 1

	speech_bubble_appearance = "phoron"

	death_message = "falls over and stops moving!"
	knockout_message = "falls over!"

	has_organ = list(
		O_HEART   = /obj/item/organ/internal/heart,
		O_LUNGS   = /obj/item/organ/internal/lungs,
		O_VOICE   = /obj/item/organ/internal/voicebox,
		O_LIVER   = /obj/item/organ/internal/liver,
		O_KIDNEYS = /obj/item/organ/internal/kidneys,
		O_BRAIN   = /obj/item/organ/internal/brain,
		O_EYES    = /obj/item/organ/internal/eyes,
	)
	vision_organ = O_EYES

	cold_level_1 = 200
	cold_level_2 = 180
	cold_level_3 = 120

	breath_cold_level_1 = 120 // so they can probably breathe outside?
	breath_cold_level_2 = 80
	breath_cold_level_3 = 60

	heat_level_1 = 360
	heat_level_2 = 500
	heat_level_3 = 800

	minimum_breath_pressure = 12

	body_temperature = T20C

/datum/species/phoronoid/handle_environment_special(mob/living/carbon/human/H, datum/gas_mixture/environment, dt)
	if(!environment)
		return

	/// In case they're ever set on fire while wearing a spacesuit, we don't want the message that they're reacting with the atmosphere.
	var/enviroment_bad = FALSE

	if( (environment.gas[GAS_ID_OXYGEN] / environment.total_moles) > 0.1) //greater than 10% oxygen
		// Now any airtight spessuit works for them. Which means exploration voidsuits work. :O
		if(istype(H.wear_suit, /obj/item/clothing) && istype(H.head,/obj/item/clothing))
			var/obj/item/clothing/suit = H.wear_suit
			var/obj/item/clothing/head = H.head
			if(head.min_pressure_protection == 0 && suit.min_pressure_protection == 0)
				return

		H.adjust_fire_stacks(3)
		enviroment_bad = TRUE
		if(!H.on_fire && enviroment_bad)
			H.visible_message(
				SPAN_DANGER("[H]'s body reacts with the atmosphere and bursts into flames!"),
				SPAN_USERDANGER("Your body reacts with the atmosphere and bursts into flames!"),
				SPAN_HEAR("You hear something combust into flames!")
			)
			H.IgniteMob()
	enviroment_bad = FALSE

/datum/species/phoronoid/apply_survival_gear(mob/living/carbon/for_target, list/into_box, list/into_inv)
	// ensure they have a valid mask
	var/mask_type = /obj/item/clothing/mask/breath

	if(for_target)
		var/obj/item/existing_mask = for_target.inventory.get_slot_single(/datum/inventory_slot/inventory/mask)
		if(existing_mask?.clothing_flags & ALLOWINTERNALS)
		else
			if(!isnull(existing_mask))
				into_inv?.Add(existing_mask)
			for_target.temporarily_remove_from_inventory(existing_mask, INV_OP_FORCE)
			for_target.equip_to_slot_or_del(new mask_type(for_target), /datum/inventory_slot/inventory/mask, INV_OP_SILENT | INV_OP_FLUFFLESS)
	else
		if(!isnull(mask_type))
			into_inv?.Add(mask_type)

	var/suit_path = /obj/item/clothing/suit/space/void/plasman

	//this switch IS really bad but it's probably the.. cleanest way to go about it, actually, seeing as assigned_job seems to be unused
	switch(for_target.mind?.assigned_role)
		if("Security Officer")
			suit_path = /obj/item/clothing/suit/space/void/plasman/sec


		if("Detective")
			suit_path = /obj/item/clothing/suit/space/void/plasman/sec/detective


		if("Warden")
			suit_path = /obj/item/clothing/suit/space/void/plasman/sec/warden


		if("Head of Security")
			suit_path = /obj/item/clothing/suit/space/void/plasman/sec/hos


		if("Facility Director", "Captain")
			suit_path = /obj/item/clothing/suit/space/void/plasman/sec/captain


		if("Head of Personnel")
			suit_path = /obj/item/clothing/suit/space/void/plasman/sec/hop


		if("Scientist","Roboticist","Xenobiologist")
			suit_path = /obj/item/clothing/suit/space/void/plasman/science

		if("Explorer","Pilot","Pathfinder")
			suit_path = /obj/item/clothing/suit/space/void/plasman/science/explorer


		if("Research Director")
			suit_path = /obj/item/clothing/suit/space/void/plasman/science/rd


		if("Station Engineer")
			suit_path = /obj/item/clothing/suit/space/void/plasman/engi


		if("Chief Engineer")
			suit_path = /obj/item/clothing/suit/space/void/plasman/engi/ce


		if("Atmospheric Technician")
			suit_path = /obj/item/clothing/suit/space/void/plasman/engi/atmos


		if("Medical Doctor","Paramedic","Psychiatrist")
			suit_path = /obj/item/clothing/suit/space/void/plasman/med


		if("Field Medic")
			suit_path = /obj/item/clothing/suit/space/void/plasman/med/rescue


		if("Chemist")
			suit_path = /obj/item/clothing/suit/space/void/plasman/med/chemist


		if("Chief Medical Officer")
			suit_path = /obj/item/clothing/suit/space/void/plasman/med/cmo


		if("Bartender","Chef")
			suit_path = /obj/item/clothing/suit/space/void/plasman/service


		if("Cargo Technician","Quartermaster")
			suit_path = /obj/item/clothing/suit/space/void/plasman/cargo


		if("Shaft Miner")
			suit_path = /obj/item/clothing/suit/space/void/plasman/cargo/miner


		if("Botanist")
			suit_path = /obj/item/clothing/suit/space/void/plasman/botanist


		if("Chaplain")
			suit_path = /obj/item/clothing/suit/space/void/plasman/chaplain


		if("Janitor")
			suit_path = /obj/item/clothing/suit/space/void/plasman/janitor


		if("Internal Affairs Agent","Command Secretary")
			suit_path = /obj/item/clothing/suit/space/void/plasman/fancy


		if("Visitor")
			suit_path = /obj/item/clothing/suit/space/void/plasman/assistant


		if("Clown")
			suit_path = /obj/item/clothing/suit/space/void/plasman/clown


		if("Mime")
			suit_path = /obj/item/clothing/suit/space/void/plasman/mime


	into_inv?.Add(/obj/item/extinguisher/mini/plasman)

	if(for_target)
		var/obj/item/existing_head_slot = for_target.inventory.get_slot_single(/datum/inventory_slot/inventory/head)
		var/obj/item/existing_suit_slot = for_target.inventory.get_slot_single(/datum/inventory_slot/inventory/suit)
		var/obj/item/creating_suit_slot = new suit_path
		if(existing_head_slot)
			if(for_target.temporarily_remove_from_inventory(existing_head_slot, INV_OP_FORCE | INV_OP_SILENT | INV_OP_FLUFFLESS))
				into_inv?.Add(existing_head_slot)
		if(existing_suit_slot)
			if(for_target.temporarily_remove_from_inventory(existing_suit_slot, INV_OP_FORCE | INV_OP_SILENT | INV_OP_FLUFFLESS))
				into_inv?.Add(existing_suit_slot)
				if(!for_target.inventory.equip_to_slot_if_possible(creating_suit_slot, /datum/inventory_slot/inventory/suit, INV_OP_FORCE | INV_OP_SILENT | INV_OP_FLUFFLESS))
					into_inv?.Add(creating_suit_slot)
			else
				into_inv?.Add(creating_suit_slot)
		else
			if(!for_target.inventory.equip_to_slot_if_possible(creating_suit_slot, /datum/inventory_slot/inventory/suit, INV_OP_FORCE | INV_OP_SILENT | INV_OP_FLUFFLESS))
				into_inv?.Add(creating_suit_slot)
	else
		into_inv?.Add(suit_path)

	//! legacy: just in case
	for_target.ExtinguishMob()

	// ensure they have a vox tank
	var/tank_type = /obj/item/tank/vox
	if(for_target)
		var/obj/item/tank/equipping_tank = new tank_type
		var/could_place = TRUE
		if(for_target.inventory.equip_to_slot_if_possible(equipping_tank, /datum/inventory_slot/inventory/suit_storage))
		else if(for_target.inventory.put_in_hands(equipping_tank))
		else
			could_place = FALSE
		if(could_place)
			// todo: refactor this shit
			for_target.internal = equipping_tank
			for_target.internals.icon_state = "internal1"
		else
			into_inv?.Add(tank_type)
	else
		into_inv?.Add(tank_type)

	return ..()
