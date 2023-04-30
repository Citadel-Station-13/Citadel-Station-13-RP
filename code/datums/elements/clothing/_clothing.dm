/datum/element/clothing

/datum/element/clothing/Attach(datum/target)
	. = ..()
	if(. & ELEMENT_INCOMPATIBLE)
		return
	if(!istype(target, /obj/item/clothing))
		return ELEMENT_INCOMPATIBLE
