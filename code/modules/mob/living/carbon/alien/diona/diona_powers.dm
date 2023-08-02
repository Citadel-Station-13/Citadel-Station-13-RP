//Verbs after this point.
/mob/living/carbon/alien/diona/proc/diona_merge()

	set category = "Abilities"
	set name = "Merge with gestalt"
	set desc = "Merge with another diona."

	if(!CHECK_MOBILITY(src, MOBILITY_CAN_USE))
		return

	if(istype(src.loc,/mob/living/carbon))
		remove_verb(src, /mob/living/carbon/alien/diona/proc/diona_merge)
		return

	var/list/choices = list()
	for(var/mob/living/carbon/C in view(1,src))

		if(!(src.Adjacent(C)) || !(C.client)) continue

		if(istype(C,/mob/living/carbon/human))
			var/mob/living/carbon/human/D = C
			if(D.species && D.species.get_species_id() == SPECIES_ID_DIONA)
				choices += C

	var/mob/living/M = input(src,"Who do you wish to merge with?") in null|choices

	if(!M)
		to_chat(src, "There is nothing nearby to merge with.")
	else if(!do_merge(M))
		to_chat(src, "You fail to merge with \the [M]...")

/mob/living/carbon/alien/diona/proc/do_merge(var/mob/living/carbon/human/H)
	if(!istype(H) || !src || !(src.Adjacent(H)))
		return 0
	to_chat(H, "You feel your being twine with that of \the [src] as it merges with your biomass.")
	to_chat(src, "You feel your being twine with that of \the [H] as you merge with its biomass.")
	loc = H
	add_verb(src, /mob/living/carbon/alien/diona/proc/diona_split)
	remove_verb(src, /mob/living/carbon/alien/diona/proc/diona_merge)
	return 1

/mob/living/carbon/alien/diona/proc/diona_split()

	set category = "Abilities"
	set name = "Split from gestalt"
	set desc = "Split away from your gestalt as a lone nymph."

	if(!CHECK_MOBILITY(src, MOBILITY_CAN_USE))
		return

	if(!(istype(src.loc,/mob/living/carbon)))
		remove_verb(src, /mob/living/carbon/alien/diona/proc/diona_split)
		return

	to_chat(src.loc, "You feel a pang of loss as [src] splits away from your biomass.")
	to_chat(src, "You wiggle out of the depths of [src.loc]'s biomass and plop to the ground.")

	var/mob/living/M = src.loc

	src.loc = get_turf(src)
	remove_verb(src, /mob/living/carbon/alien/diona/proc/diona_split)
	add_verb(src, /mob/living/carbon/alien/diona/proc/diona_merge)

	if(istype(M))
		for(var/atom/A in M.contents)
			if(istype(A,/mob/living/simple_mob/animal/borer) || istype(A,/obj/item/holder))
				return
