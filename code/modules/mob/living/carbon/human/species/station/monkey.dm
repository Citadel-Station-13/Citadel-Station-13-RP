/datum/species/monkey
	name = SPECIES_MONKEY
	name_plural = "Monkeys"
	blurb = "Ook."

	icobase = 'icons/mob/human_races/monkeys/r_monkey.dmi'
	deform = 'icons/mob/human_races/monkeys/r_monkey.dmi'
	damage_overlays = 'icons/mob/human_races/masks/dam_monkey.dmi'
	damage_mask = 'icons/mob/human_races/masks/dam_mask_monkey.dmi'
	blood_mask = 'icons/mob/human_races/masks/blood_monkey.dmi'
	language = null
	default_language = "Chimpanzee"
	greater_form = SPECIES_HUMAN
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

	spawn_flags = SPECIES_IS_RESTRICTED

	bump_flag = MONKEY
	swap_flags = MONKEY|SLIME|SIMPLE_ANIMAL
	push_flags = MONKEY|SLIME|SIMPLE_ANIMAL|ALIEN

	pass_flags = PASSTABLE

	has_limbs = list(
		BP_TORSO =  list("path" = /obj/item/organ/external/chest),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/no_eyes),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right)
		)

/datum/species/monkey/handle_npc(var/mob/living/carbon/human/H)
	if(H.stat != CONSCIOUS)
		return
	if(prob(33) && H.canmove && isturf(H.loc) && !H.pulledby) //won't move if being pulled
		step(H, pick(cardinal))
	if(prob(1))
		H.emote(pick("scratch","jump","roll","tail"))

	..()

/datum/species/monkey/get_random_name()
	return "[lowertext(name)] ([rand(100,999)])"

/datum/species/monkey/tajaran
	name = SPECIES_MONKEY_TAJ
	name_plural = "Farwa"

	icobase = 'icons/mob/human_races/monkeys/r_farwa.dmi'
	deform = 'icons/mob/human_races/monkeys/r_farwa.dmi'

	greater_form = SPECIES_TAJ
	default_language = "Farwa"
	flesh_color = "#AFA59E"
	base_color = "#333333"
	tail = "farwatail"

/datum/species/monkey/skrell
	name = SPECIES_MONKEY_SKRELL
	name_plural = "Neaera"

	icobase = 'icons/mob/human_races/monkeys/r_neaera.dmi'
	deform = 'icons/mob/human_races/monkeys/r_neaera.dmi'

	greater_form = SPECIES_SKRELL
	default_language = "Neaera"
	flesh_color = "#8CD7A3"
	blood_color = "#1D2CBF"
	reagent_tag = IS_SKRELL
	tail = null

/datum/species/monkey/unathi
	name = SPECIES_MONKEY_UNATHI
	name_plural = "Stok"

	icobase = 'icons/mob/human_races/monkeys/r_stok.dmi'
	deform = 'icons/mob/human_races/monkeys/r_stok.dmi'

	tail = "stoktail"
	greater_form = SPECIES_UNATHI
	default_language = "Stok"
	flesh_color = "#34AF10"
	base_color = "#066000"
	reagent_tag = IS_UNATHI

/datum/species/monkey/shark
	name = SPECIES_MONKEY_AKULA
	name_plural = "Sobaka"
	icobase = 'icons/mob/human_races/monkeys/r_sobaka_vr.dmi'
	deform = 'icons/mob/human_races/monkeys/r_sobaka_vr.dmi'
	tail = null //The tail is part of its body due to tail using the "icons/effects/species.dmi" file. It must be null, or they'll have a chimp tail.
	greater_form = "Akula"
	default_language = "Skrellian" //Closest we have.

/datum/species/monkey/sergal
	name = SPECIES_MONKEY_SERGAL
	greater_form = "Sergal"
	icobase = 'icons/mob/human_races/monkeys/r_sergaling_vr.dmi'
	deform = 'icons/mob/human_races/monkeys/r_sergaling_vr.dmi'
	tail = null
	default_language = LANGUAGE_SAGARU

/datum/species/monkey/sparra
	name = SPECIES_MONKEY_NEVREAN
	name_plural = "Sparra"
	greater_form = "Nevrean"
	tail = null
	icobase = 'icons/mob/human_races/monkeys/r_sparra_vr.dmi'
	deform = 'icons/mob/human_races/monkeys/r_sparra_vr.dmi'
	default_language = LANGUAGE_BIRDSONG


/* Example from Polaris code
/datum/species/monkey/tajaran
	name = "Farwa"
	name_plural = "Farwa"

	icobase = 'icons/mob/human_races/monkeys/r_farwa.dmi'
	deform = 'icons/mob/human_races/monkeys/r_farwa.dmi'

	greater_form = "Tajaran"
	default_language = "Farwa"
	flesh_color = "#AFA59E"
	base_color = "#333333"
	tail = "farwatail"
*/

/datum/species/monkey/vulpkanin
	name = SPECIES_MONKEY_VULPKANIN
	name_plural = "Wolpin"

	icobase = 'icons/mob/human_races/monkeys/r_wolpin.dmi'
	deform = 'icons/mob/human_races/monkeys/r_wolpin.dmi'

	greater_form = "Vulpkanin"
	default_language = LANGUAGE_CANILUNZT
	flesh_color = "#966464"
	base_color = "#000000"
	tail = null

//INSERT CODE HERE SO MONKEYS CAN BE SPAWNED.
//Also, M was added to the end of the spawn names to signify that it's a monkey, since some names were conflicting.

/mob/living/carbon/human/sharkm/New(var/new_loc)
	..(new_loc, "Sobaka")

/mob/living/carbon/human/sergallingm/New(var/new_loc)
	..(new_loc, "Saru")

/mob/living/carbon/human/sparram/New(var/new_loc)
	..(new_loc, "Sparra")

/mob/living/carbon/human/wolpin/New(var/new_loc)
	..(new_loc, "Wolpin")
