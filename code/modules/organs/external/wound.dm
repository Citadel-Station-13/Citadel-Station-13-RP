
/****************************************************
					WOUNDS
****************************************************/
/datum/wound
	// number representing the current stage
	var/current_stage = 0

	// description of the wound
	var/desc = "wound" //default in case something borks

	// amount of damage this wound causes
	var/damage = 0
	// ticks of bleeding left.
	var/bleed_timer = 0
	// Above this amount wounds you will need to treat the wound to stop bleeding, regardless of bleed_timer
	var/bleed_threshold = 30
	// amount of damage the current wound type requires(less means we need to apply the next healing stage)
	var/min_damage = 0

	// is the wound bandaged?
	var/bandaged = FALSE
	// Similar to bandaged, but works differently
	var/clamped = FALSE
	// is the wound salved?
	var/salved = FALSE
	// is the wound disinfected?
	var/disinfected = 0
	var/created = 0
	// number of wounds of this type
	var/amount = 1
	// amount of germs in the wound
	var/germ_level = 0

	/*  These are defined by the wound type and should not be changed */

	// stages such as "cut", "deep cut", etc.
	var/list/stages
	// internal wounds can only be fixed through surgery
	var/internal = FALSE
	// maximum stage at which bleeding should still happen. Beyond this stage bleeding is prevented.
	var/max_bleeding_stage = 0
	// one of CUT, PIERCE, BRUISE, BURN
	var/damage_type = CUT
	// whether this wound needs a bandage/salve to heal at all
	// the maximum amount of damage that this wound can have and still autoheal
	var/autoheal_cutoff = 10

	// whether this wound starts infected regardless of damage level
	var/forced_infected = FALSE


	// helper lists
	var/tmp/list/desc_list = list()
	var/tmp/list/damage_list = list()

/datum/wound/New(damage)

	created = world.time

	// reading from a list("stage" = damage) is pretty difficult, so build two separate
	// lists from them instead
	for(var/V in stages)
		desc_list += V
		damage_list += stages[V]

	src.damage = damage

	// initialize with the appropriate stage
	src.init_stage(damage)

	bleed_timer += damage

// returns 1 if there's a next stage, 0 otherwise
/datum/wound/proc/init_stage(initial_damage)
	current_stage = stages.len

	while(src.current_stage > 1 && src.damage_list[current_stage-1] <= initial_damage / src.amount)
		src.current_stage--

	src.min_damage = damage_list[current_stage]
	src.desc = desc_list[current_stage]

// the amount of damage per wound
/datum/wound/proc/wound_damage()
	return src.damage / src.amount

/datum/wound/proc/can_autoheal()
	if(is_treated())
		return TRUE
	if(src.wound_damage() <= autoheal_cutoff)
		if(created + 10 MINUTES > world.time) // Wounds don't autoheal for ten minutes if not bandaged.
			return FALSE
		return TRUE

// checks whether the wound has been appropriately treated
/datum/wound/proc/is_treated()
	if(damage_type == BRUISE || damage_type == CUT || damage_type == PIERCE)
		return bandaged
	else if(damage_type == BURN)
		return salved

// Checks whether other other can be merged into src.
/datum/wound/proc/can_merge(var/datum/wound/other)
	if (other.type != src.type)
		return 0
	if (other.current_stage != src.current_stage)
		return 0
	if (other.damage_type != src.damage_type)
		return 0
	if (!(other.can_autoheal()) != !(src.can_autoheal()))
		return 0
	if (!(other.bandaged) != !(src.bandaged))
		return 0
	if (!(other.clamped) != !(src.clamped))
		return 0
	if (!(other.salved) != !(src.salved))
		return 0
	if (!(other.disinfected) != !(src.disinfected))
		return 0
	// if (other.germ_level != src.germ_level)
	// 	return 0
	return 1

/datum/wound/proc/merge_wound(datum/wound/other)
	src.damage += other.damage
	src.amount += other.amount
	src.bleed_timer += other.bleed_timer
	src.germ_level = max(src.germ_level, other.germ_level)
	src.created = max(src.created, other.created) // Take the newer created time.

/// Forces an infection, and bleeding regardless of damage or stage.
/datum/wound/proc/force_infect()
	bleed_threshold = 4 	//Will always start bleeding, making the infection worse if untreated
	forced_infected = TRUE
	germ_level = INFECTION_LEVEL_ONE + 1

// checks if wound is considered open for external infections
// untreated cuts (and bleeding bruises) and burns are possibly infectable, chance higher if wound is bigger
/datum/wound/proc/infection_check()
	if (disinfected)
		if(germ_level > INFECTION_LEVEL_ONE)
			germ_level = 0	//reset this, just in case
		forced_infected = FALSE
		return FALSE
	if (damage < 10 && !forced_infected)	//small cuts, tiny bruises, and moderate burns shouldn't be infectable.
		return FALSE
	if (is_treated() && damage < 25)	//anything less than a flesh wound (or equivalent) isn't infectable if treated properly
		return FALSE
	if (damage_type == BRUISE && !bleeding()) //bruises only infectable if bleeding
		return FALSE


	if(forced_infected) //This wound is forced to be infected, circumventing damage requirements, check after making sure it's not bleeding and isn't disinfected
		return TRUE

	var/dam_coef = round(damage/10)
	switch (damage_type)
		if (BRUISE)
			return prob(dam_coef*5)
		if (BURN)
			return prob(dam_coef*10)
		if (CUT)
			return prob(dam_coef*20)

	return FALSE

/datum/wound/proc/bandage()
	bandaged = 1

/datum/wound/proc/salve()
	salved = 1

/datum/wound/proc/disinfect()
	disinfected = 1

// heal the given amount of damage, and if the given amount of damage was more
// than what needed to be healed, return how much heal was left
// set @heals_internal to also heal internal organ damage
/datum/wound/proc/heal_damage(amount, heals_internal = 0)
	if(src.internal && !heals_internal)
		// heal nothing
		return amount

	var/healed_damage = min(src.damage, amount)
	amount -= healed_damage
	src.damage -= healed_damage

	while(src.wound_damage() < damage_list[current_stage] && current_stage < src.desc_list.len)
		current_stage++
	desc = desc_list[current_stage]
	src.min_damage = damage_list[current_stage]

	// return amount of healing still leftover, can be used for other wounds
	return amount

// opens the wound again
/datum/wound/proc/open_wound(damage)
	src.damage += damage
	bleed_timer += damage

	while(src.current_stage > 1 && src.damage_list[current_stage-1] <= src.damage / src.amount)
		src.current_stage--

	src.desc = desc_list[current_stage]
	src.min_damage = damage_list[current_stage]

// returns whether this wound can absorb the given amount of damage.
// this will prevent large amounts of damage being trapped in less severe wound types
/datum/wound/proc/can_worsen(damage_type, damage)
	if (src.damage_type != damage_type)
		return 0	//incompatible damage types

	if (src.amount > 1)
		return 0//merged wounds cannot be worsened.

	//with 1.5*, a shallow cut will be able to carry at most 30 damage,
	//37.5 for a deep cut
	//52.5 for a flesh wound, etc.
	var/max_wound_damage = 1.5*src.damage_list[1]
	if (src.damage + damage > max_wound_damage)
		return 0

	return 1

/datum/wound/proc/bleeding()
	if (src.internal)
		return 0	// internal wounds don't bleed in the sense of this function

	if (current_stage > max_bleeding_stage)
		return 0

	if (bandaged||clamped)
		return 0

	if (bleed_timer <= 0 && wound_damage() <= bleed_threshold)
		return 0	//Bleed timer has run out. Once a wound is big enough though, you'll need a bandage to stop it

	return 1

/** WOUND DEFINITIONS **/

//Note that the MINIMUM damage before a wound can be applied should correspond to
//the damage amount for the stage with the same name as the wound.
//e.g. /datum/wound/cut/deep should only be applied for 15 damage and up,
//because in it's stages list, "deep cut" = 15.
/proc/get_wound_type(type = CUT, damage)
	switch(type)
		if(CUT)
			switch(damage)
				if(70 to INFINITY)
					return /datum/wound/cut/massive
				if(60 to 70)
					return /datum/wound/cut/gaping_big
				if(50 to 60)
					return /datum/wound/cut/gaping
				if(25 to 50)
					return /datum/wound/cut/flesh
				if(15 to 25)
					return /datum/wound/cut/deep
				if(0 to 15)
					return /datum/wound/cut/small
		if(PIERCE)
			switch(damage)
				if(60 to INFINITY)
					return /datum/wound/puncture/massive
				if(50 to 60)
					return /datum/wound/puncture/gaping_big
				if(30 to 50)
					return /datum/wound/puncture/gaping
				if(15 to 30)
					return /datum/wound/puncture/flesh
				if(0 to 15)
					return /datum/wound/puncture/small
		if(BRUISE)
			return /datum/wound/bruise
		if(BURN)
			switch(damage)
				if(50 to INFINITY)
					return /datum/wound/burn/carbonised
				if(40 to 50)
					return /datum/wound/burn/deep
				if(30 to 40)
					return /datum/wound/burn/severe
				if(15 to 30)
					return /datum/wound/burn/large
				if(0 to 15)
					return /datum/wound/burn/moderate
	return null //no wound
