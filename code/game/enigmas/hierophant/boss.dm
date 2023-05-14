/mob/living/simple_mob/boss/hierophant
	#warn name, desc
	#warn icon stuff

	/// our vortex magic holder
	var/datum/vortex_magic/vortex

/mob/living/simple_mob/boss/hierophant/Initialize(mapload)
	vortex = new /datum/vortex_magic/boss
	return ..()

#warn impl
