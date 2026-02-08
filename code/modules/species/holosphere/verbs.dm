/mob/living/carbon/human/proc/disable_hologram()
	set name = "Disable Hologram (Holosphere)"
	set desc = "Disable your hologram."
	set category = VERB_CATEGORY_IC

	var/datum/species/shapeshifter/holosphere/holosphere_species = species
	if(!istype(holosphere_species))
		return

	holosphere_species.try_transform(src)
