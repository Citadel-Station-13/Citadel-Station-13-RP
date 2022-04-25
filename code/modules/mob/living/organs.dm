/mob/living
	var/list/internal_organs = list()
	var/list/organs = list()
	/// Map organ names to organs
	var/list/organs_by_name = list()
	/// So internal organs have less ickiness too
	var/list/internal_organs_by_name = list()
	/// Organs we check until they are good.
	var/list/bad_external_organs = list()

/mob/living/proc/get_bodypart_name(var/zone)
	var/obj/item/organ/external/E = get_organ(zone)
	if(E) . = E.name

/mob/living/proc/get_organ(var/zone)
	if(!zone)
		zone = BP_TORSO
	else if (zone in list( O_EYES, O_MOUTH ))
		zone = BP_HEAD
	return organs_by_name[zone]

/mob/living/gib()
	for(var/obj/item/organ/I in internal_organs)
		I.removed()
		if(isturf(I?.loc)) // Some organs qdel themselves or other things when removed
			I.throw_at(get_edge_target_turf(src,pick(GLOB.alldirs)),rand(1,3),30)

	for(var/obj/item/organ/external/E in src.organs)
		E.droplimb(0, DROPLIMB_EDGE, 1)

	..()
