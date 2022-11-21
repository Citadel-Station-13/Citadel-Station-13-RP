/obj/belly/proc/process_tf(var/mode,var/list/touchable_mobs) //We pass mode so it's mega-ultra local.
	/* May not be necessary... Transform only shows up in the panel for humans.
	if(!ishuman(owner))
		return //Need DNA and junk for this.
	*/

	//Cast here for reduced duplication
	var/mob/living/carbon/human/O = owner

///////////////////////////// DM_EGG /////////////////////////////
	if(mode == DM_EGG)
		for (var/mob/living/carbon/human/P in touchable_mobs)
			if(P.absorbed || P.stat == DEAD)
				continue

			put_in_egg(P,1)

