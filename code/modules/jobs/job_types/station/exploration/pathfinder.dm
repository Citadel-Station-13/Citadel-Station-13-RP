/datum/job/station/pathfinder
	title = "Pathfinder"
	flag = PATHFINDER
	departments = list(DEPARTMENT_PLANET)
	departments_managed = list(DEPARTMENT_PLANET)
	sorting_order = 1 // above the other explorers
	department_flag = MEDSCI
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Facility Director"
	selection_color = "#d6d05c"
	idtype = /obj/item/card/id/explorer/head/pathfinder
	economic_modifier = 8
	minimal_player_age = 7
	pto_type = PTO_EXPLORATION

	access = list(access_eva, access_maint_tunnels, access_external_airlocks, access_pilot, access_explorer, access_research, access_gateway, access_pathfinder)
	minimal_access = list(access_eva, access_maint_tunnels, access_external_airlocks, access_pilot, access_explorer, access_research, access_gateway, access_pathfinder)
	outfit_type = /datum/outfit/job/station/pathfinder
	desc = "The Pathfinder's job is to lead and manage expeditions, and is the primary authority on all off-station expeditions."
	alt_titles = list(
		"Expedition Lead" = /datum/alt_title/expedition_lead,
		"Exploration Manager" = /datum/alt_title/exploration_manager,
		"Lead Pioneer" = /datum/alt_title/pathfinder/pioneer
		)

/datum/alt_title/expedition_lead
	title = "Expedition Lead"

/datum/alt_title/exploration_manager
	title = "Exploration Manager"

/datum/alt_title/pathfinder/pioneer
	title = "Lead Pioneer"

/datum/outfit/job/station/pathfinder
	name = OUTFIT_JOB_NAME("Pathfinder")
	shoes = /obj/item/clothing/shoes/boots/winter/explorer
	uniform = /obj/item/clothing/under/explorer //TODO: Uniforms.
	l_ear = /obj/item/radio/headset/pathfinder
	id_slot = SLOT_ID_WORN_ID
	pda_slot = SLOT_ID_LEFT_POCKET
	pda_type = /obj/item/pda/pathfinder
	id_type = /obj/item/card/id/explorer/head/pathfinder
	id_pda_assignment = "Pathfinder"

	backpack = /obj/item/storage/backpack/voyager
	backpack_contents = list(/obj/item/clothing/accessory/permit/gun/planetside = 1)
	satchel_one = /obj/item/storage/backpack/satchel/voyager
	dufflebag = /obj/item/storage/backpack/dufflebag/voyager

	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL|OUTFIT_COMPREHENSIVE_SURVIVAL

/datum/outfit/job/station/pathfinder/post_equip(mob/living/carbon/human/H)
	..()
	for(var/obj/item/clothing/accessory/permit/gun/planetside/permit in H.back.contents)
		permit.set_name(H.real_name)

/datum/outfit/job/station/assistant/explorer
	id_type = /obj/item/card/id/explorer
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_COMPREHENSIVE_SURVIVAL
