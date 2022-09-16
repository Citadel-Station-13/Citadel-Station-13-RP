/*
This component was designed to attach to Horrors, Abominations, and Cult mobs. It's meant to represent the Lovecraftian nature of such beasts by triggering hallucinations as reality around them unravels.
It also serves the purposes of portraying the Lore accurate effect of "Acausal Logic Engine Disruption" - ie; the supernatural elements disrupt electronics. Classic horror.
*/

/datum/component/horror_aura
	var/radius = 5
	var/emp_radius = 3

/datum/component/horror_aura/Initialize(radius)
	if(radius)
		src.radius = radius
	if(. & COMPONENT_INCOMPATIBLE)
		return
	else if(!istype(parent))
		return COMPONENT_INCOMPATIBLE
	else
		START_PROCESSING(SSobj, src)

/datum/component/horror_aura/process()
	aura_effect()

/datum/component/horror_aura/proc/aura_effect()
	for(var/mob/living/carbon/human/H in range(radius, parent))
		if(!iscultist(H) && !istype(H.head, /obj/item/clothing/head/helmet/para))
			H.hallucination += 15
	var/turf/T = get_turf(parent)
	empulse(T, 0, 0, 0, emp_radius)

/datum/component/horror_aura/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/datum/component/horror_aura/weak
	radius = 2
	emp_radius = 2

/datum/component/horror_aura/strong
	radius = 7
	emp_radius = 4
