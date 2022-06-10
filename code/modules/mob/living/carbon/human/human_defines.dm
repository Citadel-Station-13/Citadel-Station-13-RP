/mob/living/carbon/human
	hud_possible = list(
		LIFE_HUD,
		STATUS_HUD,
		ID_HUD,
		WANTED_HUD,
		IMPLOYAL_HUD,
		IMPTRACK_HUD,
		IMPCHEM_HUD,
		ANTAG_HUD
	)

//! ## Hair colour and style
	var/r_hair = 0
	var/g_hair = 0
	var/b_hair = 0
	var/h_style = "Bald"

//! ## Hair gradients
	var/r_grad = 0
	var/g_grad = 0
	var/b_grad = 0
	var/grad_style = "None"

//! ## Facial hair colour and style
	var/r_facial = 0
	var/g_facial = 0
	var/b_facial = 0
	var/f_style = "Shaved"

//! ## Eye colour
	var/r_eyes = 0
	var/g_eyes = 0
	var/b_eyes = 0
	/// Skin tone
	var/s_tone = 0

//! ## Skin colour
	var/r_skin = 238 // TO DO: Set defaults for other races.
	var/g_skin = 206
	var/b_skin = 179
	/// Skin flag
	var/skin_state = SKIN_NORMAL

//! ## ears, tails, wings and custom species.
	var/datum/sprite_accessory/ears/ear_style = null
	var/r_ears = 30
	var/g_ears = 30
	var/b_ears = 30
	var/r_ears2 = 30
	var/g_ears2 = 30
	var/b_ears2 = 30
	var/r_ears3 = 30 //Trust me, we could always use more colour. No japes.
	var/g_ears3 = 30
	var/b_ears3 = 30

	var/datum/sprite_accessory/tail/tail_style = null
	var/r_tail = 30
	var/g_tail = 30
	var/b_tail = 30
	var/r_tail2 = 30
	var/g_tail2 = 30
	var/b_tail2 = 30
	var/r_tail3 = 30
	var/g_tail3 = 30
	var/b_tail3 = 30

	var/datum/sprite_accessory/wing/wing_style = null
	var/r_gradwing = 0
	var/g_gradwing = 0
	var/b_gradwing = 0
	var/grad_wingstyle = "None"

	var/r_wing = 30
	var/g_wing = 30
	var/b_wing = 30
	var/r_wing2 = 30
	var/g_wing2 = 30
	var/b_wing2 = 30
	var/r_wing3 = 30
	var/g_wing3 = 30
	var/b_wing3 = 30

	var/wagging = 0 //UGH.
	var/flapping = 0
	///What's my status?
	var/vantag_pref = VANTAG_NONE
	///For impersonating a bodytype
	var/impersonate_bodytype
	///Shadekin abilities/potentially other species-based?
	var/ability_flags = 0
	///Suit sensor loadout pref
	var/sensorpref = 5

	var/custom_species

//! ## Synth colors
	///Lets normally uncolorable synth parts be colorable.
	var/synth_color	= 0
	//Used with synth_color to color synth parts that normaly can't be colored.
	var/r_synth
	var/g_synth
	var/b_synth
	///Enables/disables markings on synth parts.
	var/synth_markings = 0
	///For adherent coloring....
	var/s_base

	///multiplies melee combat damage
	var/damage_multiplier = 1
	///whether icon updating shall take place
	var/icon_update = 1

	///no lipstick by default- arguably misleading, as it could be used for general makeup
	var/lip_style = null

	///Player's age (pure fluff)
	var/age = 30
	///Player's bloodtype
	var/b_type = "A+"
	///If they are a synthetic (aka synthetic torso). Also holds the datum for the type of robolimb.
	var/datum/robolimb/synthetic

	var/list/all_underwear = list()
	var/list/all_underwear_metadata = list()
	var/list/hide_underwear = list()
	///Which backpack type the player has chosen.
	var/backbag = 2
	///Which PDA type the player has chosen.
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

	///Instead of new say code calling GetVoice() over and over and over, we're just going to ask this variable, which gets updated in Life()
	var/voice = ""

	///Toggle for the mime's abilities. //TODO Readd mime stuff :(
	//var/miming = null
	/// For changing our voice. Used by a symptom.
	var/special_voice = ""

	///Used for determining if we need to process all organs or just some or even none.
	var/last_dam = -1

	///For the spoooooooky xylophone cooldown
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

	///machine that is currently applying visual effects to this mob. Only used for camera monitors currently.
	var/obj/machinery/machine_visual

/mob/living/carbon/human/proc/shadekin_get_energy()
	var/datum/species/shadekin/SK = species

	if(!istype(SK))
		return 0

	return SK.get_energy(src)

/mob/living/carbon/human/proc/shadekin_get_max_energy()
	var/datum/species/shadekin/SK = species

	if(!istype(SK))
		return 0

	return SK.get_max_energy(src)

/mob/living/carbon/human/proc/shadekin_set_energy(var/new_energy)
	var/datum/species/shadekin/SK = species

	if(!istype(SK))
		return 0

	SK.set_energy(src, new_energy)

/mob/living/carbon/human/proc/shadekin_set_max_energy(var/new_max_energy)
	var/datum/species/shadekin/SK = species

	if(!istype(SK))
		return 0

	SK.set_max_energy(src, new_max_energy)

/mob/living/carbon/human/proc/shadekin_adjust_energy(var/amount)
	var/datum/species/shadekin/SK = species

	if(!istype(SK))
		return 0

	if(amount > 0 || !(SK.check_infinite_energy(src)))
		var/new_amount = SK.get_energy(src) + amount
		SK.set_energy(src, new_amount)
