/// ais grab their eyeobj's perspective whenever possible
/mob/living/silicon/ai/get_perspective()
	RETURN_TYPE(/datum/perspective)
	return eyeobj?.get_perspective() || ..()

/mob/living/silicon/ai/perspective_shunted()
	return !(using_perspective == eyeobj?.self_perspective) && ..()
