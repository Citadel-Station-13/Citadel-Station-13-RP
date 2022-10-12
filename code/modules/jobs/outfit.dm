/datum/outfit/job
	name = "Standard Gear"
	abstract_type = /datum/outfit/job

	uniform = /obj/item/clothing/under/color/grey
	l_ear = /obj/item/radio/headset
	shoes = /obj/item/clothing/shoes/black

	id_slot = SLOT_ID_WORN_ID
	id_type = /obj/item/card/id/civilian
	pda_slot = SLOT_ID_BELT
	pda_type = /obj/item/pda

	flags = OUTFIT_HAS_BACKPACK

/datum/outfit/job/equip_id(mob/living/carbon/human/H, rank, assignment)
	var/obj/item/card/id/C = ..()
	if(!C)
		return
	var/datum/job/J = job_master.GetJob(rank)
	if(J)
		C.access = J.get_access()
	if(H.mind)
		var/datum/mind/M = H.mind
		if(M.initial_account)
			var/datum/money_account/A = M.initial_account
			C.associated_account_number = A.account_number
	return C
