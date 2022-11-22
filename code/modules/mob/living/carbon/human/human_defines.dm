/mob/living/carbon/human
	blocks_emissive = EMISSIVE_BLOCK_UNIQUE
	name = "unknown"
	real_name = "unknown"
	voice_name = "unknown"
	icon = 'icons/effects/effects.dmi' //We have an ultra-complex update icons that overlays everything, don't load some stupid random male human
	icon_state = "nothing"

	/// To check if we've need to roll for damage on movement while an item is imbedded in us.
	var/embedded_flag
	/// This is very not good, but it's much much better than calling get_rig() every update_canmove() call.
	var/obj/item/rig/wearing_rig
	/// For human_attackhand.dm, keeps track of the last use of disarm.
	var/last_push_time

	/// Spitting and spitting related things. Any human based ranged attacks, be it innate or added abilities.
	var/spitting = FALSE
	/// Projectile type.
	var/spit_projectile = null
	/// String
	var/spit_name = null
	/// Timestamp.
	var/last_spit = 0

	/// Horrible damage (like beheadings) will prevent defibbing organics.
	var/can_defib = TRUE
	/// Used for the regenerate proc in human_powers.dm
	var/active_regen = FALSE
	var/active_regen_delay = 300
	/// Throws byond:tm: errors if placed in human/emote, but not here.
	var/spam_flag = FALSE

	hud_possible = list(
		LIFE_HUD,
		STATUS_HUD,
		ID_HUD,
		WANTED_HUD,
		IMPLOYAL_HUD,
		IMPTRACK_HUD,
		IMPCHEM_HUD,
		ANTAG_HUD,
	)

	//! Buckling - For riding.dm
	buckle_allowed = TRUE
	buckle_flags = BUCKLING_NO_DEFAULT_BUCKLE // Custom procs handle that.

	//! Cosmetics / Basic Rendering
	//? Note: This is what we actually have.
	//? DNA can differ; DNA is our DNA, this is our body.
	/// body color
	var/body_color
	/// eye color
	var/eye_color

	//! Sprite Accessories - these are AGGRESSIVELY CACHED, please use necessary procs!
	//? Note: This is what we actually have.
	//? DNA can differ; DNA is our DNA, this is our body.
	#warn ugh handle this
	/// hair
	VAR_PRIVATE/datum/sprite_accessory_data/hair
	var/cache_hair_overlays
	var/cache_hair_emissives
	/// facial hair
	VAR_PRIVATE/datum/sprite_accessory_data/facial_hair
	var/cache_facial_hair_overlays
	var/cache_facial_hair_emissives
	/// ears
	VAR_PRIVATE/datum/sprite_accessory_data/ears_1
	var/cache_ears_1_overlays
	var/cache_ears_1_emissives
	/// ears
	VAR_PRIVATE/datum/sprite_accessory_data/ears_2
	var/cache_ears_2_overlays
	var/cache_ears_2_emissives
	/// tail
	VAR_PRIVATE/datum/sprite_accessory_data/tail
	var/cache_tail_overlays
	var/cache_tail_emissives
	/// wings
	VAR_PRIVATE/datum/sprite_accessory_data/wings
	var/cache_wing_overlays
	var/cache_wing_emissives
	/// body markings
	#warn kick this shit to the limb itself maybe?
	VAR_PRIVATE/list/datum/sprite_accessory_data/markings
	var/cache_marking_overlays
	var/cache_marking_emissives

	var/wagging  = 0 //UGH.
	var/flapping = 0
	var/spread   = 0
	/// What's my status?
	var/vantag_pref = VANTAG_NONE
	// todo: REOMVE THIS FOR SPECIES VAR CHANGES
	/// For impersonating a bodytype.
	var/impersonate_bodytype_legacy
	/// for impersonating a bodytype but actually.
	var/impersonate_bodytype
	/// Shadekin abilities/potentially other species-based?
	var/ability_flags = NONE
	/// Suit sensor loadout pref.
	var/sensorpref = 5

	var/custom_species

//! ## Synth colors
	/// Lets normally uncolorable synth parts be colorable.
	var/synth_color	= 0
	// Used with synth_color to color synth parts that normaly can't be colored.
	var/r_synth
	var/g_synth
	var/b_synth
	/// Enables/disables markings on synth parts.
	var/synth_markings = 0
	/// For adherent coloring....
	var/s_base

	/// Multiplies melee combat damage.
	var/damage_multiplier = 1
	/// Whether icon updating shall take place.
	var/icon_update = 1

	/// No lipstick by default- arguably misleading, as it could be used for general makeup.
	var/lip_style = null

	/// Player's age.
	var/age = 30
	/// Player's bloodtype.
	var/b_type = "A+"
	/// If they are a synthetic (aka synthetic torso). Also holds the datums for the type of robolimb.
	var/datum/robolimb/synthetic

	var/list/all_underwear = list()
	var/list/all_underwear_metadata = list()
	var/list/hide_underwear = list()

	/// Which backpack type the player has chosen.
	var/backbag   = 2
	/// Which PDA type the player has chosen.
	var/pdachoice = 1

//! ## General information
	var/home_system = ""
	var/citizenship = ""
	var/personal_faction = ""
	var/religion = ""
	var/antag_faction = ""
	var/antag_vis = ""

//! ## Equipment slots
	var/obj/item/wear_suit = null
	var/obj/item/w_uniform = null
	var/obj/item/shoes = null
	var/obj/item/belt = null
	var/obj/item/gloves = null
	var/obj/item/glasses = null
	var/obj/item/head = null
	var/obj/item/l_ear = null
	var/obj/item/r_ear = null
	var/obj/item/wear_id = null
	var/obj/item/r_store = null
	var/obj/item/l_store = null
	var/obj/item/s_store = null

	var/used_skillpoints = 0
	var/skill_specialization = null
	var/list/skills = list()

	/// Instead of new say code calling GetVoice() over and over and over, we're just going to ask this variable, which gets updated in Life()
	var/voice = ""

	/// Toggle for the mime's abilities. //TODO Readd mime stuff :(
	//var/miming = null
	/// For changing our voice. Used by a symptom.
	var/special_voice = ""

	/// Used for determining if we need to process all organs or just some or even none.
	var/last_dam = -1

	/// For the spoooooooky xylophone cooldown. //TODO: Everyone shouldn't have this.
	var/xylophone = 0

	var/mob/remoteview_target = null
	var/hand_blood_color

	var/list/flavor_texts = list()
	var/gunshot_residue
	/// Are you trying not to hurt your opponent?
	var/pulling_punches
	/// Total number of external robot parts.
	var/robolimb_count = 0
	/// Counts torso, groin, and head, if they're robotic
	var/robobody_count = 0

	mob_bump_flag = HUMAN
	mob_push_flags = ~HEAVY
	mob_swap_flags = ~HEAVY

	/// In case someone identifies as another gender than it's biological one
	var/identifying_gender

	/// For comparative examine code
	var/list/descriptors

	/// Track how many footsteps have been taken to know when to play footstep sounds
	var/step_count = 0

	can_be_antagged = TRUE

	/// Used by mobs in virtual reality to point back to the "real" mob the client belongs to.
	var/mob/living/carbon/human/vr_holder = null
	/// Used by "real" mobs after they leave a VR session
	var/mob/living/carbon/human/vr_link = null

	/**
	 * Machine that is currently applying visual effects to this mob.
	 * Only used for camera monitors currently.
	 */
	var/obj/machinery/machine_visual
