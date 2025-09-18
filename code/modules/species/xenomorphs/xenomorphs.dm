/proc/create_new_xenomorph(alien_caste, target)

	target = get_turf(target)
	if(!target || !alien_caste) return

	var/mob/living/carbon/human/new_alien = new(target)
	new_alien.set_species("Xenomorph [alien_caste]")
	return new_alien

/mob/living/carbon/human/xdrone
	species = /datum/species/xenomorph/drone
	h_style = "Bald"
	iff_factions = MOB_IFF_FACTION_XENOMORPH

/mob/living/carbon/human/xsentinel
	species = /datum/species/xenomorph/sentinel
	h_style = "Bald"
	iff_factions = MOB_IFF_FACTION_XENOMORPH

/mob/living/carbon/human/xhunter
	species = /datum/species/xenomorph/hunter
	h_style = "Bald"
	iff_factions = MOB_IFF_FACTION_XENOMORPH

/mob/living/carbon/human/xqueen
	species = /datum/species/xenomorph/queen
	h_style = "Bald"
	iff_factions = MOB_IFF_FACTION_XENOMORPH
