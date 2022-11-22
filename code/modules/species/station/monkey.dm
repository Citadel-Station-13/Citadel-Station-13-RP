/datum/species/monkey
	name = SPECIES_MONKEY
	uid = SPECIES_ID_MONKEY
	name_plural = "Monkeys"
	greater_form = SPECIES_HUMAN

	blurb = "Ook."

	icobase         = 'icons/mob/species/monkey/body_monkey.dmi'
	deform          = 'icons/mob/species/monkey/body_monkey.dmi'
	damage_overlays = 'icons/mob/species/monkey/damage_overlay.dmi'
	damage_mask     = 'icons/mob/species/monkey/damage_mask.dmi'
	blood_mask      = 'icons/mob/species/monkey/blood_mask.dmi'

	default_language = LANGUAGE_ID_CHIMPANZEE
	intrinsic_languages = LANGUAGE_ID_CHIMPANZEE
	mob_size = MOB_SMALL
	has_fine_manipulation = 0
	show_ssd = null
	health_hud_intensity = 2

	gibbed_anim = "gibbed-m"
	dusted_anim = "dust-m"
	death_message = "lets out a faint chimper as it collapses and stops moving..."
	tail = "chimptail"
	fire_icon_state = "monkey"

	unarmed_types = list(/datum/unarmed_attack/bite, /datum/unarmed_attack/claws)
	inherent_verbs = list(/mob/living/proc/ventcrawl)
	hud_type = /datum/hud_data/monkey
	meat_type = /obj/item/reagent_containers/food/snacks/meat/monkey

	rarity_value = 0.1
	total_health = 75
	brute_mod = 1.5
	burn_mod = 1.5

	species_spawn_flags = SPECIES_SPAWN_SPECIAL

	bump_flag  = MONKEY
	swap_flags = MONKEY|SLIME|SIMPLE_ANIMAL
	push_flags = MONKEY|SLIME|SIMPLE_ANIMAL|ALIEN

	pass_flags = ATOM_PASS_TABLE

	has_limbs = list(
		BP_TORSO  = list("path" = /obj/item/organ/external/chest),
		BP_GROIN  = list("path" = /obj/item/organ/external/groin),
		BP_HEAD   = list("path" = /obj/item/organ/external/head/no_eyes),
		BP_L_ARM  = list("path" = /obj/item/organ/external/arm),
		BP_R_ARM  = list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG  = list("path" = /obj/item/organ/external/leg),
		BP_R_LEG  = list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right),
	)

/datum/species/monkey/handle_npc(mob/living/carbon/human/H)
	if(H.stat != CONSCIOUS)
		return
	if(prob(33) && H.canmove && isturf(H.loc) && !H.pulledby) //won't move if being pulled
		step(H, pick(GLOB.cardinal))
	if(prob(1))
		H.emote(pick("scratch","jump","roll","tail"))

	..()

/datum/species/monkey/get_random_name()
	return "[lowertext(name)] ([rand(100,999)])"

/datum/species/monkey/tajaran
	name = SPECIES_MONKEY_TAJ
	name_plural = SPECIES_MONKEY_TAJ
	uid = SPECIES_ID_FARWA

	icobase = 'icons/mob/species/monkey/body_farwa.dmi'
	deform  = 'icons/mob/species/monkey/body_farwa.dmi'

	greater_form = SPECIES_TAJ
	default_language = LANGUAGE_ID_FARWA
	intrinsic_languages = LANGUAGE_ID_FARWA
	flesh_color = "#AFA59E"
	base_color  = "#333333"
	tail = "farwatail"

/datum/species/monkey/skrell
	name = SPECIES_MONKEY_SKRELL
	name_plural = SPECIES_MONKEY_SKRELL
	uid = SPECIES_ID_NEAERA

	icobase = 'icons/mob/species/monkey/body_neaera.dmi'
	deform  = 'icons/mob/species/monkey/body_neaera.dmi'

	greater_form = SPECIES_SKRELL
	default_language = LANGUAGE_ID_NEAERA
	intrinsic_languages = LANGUAGE_ID_NEAERA
	flesh_color = "#8CD7A3"
	blood_color = "#1D2CBF"
	reagent_tag = IS_SKRELL
	tail = null

/datum/species/monkey/unathi
	name = SPECIES_MONKEY_UNATHI
	name_plural = SPECIES_MONKEY_UNATHI
	uid = SPECIES_ID_STOK

	icobase = 'icons/mob/species/monkey/body_stok.dmi'
	deform  = 'icons/mob/species/monkey/body_stok.dmi'

	tail = "stoktail"
	greater_form = SPECIES_UNATHI
	default_language = LANGUAGE_ID_STOK
	intrinsic_languages = LANGUAGE_ID_STOK
	flesh_color = "#34AF10"
	base_color  = "#066000"
	reagent_tag = IS_UNATHI

/datum/species/monkey/shark
	name = SPECIES_MONKEY_AKULA
	name_plural = SPECIES_MONKEY_AKULA
	uid = SPECIES_ID_SOBAKA

	icobase = 'icons/mob/species/monkey/body_sobaka.dmi'
	deform  = 'icons/mob/species/monkey/body_sobaka.dmi'
	tail = null //The tail is part of its body due to tail using the "icons/effects/species.dmi" file. It must be null, or they'll have a chimp tail.
	greater_form = SPECIES_AKULA
	default_language = LANGUAGE_ID_SKRELL //Closest we have.
	intrinsic_languages = LANGUAGE_ID_SKRELL

/datum/species/monkey/sergal
	name = SPECIES_MONKEY_SERGAL
	greater_form = SPECIES_SERGAL
	uid = SPECIES_ID_SERGLING

	icobase = 'icons/mob/species/monkey/body_sergaling.dmi'
	deform  = 'icons/mob/species/monkey/body_sergaling.dmi'
	tail = null
	default_language = LANGUAGE_ID_NARAMADI
	intrinsic_languages = LANGUAGE_ID_NARAMADI

/datum/species/monkey/sparra
	name = SPECIES_MONKEY_NEVREAN
	name_plural = SPECIES_MONKEY_NEVREAN
	uid = SPECIES_ID_SPARRA
	greater_form = SPECIES_NEVREAN
	icobase = 'icons/mob/species/monkey/body_sparra.dmi'
	deform  = 'icons/mob/species/monkey/body_sparra.dmi'
	tail = null
	default_language = LANGUAGE_ID_BIRDSONG
	intrinsic_languages = LANGUAGE_ID_BIRDSONG


/* Example
/datum/species/monkey/tajaran
	name = SPECIES_MONKEY_TAJ
	name_plural = SPECIES_MONKEY_TAJ

	icobase = 'icons/mob/species/monkeys/body_farwa.dmi'
	deform  = 'icons/mob/species/monkeys/body_farwa.dmi'

	greater_form = "Tajaran"
	default_language = LANGUAGE_FARWA
	flesh_color = "#AFA59E"
	base_color = "#333333"
	tail = "farwatail"
*/

/datum/species/monkey/vulpkanin
	name = SPECIES_MONKEY_VULPKANIN
	name_plural = SPECIES_MONKEY_VULPKANIN
	uid = SPECIES_ID_WOLPIN

	icobase = 'icons/mob/species/monkey/body_wolpin.dmi'
	deform = 'icons/mob/species/monkey/body_wolpin.dmi'

	greater_form = SPECIES_VULPKANIN
	default_language = LANGUAGE_ID_VULPKANIN
	intrinsic_languages = LANGUAGE_ID_VULPKANIN
	flesh_color = "#966464"
	base_color  = "#000000"
	tail = null

//INSERT CODE HERE SO MONKEYS CAN BE SPAWNED.
//Also, M was added to the end of the spawn names to signify that it's a monkey, since some names were conflicting.

/mob/living/carbon/human/sharkm/Initialize(mapload)
	..(mapload, SPECIES_MONKEY_AKULA)

/mob/living/carbon/human/sergallingm/Initialize(mapload)
	..(mapload, SPECIES_MONKEY_SERGAL)

/mob/living/carbon/human/sparram/Initialize(mapload)
	..(mapload, SPECIES_MONKEY_NEVREAN)

/mob/living/carbon/human/wolpin/Initialize(mapload)
	..(mapload, SPECIES_MONKEY_VULPKANIN)
