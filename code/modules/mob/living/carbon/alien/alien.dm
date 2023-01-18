/datum/category_item/catalogue/fauna/alien
	name = SPECIES_XENO
	desc = "Xenomorphs are a widely recognized and rightfully feared scourge \
	across the Frontier. Although the origin of these creatures remains unknown, \
	their violence and their teriffying method of procreation makes them a universally \
	hated organism. Kill on sight."
	value = CATALOGUER_REWARD_TRIVIAL
	unlocked_by_any = list(/datum/category_item/catalogue/fauna/alien)

// Obtained by scanning all Aliens.
/datum/category_item/catalogue/fauna/all_aliens
	name = "Collection - Xenomorphs"
	desc = "You have scanned a large array of different types of Xenomorph, \
	and therefore you have been granted a large sum of points, through this \
	entry."
	value = CATALOGUER_REWARD_HARD
	unlocked_by_all = list(
		/datum/category_item/catalogue/fauna/alien/larva,
		/datum/category_item/catalogue/fauna/alien/drone
		)

/datum/category_item/catalogue/fauna/alien/drone
	name = "Xenomorph - Drone"
	desc = "The adult form of the Xenomorph, the drone's iconic \
	morphology and biological traits make it easily identifiable across \
	the Frontier. Feared for its prowess, the Drone is a sign that an even \
	larger threat is present: a Xenomorph Hive. Kill on sight."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/carbon/alien

	name = "alien"
	desc = "What IS that?"
	icon = 'icons/mob/alien.dmi'
	icon_state = "alien"
	pass_flags = ATOM_PASS_TABLE
	health = 100
	maxHealth = 100
	mob_size = 4
	catalogue_data = list(/datum/category_item/catalogue/fauna/alien/drone)

	var/adult_form
	var/dead_icon
	var/amount_grown = 0
	var/max_grown = 200
	var/time_of_birth
	var/language
	var/death_msg = "lets out a waning guttural screech, green blood bubbling from its maw."
	var/can_namepick_as_adult = 0
	var/adult_name
	var/instance_num

/mob/living/carbon/alien/Initialize(mapload)
	time_of_birth = world.time

	add_verb(src, /mob/living/proc/ventcrawl)
	add_verb(src, /mob/living/proc/hide)

	instance_num = rand(1, 1000)
	name = "[initial(name)] ([instance_num])"
	real_name = name
	regenerate_icons()

	if(language)
		add_language(language)

	gender = NEUTER

	return ..()

/mob/living/carbon/alien/statpanel_data(client/C)
	. = ..()
	STATPANEL_DATA_LINE("")
	STATPANEL_DATA_LINE("Progress: [amount_grown]/[max_grown]")

/mob/living/carbon/alien/restrained()
	return 0

/mob/living/carbon/alien/request_strip_menu(mob/user, ignore_adjacency = FALSE, ignore_incapacitation = FALSE)
	return FALSE

/mob/living/carbon/alien/cannot_use_vents()
	return
