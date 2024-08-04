#define RAD_AMOUNT_LOW 50
#define RAD_AMOUNT_MEDIUM 200
#define RAD_AMOUNT_HIGH 500
#define RAD_AMOUNT_EXTREME 1000

/datum/component/radioactive
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	registered_type = /datum/component/radioactive

	/// half life in deciseconds
	var/hl3_release_date
	var/strength
	var/can_contaminate
	/// distance falloff
	var/falloff = RAD_FALLOFF_CONTAMINATION_NORMAL

/datum/component/radioactive/Initialize(_strength=0, _half_life = RAD_HALF_LIFE_DEFAULT, _can_contaminate = TRUE, falloff)
	strength = _strength
	hl3_release_date = _half_life
	can_contaminate = _can_contaminate
	if(falloff)
		src.falloff = falloff

	if(istype(parent, /atom))
		RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(rad_examine))
		// if(istype(parent, /obj/item))
		// 	RegisterSignal(parent, COMSIG_ITEM_ATTACK, PROC_REF(rad_attack))
		// 	RegisterSignal(parent, COMSIG_ITEM_ATTACK_OBJ, PROC_REF(rad_attack))
	else
		. = COMPONENT_INCOMPATIBLE
		CRASH("Something that wasn't an atom was given /datum/component/radioactive")

	if(strength > RAD_MINIMUM_CONTAMINATION)
		SSradiation.warn(src)

	//Let's make er glow
	//This relies on parent not being a turf or something. IF YOU CHANGE THAT, CHANGE THIS
	var/atom/movable/master = parent
	master.add_filter("rad_glow", 2, list("type" = "outline", "color" = "#14fff714", "size" = 2))
	addtimer(CALLBACK(src, PROC_REF(glow_loop), master), rand(1,19))//Things should look uneven
	SSradiation.sources += src

/datum/component/radioactive/Destroy()
	SSradiation.sources -= src
	var/atom/movable/master = parent
	master.remove_filter("rad_glow")
	return ..()

/datum/component/radioactive/proc/emit(ds)
	if(!prob(50))
		return
	if(!hl3_release_date)
		radiation_pulse(parent, strength, falloff, FALSE, can_contaminate)
		return
	// strength -= (1 / 2) ** ((ds) / RAD_HALF_LIFE_DEFAULT
	var/becoming = strength * ((1 / 2) ** (ds / (hl3_release_date)))
	radiation_pulse(parent, (strength - becoming) * RAD_CONTAMINATION_CHEAT_FACTOR, falloff, FALSE, can_contaminate)
	strength = becoming
	if(strength <= RAD_BACKGROUND_RADIATION)
		addtimer(CALLBACK(src, PROC_REF(check_dissipate)), 5 SECONDS)
		SSradiation.sources -= src

/datum/component/radioactive/proc/check_dissipate()
	if(strength <= RAD_BACKGROUND_RADIATION)
		qdel(src)
		return
	if(!(datum_flags & DF_ISPROCESSING))	// keep going
		SSradiation.sources += src

/datum/component/radioactive/proc/glow_loop(atom/movable/master)
	var/filter = master.get_filter("rad_glow")
	if(filter)
		animate(filter, alpha = 75, time = 15, loop = -1)
		animate(alpha = 25, time = 25)

/datum/component/radioactive/InheritComponent(datum/component/C, i_am_original, _strength, _source, _half_life, _can_contaminate)
	if(!i_am_original)
		return
	if(C)
		var/datum/component/radioactive/other = C
		constructive_interference(other.strength, other.strength)
	else
		constructive_interference(_strength, _strength)

/**
 * returns amount added
 */
/datum/component/radioactive/proc/constructive_interference(limit, amt)
	// permanent ones shouldn't
	if(!hl3_release_date)
		return 0
	. = min(amt, limit - strength)
	if(. < 0)
		return 0
	strength += .

/datum/component/radioactive/proc/rad_examine(datum/source, mob/user, list/examine_list)
	var/atom/master = parent
	var/list/out = list()
	if(get_dist(master, user) <= 1)
		out += "The air around [master] feels warm"
	switch(strength)
		if(RAD_AMOUNT_LOW to RAD_AMOUNT_MEDIUM)
			out += "[out ? " and it " : "[master] "]feels weird to look at."
		if(RAD_AMOUNT_MEDIUM to RAD_AMOUNT_HIGH)
			out += "[out ? " and it " : "[master] "]seems to be glowing a bit."
		if(RAD_AMOUNT_HIGH to INFINITY) //At this level the object can contaminate other objects
			out += "[out ? " and it " : "[master] "]hurts to look at."
	if(!LAZYLEN(out))
		return
	out += "."
	examine_list += out.Join()

/datum/component/radioactive/proc/rad_attack(datum/source, atom/movable/target, mob/living/user)
	emit(1 SECONDS)

/datum/component/radioactive/proc/clean(str, mul)
	strength -= strength * mul + str
	if(strength < RAD_BACKGROUND_RADIATION)
		qdel(src)

#undef RAD_AMOUNT_LOW
#undef RAD_AMOUNT_MEDIUM
#undef RAD_AMOUNT_HIGH
#undef RAD_AMOUNT_EXTREME
