/mob/living
	var/list/internal_organs = list()
	var/list/organs = list()
	/// Map organ names to organs
	var/list/organs_by_name = list()
	/// So internal organs have less ickiness too
	var/list/internal_organs_by_name = list()
	/// Organs we check until they are good.
	var/list/bad_external_organs = list()

/mob/living/proc/get_bodypart_name(zone)
	var/obj/item/organ/external/E = get_organ(zone)
	if(E)
		. = E.name

/mob/living/proc/get_organ(zone)
	if(!zone)
		zone = BP_TORSO
	else if (zone in list( O_EYES, O_MOUTH ))
		zone = BP_HEAD
	return organs_by_name[zone]
