
/* I'm commenting out Geneticist so you can't actually see it in the job menu, given that you can't play as one - Jon.
//////////////////////////////////
//			Geneticist
//////////////////////////////////
/datum/job/station/geneticist
	title = "Geneticist"
	flag = GENETICIST
	departments = list(DEPARTMENT_MEDICAL, DEPARTMENT_RESEARCH)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	supervisors = "the Chief Medical Officer and Research Director"
	selection_color = "#013D3B"
	pto_type = PTO_MEDICAL
	idtype = /obj/item/card/id/medical/geneticist
	economic_modifier = 7
	access = list(access_medical, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics, access_research)
	minimal_access = list(access_medical, access_morgue, access_genetics, access_research)

	outfit_type = /datum/outfit/job/medical/geneticist
	job_description = "A Geneticist operates genetic manipulation equipment to repair any genetic defects encountered in crew, from cloning or radiation as examples. \
						When required, geneticists have the skills to clone, and are the superior choice when available for doing so."
*/

/datum/outfit/job/medical/geneticist
	name = OUTFIT_JOB_NAME("Geneticist")
	uniform = /obj/item/clothing/under/rank/geneticist
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/genetics
	backpack = /obj/item/storage/backpack/genetics
	r_pocket = /obj/item/flashlight/pen
	satchel_one = /obj/item/storage/backpack/satchel/gen
	id_type = /obj/item/card/id/medical/geneticist
	pda_type = /obj/item/pda/geneticist
	l_ear = /obj/item/radio/headset/headset_med
	shoes = /obj/item/clothing/shoes/white
	pda_slot = slot_l_store
	backpack = /obj/item/storage/backpack/medic
	satchel_one = /obj/item/storage/backpack/satchel/med
	messenger_bag = /obj/item/storage/backpack/messenger/med
