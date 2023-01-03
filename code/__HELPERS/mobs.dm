/atom/movable/proc/get_mob()
	return

/obj/mecha/get_mob()
	return occupant

/obj/vehicle_old/train/get_mob()
	return buckled_mobs

/mob/get_mob()
	return src

/mob/living/bot/mulebot/get_mob()
	if(load && istype(load, /mob/living))
		return list(src, load)
	return src

/proc/mobs_in_view(range, source)
	var/list/mobs = list()
	for(var/atom/movable/AM in view(range, source))
		var/M = AM.get_mob()
		if(M)
			mobs += M

	return mobs

/proc/mobs_in_xray_view(range, source)
	var/list/mobs = list()
	for(var/atom/movable/AM in orange(range, source))
		var/M = AM.get_mob()
		if(M)
			mobs += M

	return mobs

/proc/random_hair_style(gender, species = SPECIES_HUMAN)
	var/list/valid = list()
	for(var/id in GLOB.sprite_accessory_hair)
		var/datum/sprite_accessory/hair/S = GLOB.sprite_accessory_hair[id]
		if(S.gender != NEUTER && gender != S.gender)
			continue
		if(S.apply_restrictions && !(species in S.species_allowed))
			continue
		valid += id
	return SAFEPICK(valid)

/proc/random_facial_hair_style(gender, species = SPECIES_HUMAN)
	var/list/valid = list()
	for(var/id in GLOB.sprite_accessory_facial_hair)
		var/datum/sprite_accessory/facial_hair/S = GLOB.sprite_accessory_facial_hair[id]
		if(S.gender != NEUTER && gender != S.gender)
			continue
		if(S.apply_restrictions && !(species in S.species_allowed))
			continue
		valid += id
	return SAFEPICK(valid)

/proc/sanitize_species_name(name, species = SPECIES_HUMAN)
	var/datum/species/current_species
	if(species)
		current_species = SScharacters.resolve_species_name(species)

	return current_species ? current_species.sanitize_species_name(name) : sanitizeName(name, MAX_NAME_LEN)

/proc/random_name(gender, species = SPECIES_HUMAN)

	var/datum/species/current_species
	if(species)
		current_species = SScharacters.resolve_species_name(species)

	if(!current_species || current_species.name_language == null)
		if(gender==FEMALE)
			return capitalize(pick(GLOB.first_names_female)) + " " + capitalize(pick(GLOB.last_names))
		else
			return capitalize(pick(GLOB.first_names_male)) + " " + capitalize(pick(GLOB.last_names))
	else
		return current_species.get_random_name(gender)

/proc/random_skin_tone()
	switch(pick(60;"caucasian", 15;"afroamerican", 10;"african", 10;"latino", 5;"albino"))
		if("caucasian")		. = -10
		if("afroamerican")	. = -115
		if("african")		. = -165
		if("latino")		. = -55
		if("albino")		. = 34
		else				. = rand(-185,34)
	return min(max( .+rand(-25, 25), -185),34)

/proc/skintone2racedescription(tone)
	switch (tone)
		if(30 to INFINITY)		return "albino"
		if(20 to 30)			return "pale"
		if(5 to 15)				return "light skinned"
		if(-10 to 5)			return "white"
		if(-25 to -10)			return "tan"
		if(-45 to -25)			return "darker skinned"
		if(-65 to -45)			return "brown"
		if(-INFINITY to -65)	return "black"
		else					return "unknown"

/proc/age2agedescription(age)
	switch(age)
		if(0 to 1)			return "infant"
		if(1 to 3)			return "toddler"
		if(3 to 13)			return "child"
		if(13 to 19)		return "teenager"
		if(19 to 30)		return "young adult"
		if(30 to 45)		return "adult"
		if(45 to 60)		return "middle-aged"
		if(60 to 70)		return "aging"
		if(70 to INFINITY)	return "elderly"
		else				return "unknown"

/**
 * Proc for attack log creation, because really why not
 * 1 argument is the actor
 * 2 argument is the target of action
 * 3 is the description of action(like punched, throwed, or any other verb)
 * 4 should it make adminlog note or not
 * 5 is the tool with which the action was made(usually item)
 * ? 5 and 6 are very similar(5 have "by " before it, that it) and are separated just to keep things in a bit more in order
 * 6 is additional information, anything that needs to be added
 */
/proc/add_attack_logs(mob/user, mob/target, what_done, var/admin_notify = TRUE)
	if(islist(target)) //Multi-victim adding
		var/list/targets = target
		for(var/mob/M in targets)
			add_attack_logs(user,M,what_done,admin_notify)
		return

	var/user_str = key_name(user)
	var/target_str = key_name(target)

	if(ismob(user))
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Attacked [target_str]: [what_done]</font>")
	if(ismob(target))
		target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Attacked by [user_str]: [what_done]</font>")
	log_attack(user_str,target_str,what_done)
	if(admin_notify)
		msg_admin_attack("[key_name_admin(user)] vs [target_str]: [what_done]")

//checks whether this item is a module of the robot it is located in.
/proc/is_robot_module(obj/item/thing)
	if (!thing || !istype(thing.loc, /mob/living/silicon/robot))
		return 0
	var/mob/living/silicon/robot/R = thing.loc
	return (thing in R.module.modules)

/proc/get_exposed_defense_zone(atom/movable/target)
	var/obj/item/grab/G = locate() in target
	if(G && G.state >= GRAB_NECK) //works because mobs are currently not allowed to upgrade to NECK if they are grabbing two people.
		return pick("head", "l_hand", "r_hand", "l_foot", "r_foot", "l_arm", "r_arm", "l_leg", "r_leg")
	else
		return pick("chest", "groin")

/atom/proc/living_mobs(range = world.view)
	var/list/viewers = oviewers(src,range)
	var/list/living = list()
	for(var/mob/living/L in viewers)
		living += L

	return living

/atom/proc/human_mobs(range = world.view)
	var/list/viewers = oviewers(src,range)
	var/list/humans = list()
	for(var/mob/living/carbon/human/H in viewers)
		humans += H

	return humans

/proc/cached_character_icon(mob/desired)
	var/cachekey = "\ref[desired][desired.real_name]"

	if(cached_character_icons[cachekey])
		. = cached_character_icons[cachekey]
	else
		. = get_compound_icon(desired)
		cached_character_icons[cachekey] = .

/// Gets the client of the mob, allowing for mocking of the client.
/// You only need to use this if you know you're going to be mocking clients somewhere else.
#define GET_CLIENT(mob) (##mob.client || ##mob.mock_client)
