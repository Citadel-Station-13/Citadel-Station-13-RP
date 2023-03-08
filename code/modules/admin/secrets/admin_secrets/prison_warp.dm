/datum/admin_secret_item/admin_secret/prison_warp
	name = "Prison Warp"

/datum/admin_secret_item/admin_secret/prison_warp/execute(var/mob/user)
	. = ..()
	if(!.)
		return
	for(var/mob/living/carbon/human/H in GLOB.mob_list)
		var/turf/T = get_turf(H)
		var/security = 0
		if((T && (T in GLOB.using_map.admin_levels)) || prisonwarped.Find(H))
		//don't warp them if they aren't ready or are already there
			continue
		H.Unconscious(5)
		if(H.wear_id)
			var/obj/item/card/id/id = H.get_idcard()
			for(var/A in id.access)
				if(A == ACCESS_SECURITY_EQUIPMENT)
					security++
		if(!security)
			//strip their stuff before they teleport into a cell :downs:
			H.drop_inventory(TRUE, TRUE, TRUE)
			//teleport person to cell
			H.forceMove(pick(prisonwarp))
			H.equip_to_slot_or_del(new /obj/item/clothing/under/color/prison(H), SLOT_ID_UNIFORM)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/orange(H), SLOT_ID_SHOES)
		else
			//teleport security person
			H.loc = pick(prisonsecuritywarp)
		prisonwarped += H
