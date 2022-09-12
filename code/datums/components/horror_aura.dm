/*
This component was designed to attach to Horrors, Abominations, and Cult mobs. It's meant to represent the Lovecraftian nature of such beasts by triggering hallucinations as reality around them unravels.
It also serves the purposes of portraying the Lore accurate effect of "Acausal Logic Engine Disruption" - ie; the supernatural elements disrupt electronics. Classic horror.
*/

/datum/component/horror_aura
	var/radius = 7
	var/emp_radius = 4

/datum/component/horror_aura/Initialize(var/atom/movable/AM, radius)
	src.radius = radius
	if(. & COMPONENT_INCOMPATIBLE)
		return
	else if(!istype(AM))
		return COMPONENT_INCOMPATIBLE
	else
		START_PROCESSING(SSobj, src)

/datum/component/horror_aura/process()
	aura_effect()

/datum/component/horror_aura/proc/aura_effect()
	var/atom/movable/AM = parent
	for(var/mob/living/carbon/human/H in view(radius))
		if(!iscultist(H) && !istype(H.head, /obj/item/clothing/head/helmet/para))
			H.hallucination = max(10 SECONDS)
		AM.emp_act(emp_radius)
