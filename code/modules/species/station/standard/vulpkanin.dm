/datum/species/vulpkanin
	uid = SPECIES_ID_VULPKANIN
	id = SPECIES_ID_VULPKANIN
	name = SPECIES_VULPKANIN
	name_plural = SPECIES_VULPKANIN
	primitive_form = SPECIES_MONKEY_VULPKANIN
	default_bodytype = BODYTYPE_VULPKANIN

	icobase      = 'icons/mob/species/vulpkanin/body.dmi'
	deform       = 'icons/mob/species/vulpkanin/body.dmi' // They don't have a proper one for some reason...
	preview_icon = 'icons/mob/species/vulpkanin/preview.dmi'
	husk_icon    = 'icons/mob/species/vulpkanin/husk.dmi'

	sprite_accessory_defaults = list(
		SPRITE_ACCESSORY_SLOT_TAIL = /datum/sprite_accessory/tail/bodyset/vulpkanin,
	)

	max_additional_languages = 3
	name_language   = LANGUAGE_ID_VULPKANIN
	intrinsic_languages = LANGUAGE_ID_VULPKANIN

	vision_innate = /datum/vision/baseline/species_tier_1
	vision_organ = O_EYES

	color_mult = 1

	blurb = {"
	Vulpkanin are a species of sharp-witted canine-pideds residing on the planet Altam just barely within the
	dual-star Vazzend system. Their politically de-centralized society and independent natures have led them to become a species and
	culture both feared and respected for their scientific breakthroughs. Discovery, loyalty, and utilitarianism dominates their lifestyles
	to the degree it can cause conflict with more rigorous and strict authorities. They speak a guttural language known as 'Canilunzt'
	which has a heavy emphasis on utilizing tail positioning and ear twitches to communicate intent.
	"}

	// wikilink = ""
	catalogue_data = list(/datum/category_item/catalogue/fauna/vulpkanin)

	primitive_form = SPECIES_MONKEY_VULPKANIN

	species_spawn_flags = SPECIES_SPAWN_CHARACTER
	species_appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	flesh_color = "#966464"
	base_color  = "#B43214"

	max_age = 80

	unarmed_types = list(
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/kick,
		/datum/unarmed_attack/claws,
		/datum/unarmed_attack/bite/sharp,
	)

	inherent_verbs = list(
		/mob/living/proc/shred_limb,
		/mob/living/carbon/human/proc/tie_hair,
		/mob/living/carbon/human/proc/hide_horns,
		/mob/living/carbon/human/proc/hide_wings,
		/mob/living/carbon/human/proc/hide_tail,
	)


/datum/ability/species/vulp/dash
	name = "Dash"
	desc = "Dash forwards."
	action_state = "genetic_jump"
	cooldown = 10 SECONDS
	nutrition_cost = 10

/datum/ability/species/vulp/dash/on_trigger()
	. = ..()
	if(!isliving(user))
		return

	var/atom/target = get_edge_target_turf(user, user.dir) //gets the user's direction

	playsound(src, 'sound/effects/stealthoff.ogg', 50, 1, 1)
	user.visible_message(SPAN_WARNING("[user] dashes forward!"))
	user.throw_at_old(target, jumpdistance, jumpspeed)
	recharging_time = world.time + recharging_rate

/*
/obj/item/clothing/shoes/bhop/ui_action_click()
	var/mob/living/user = loc
	if(!isliving(user))
		return

	if(user.throwing)
		return // User is already being thrown

	if(recharging_time > world.time)
		to_chat(user, SPAN_WARNING("The boot's internal propulsion needs to recharge still!"))
		return

	var/atom/target = get_edge_target_turf(user, user.dir) //gets the user's direction

	playsound(src, 'sound/effects/stealthoff.ogg', 50, 1, 1)
	user.visible_message(SPAN_WARNING("[user] dashes forward into the air!"))
	user.throw_at_old(target, jumpdistance, jumpspeed)
	recharging_time = world.time + recharging_rate
*/
