/mob/living/carbon/human/proc/disable_hologram()
	set name = "Disable Hologram (Holosphere)"
	set desc = "Disable your hologram."
	set category = VERB_CATEGORY_IC

	var/datum/species/shapeshifter/holosphere/holosphere_species = species
	if(!istype(holosphere_species))
		return

	holosphere_species.try_transform()

/mob/living/carbon/human/proc/change_limb_icons()
	set name = "Change Limbs"
	set desc = "Change the appearance of individual limbs."
	set category = VERB_CATEGORY_IC

	var/datum/species/shapeshifter/holosphere/holosphere_species = species
	if(!istype(holosphere_species))
		return

	holosphere_species.change_limb_icons(src)

