
/obj/item/organ/internal/diona
	name = "diona nymph"
	icon = 'icons/obj/objects.dmi'
	icon_state = "nymph"
	organ_tag = "special" // Turns into a nymph instantly, no transplanting possible.
	biology_type = BIOLOGY_TYPE_PLANT

/obj/item/organ/internal/diona/removed(var/mob/living/user, var/skip_nymph)
	if(robotic >= ORGAN_ROBOT)
		return ..()
	var/mob/living/carbon/human/H = owner
	..()
	if(!istype(H) || !H.organs || !H.organs.len)
		H.death()
	if(prob(50) && !skip_nymph && spawn_diona_nymph(get_turf(src)))
		qdel(src)

/obj/item/organ/internal/diona/process(delta_time)
	return

/obj/item/organ/internal/diona/strata
	name = "neural strata"
	parent_organ = BP_TORSO
	organ_tag = O_STRATA
	biology_type = BIOLOGY_TYPE_PLANT

/obj/item/organ/internal/diona/bladder
	name = "gas bladder"
	parent_organ = BP_HEAD
	organ_tag = O_GBLADDER
	biology_type = BIOLOGY_TYPE_PLANT

/obj/item/organ/internal/diona/polyp
	name = "polyp segment"
	parent_organ = BP_GROIN
	organ_tag = O_POLYP
	biology_type = BIOLOGY_TYPE_PLANT

/obj/item/organ/internal/diona/ligament
	name = "anchoring ligament"
	parent_organ = BP_GROIN
	organ_tag = O_ANCHOR
	biology_type = BIOLOGY_TYPE_PLANT

/obj/item/organ/internal/diona/node
	name = "receptor node"
	parent_organ = BP_HEAD
	organ_tag = O_RESPONSE
	biology_type = BIOLOGY_TYPE_PLANT

/obj/item/organ/internal/diona/nutrients
	name = O_NUTRIENT
	parent_organ = BP_TORSO
	organ_tag = O_NUTRIENT
	biology_type = BIOLOGY_TYPE_PLANT

// These are different to the standard diona organs as they have a purpose in other
// species (absorbing radiation and light respectively)
/obj/item/organ/internal/diona/nutrients
	name = O_NUTRIENT
	organ_tag = O_NUTRIENT
	icon = 'icons/mob/alien.dmi'
	icon_state = "claw"
	biology_type = BIOLOGY_TYPE_PLANT

/obj/item/organ/internal/diona/nutrients/removed(mob/user)
	return ..(user, 1)

/obj/item/organ/internal/diona/node
	name = "response node"
	parent_organ = BP_HEAD
	organ_tag = O_RESPONSE
	icon = 'icons/mob/alien.dmi'
	icon_state = "claw"
	biology_type = BIOLOGY_TYPE_PLANT

/obj/item/organ/internal/diona/node/removed()
	return

// A 'brain' for the tree, still becomes a mindless nymph when removed like any other. Satisfies the FBP code.
/obj/item/organ/internal/brain/cephalon
	name = "cephalon mass"
	parent_organ = BP_TORSO
	vital = TRUE
	biology_type = BIOLOGY_TYPE_PLANT

/obj/item/organ/internal/brain/cephalon/Initialize(mapload)
	. = ..()
	spawn(30 SECONDS) // FBP Dionaea need some way to be disassembled through surgery, if absolutely necessary.
		if(owner && !owner.synthetic)
			vital = FALSE

/obj/item/organ/internal/brain/cephalon/robotize()
	return

/obj/item/organ/internal/brain/cephalon/mechassist()
	return

/obj/item/organ/internal/brain/cephalon/digitize()
	return

/obj/item/organ/internal/brain/cephalon/removed(mob/living/user, skip_nymph)
	if(robotic >= ORGAN_ROBOT)
		return ..()
	var/mob/living/carbon/human/H = owner
	..()
	if(!istype(H) || !H.organs || !H.organs.len)
		H.death()
	if(prob(50) && !skip_nymph && spawn_diona_nymph(get_turf(src)))
		qdel(src)
