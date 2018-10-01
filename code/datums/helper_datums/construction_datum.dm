<<<<<<< HEAD
#define FORWARD -1
#define BACKWARD 1

/datum/construction
	var/list/steps
	var/atom/holder
	var/result
	var/list/steps_desc

	New(atom)
		..()
		holder = atom
		if(!holder) //don't want this without a holder
			spawn
				qdel(src)
		set_desc(steps.len)
		return

	proc/next_step()
		steps.len--
		if(!steps.len)
			spawn_result()
		else
			set_desc(steps.len)
		return

	proc/action(atom/used_atom,mob/user as mob)
		return

	proc/check_step(atom/used_atom,mob/user as mob) //check last step only
		var/valid_step = is_right_key(used_atom)
		if(valid_step)
			if(custom_action(valid_step, used_atom, user))
				next_step()
				return 1
		return 0

	proc/is_right_key(atom/used_atom) // returns current step num if used_atom is of the right type.
		var/list/L = steps[steps.len]
		if(istype(used_atom, L["key"]))
			return steps.len
		return 0

	proc/custom_action(step, used_atom, user)
		return 1

	proc/check_all_steps(atom/used_atom,mob/user as mob) //check all steps, remove matching one.
		for(var/i=1;i<=steps.len;i++)
			var/list/L = steps[i];
			if(istype(used_atom, L["key"]))
				if(custom_action(i, used_atom, user))
					steps[i]=null;//stupid byond list from list removal...
					listclearnulls(steps);
					if(!steps.len)
						spawn_result()
					return 1
		return 0


	proc/spawn_result()
		if(result)
			new result(get_turf(holder))
			spawn()
				qdel(holder)
		return

	proc/set_desc(index as num)
		var/list/step = steps[index]
		holder.desc = step["desc"]
		return

/datum/construction/reversible
	var/index

	New(atom)
		..()
		index = steps.len
		return

	proc/update_index(diff as num)
		index+=diff
		if(index==0)
			spawn_result()
		else
			set_desc(index)
		return

	is_right_key(atom/used_atom) // returns index step
		var/list/L = steps[index]
		if(istype(used_atom, L["key"]))
			return FORWARD //to the first step -> forward
		else if(L["backkey"] && istype(used_atom, L["backkey"]))
			return BACKWARD //to the last step -> backwards
		return 0

	check_step(atom/used_atom,mob/user as mob)
		var/diff = is_right_key(used_atom)
		if(diff)
			if(custom_action(index, diff, used_atom, user))
				update_index(diff)
				return 1
		return 0

	custom_action(index, diff, used_atom, user)
		return 1
=======
#define FORWARD -1
#define BACKWARD 1


// As of August 4th, 2018, these datums are only used in Mech construction.
/datum/construction
	var/list/steps
	var/atom/holder
	var/result
	var/list/steps_desc

/datum/construction/New(atom)
	..()
	holder = atom
	if(!holder) //don't want this without a holder
		spawn
			qdel(src)
	set_desc(steps.len)
	return

/datum/construction/proc/next_step()
	steps.len--
	if(!steps.len)
		spawn_result()
	else
		set_desc(steps.len)
	return

/datum/construction/proc/action(var/obj/item/I,mob/user as mob)
	return

/datum/construction/proc/check_step(var/obj/item/I,mob/user as mob) //check last step only
	var/valid_step = is_right_key(I)
	if(valid_step)
		if(custom_action(valid_step, I, user))
			next_step()
			return 1
	return 0

/datum/construction/proc/is_right_key(var/obj/item/I) // returns current step num if I is of the right type.
	var/list/L = steps[steps.len]
	switch(L["key"])
		if(IS_SCREWDRIVER)
			if(I.is_screwdriver())
				return steps.len
		if(IS_CROWBAR)
			if(I.is_crowbar())
				return steps.len
		if(IS_WIRECUTTER)
			if(I.is_wirecutter())
				return steps.len
		if(IS_WRENCH)
			if(I.is_wrench())
				return steps.len

	if(istype(I, L["key"]))
		return steps.len
	return 0

/datum/construction/proc/custom_action(step, I, user)
	return 1

/datum/construction/proc/check_all_steps(var/obj/item/I,mob/user as mob) //check all steps, remove matching one.
	for(var/i=1;i<=steps.len;i++)
		var/list/L = steps[i];
		if(istype(I, L["key"]))
			if(custom_action(i, I, user))
				steps[i]=null;//stupid byond list from list removal...
				listclearnulls(steps);
				if(!steps.len)
					spawn_result()
				return 1
	return 0


/datum/construction/proc/spawn_result()
	if(result)
		new result(get_turf(holder))
		spawn()
			qdel(holder)
	return

/datum/construction/proc/set_desc(index as num)
	var/list/step = steps[index]
	holder.desc = step["desc"]
	return


// Reversible
/datum/construction/reversible
	var/index

/datum/construction/reversible/New(atom)
	..()
	index = steps.len
	return

/datum/construction/reversible/proc/update_index(diff as num)
	index+=diff
	if(index==0)
		spawn_result()
	else
		set_desc(index)
	return

/datum/construction/reversible/is_right_key(var/obj/item/I) // returns index step
	var/list/L = steps[index]

	switch(L["key"])
		if(IS_SCREWDRIVER)
			if(I.is_screwdriver())
				return FORWARD
		if(IS_CROWBAR)
			if(I.is_crowbar())
				return FORWARD
		if(IS_WIRECUTTER)
			if(I.is_wirecutter())
				return FORWARD
		if(IS_WRENCH)
			if(I.is_wrench())
				return FORWARD

	switch(L["backkey"])
		if(IS_SCREWDRIVER)
			if(I.is_screwdriver())
				return BACKWARD
		if(IS_CROWBAR)
			if(I.is_crowbar())
				return BACKWARD
		if(IS_WIRECUTTER)
			if(I.is_wirecutter())
				return BACKWARD
		if(IS_WRENCH)
			if(I.is_wrench())
				return BACKWARD

	if(istype(I, L["key"]))
		return FORWARD //to the first step -> forward
	else if(L["backkey"] && istype(I, L["backkey"]))
		return BACKWARD //to the last step -> backwards
	return 0

/datum/construction/reversible/check_step(var/obj/item/I,mob/user as mob)
	var/diff = is_right_key(I)
	if(diff)
		if(custom_action(index, diff, I, user))
			update_index(diff)
			return 1
	return 0

/datum/construction/reversible/custom_action(index, diff, I, user)
	return 1
>>>>>>> b8f240f... Merge pull request #4282 from VOREStation/sync-09272018
