/datum/physiology_modifier/intrinsic/species/teshari
	carry_strength_add = CARRY_STRENGTH_ADD_TESHARI
	carry_strength_factor = CARRY_FACTOR_MOD_TESHARI

/datum/species/teshari
	uid = SPECIES_ID_TESHARI
	id = SPECIES_ID_TESHARI
	name = SPECIES_TESHARI
	default_bodytype = BODYTYPE_TESHARI
	category = "Teshari"
	name_plural = "Tesharii"
	uid = SPECIES_ID_TESHARI
	mob_physiology_modifier = /datum/physiology_modifier/intrinsic/species/teshari

	blurb = {"
	A race of feathered raptors who developed alongside the Skrell, inhabiting
	the polar tundral regions outside of Skrell territory.  Extremely fragile, they developed
	hunting skills that emphasized taking out their prey without themselves getting hit.
	"}

	icobase           = 'icons/mob/species/teshari/body.dmi'
	deform            = 'icons/mob/species/teshari/deformed_body.dmi'
	preview_icon      = 'icons/mob/species/teshari/preview.dmi'
	damage_mask       = 'icons/mob/species/teshari/damage_mask.dmi'
	blood_mask        = 'icons/mob/species/teshari/blood_mask.dmi'
	damage_overlays   = 'icons/mob/species/teshari/damage_overlay.dmi'
	suit_storage_icon = 'icons/mob/clothing/species/teshari/belt_mirror.dmi'

	fire_icon_state = "generic" // Humanoid is too big for them and spriting a new one is really annoying.
	sprite_accessory_defaults = list(
		SPRITE_ACCESSORY_SLOT_TAIL = /datum/sprite_accessory/tail/bodyset/teshari,
	)

	max_additional_languages = 3
	name_language    = LANGUAGE_ID_TESHARI
	intrinsic_languages = LANGUAGE_ID_TESHARI
	whitelist_languages = list(
		LANGUAGE_ID_TESHARI,
		LANGUAGE_ID_SKRELL,
	)

	male_cough_sounds   = list('sound/effects/mob_effects/tesharicougha.ogg', 'sound/effects/mob_effects/tesharicoughb.ogg')
	female_cough_sounds = list('sound/effects/mob_effects/tesharicougha.ogg', 'sound/effects/mob_effects/tesharicoughb.ogg')
	male_sneeze_sound   = 'sound/effects/mob_effects/tesharisneeze.ogg'
	female_sneeze_sound = 'sound/effects/mob_effects/tesharisneeze.ogg'
	male_scream_sound   = 'sound/effects/mob_effects/teshariscream.ogg'
	female_scream_sound = 'sound/effects/mob_effects/teshariscream.ogg'

	max_age = 75
	health_hud_intensity = 3

	color_mult   = 1
	blood_color = "#D514F7"
	flesh_color = "#5F7BB0"
	base_color  = "#001144"

	reagent_tag = IS_TESHARI
	meat_type   = /obj/item/reagent_containers/food/snacks/meat/chicken/teshari
	move_trail = /obj/effect/debris/cleanable/blood/tracks/paw

	movement_base_speed = 6.66
	snow_movement     = -1
	item_slowdown_mod = 0.5

	total_health = 75
	brute_mod    = 1.1
	burn_mod     = 1.1

	mob_size     = MOB_SMALL
//	pass_flags   = ATOM_PASS_TABLE
	holder_type  = /obj/item/holder/human
//	short_sighted = 1
	gluttonous    = 1
	blood_volume  = 400
	hunger_factor = 0.2

	ambiguous_genders = TRUE

	species_spawn_flags	= SPECIES_SPAWN_CHARACTER
	species_appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	bump_flag  = MONKEY
	swap_flags = MONKEY|SLIME|SIMPLE_ANIMAL
	push_flags = MONKEY|SLIME|SIMPLE_ANIMAL|ALIEN

	cold_level_1 = 180
	cold_level_2 = 130
	cold_level_3 = 70

	breath_cold_level_1 = 180
	breath_cold_level_2 = 100
	breath_cold_level_3 = 60

	heat_level_1 = 330
	heat_level_2 = 370
	heat_level_3 = 600

	breath_heat_level_1 = 350
	breath_heat_level_2 = 400
	breath_heat_level_3 = 800

	heat_discomfort_level = 295
	heat_discomfort_strings = list(
		"Your feathers prickle in the heat.",
		"You feel uncomfortably warm.",
		"Your hands and feet feel hot as your body tries to regulate heat",
	)
	cold_discomfort_level = 180
	cold_discomfort_strings = list(
		"You feel a bit chilly.",
		"You fluff up your feathers against the cold.",
		"You move your arms closer to your body to shield yourself from the cold.",
		"You press your ears against your head to conserve heat",
		"You start to feel the cold on your skin",
	)

	minimum_breath_pressure = 12 // Smaller, so needs less air

	has_limbs = list(
		BP_TORSO  = list("path" = /obj/item/organ/external/chest),
		BP_GROIN  = list("path" = /obj/item/organ/external/groin),
		BP_HEAD   = list("path" = /obj/item/organ/external/head/teshari),
		BP_L_ARM  = list("path" = /obj/item/organ/external/arm),
		BP_R_ARM  = list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG  = list("path" = /obj/item/organ/external/leg),
		BP_R_LEG  = list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/teshari),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/teshari),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/teshari),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/teshari),
	)

	has_organ = list(
		O_HEART     = /obj/item/organ/internal/heart,
		O_LUNGS     = /obj/item/organ/internal/lungs,
		O_VOICE     = /obj/item/organ/internal/voicebox,
		O_LIVER     = /obj/item/organ/internal/liver,
		O_KIDNEYS   = /obj/item/organ/internal/kidneys,
		O_BRAIN     = /obj/item/organ/internal/brain,
		O_EYES      = /obj/item/organ/internal/eyes,
		O_STOMACH   = /obj/item/organ/internal/stomach,
		O_INTESTINE = /obj/item/organ/internal/intestine,
	)
	vision_organ = O_EYES

	unarmed_types = list(
		/datum/melee_attack/unarmed/bite/sharp,
		/datum/melee_attack/unarmed/claws,
		/datum/melee_attack/unarmed/stomp/weak,
	)

	inherent_verbs = list(
		/mob/living/carbon/human/proc/tie_hair,
		/mob/living/carbon/human/proc/hide_horns,
		/mob/living/carbon/human/proc/hide_wings,
		/mob/living/carbon/human/proc/hide_tail,
		/mob/living/proc/hide,
		/mob/living/proc/shred_limb,
	)

	abilities = list(
		/datum/ability/species/toggle_agility,
		/datum/ability/species/sonar,
	)
	descriptors = list(
		/datum/mob_descriptor/height = -3,
		/datum/mob_descriptor/build = -3,
	)

	var/static/list/flight_bodyparts = list(
		BP_L_ARM,
		BP_R_ARM,
		BP_L_HAND,
		BP_R_HAND,
	)
	var/static/list/flight_suit_blacklisted_types = list(
		/obj/item/clothing/suit/space,
		/obj/item/clothing/suit/straight_jacket,
	)

/datum/species/teshari/apply_racial_gear(mob/living/carbon/for_target, list/into_box, list/into_inv)
	var/footwear_type = /obj/item/clothing/shoes/sandal
	if(for_target && !for_target.inventory?.get_slot_single(/datum/inventory_slot/inventory/shoes))
		var/obj/item/footwear_instance = new footwear_type
		if(!for_target.inventory.equip_to_slot_if_possible(footwear_instance, /datum/inventory_slot/inventory/shoes))
			into_inv += footwear_instance
	else
		into_inv += footwear_type
	return ..()

/datum/species/teshari/handle_falling(mob/living/carbon/human/H, atom/hit_atom, damage_min, damage_max, silent, planetary)

	// Tesh can glide to save themselves from some falls. Basejumping bird
	// without parachute, or falling bird without free wings goes splat.

	// Are we landing from orbit, or handcuffed/unconscious/tied to something?
	if(planetary || !istype(H) || H.incapacitated())
		return ..()

	// Are we landing on a turf? Not sure how this could not be the case, but let's be safe.
	var/turf/landing = get_turf(hit_atom)
	if(!istype(landing))
		return ..()

	if(H.buckled)
		if(!silent)
			to_chat(H, SPAN_WARNING("You try to spread your wings to slow your fall, but \the [H.buckled] weighs you down!"))
		return ..()

	// Is there enough air to flap against?
	var/pressure = landing.return_pressure()
	if(pressure < (ONE_ATMOSPHERE * 0.75))
		if(!silent)
			to_chat(H, SPAN_WARNING("You spread your wings to slow your fall, but the air is too thin!"))
		return ..()

	// Are we wearing a space suit?
	if(H.wear_suit)
		for(var/blacklisted_type in flight_suit_blacklisted_types)
			if(istype(H.wear_suit, blacklisted_type))
				if(!silent)
					to_chat(H, SPAN_WARNING("You try to spread your wings to slow your fall, but \the [H.wear_suit] is in the way!"))
				return ..()

	// Do we have working wings?
	for(var/bp in flight_bodyparts)
		var/obj/item/organ/external/E = H.organs_by_name[bp]
		if(!istype(E) || !E.is_usable() || E.is_broken() || E.is_stump())
			if(!silent)
				to_chat(H, SPAN_WARNING("You try to spread your wings to slow your fall, but they won't hold your weight!"))
			return ..()

	// Handled!
	if(!silent)
		to_chat(H, SPAN_NOTICE("You catch the air in your wings and greatly slow your fall."))
		H.visible_message(SPAN_NOTICE("\The [H] glides down from above, landing safely."))
		H.afflict_stun(20 * 2)
		playsound(H, "rustle", 25, 1)
	return TRUE
