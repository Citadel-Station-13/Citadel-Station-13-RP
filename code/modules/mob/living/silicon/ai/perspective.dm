/// ais grab their eyeobj's perspective whenever possible
/mob/living/silicon/ai/get_perspective()
	RETURN_TYPE(/datum/perspective)
	. = eyeobj?.get_perspective() || ..()
