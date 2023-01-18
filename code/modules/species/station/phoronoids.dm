/datum/species/phoronoid
	name = SPECIES_PHORONOID
	uid = SPECIES_ID_PHORONOID
	name_plural = "Phoronoids"
	default_bodytype = BODYTYPE_PHORONOID

	icobase      = 'icons/mob/species/phoronoid/body.dmi'
	deform       = 'icons/mob/species/phoronoid/body.dmi'
	preview_icon = 'icons/mob/species/phoronoid/preview.dmi'
	husk_icon    = 'icons/mob/species/phoronoid/husk.dmi'

	intrinsic_languages = LANGUAGE_ID_PHORONOID
	max_additional_languages = 3
	name_language = null // name randomisers are fucking weird

	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/punch)
	blurb = {"
	Phoronoids are a race rarely seen by most, tending to keep to themselves throughout known space.
	These curious skeleton-folk react violently with oxygen, catching alight in the normal concentration needed for humans.
	Luckily, with the help of NT, they come equipped with specialised suits, keeping oxygen out and phoron in.
	"}

	max_age = 180
	health_hud_intensity = 1.5
	rarity_value = 5
	blood_color = "#FC2BC5"

	species_flags = NO_SCAN | NO_MINOR_CUT | CONTAMINATION_IMMUNE
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

	breath_type = /datum/gas/phoron
	poison_type = /datum/gas/oxygen
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

	cold_level_1 = 200
	cold_level_2 = 180
	cold_level_3 = 120

	breath_cold_level_1 = 120 // so they can probably breathe outside?
	breath_cold_level_2 = 80
	breath_cold_level_3 = 60

	heat_level_1 = 360
	heat_level_2 = 500
	heat_level_3 = 800

	body_temperature = T20C

/datum/species/phoronoid/handle_environment_special(mob/living/carbon/human/H)
	var/turf/T = H.loc
	if(!T)
		return
	var/datum/gas_mixture/environment = T.copy_cell_volume()
	if(!environment)
		return

	/// In case they're ever set on fire while wearing a spacesuit, we don't want the message that they're reacting with the atmosphere.
	var/enviroment_bad = FALSE

	if(environment.gas[/datum/gas/oxygen] > 0.5)
		// Now any airtight spessuit works for them. Which means exploration voidsuits work. :O
		if(H.wear_suit && istype(H.wear_suit,/obj/item/clothing/suit/space) && H.head && istype(H.head,/obj/item/clothing/head/helmet/space))
			return
		H.adjust_fire_stacks(2)
		enviroment_bad = TRUE
		if(!H.on_fire && enviroment_bad)
			H.visible_message(
				SPAN_DANGER("[H]'s body reacts with the atmosphere and bursts into flames!"),
				SPAN_USERDANGER("Your body reacts with the atmosphere and bursts into flames!"),
				SPAN_HEAR("You hear something combust into flames!")
			)
			H.IgniteMob()
	enviroment_bad = FALSE

/datum/species/phoronoid/equip_survival_gear(mob/living/carbon/human/H, extendedtank = FALSE, comprehensive = FALSE)
	. = ..()
	var/suit = /obj/item/clothing/suit/space/plasman
	var/helm = /obj/item/clothing/head/helmet/space/plasman

	H.equip_to_slot_or_del(new /obj/item/clothing/mask/breath(H), SLOT_ID_MASK)

	switch(H.mind?.assigned_role)
		if("Security Officer")
			suit=/obj/item/clothing/suit/space/plasman/sec
			helm=/obj/item/clothing/head/helmet/space/plasman/sec

		if("Detective")
			suit=/obj/item/clothing/suit/space/plasman/sec/detective
			helm=/obj/item/clothing/head/helmet/space/plasman/sec/detective

		if("Warden")
			suit=/obj/item/clothing/suit/space/plasman/sec/warden
			helm=/obj/item/clothing/head/helmet/space/plasman/sec

		if("Head of Security")
			suit=/obj/item/clothing/suit/space/plasman/sec/hos
			helm=/obj/item/clothing/head/helmet/space/plasman/sec/hos

		if("Facility Director")
			suit=/obj/item/clothing/suit/space/plasman/sec/captain
			helm=/obj/item/clothing/head/helmet/space/plasman/sec/captain

		if("Head of Personnel")
			suit=/obj/item/clothing/suit/space/plasman/sec/hop
			helm=/obj/item/clothing/head/helmet/space/plasman/sec/hop

		if("Scientist","Roboticist","Xenobiologist")
			suit=/obj/item/clothing/suit/space/plasman/science
			helm=/obj/item/clothing/head/helmet/space/plasman/science

		if("Explorer","Pilot","Pathfinder")
			suit=/obj/item/clothing/suit/space/plasman/science/explorer
			helm=/obj/item/clothing/head/helmet/space/plasman/science/explorer

		if("Research Director")
			suit=/obj/item/clothing/suit/space/plasman/science/rd
			helm=/obj/item/clothing/head/helmet/space/plasman/science/rd

		if("Station Engineer")
			suit=/obj/item/clothing/suit/space/plasman/engi/
			helm=/obj/item/clothing/head/helmet/space/plasman/engi/

		if("Chief Engineer")
			suit=/obj/item/clothing/suit/space/plasman/engi/ce
			helm=/obj/item/clothing/head/helmet/space/plasman/engi/ce

		if("Atmospheric Technician")
			suit=/obj/item/clothing/suit/space/plasman/engi/atmos
			helm=/obj/item/clothing/head/helmet/space/plasman/engi/atmos

		if("Medical Doctor","Paramedic","Psychiatrist")
			suit=/obj/item/clothing/suit/space/plasman/med
			helm=/obj/item/clothing/head/helmet/space/plasman/med

		if("Field Medic")
			suit=/obj/item/clothing/suit/space/plasman/med/rescue
			helm=/obj/item/clothing/head/helmet/space/plasman/med/rescue

		if("Chemist")
			suit=/obj/item/clothing/suit/space/plasman/med/chemist
			helm=/obj/item/clothing/head/helmet/space/plasman/med/chemist

		if("Chief Medical Officer")
			suit=/obj/item/clothing/suit/space/plasman/med/cmo
			helm=/obj/item/clothing/head/helmet/space/plasman/med/cmo

		if("Bartender","Chef")
			suit=/obj/item/clothing/suit/space/plasman/service
			helm=/obj/item/clothing/head/helmet/space/plasman/service

		if("Cargo Technician","Quartermaster")
			suit=/obj/item/clothing/suit/space/plasman/cargo
			helm=/obj/item/clothing/head/helmet/space/plasman/cargo

		if("Shaft Miner")
			suit=/obj/item/clothing/suit/space/plasman/cargo/miner
			helm=/obj/item/clothing/head/helmet/space/plasman/cargo/miner

		if("Botanist")
			suit=/obj/item/clothing/suit/space/plasman/botanist
			helm=/obj/item/clothing/head/helmet/space/plasman/botanist

		if("Chaplain")
			suit=/obj/item/clothing/suit/space/plasman/chaplain
			helm=/obj/item/clothing/head/helmet/space/plasman/chaplain

		if("Janitor")
			suit=/obj/item/clothing/suit/space/plasman/janitor
			helm=/obj/item/clothing/head/helmet/space/plasman/janitor

		if("Internal Affairs Agent","Command Secretary")
			suit=/obj/item/clothing/suit/space/plasman/fancy
			helm=/obj/item/clothing/head/helmet/space/plasman/fancy

		if("Visitor")
			suit=/obj/item/clothing/suit/space/plasman/assistant
			helm=/obj/item/clothing/head/helmet/space/plasman/assistant

		if("Clown")
			suit=/obj/item/clothing/suit/space/plasman/clown
			helm=/obj/item/clothing/head/helmet/space/plasman/clown

		if("Mime")
			suit=/obj/item/clothing/suit/space/plasman/mime
			helm=/obj/item/clothing/head/helmet/space/plasman/mime
	H.equip_to_slot_or_del(new suit(H), SLOT_ID_SUIT)
	H.equip_to_slot_or_del(new helm(H), SLOT_ID_HEAD)
	H.put_in_hands_or_del(new /obj/item/extinguisher/mini/plasman(H))

	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/tank/vox(H), SLOT_ID_BACK)
		H.internal = H.back
	else
		H.equip_to_slot_or_del(new /obj/item/tank/vox(H), SLOT_ID_SUIT_STORAGE)
		H.internal = H.s_store

	H.internal = locate(/obj/item/tank) in H.contents
	if(istype(H.internal,/obj/item/tank) && H.internals)
		H.internals.icon_state = "internal1"

	spawn(2)
		if(H.head && !istype(H.head,/obj/item/clothing/head/helmet/space/plasman))
			qdel(H.head)
			H.equip_to_slot_or_del(new helm(H), SLOT_ID_HEAD)
			if(H.on_fire)
				H.ExtinguishMob()

		if(H.wear_suit && !istype(H.wear_suit,/obj/item/clothing/suit/space/plasman))
			qdel(H.wear_suit)
			H.equip_to_slot_or_del(new suit(H), SLOT_ID_SUIT)
			if(H.on_fire)
				H.ExtinguishMob()
			H.equip_to_slot_or_del(new /obj/item/tank/vox(H), SLOT_ID_SUIT_STORAGE)
			H.internal = H.s_store
