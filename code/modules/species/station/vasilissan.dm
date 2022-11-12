/datum/species/vasilissan //These actually look pretty damn spooky!
	name = SPECIES_VASILISSAN
	name_plural = "Vasilissans"
	uid = SPECIES_ID_VASILISSAN

	icobase = 'icons/mob/species/vasilissan/body.dmi'
	deform = 'icons/mob/species/vasilissan/deformed_body.dmi'
	preview_icon = 'icons/mob/species/vasilissan/preview.dmi'
	husk_icon = 'icons/mob/species/vasilissan/husk.dmi'
	tail = "tail" // Spider tail.
	icobase_tail = 1

	darksight = 8      // Can see completely in the dark. They are spiders, after all. Not that any of this matters because people will be using custom race.
	slowdown  = -0.15  // Small speedboost, as they've got a bunch of legs. Or something. I dunno.
	brute_mod = 0.8    // 20% brute damage reduction
	burn_mod  = 1.15   // 15% burn damage increase. They're spiders. Aerosol can+lighter = dead spiders.

	max_additional_languages = 2
	intrinsic_languages = LANGUAGE_ID_VASILISSAN

	is_weaver = TRUE
	silk_reserve = 500
	silk_max_reserve = 1000

	inherent_verbs = list(
		/mob/living/carbon/human/proc/check_silk_amount,
		/mob/living/carbon/human/proc/set_silk_color,
		/mob/living/carbon/human/proc/tie_hair,
		/mob/living/carbon/human/proc/toggle_silk_production,
		/mob/living/carbon/human/proc/weave_item,
		/mob/living/carbon/human/proc/weave_structure,
	)

	max_age = 80

	blurb = {"
	Vasilissans are a tall, lanky, spider like people.  Each having four eyes, an extra four, large legs sprouting from their back,
	and a chitinous plating on their body, and the ability to spit webs from their mandible lined mouths.  They are a recent discovery
	by Nanotrasen, only being discovered roughly seven years ago.  Before they were found they built great cities out of their silk,
	being united and subjugated in warring factions under great <b>Star Queens</b>, who forced the working class to build huge,
	towering cities to attempt to reach the stars, which they worship as gems of great spiritual and magical significance.
	"}
	wikilink = "N/A"
	catalogue_data = list(/datum/category_item/catalogue/fauna/vasilissan)

	hazard_low_pressure = 20 //Prevents them from dying normally in space. Special code handled below.
	cold_level_1 = -1 // All cold debuffs are handled below in handle_environment_special
	cold_level_2 = -1
	cold_level_3 = -1

	//primitive_form = SPECIES_MONKEY //I dunno. Replace this in the future.

	species_flags = NO_MINOR_CUT | CONTAMINATION_IMMUNE
	species_spawn_flags = SPECIES_SPAWN_ALLOWED
	species_appearance_flags = HAS_HAIR_COLOR | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	color_mult = 1
	flesh_color = "#AFA59E" //Gray-ish. Not sure if this is really needed, but eh.
	base_color 	= "#333333" //Blackish-gray
	blood_color = "#0952EF" //Spiders have blue blood.

	unarmed_types = list(
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/kick,
		/datum/unarmed_attack/claws,
		/datum/unarmed_attack/bite/sharp,
		/datum/unarmed_attack/bite/sharp/numbing,
	)

/datum/species/vasilissan/handle_environment_special(mob/living/carbon/human/H)
	if(H.stat == DEAD) // If they're dead they won't need anything.
		return

	if(H.bodytemperature <= 260) //If they're really cold, they go into stasis.
		var/coldshock = 0
		if(H.bodytemperature <= 260 && H.bodytemperature >= 200) //Chilly.
			coldshock = 4 //This will begin to knock them out until they run out of oxygen and suffocate or until someone finds them.
			H.eye_blurry = 5 //Blurry vision in the cold.
		if(H.bodytemperature <= 199 && H.bodytemperature >= 100) //Extremely cold. Even in somewhere like the server room it takes a while for bodytemp to drop this low.
			coldshock = 8
			H.eye_blurry = 5
		if(H.bodytemperature <= 99) //Insanely cold.
			coldshock = 16
			H.eye_blurry = 5
		H.shock_stage = min(H.shock_stage + coldshock, 160) //cold hurts and gives them pain messages, eventually weakening and paralysing, but doesn't damage.
		return
