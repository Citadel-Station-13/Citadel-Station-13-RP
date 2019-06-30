/datum/species/plasmaman
	name = SPECIES_PLASMAMAN
	name_plural = "Phoronoids"
	icobase = 'icons/mob/human_races/r_plasmaman_sb.dmi'
	primitive_form = null
	language = LANGUAGE_GALCOM
	species_language = LANGUAGE_BONES
	num_alternate_languages = 3
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/punch)
	blurb = "Phoronoids are a race rarely seen by most, tending to keep to themselves throughout known space. \
	These curious skeleton-folk react violently with oxygen, catching alight in the normal concentration needed for humans. \
	Luckily, with the help of NT, they come equipped with specialised suits, keeping oxygen out and phoron in."
	name_language = null // name randomisers are fucking weird
	min_age = 18
	max_age = 180
	health_hud_intensity = 1.5
	rarity_value = 5
	blood_color = "#FC2BC5"

	flags = NO_SCAN | NO_MINOR_CUT | NO_BLOOD
	spawn_flags = SPECIES_IS_WHITELISTED | SPECIES_CAN_JOIN
	appearance_flags = HAS_EYE_COLOR

	show_ssd = "completely motionless"

	hunger_factor = 0
	metabolic_rate = 1

	virus_immune = 1

	brute_mod =     1.5
	burn_mod =      1.5
	oxy_mod =       1
	toxins_mod =    0 // blackmajor "encouraged" it
	radiation_mod = 0
	flash_mod =     2
	chemOD_mod =	1 // turns out this is just damage

	breath_type = "phoron"
	poison_type = "oxygen"
	siemens_coefficient = 1

	speech_bubble_appearance = "phoron"

	death_message = "falls over and stops moving!"
	knockout_message = "falls over!"

	has_organ = list(
		O_HEART =    /obj/item/organ/internal/heart,
		O_LUNGS =    /obj/item/organ/internal/lungs,
		O_VOICE = 	/obj/item/organ/internal/voicebox,
		O_LIVER =    /obj/item/organ/internal/liver,
		O_KIDNEYS =  /obj/item/organ/internal/kidneys,
		O_BRAIN =    /obj/item/organ/internal/brain,
		O_EYES =     /obj/item/organ/internal/eyes
		)

	cold_level_1 = 200 //Default 260 - Lower is better
	cold_level_2 = 180 //Default 200
	cold_level_3 = 120 //Default 120

	breath_cold_level_1 = 120		// so they can probably breathe outside?					.
	breath_cold_level_2 = 80
	breath_cold_level_3 = 60

	heat_level_1 = 360 //Default 360
	heat_level_2 = 500 //Default 400
	heat_level_3 = 800 //Default 1000

	body_temperature = T20C

/datum/species/plasmaman/handle_environment_special(var/mob/living/carbon/human/H)
	var/datum/gas_mixture/environment = H.loc.return_air()
	var/atmos_sealed = FALSE
	if (H.wear_suit && H.head && istype(H.wear_suit, /obj/item/clothing) && istype(H.head, /obj/item/clothing))
		var/obj/item/clothing/wear_suit = H.wear_suit
		var/obj/item/clothing/head = H.head
		if (head.item_flags & wear_suit.item_flags & STOPPRESSUREDAMAGE)
			atmos_sealed = TRUE
	if((!istype(H.wear_suit,/obj/item/clothing/suit/space/plasman) || !istype(H.head, /obj/item/clothing/head/helmet/space/plasman)) && !atmos_sealed)
		if(environment)
			if(environment.gas["oxygen"] > 1) //Same threshhold that extinguishes fire
				H.adjust_fire_stacks(0.5)
				if(!H.on_fire && H.fire_stacks > 0)
					H.visible_message("<span class='danger'>[H]'s body reacts with the atmosphere and bursts into flames!</span>","<span class='userdanger'>Your body reacts with the atmosphere and bursts into flame!</span>")
				H.IgniteMob()
	else
		if(H.fire_stacks)
			var/obj/item/clothing/suit/space/plasman/P = H.wear_suit
			if(istype(P))
				P.Extinguish(H)
		else
	H.update_fire()

/datum/species/plasmaman/equip_survival_gear(var/mob/living/carbon/human/H, var/extendedtank = 0,var/comprehensive = 0)
	. = ..()
	var/suit=/obj/item/clothing/suit/space/plasman
	var/helm=/obj/item/clothing/head/helmet/space/plasman

	H.equip_to_slot_or_del(new /obj/item/clothing/mask/breath(H), slot_wear_mask)

	switch(H.mind.assigned_role)
		if("Security Officer","Detective")
			suit=/obj/item/clothing/suit/space/plasman/sec
			helm=/obj/item/clothing/head/helmet/space/plasman/sec
		if("Warden")
			suit=/obj/item/clothing/suit/space/plasman/sec/warden
			helm=/obj/item/clothing/head/helmet/space/plasman/sec
		if("Head of Security")
			suit=/obj/item/clothing/suit/space/plasman/sec/hos
			helm=/obj/item/clothing/head/helmet/space/plasman/sec/hos
		if("Colony Director")
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
		if("Search and Rescue")
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
		if("Clown")
			suit=/obj/item/clothing/suit/space/plasman/clown
			helm=/obj/item/clothing/head/helmet/space/plasman/clown
		if("Mime")
			suit=/obj/item/clothing/suit/space/plasman/mime
			helm=/obj/item/clothing/head/helmet/space/plasman/mime
	H.equip_to_slot_or_del(new suit(H), slot_wear_suit)
	H.equip_to_slot_or_del(new helm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/extinguisher/mini/plasman(H), slot_r_hand)
	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/tank/vox(H), slot_back)
		H.internal = H.back
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/tank/vox(H), slot_s_store)
		H.internal = H.s_store
	H.internal = locate(/obj/item/weapon/tank) in H.contents
	if(istype(H.internal,/obj/item/weapon/tank) && H.internals)
		H.internals.icon_state = "internal1"
	spawn(2)
		if(H.head && !istype(H.head,/obj/item/clothing/head/helmet/space/plasman))
			qdel(H.head)
			H.equip_to_slot_or_del(new helm(H), slot_head)
			if(H.on_fire)
				H.ExtinguishMob()

		if(H.wear_suit && !istype(H.wear_suit,/obj/item/clothing/suit/space/plasman))
			qdel(H.wear_suit)
			H.equip_to_slot_or_del(new suit(H), slot_wear_suit)
			if(H.on_fire)
				H.ExtinguishMob()
			H.equip_to_slot_or_del(new /obj/item/weapon/tank/vox(H), slot_s_store)
			H.internal = H.s_store
			H.internals.icon_state = "internal1"