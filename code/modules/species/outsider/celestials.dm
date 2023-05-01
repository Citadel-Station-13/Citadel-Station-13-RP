//AURILS
/datum/species/auril
	name = SPECIES_AURIL
	name_plural = SPECIES_AURIL
	uid = SPECIES_ID_AURIL
	category = SPECIES_CATEGORY_DAEDAL

	blurb = {"
	The Auril are humanoids that resemble the angelic figures of Old Earth Christian myth.  The resemblance, however,
	is surface-level.  Auril are an alien species from the Daedal system, which is the only system in the galaxy inhabited to a
	major scale by the Auril.  They are perfectionists, conformists, and obedient to authority - in that order.  Their high-pressure
	society on Aura, their homeworld, leads to some abandoning this mindset entirely, however, which in turn causes them to
	seek out a new identity beyond their homeworld.
	"}
	catalogue_data = list(/datum/category_item/catalogue/fauna/auril)

	icobase = 'icons/mob/species/human/body_greyscale.dmi'
	deform  = 'icons/mob/species/human/deformed_body_greyscale.dmi'

	//intrinsic_languages = LANGUAGE_ID_DAEDAL_AURIL -- Handled by culture / backgrounds
	max_additional_languages = 3

	species_spawn_flags = SPECIES_SPAWN_CHARACTER
	species_appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR

	color_mult  = 1
	base_color  = "#EECEB3"
	blood_color = "#856A16"
	base_color  = "#DED2AD"


	//Angels glow in the dark.
	has_glowing_eyes = TRUE

	//Physical resistances and Weaknesses.
	flash_mod = 0.5
	radiation_mod = 1.25
	toxins_mod = 0.85
	burn_mod = 1.25
	flight_mod = 0.4

	unarmed_types = list(
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/kick,
		/datum/unarmed_attack/punch,
		/datum/unarmed_attack/bite,
	)

	inherent_verbs = list(
		/mob/living/carbon/human/proc/tie_hair,
		/mob/living/carbon/human/proc/lick_wounds,
		/mob/living/proc/glow_toggle,
		/mob/living/proc/glow_color)

	abilities = list(
		/datum/ability/species/toggle_flight/auril,
		/datum/ability/species/toggle_agility
	)

/datum/species/auril/praesidus
	name = SPECIES_AURIL_PRAE
	name_plural = SPECIES_AURIL_PRAE
	uid = SPECIES_ID_AURIL_PRAE
	blurb = {"
	The Auril Praesidus caste is the one found in most of their policing and military forces.
	Their genetic template specifically aimed at making each member of their caste with more muscle mass, larger wingspan, and general sturdiness.
	While most are born into the caste, often by design, there are procedures that allow various other caste members to transition into one, should they earn it.
	Despite their physical benefits, they suffer from increased susceptability to alcohol, among other poisons. They are more robust, able to withstand equipment burdens and have a general
	hardiness against physical damage. However, they have a faster metabolism in turn.
	"}
	item_slowdown_mod = 0.5 //less slowdown
	toxins_mod = 1.5
	total_health = 120
	hunger_factor = 0.1 //more hungry
	brute_mod = 0.75
	flight_mod = 0.2
	darksight = 5

	abilities = list(
		/datum/ability/species/toggle_flight/auril,
	)

/datum/species/auril/incanus
	name = SPECIES_AURIL_INCAN
	name_plural = SPECIES_AURIL_INCAN
	uid = SPECIES_ID_AURIL_INCAN
	blurb = {"
	The Auril Incanus caste is the one made of intellectuals, scholars, educators and doctors. They are the masters of the genetic proceses and often the caste responsible for the
	immaculate reputation of Aura-based products, especially genemods. As they prefer mind-over-matter, most of their genetic modifications lend them towards becoming far more mentally robust,
	at the expense of physical attributes. They are more frail, but have a slower metabolism.
	"}
	item_slowdown_mod = 1.2
	hunger_factor = 0.02 //Less hungry
	toxins_mod = 1.5
	total_health = 75
	brute_mod = 1.2
	slowdown = -0.2 //faster
	max_additional_languages = 5

	abilities = list(
		/datum/ability/species/toggle_flight
	)

/datum/species/dremachir
	uid = SPECIES_ID_DREMACHIR
	name = SPECIES_DREMACHIR
	name_plural = SPECIES_DREMACHIR
	category = SPECIES_CATEGORY_DAEDAL

	blurb = {"
	Dremachir are the divergent, over-mutated strain of Aurils that was left to fend for itself on the desert dunes of Drema.
	'Chir' meaning 'corrupted, wrong' in Auril tongue. This moniker has been adapted to one of spiteful pride by the population. Their planet has grown to become
	a bustling center of all sorts of competitive commerce, protected by the Auril fleets after a pyrrhic, guerilla war that left them a vassal state.
	They are extremely divergent amongst themselves, hailing from one of the several megalopoli dotting the surface of the planet, or from the
	dense networks underground, or even from many of the smaller settlements inhabited by bandits, religious groups and other delinquents in the eyes of Aurils.
	"}
	catalogue_data = list(/datum/category_item/catalogue/fauna/dremachir)

	icobase = 'icons/mob/species/human/body_greyscale.dmi'
	deform  = 'icons/mob/species/human/deformed_body_greyscale.dmi'

	intrinsic_languages = LANGUAGE_ID_DAEDAL_DREMACHIR
	max_additional_languages = 3

	species_spawn_flags = SPECIES_SPAWN_CHARACTER
	species_appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR

	color_mult  = 1
	base_color  = "#EECEB3"
	blood_color = "#27173D"
	base_color  = "#580412"


	//Demons glow in the dark.
	has_glowing_eyes = TRUE
	darksight = 7

	//Physical resistances and Weaknesses.
	flash_mod = 3.0
	brute_mod = 0.85

	unarmed_types = list(
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/kick,
		/datum/unarmed_attack/claws,
		/datum/unarmed_attack/bite/sharp,
	)

	inherent_verbs = list(
		/mob/living/carbon/human/proc/tie_hair,
		/mob/living/carbon/human/proc/succubus_drain,
		/mob/living/carbon/human/proc/succubus_drain_finalize,
		/mob/living/carbon/human/proc/succubus_drain_lethal,
	)
//Auril (and general flight) Abilities
/datum/ability/species/toggle_flight
	name = "Toggle Flight"
	desc = "Flying allows you to cross various hazards and pits safely, while being able to ascend, and descend. Equipment slows you down more while in-flight."
	cooldown = 3 SECONDS
	windup = 1 SECOND
	interact_type = ABILITY_INTERACT_TOGGLE
	action_state = "flight"
	always_bind = TRUE
	var/slowdown = 0.2

/datum/ability/species/toggle_flight/available_check()
	if(owner.nutrition < 25 && !owner.flying)	//too hungy
		return FALSE
	if(owner.nutrition > 1000 && !owner.flying)	//too fat
		return FALSE
	. = ..()

/datum/ability/species/toggle_flight/unavailable_reason()
	if(owner.nutrition < 25 && !owner.flying)	//too hungy
		return "You're too hungry to fly."
	if(owner.nutrition > 1000 && !owner.flying)	//too fat
		return "You're too fat too fly."
	. = ..()

/datum/ability/species/toggle_flight/on_enable()
	. = ..()
	owner.flying = TRUE
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.species.item_slowdown_mod += slowdown
	owner.update_floating()
	to_chat(owner, "<span class='notice'>You have started flying.</span>")

/datum/ability/species/toggle_flight/on_disable()
	. = ..()
	owner.flying = FALSE
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.species.item_slowdown_mod -= slowdown
	owner.update_floating()
	to_chat(owner, "<span class='notice'>You have stopped flying.</span>")

//Auril-specific flight (slightly better)
/datum/ability/species/toggle_flight/auril
	name = "Toggle Advanced Flight"
	action_state = "flight_enhanced"
	windup = 0
	slowdown = 0	//Aurils don't get any extra slowdown

//Generic Agility Ability
/datum/ability/species/toggle_agility
	name = "Toggle Agility"
	desc = "Allows the user to traverse over tables, trays and other solid climbable objects with ease."
	action_state = "agility"
	windup = 1 SECOND
	cooldown = 2 MINUTES
	always_bind = TRUE
	var/duration = 1 MINUTE
	var/active = FALSE

/datum/ability/species/toggle_agility/on_trigger()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	toggle(H)
	addtimer(CALLBACK(src, .proc/toggle,owner), duration, TIMER_UNIQUE)

/datum/ability/species/toggle_agility/proc/toggle(mob/living/carbon/human/H)
	if(!active)
		H.visible_message(
			SPAN_NOTICE("[owner] seems to gain a lithe, agile gait."),
			SPAN_NOTICE("You focus on your movement. You're able to walk over tables and similar easily.")
		)
		H.pass_flags |= ATOM_PASS_TABLE
		active = TRUE
	else
		H.visible_message(
			SPAN_NOTICE("[owner] seems to get tired, their legs quivering slightly."),
			SPAN_NOTICE("Your legs tire. Tables are an obstacle once more.")
		)
		H.pass_flags &= ~ATOM_PASS_TABLE
		active = FALSE

//CULTURE
/datum/lore/character_background/culture/species/auril
	name = "Auraborn Exile"
	id = "culture_auril_main"
	category = "Species -- Auril"
	innate_languages = list(
		/datum/language/angel,
	)
	desc = "Aurils who were born and grew up on the lush, tropical homeworld of Aura. They were taught the virtues and values of Aura -- diligence, responsibility, and to think ahead for the overall good of the species. In spite of this, the pressures of society, or other factors have led them to abandon the homeworld."

/datum/lore/character_background/culture/species/auril/prideborn
	name = "Prideborn Exile"
	id = "culture_auril_pride"
	innate_languages = list(
		/datum/language/angel,
		/datum/language/demon,
	)
	language_amount_mod = -1
	desc = "Aurils who were originating from the Auril Enclave on the Dremachir homeworld -- City of Pride, as named by humans. Its pearlescent, high altitude platform city shined like a beacon in the dusty plains of Drema, and both of the species intermingled amongst each other, leading to a far less homogenous ideals and beliefs."

/datum/lore/character_background/culture/species/auril/outsider
	name = "Outsider"
	id = "culture_auril_outsider"
	language_amount_mod = 1
	desc = "Aurils who were born or grew up outside of Daedal entirely. Their innate genetic disposition granted them easier ability to learn any given language while growing up. They may share any set of ideals or beliefs from their extraneous homeworld."
