/**
 * Species Datums
 *
 * They are **not** singletons, however, they are globally cached as a static set
 * for use in preferences to determine default properties/whatever
 *
 * ? Someday we'll rework this. Someday. I believe.
 *
 * Mob set_species supports either a datum or a typepath. Mobs, upon receiving a typepath, will make their own copy for modification.
 *
 * Mob species var should **never** be the global copy.
 *
 * Unfortunately, until we decide how we want to refactor species and humans proper,
 * we're stuck doing the following:
 * - Species procs will all be static with the template of (H, ...) where H is the human it's ticking on
 * - **New species are allowed to have instance variables, like proteans using this for storage**, since species are no longer actually static cached copies
 * - **New species are allowed to use these instance variables.** TODO: unified tgui for species ability control, ability datums/actions
 * - A global cache of species by typepath will still be maintained for "static" usages of these datums, like for preferences rendering.
 */
/datum/species
	/// Abstract type.
	abstract_type = /datum/species

	//! Intrinsics
	/// uid - **must be unique**
	var/uid
	/// if we're a subspecies, real id
	var/id
	// TODO: ref species by id in code, so we can rename as needed

	//! Appearance
	/// Appearance/display related features.
	var/species_appearance_flags = NONE

	//! Spawning
	/// Flags that specify who can spawn as this species
	var/species_spawn_flags = NONE

	//! Culture/Background - Typepaths
	/// default origin
	var/default_origin = /datum/lore/character_background/origin/custom
	/// default citizenship
	var/default_citizenship = /datum/lore/character_background/citizenship/custom
	/// default faction
	var/default_faction = /datum/lore/character_background/faction/nanotrasen
	/// default religion
	var/default_religion = /datum/lore/character_background/religion/custom
	/// fluff flags
	var/species_fluff_flags = NONE

	//! Language - IDs
	/// default language used when speaking
	var/default_language = LANGUAGE_ID_COMMON
	/// do we have galactic common? this is so common we just have this as a var
	var/galactic_language = TRUE
	/// intrinsic species languages - list() or singular language or null
	// todo: linter check for language default being in here
	var/list/intrinsic_languages
	/// language our name is in - used for namegen; null to force stock ss13 namegen instead
	// todo: language for namegen is questionaable
	var/name_language = LANGUAGE_ID_COMMON
	/// languages we are always allowed to learn (overridden by intrinsic languages) even if restricted - list() or singular language
	var/list/whitelist_languages
	/// additional languages we can learn (ONTOP OF INTRINSIC AND CULTURE)
	var/max_additional_languages = 3

//! ## Languages (old)
	/// The languages the species can't speak without an assisted organ.
	/// This list is a guess at things that no one other than the parent species should be able to speak
	var/list/assisted_langs = list(LANGUAGE_EAL, LANGUAGE_SKRELLIAN, LANGUAGE_SKRELLIANFAR, LANGUAGE_ROOTLOCAL, LANGUAGE_ROOTGLOBAL, LANGUAGE_VOX)

//! ## Descriptors and strings.
	/// Species real name.
	// TODO: STOP USING THIS. This is being phased out for species IDs.
	var/name
	/// Category in character setup
	var/category = "Miscellaneous"
	/// what you see on tooltip/examine
	var/examine_name
	/// what you see on health analyzers/IC
	var/display_name
	/// Pluralized name (since "[name]s" is not always valid)
	var/name_plural
	/// A brief lore summary for use in the chargen screen.
	var/blurb = "A completely nondescript species."
	/// A list of /datum/category_item/catalogue datums, for the cataloguer, or null.
	var/list/catalogue_data = null

//! ## Icon/appearance vars.
	/// Normal icon set.
	var/icobase      = 'icons/mob/species/human/body.dmi'
	/// Mutated icon set.
	var/deform       = 'icons/mob/species/human/deformed_body.dmi'
	/// Preview icon used in species selection.
	var/preview_icon = 'icons/mob/species/human/preview.dmi'
	/// Species-specific husk sprite if applicable.
	var/husk_icon    = 'icons/mob/species/default_husk.dmi'
	// var/bandages_icon

	/// Part of icon_state to use for speech bubbles when talking.	See talk.dmi for available icons.
	var/speech_bubble_appearance = "normal"
	/// The icon_state used inside OnFire.dmi for when on fire.
	var/fire_icon_state = "humanoid"
	/// Icons used for worn items in suit storage slot.
	var/suit_storage_icon = 'icons/mob/clothing/belt_mirror.dmi'
	/// override for bodytype
	var/override_worn_legacy_bodytype

	/// default bodytype to use for clothing rendering
	var/default_bodytype = BODYTYPE_DEFAULT

//! ## Damage overlay and masks.
	var/damage_overlays = 'icons/mob/species/human/damage_overlay.dmi'
	var/damage_mask     = 'icons/mob/species/human/damage_mask.dmi'
	var/blood_mask      = 'icons/mob/species/human/blood_mask.dmi'

	/// If set, draws this from icobase when mob is prone.
	var/prone_icon
	/// The color of the species blood.
	var/blood_color = "#A10808"
	/// The color of the species flesh.
	var/flesh_color = "#FFC896"
	/// Used by changelings. Should also be used for icon previews.
	var/base_color
	/// Species specific internal organs icons.
	var/organs_icon

	/// Name of tail state in species effects icon file.
	var/tail
	/// If set, the icon to obtain tail animation states from.
	var/tail_animation
	var/tail_hair

	/// Used for mob icon generation for non-32x32 species.
	var/icon_template = 'icons/mob/species/template.dmi'
	/// Makes the icon wider/thinner.
	var/icon_scale_x = 1
	/// Makes the icon taller/shorter.
	var/icon_scale_y = 1
	/// Used for offsetting large icons.
	var/pixel_offset_x = 0
	/// Used for offsetting large icons.
	var/pixel_offset_y = 0
	/// Used for offsetting large icons.
	var/pixel_offset_z = 0
	/// As above, but specifically for the antagHUD indicator.
	// var/antaghud_offset_x = 0
	/// As above, but specifically for the antagHUD indicator.
	// var/antaghud_offset_y = 0

	var/mob_size = MOB_MEDIUM
	var/show_ssd = "fast asleep"
	var/virus_immune
	/// Permanent weldervision.
	var/short_sighted
	/// Name for the species' blood.
	var/blood_name = "blood"
	/// Initial blood volume.
	/// TODO: Put this on living so this is moreso an override. @Zandario
	var/blood_volume = 560
	/// Multiplier for how fast a species bleeds out. Higher = Faster
	var/bloodloss_rate = 1
	/// "Safe" blood level; above this, you're OK.
	var/blood_level_safe = 0.85
	/// "Warning" blood level; above this, you're a bit woozy and will have low-level oxydamage. (no more than 20, or 15 with inap)
	var/blood_level_warning = 0.75
	/// "Danger" blood level; above this, you'll rapidly take up to 50 oxyloss, and it will then steadily accumulate at a lower rate.
	var/blood_level_danger = 0.6
	/// "Fatal" blood level; below this, you take extremely high oxydamage.
	var/blood_level_fatal = 0.4
	/// Multiplier for hunger.
	var/hunger_factor = 0.05
	/// Multiplier for thirst.
	var/thirst_factor = DEFAULT_THIRST_FACTOR
	/// Multiplier for 'Regenerate' power speed, in human_powers.dm
	var/active_regen_mult = 1
	/// How sensitive the species is to minute tastes.
	var/taste_sensitivity = TASTE_NORMAL

	/// The minimum age a species is allowed to be played as. For our purposes, this is global.
	var/min_age = 18
	/// The maximum age a species is allowed to be played as. This is generally determined by lifespan.
	var/max_age = 70

//! ## Speech Sounds
	/// A list of sounds to potentially play when speaking.
	var/list/speech_sounds = list()
	/// The likelihood of a speech sound playing.
	var/list/speech_chance = list()

//! ## Soundy emotey things.
	var/scream_verb = "screams"
	var/male_scream_sound   = list('sound/voice/screams/sound_voice_scream_scream_m1.ogg', 'sound/voice/screams/sound_voice_scream_scream_m2.ogg')
	var/female_scream_sound = list('sound/voice/screams/sound_voice_scream_scream_f1.ogg', 'sound/voice/screams/sound_voice_scream_scream_f2.ogg', 'sound/voice/screams/sound_voice_scream_scream_f3.ogg')
	var/male_cough_sounds   = list('sound/effects/mob_effects/m_cougha.ogg','sound/effects/mob_effects/m_coughb.ogg', 'sound/effects/mob_effects/m_coughc.ogg')
	var/female_cough_sounds = list('sound/effects/mob_effects/f_cougha.ogg','sound/effects/mob_effects/f_coughb.ogg')
	var/male_sneeze_sound   = 'sound/effects/mob_effects/sneeze.ogg'
	var/female_sneeze_sound = 'sound/effects/mob_effects/f_sneeze.ogg'

//! ## Combat vars.
	/// Point at which the mob will enter crit.
	var/total_health = 100
	/// Possible unarmed attacks that the mob will use in combat,
	var/list/unarmed_types = list(
		/datum/unarmed_attack,
		/datum/unarmed_attack/bite
	)
	/// For empty hand harm-intent attack
	var/list/unarmed_attacks = null
	/// Physical damage multiplier.
	var/brute_mod = 1
	/// Burn damage multiplier.
	var/burn_mod = 1
	/// Oxyloss modifier
	var/oxy_mod = 1
	/// Toxloss modifier
	var/toxins_mod = 1
	/// Radiation modifier
	var/radiation_mod = 1
	/// Stun from blindness modifier.
	var/flash_mod = 1
	/// how much damage to take from being flashed if light hypersensitive
	var/flash_burn = 0
	/// Stun from sounds, I.E. flashbangs.
	var/sound_mod = 1
	/// Damage modifier for overdose
	var/chemOD_mod = 1
	/// Same flags as glasses.
	var/vision_flags = SIGHT_FLAGS_DEFAULT

//! ## Death vars.
	var/meat_type = /obj/item/reagent_containers/food/snacks/meat/human
	var/bone_type = /obj/item/stack/material/bone
	var/hide_type = /obj/item/stack/animalhide/human
	var/exotic_type = /obj/item/stack/sinew
	var/remains_type = /obj/effect/decal/remains/xeno
	var/gibbed_anim = "gibbed-h"
	var/dusted_anim = "dust-h"
	var/death_sound
	var/death_message = "seizes up and falls limp, their eyes dead and lifeless..."
	var/knockout_message = "has been knocked unconscious!"
	var/cloning_modifier = /datum/modifier/cloning_sickness

	// Environment tolerance/life processes vars.
	///Used for metabolizing reagents.
	var/reagent_tag
	/// Non-oxygen gas breathed, if any.
	var/breath_type = /datum/gas/oxygen
	/// Poisonous air.
	var/poison_type = /datum/gas/phoron
	/// Exhaled gas type.
	var/exhale_type = /datum/gas/carbon_dioxide

	/// Species will try to stabilize at this temperature. (also affects temperature processing)
	var/body_temperature = 310.15

//! ## Cold
	/// Cold damage level 1 below this point.
	var/cold_level_1 = 260
	/// Cold damage level 2 below this point.
	var/cold_level_2 = 200
	/// Cold damage level 3 below this point.
	var/cold_level_3 = 120

	/// Cold gas damage level 1 below this point.
	var/breath_cold_level_1 = 240
	/// Cold gas damage level 2 below this point.
	var/breath_cold_level_2 = 180
	/// Cold gas damage level 3 below this point.
	var/breath_cold_level_3 = 100

	/// Aesthetic messages about feeling chilly.
	var/cold_discomfort_level = 285
	var/list/cold_discomfort_strings = list(
		"You feel chilly.",
		"You shiver suddenly.",
		"Your chilly flesh stands out in goosebumps."
	)

//! ## Hot
	/// Heat damage level 1 above this point.
	var/heat_level_1 = 360
	/// Heat damage level 2 above this point.
	var/heat_level_2 = 400
	/// Heat damage level 3 above this point.
	var/heat_level_3 = 1000

	/// Heat gas damage level 1 below this point.
	var/breath_heat_level_1 = 380
	/// Heat gas damage level 2 below this point.
	var/breath_heat_level_2 = 450
	/// Heat gas damage level 3 below this point.
	var/breath_heat_level_3 = 1250

	/// Aesthetic messages about feeling warm.
	var/heat_discomfort_level = 315
	var/list/heat_discomfort_strings = list(
		"You feel sweat drip down your neck.",
		"You feel uncomfortably warm.",
		"Your skin prickles in the heat."
	)


	/// Species will gain this much temperature every second
	var/passive_temp_gain = 0
	/// Dangerously high pressure.
	var/hazard_high_pressure = HAZARD_HIGH_PRESSURE
	/// High pressure warning.
	var/warning_high_pressure = WARNING_HIGH_PRESSURE
	/// Low pressure warning.
	var/warning_low_pressure = WARNING_LOW_PRESSURE
	/// Dangerously low pressure.
	var/hazard_low_pressure = HAZARD_LOW_PRESSURE
	var/safe_pressure = ONE_ATMOSPHERE
	/// If set, mob will be damaged in light over this value and heal in light below its negative.
	var/light_dam
	/// Minimum required pressure for breath, in kPa
	var/minimum_breath_pressure = 16

	/// Used to shift equipment around based on which species you are.
	var/list/equip_adjust = list()
	var/list/equip_overlays = list()

	var/metabolic_rate = 1

//! ## HUD data vars.
	var/datum/hud_data/hud
	var/hud_type
	/// This modifies how intensely the health hud is colored.
	var/health_hud_intensity = 1

//! ## Body/form vars.
	/// Species-specific verbs.
	var/list/inherent_verbs = list()
	/// Species-specific spells.
	var/list/inherent_spells = list()
	/// Can use small items.
	var/has_fine_manipulation = TRUE
	/// The lower, the thicker the skin and better the insulation.
	var/siemens_coefficient = 1
	/// Native darksight distance.
	var/darksight = 2

//! ## Flags
	/// Various specific features.
	var/species_flags = NONE
	/// What marks are left when walking
	var/obj/effect/debris/cleanable/blood/tracks/move_trail = /obj/effect/debris/cleanable/blood/tracks/footprints
	var/list/skin_overlays = list()
	/// Whether the eyes can be shown above other icons
	var/has_floating_eyes = FALSE
	/// Whether the eyes are shown above all lighting
	var/has_glowing_eyes = FALSE

	/// Passive movement speed malus (or boost, if negative)
	var/slowdown = 0
	/// How much faster or slower the species is in water
	var/water_movement = 0
	/// How much faster or slower the species is on snow
	var/snow_movement = 0
	/// Whether the species can infect wounds, only works with claws / bites
	var/infect_wounds = 0

	/// How affected by item slowdown the species is.
	var/item_slowdown_mod = 1
	/// Lesser form, if any (ie. monkey for humans)
	var/primitive_form
	/// Greater form, if any, ie. human for monkeys.
	var/greater_form
	/// This allows you to pick up crew
	var/holder_type = /obj/item/holder/micro
	/// Can eat some mobs. 1 for mice, 2 for monkeys, 3 for people.
	var/gluttonous

	/// Relative rarity/collector value for this species.
	var/rarity_value = 1
	/// How much money this species makes
	var/economic_modifier = 2

	/// Determines the organs that the species spawns with and which required-organ checks are conducted.
	var/list/has_organ = list(
		O_HEART     = /obj/item/organ/internal/heart,
		O_LUNGS     = /obj/item/organ/internal/lungs,
		O_VOICE     = /obj/item/organ/internal/voicebox,
		O_LIVER     = /obj/item/organ/internal/liver,
		O_KIDNEYS   = /obj/item/organ/internal/kidneys,
		O_BRAIN     = /obj/item/organ/internal/brain,
		O_APPENDIX  = /obj/item/organ/internal/appendix,
		O_EYES      = /obj/item/organ/internal/eyes,
		O_STOMACH   = /obj/item/organ/internal/stomach,
		O_INTESTINE = /obj/item/organ/internal/intestine,
	)

	/// If set, this organ is required for vision. Defaults to "eyes" if the species has them.
	var/vision_organ
	/// If set, the species will be affected by flashbangs regardless if they have eyes or not, as they see in large areas.
	var/dispersed_eyes

	var/list/has_limbs = list(
		BP_TORSO  = list("path" = /obj/item/organ/external/chest),
		BP_GROIN  = list("path" = /obj/item/organ/external/groin),
		BP_HEAD   = list("path" = /obj/item/organ/external/head),
		BP_L_ARM  = list("path" = /obj/item/organ/external/arm),
		BP_R_ARM  = list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG  = list("path" = /obj/item/organ/external/leg),
		BP_R_LEG  = list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right)
	)

	/// Used for species that only need to change one or two entries in has_limbs.
	//var/list/override_limb_types //Not used yet.

	/// The basic skin colours this species uses.
	var/list/base_skin_colours
	var/list/genders = list(MALE, FEMALE)
	/// If true, people examining a member of this species whom are not also the same species will see them as gender neutral.	Because aliens.
	var/ambiguous_genders = FALSE

	/// Organ tag where they are located if they can be kicked for increased pain.
	var/sexybits_location = BP_GROIN // Come on... You know it's there for most of them.

//! ## Bump vars
	/// What are we considered to be when bumped?
	var/bump_flag = HUMAN
	/// What can we push?
	var/push_flags = ~HEAVY
	/// What can we swap place with?
	var/swap_flags = ~HEAVY

	var/pass_flags = 0

//! ## Misc vars
	/// descriptors
	var/list/descriptors = list()
	/// traits
	var/list/traits = list()

	/// This is used in character setup preview generation (prefences_setup.dm) and human mob rendering (update_icons.dm)
	var/color_mult = 0
	/// force non greyscale icons to greyscale before multiplying? WARNING :CITADEL JANK, REPLACE ASAP
	var/color_force_greyscale = FALSE

	/// This is for overriding tail rendering with a specific icon in icobase, for static tails only, since tails would wag when dead if you used this.
	var/icobase_tail = 0

	var/wing_hair
	var/wing
	var/wing_animation
	var/icobase_wing
	var/wikilink = null //link to wiki page for species

	//!Weaver abilities
	var/is_weaver = FALSE
	var/silk_production = FALSE
	var/silk_reserve = 100
	var/silk_max_reserve = 500
	var/silk_color = "#FFFFFF"

	/// max nutrition - i hate myself for haphazardly throwing this in but sue me
	var/max_nutrition = 450

	//Moved these from custom_species.dm
	//var/vore_numbing = 0
	var/is_vampire = FALSE // If this is set to true, the person can't get nutrition from food.
	var/is_cyberpsycho = FALSE // If you turn this to true, the person's capacity stat decreases. (aka - Their symptoms worsen)
	var/metabolism = 0.0015
	var/lightweight = FALSE //Oof! Nonhelpful bump stumbles.
	var/trashcan = FALSE //It's always sunny in the wrestling ring.
	var/base_species = null // Unused outside of a few species
	var/selects_bodytype = FALSE // Allows the species to choose from body types intead of being forced to be just one.

/datum/species/New()
	if(hud_type)
		hud = new hud_type()
	else
		hud = new()

	// Prep the descriptors for the species
	if(LAZYLEN(descriptors))
		var/list/descriptor_datums = list()
		for(var/desctype in descriptors)
			var/datum/mob_descriptor/descriptor = new desctype
			descriptor.comparison_offset = descriptors[desctype]
			descriptor_datums[descriptor.name] = descriptor
		descriptors = descriptor_datums

	//If the species has eyes, they are the default vision organ
	if(!vision_organ && has_organ[O_EYES])
		vision_organ = O_EYES

	unarmed_attacks = list()
	for(var/u_type in unarmed_types)
		unarmed_attacks += new u_type()

	if(gluttonous)
		if(!inherent_verbs)
			inherent_verbs = list()
		inherent_verbs |= /mob/living/carbon/human/proc/regurgitate

/**
 * called when we apply to a mob
 *
 * **this does not create organs**
 *
 * handle_post_spawn() and create_organs() should be called manually if you are applying a species to a human being instantiated!
 */
/datum/species/proc/on_apply(mob/living/carbon/human/H)
	// todo: language sources and holder
	for(var/id in get_intrinsic_language_ids())
		H.add_language(id)
	if(galactic_language)
		H.add_language(LANGUAGE_ID_COMMON)

	if(holder_type)
		H.holder_type = holder_type

	if(!(H.gender in genders))
		H.gender = genders[1]

	H.maxHealth = total_health

	add_inherent_verbs(H)
	add_inherent_spells(H)

	for(var/name in traits)
		var/datum/trait/T = all_traits[name]
		T.apply(src, H)

/**
 * called when we are removed from a mob
 */
/datum/species/proc/on_remove(mob/living/carbon/human/H)
	// todo: language sources and holder
	for(var/id in get_intrinsic_language_ids())
		H.remove_language(id)
	if(galactic_language)
		H.remove_language(LANGUAGE_ID_COMMON)

	remove_inherent_spells(H)
	remove_inherent_verbs(H)
	H.holder_type = null

	for(var/name in traits)
		var/datum/trait/T = all_traits[name]
		T.remove(src, H)

/datum/species/proc/sanitize_name(var/name)
	return sanitizeName(name, MAX_NAME_LEN)

GLOBAL_LIST_INIT(species_oxygen_tank_by_gas, list(
	/datum/gas/oxygen = /obj/item/tank/emergency/oxygen,
	/datum/gas/nitrogen = /obj/item/tank/emergency/nitrogen,
	/datum/gas/phoron = /obj/item/tank/emergency/phoron,
	/datum/gas/carbon_dioxide = /obj/item/tank/emergency/carbon_dioxide
))

/datum/species/proc/equip_survival_gear(var/mob/living/carbon/human/H,var/extendedtank = 0,var/comprehensive = 0)
	var/boxtype = /obj/item/storage/box/survival //Default survival box

	var/synth = H.isSynthetic()

	//Empty box for synths
	if(synth)
		boxtype = /obj/item/storage/box/survival/synth

	//Special box with extra equipment
	else if(comprehensive)
		boxtype = /obj/item/storage/box/survival/comp

	//Create the box
	var/obj/item/storage/box/box = new boxtype(H)

	//If not synth, they get an air tank (if they breathe)
	if(!synth && breath_type)
		//Create a tank (if such a thing exists for this species)
		var/given_path = GLOB.species_oxygen_tank_by_gas[breath_type]
		var/tankpath
		if(extendedtank)
			tankpath = text2path("[given_path]" + "/engi")
			if(!tankpath) //Is it just that there's no /engi?
				tankpath = text2path("[given_path]" + "/double")

		if(!tankpath)
			tankpath = given_path

		if(tankpath)
			new tankpath(box)
		else
			stack_trace("Could not find a tank path for breath type [breath_type], given path was [given_path].")

	//If they are synth, they get a smol battery
	else if(synth)
		new /obj/item/fbp_backup_cell(box)

	box.calibrate_size()

	if(H.backbag == 1)
		H.equip_to_slot_or_del(box, /datum/inventory_slot_meta/abstract/hand/right, INV_OP_SILENT | INV_OP_FLUFFLESS)
	else
		H.equip_to_slot_or_del(box, /datum/inventory_slot_meta/abstract/put_in_backpack, INV_OP_FORCE | INV_OP_SILENT)

/**
 * called to ensure organs are consistent with our species's
 * this is a destructive operation and will erase old organs!
 */
/datum/species/proc/create_organs(var/mob/living/carbon/human/H) //Handles creation of mob organs.

	H.mob_size = mob_size
	for(var/obj/item/organ/organ in H.contents)
		if((organ in H.organs) || (organ in H.internal_organs))
			qdel(organ)

	if(H.organs)									H.organs.Cut()
	if(H.internal_organs)				 H.internal_organs.Cut()
	if(H.organs_by_name)					H.organs_by_name.Cut()
	if(H.internal_organs_by_name) H.internal_organs_by_name.Cut()

	H.organs = list()
	H.internal_organs = list()
	H.organs_by_name = list()
	H.internal_organs_by_name = list()

	for(var/limb_type in has_limbs)
		var/list/organ_data = has_limbs[limb_type]
		var/limb_path = organ_data["path"]
		var/obj/item/organ/O = new limb_path(H)
		organ_data["descriptor"] = O.name
		if(O.parent_organ)
			organ_data = has_limbs[O.parent_organ]
			organ_data["has_children"] = organ_data["has_children"]+1

	for(var/organ_tag in has_organ)
		var/organ_type = has_organ[organ_tag]
		var/obj/item/organ/O = new organ_type(H,1)
		if(organ_tag != O.organ_tag)
			warning("[O.type] has a default organ tag \"[O.organ_tag]\" that differs from the species' organ tag \"[organ_tag]\". Updating organ_tag to match.")
			O.organ_tag = organ_tag
		H.internal_organs_by_name[organ_tag] = O

	if(H.nif)
		var/type = H.nif.type
		var/durability = H.nif.durability
		var/list/nifsofts = H.nif.nifsofts
		var/list/nif_savedata = H.nif.save_data.Copy()

		var/obj/item/nif/nif = new type(H,durability,nif_savedata)
		nif.nifsofts = nifsofts

	if(base_color)
		H.r_skin = hex2num(copytext(base_color,2,4))
		H.g_skin = hex2num(copytext(base_color,4,6))
		H.b_skin = hex2num(copytext(base_color,6,8))
	else
		H.r_skin = 0
		H.g_skin = 0
		H.b_skin = 0

/**
 * called to ensure blood is consistent
 * this is a destructive proc and will erase incompatible blood.
 */
/datum/species/proc/create_blood(mob/living/carbon/human/H)
	H.make_blood()
	if(H.vessel.total_volume < blood_volume)
		H.vessel.maximum_volume = blood_volume
		H.vessel.add_reagent("blood", blood_volume - H.vessel.total_volume)
	else if(H.vessel.total_volume > blood_volume)
		H.vessel.remove_reagent("blood", H.vessel.total_volume - blood_volume)
		H.vessel.maximum_volume = blood_volume
	H.fixblood()

/datum/species/proc/hug(var/mob/living/carbon/human/H, var/mob/living/target)

	var/t_him = "them"
	if(ishuman(target))
		var/mob/living/carbon/human/T = target
		if(!T.species.ambiguous_genders || (T.species.ambiguous_genders && H.species == T.species))
			switch(T.identifying_gender)
				if(MALE)
					t_him = "him"
				if(FEMALE)
					t_him = "her"
		else
			t_him = "them"
	else
		switch(target.gender)
			if(MALE)
				t_him = "him"
			if(FEMALE)
				t_him = "her"
	if(H.zone_sel.selecting == "head") // Headpats and Handshakes!
		H.visible_message( \
			"<span class='notice'>[H] pats [target] on the head.</span>", \
			"<span class='notice'>You pat [target] on the head.</span>", )
	else if(H.zone_sel.selecting == "r_hand" || H.zone_sel.selecting == "l_hand")
		H.visible_message( \
			"<span class='notice'>[H] shakes [target]'s hand.</span>", \
			"<span class='notice'>You shake [target]'s hand.</span>", )
	//Ports nose booping
	else if(H.zone_sel.selecting == "mouth")
		H.visible_message( \
			"<span class='notice'>[H] boops [target]'s nose.</span>", \
			"<span class='notice'>You boop [target] on the nose.</span>", )
	else H.visible_message("<span class='notice'>[H] hugs [target] to make [t_him] feel better!</span>", \
					"<span class='notice'>You hug [target] to make [t_him] feel better!</span>")

/datum/species/proc/remove_inherent_verbs(var/mob/living/carbon/human/H)
	if(inherent_verbs)
		for(var/verb_path in inherent_verbs)
			H.verbs -= verb_path
	return

/datum/species/proc/add_inherent_verbs(var/mob/living/carbon/human/H)
	if(inherent_verbs)
		for(var/verb_path in inherent_verbs)
			H.verbs |= verb_path
	return

/datum/species/proc/add_inherent_spells(var/mob/living/carbon/human/H)
	if(inherent_spells)
		for(var/spell_to_add in inherent_spells)
			var/spell/S = new spell_to_add(H)
			H.add_spell(S)

/datum/species/proc/remove_inherent_spells(var/mob/living/carbon/human/H)
	H.spellremove()

/**
 * called after a mob is **fully** spawned
 */
/datum/species/proc/handle_post_spawn(var/mob/living/carbon/human/H) //Handles anything not already covered by basic species assignment.
	H.mob_bump_flag = bump_flag
	H.mob_swap_flags = swap_flags
	H.mob_push_flags = push_flags
	H.pass_flags = pass_flags

/datum/species/proc/handle_death(var/mob/living/carbon/human/H, gibbed = FALSE) //Handles any species-specific death events (such as dionaea nymph spawns).
	return

// Only used for alien plasma weeds atm, but could be used for Dionaea later.
/datum/species/proc/handle_environment_special(var/mob/living/carbon/human/H)
	return

// Used to update alien icons for aliens.
/datum/species/proc/handle_login_special(var/mob/living/carbon/human/H)
	return

// As above.
/datum/species/proc/handle_logout_special(var/mob/living/carbon/human/H)
	return

// Builds the HUD using species-specific icons and usable slots.
/datum/species/proc/build_hud(var/mob/living/carbon/human/H)
	return

//Used by xenos understanding larvae and dionaea understanding nymphs.
/datum/species/proc/can_understand(var/mob/other)
	return

// Called when using the shredding behavior.
/datum/species/proc/can_shred(var/mob/living/carbon/human/H, var/ignore_intent)

	if(!ignore_intent && H.a_intent != INTENT_HARM)
		return 0

	for(var/datum/unarmed_attack/attack in unarmed_attacks)
		if(!attack.is_usable(H))
			continue
		if(attack.shredding)
			return 1

	return 0

// Called in life() when the mob has no client.
/datum/species/proc/handle_npc(var/mob/living/carbon/human/H)
	if(H.stat == CONSCIOUS && H.ai_holder)
		if(H.resting)
			H.resting = FALSE
			H.update_canmove()
	return

// Called when lying down on a water tile.
/datum/species/proc/can_breathe_water()
	return FALSE

// Impliments different trails for species depending on if they're wearing shoes.
/datum/species/proc/get_move_trail(var/mob/living/carbon/human/H)
	if( H.shoes || ( H.wear_suit && (H.wear_suit.body_parts_covered & FEET) ) )
		return /obj/effect/debris/cleanable/blood/tracks/footprints
	else
		return move_trail

/datum/species/proc/update_skin(var/mob/living/carbon/human/H)
	return

/datum/species/proc/get_eyes(var/mob/living/carbon/human/H)
	return

/datum/species/proc/can_overcome_gravity(var/mob/living/carbon/human/H)
	return FALSE

/datum/species/proc/handle_fall_special(var/mob/living/carbon/human/H, var/turf/landing)
	return FALSE

// Used for any extra behaviour when falling and to see if a species will fall at all.
/datum/species/proc/can_fall(var/mob/living/carbon/human/H)
	return TRUE

// Used to find a special target for falling on, such as pouncing on someone from above.
/datum/species/proc/find_fall_target_special(src, landing)
	return FALSE

// Used to override normal fall behaviour. Use only when the species does fall down a level.
/datum/species/proc/fall_impact_special(var/mob/living/carbon/human/H, var/atom/A)
	return FALSE

// Allow species to display interesting information in the human stat panels
/datum/species/proc/Stat(var/mob/living/carbon/human/H)
	return

/datum/species/proc/update_attack_types()
	unarmed_attacks = list()
	for(var/u_type in unarmed_types)
		unarmed_attacks += new u_type()

/datum/species/proc/give_numbing_bite() //Holy SHIT this is hacky, but it works. Updating a mob's attacks mid game is insane.
	unarmed_attacks = list()
	unarmed_types += /datum/unarmed_attack/bite/sharp/numbing
	for(var/u_type in unarmed_types)
		unarmed_attacks += new u_type()

/datum/species/proc/handle_falling(mob/living/carbon/human/H, atom/hit_atom, damage_min, damage_max, silent, planetary)
	return FALSE

/datum/species/proc/get_offset_overlay_image(spritesheet, mob_icon, mob_state, color, slot)

	// If we don't actually need to offset this, don't bother with any of the generation/caching.
	if(!spritesheet && equip_adjust.len && equip_adjust[slot] && LAZYLEN(equip_adjust[slot]))

		// Check the cache for previously made icons.
		var/image_key = "[mob_icon]-[mob_state]-[color]"
		if(!equip_overlays[image_key])

			var/icon/final_I = new(icon_template)
			var/list/shifts = equip_adjust[slot]

			// Apply all pixel shifts for each direction.
			for(var/shift_facing in shifts)
				var/list/facing_list = shifts[shift_facing]
				var/use_dir = text2num(shift_facing)
				var/icon/equip = new(mob_icon, icon_state = mob_state, dir = use_dir)
				var/icon/canvas = new(icon_template)
				canvas.Blend(equip, ICON_OVERLAY, facing_list["x"]+1, facing_list["y"]+1)
				final_I.Insert(canvas, dir = use_dir)
			equip_overlays[image_key] = overlay_image(final_I, color = color, flags = RESET_COLOR)
		var/image/I = new() // We return a copy of the cached image, in case downstream procs mutate it.
		I.appearance = equip_overlays[image_key]
		return I
	return overlay_image(mob_icon, mob_state, color, RESET_COLOR)

/**
 * clones us into a new datum
 */
/datum/species/proc/clone()
	var/datum/species/created = new type
	created.copy_from(src)

/**
 * completely clones us from another species, updating the provided human in the process
 *
 * @params
 * to_copy - species copy
 * traits - traits to add
 * H - update this human
 */
/datum/species/proc/copy_from(datum/species/to_copy, list/traits = list(), mob/living/carbon/human/H)
	ASSERT(to_copy)

	if(ispath(to_copy))
		to_copy = SScharacters.resolve_species_path(to_copy)
	if(istext(to_copy))
		to_copy = SScharacters.resolve_species_name(to_copy)

	//Initials so it works with a simple path passed, or an instance
	base_species = to_copy.name
	icobase = to_copy.icobase
	deform = to_copy.deform
	tail = to_copy.tail
	tail_animation = to_copy.tail_animation
	icobase_tail = to_copy.icobase_tail
	color_mult = to_copy.color_mult
	primitive_form = to_copy.primitive_form
	species_appearance_flags = to_copy.species_appearance_flags
	flesh_color = to_copy.flesh_color
	base_color = to_copy.base_color
	blood_mask = to_copy.blood_mask
	damage_mask = to_copy.damage_mask
	damage_overlays = to_copy.damage_overlays
	move_trail = move_trail
	has_floating_eyes = has_floating_eyes


	//Set up the mob provided
	if(H)
		// If you had traits, apply them
		// but also make sure the human's species is actually us
		ASSERT(H.species == src)

		var/list/adding = traits - src.traits
		var/list/removing = src.traits - traits
		for(var/name in adding)
			var/datum/trait/T = all_traits[name]
			T.apply(src, H)
		for(var/name in removing)
			var/datum/trait/T = all_traits[name]
			T.remove(src, H)
		src.traits = traits

		H.icon_state = lowertext(get_bodytype_legacy())

		if(holder_type)
			H.holder_type = holder_type

		if(H.dna)
			H.dna.ready_dna(H)
	else
		src.traits = traits
