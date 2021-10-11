/datum/category_item/catalogue/fauna/yithian
	name = "Mystery - Yithian"
	desc = "The exact provenance of this creature remains unknown. \
	Although scientists have confirmed that this species is Sapient, and \
	that they possess great psionic potential, there have been as of yet \
	no known instances of formal communication with the 'Great Race' of \
	Yith."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/animal/passive/yithian
	name = "yithian"
	desc = "A friendly creature vaguely resembling an oversized snail without a shell."
	tt_desc = "J Escargot escargot" // a product of Jade, which is a planet that totally exists

	icon_state = "yithian"
	icon_living = "yithian"
	icon_dead = "yithian_dead"
	icon = 'icons/jungle.dmi'
	catalogue_data = list(/datum/category_item/catalogue/fauna/yithian)

	// Same stats as lizards.
	health = 5
	maxHealth = 5
	mob_size = MOB_MINISCULE
	randomized = TRUE

/datum/category_item/catalogue/fauna/tindalos
	name = "Mystery - Tindalos"
	desc = "There is much dispute regarding the origin of Tindalosi. \
	Commonly referred to as 'hounds', these creatures exhibit translocative \
	properties and seem to come from another dimension. As paracausal \
	creatures, containment often proves difficult. Researchers have recently \
	concluded that Tindalos hounds translate into our dimensional space via \
	acute angles."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/animal/passive/tindalos
	name = "tindalos"
	desc = "It looks like a large, flightless grasshopper."
	tt_desc = "J Locusta bruchus"

	icon_state = "tindalos"
	icon_living = "tindalos"
	icon_dead = "tindalos_dead"
	icon = 'icons/jungle.dmi'
	catalogue_data = list(/datum/category_item/catalogue/fauna/tindalos)

	// Same stats as lizards.
	health = 5
	maxHealth = 5
	mob_size = MOB_MINISCULE
