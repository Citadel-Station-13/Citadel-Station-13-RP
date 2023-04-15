// A thing you can fish in
/datum/component/fishing_spot
	/// Defines the probabilities and fish availibilty
	var/datum/fish_source/fish_source

/datum/component/fishing_spot/Initialize(configuration)
	if(!isatom(parent) || ((. = ..()) & COMPONENT_INCOMPATIBLE))
		return COMPONENT_INCOMPATIBLE
	if(ispath(configuration, /datum/fish_source))
		// Create new one of the given type
		fish_source = fetch_fish_source(configuration)
	else if(istype(configuration, /datum/fish_source))
		// Use passed in instance
		fish_source = configuration

/datum/component/fishing_spot/proc/try_start_fishing(obj/item/possibly_rod, mob/user)
	var/obj/item/fishing_rod/rod = possibly_rod
	if(!istype(rod))
		return FALSE
	if(HAS_TRAIT(user,TRAIT_MOB_IS_FISHING) || rod.currently_hooked_item)
		user.bubble_action_feedback("already fishing", possibly_rod)
		return TRUE
	var/denial_reason = fish_source.reason_we_cant_fish(rod, user)
	if(denial_reason)
		to_chat(user, SPAN_WARNING(denial_reason))
		return TRUE
	start_fishing_challenge(rod, user)
	return TRUE

/datum/component/fishing_spot/proc/start_fishing_challenge(obj/item/fishing_rod/rod, mob/user)
	/// Roll what we caught based on modified table
	var/result = fish_source.roll_reward(rod, user)
	var/datum/fishing_challenge/challenge = new(parent, result, rod, user)
	challenge.background = fish_source.background
	challenge.difficulty = fish_source.calculate_difficulty(result, rod, user)
	RegisterSignal(challenge, COMSIG_FISHING_CHALLENGE_COMPLETED, PROC_REF(fishing_completed))
	challenge.start(user)

/datum/component/fishing_spot/proc/fishing_completed(datum/fishing_challenge/source, mob/user, success, perfect)
	if(!success)
		return
	fish_source.dispense_reward(source.reward_path, user)
