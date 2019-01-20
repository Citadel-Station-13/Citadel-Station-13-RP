/obj/structure/bed/chair/wheelchair/buckle_mob(mob/living/M, forced = FALSE, check_loc = TRUE)
	if(issilicon(M)) // No abusing wheelchairs.
		return
	..()
