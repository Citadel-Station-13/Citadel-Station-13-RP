/obj/item/gun/projectile/ballistic/proc/legacy_emit_chambered_residue()
	if(chamber.leaves_residue)
		var/mob/living/carbon/human/H = loc
		if(istype(H))
			if(!istype(H.gloves, /obj/item/clothing))
				H.gunshot_residue = chamber.get_caliber_string()
			else
				var/obj/item/clothing/G = H.gloves
				G.gunshot_residue = chamber.get_caliber_string()
