/datum/component/horror_aura/Initialize()
	if(ismob(parent))
		RegisterSignal(parent, .proc/aura_effect)

/datum/component/horror_aura/proc/aura_effect()
	var/atom/movable/AM = parent
	for(var/mob/living/carbon/human/H in view(7,src))
		if(!iscultist(H) && !istype(H.head, /obj/item/clothing/head/helmet/para))
			H.hallucination = max(10 SECONDS)
		AM.emp_act(3)
