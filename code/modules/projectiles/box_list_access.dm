#define INSTANTIATION_HARD_LIMIT 500		//If you ave more than 500 rounds in a box your gun is not coded right and you need to rethink your life choices.
//ACCESS PROCS FOR STORED AMMO.
//Reason there's so many procs is because formats may change, and it may become more optimized to use certain ones over others.
//Always use the most specific one you can, as it'll be the most optimized. If you're getting the top casing, use x_top_casing(), NOT x_casing()
//Another example: If you're ejecting a casing, use EXPEND_CASING(), NOT RETURN_CASING. That'll generally be more optimized.
//Also, expend_casing() will try to gc the stored ammo list if possible. Again, DO NOT USE RETURN_CASING OR DIRECT LIST ACCESS TO /REMOVE/ CASINGS OR I WILL REPLACE YOUR EYES WITH LEMONS.

//As a further note, not all of these procs are as optimized as they could be. Anything that doesn't operate on the top casing is guarunteed to not be optimized. Maybe later!

/obj/item/ammo_box/proc/initialize_stored_ammo()
	if(isnull(default_ammo_left))
		default_ammo_left = space_left()

/obj/item/ammo_box/proc/default_return_casing()
	switch(default_fire_order)
		if(MAGAZINE_ORDER_FILO)
			return expend_top_casing()
		if(MAGAZINE_ORDER_FIFO)
			return expend_last_casing()

/obj/item/ammo_box/proc/default_expend_casing()
	switch(default_fire_order)
		if(MAGAZINE_ORDER_FILO)
			return expend_top_casing()
		if(MAGAZINE_ORDER_FIFO)
			return expend_last_casing()

/obj/item/ammo_box/proc/default_insert_casing(obj/item/ammu_casing/C)
	return insert_top_casing()

/obj/item/ammo_box/proc/return_top_casing()
	if(!LAZYLEN(_stored_ammo))
		//we'll have to instantiate since this is return, not expend.
		if(default_ammo_left <= 0)		//empty
			return
		_stored_ammo = list(instantiate_casing(ammo_type, src))
		default_ammo_left--
		return _stored_ammo[1]
	else
		var/obj/item/ammu_casing/C = _stored_ammo[1]
		if(istype(C))
			return C
		else if(ispath(C))
			_stored_ammo[1] = C = instantiate_casing(C, src)
			return C
		else
			CRASH("INVALID VALUE ([C]) IN STORED AMMO LIST!")
			_stored_ammo.Cut(1, 2)

/obj/item/ammo_box/proc/return_casing(index)
	force_instantiate_stored_list(TRUE)				//This is why you never ever use this when you can help it.
	if(index > LAZYLEN(_stored_ammo))
		return
	var/obj/item/ammu_casing/C = _stored_ammo[index]
	if(ispath(C))
		_stored_ammo[index] = C = instantiate_casing(C, src)
	return C

/obj/item/ammo_box/proc/return_last_casing()
	force_instantiate_stored_list(TRUE)				//This is why you never ever use this when you can help it.
	if(!LAZYLEN(_stored_ammo))
		return
	var/obj/item/ammu_casing/C = _stored_ammo[_stored_ammo.len]
	if(ispath(C))
		_stored_ammo[_stored_ammo.len = C = instantiate_casing(C, src)
	return C

/obj/item/ammo_box/proc/expend_top_casing()
	if(!LAZYLEN(_stored_ammo))
		//we'll have to instantiate only since this is return, not expend.
		if(default_ammo_left <= 0)		//empty
			return
		default_ammo_left--
		return instantiate_casing(ammo_type, src)
	else
		var/obj/item/ammu_casing/C = _stored_ammo[1]
		if(ispath(C))
			C = instantiate_casing(C, src)
		_stored_ammo.Cut(1, 2)
		UNSETEMPTY(_stored_ammo)
		return C

/obj/item/ammo_box/proc/expend_casing(index)
	if(!LAZYLEN(_stored_ammo))
		if(default_ammo_left > 0 && index <= default_ammo_left)
			default_ammo_left--
			. = instantiate_casing(ammo_type, src)
	if(index > _stored_ammo.len)		//doesn't exist, let's try creating the whole list.
		force_instantiate_stored_list(TRUE)				//This is why you never ever use this when you can help it.
		if(index > _stored_ammo.len)		//still doesn't exist.
			return
	. = _stored_ammo[index]
	_stored_ammo.Cut(index, index + 1)
	UNSETEMPTY(_stored_ammo)

/obj/item/ammo_box/proc/expend_last_casing()
	if(default_ammo_left > 0)
		default_ammo_left--
		return instantiate_casing(ammo_type, src)
	else if(LAZYLEN(_stored_ammo))
		var/obj/item/ammu_casing/C = _stored_ammo[_stored_ammo.len]
		if(ispath(C))
			C = instantiate_casing(C, src)
		. = C
		_stored_ammo.len--
		UNSETEMPTY(_stored_ammo)

//I guess these can be used with paths too..?
//THESE MANIPULATE THE LIST, THEY DON'T MOVE ANYTHING AROUND IN THE PHYSICAL GAME WORLD!!
/obj/item/ammo_box/proc/insert_top_casing(obj/item/ammu_casing/C, force = FALSE)
	if(space_left() <= 0 && !force)
		return FALSE
	LAZYINITLIST(_stored_ammo)
	_stored_ammo.Insert(1, C)
	return TRUE

/obj/item/ammo_box/proc/insert_casing(index, obj/item/ammu_casing/C, force = FALSE)
	if(space_left() <= 0 && !force)
		return FALSE
	LAZYINITLIST(_stored_ammo)
	if(index <= _stored_ammo.len)		//already can do this without more cpu usage
		_stored_ammo.Insert(index, C)
		return TRUE
	force_instantiate_stored_ammo(TRUE)			//otherwise..
	if(index > _stored_ammo.len)		//ok.
		_stored_ammo.Insert(0, C)
	else
		_stored_ammo.Insert(index, C)
	return TRUE

/obj/item/ammo_box/proc/insert_last_casing(obj/item/ammu_casing/C, force = FALSE)
	return insert_casing(INFINITY, C, force)

/obj/item/ammo_box/proc/replace_top_casing(obj/item/ammu_casing/C)
	return replace_casing(1, C)

//returns the old casing.
/obj/item/ammo_box/proc/replace_casing(index, obj/item/ammu_casing/C)
	if(index <= LAZYLEN(_stored_ammo))
		. = _stored_ammo[index]
		_stored_ammo[index] = C
	else
		force_instantiate_stored_ammo(TRUE)
		if(index > _stored_ammo.len)
			return
		. = _stored_ammo[index]
		_stored_ammo[index] = C

/obj/item/ammo_box/proc/replace_last_casing(obj/item/ammu_casing/C)
	force_instantiate_stored_ammo(TRUE)
	return replace_casing(_stored_ammo.len, C)

//Do not use this unnecessarily. This is for admins to get all rounds initialized for adminbus, or for purposes where you absolutely must have access to every index and do it often enough this offsets
//the memory costs of using this instead of the access procs.
//This will, however, ensure the list exists, even if empty, unless otherwise specified.
/obj/item/ammo_box/proc/force_initialize_stored_ammo(path_only = FALSE, unsetempty = FALSE)
	var/default_ammo_left = src.default_ammo_left
	if(default_ammo_left <= 0)
		return
	else if(default_ammo_left > INSTANTIATION_HARD_LIMIT)
		stack_trace("Something tried to instantiate more than 500 bullets at a time in [src]. Meaning whoever did this doesn't know what they're doing!")
		defualt_ammo_left = INSTANTIATION_HARD_LIMIT
	var/made = islist(_stored_ammo)
	if(!made)
		_stored_ammo = list()
	if(!_stored_ammo.len)
		_stored_ammo.len = default_ammo_left
		for(var/i in 1 to default_ammo_left)
			_stored_ammo[i] = path_only? ammo_type : instantiate_casing(ammo_type, src)
	else
		for(var/i in 1 to default_ammo_left)
			_stored_ammo.Insert(0, path_only? ammo_type : instantiate_casing(ammo_type, src))
	if(!path_only && !made)								//if we're not doing path only, also make sure all paths are instantiated.
		for(var/i in 1 to _stored_ammo.len)
			var/thing = _stored_ammo[i]
			if(ispath(thing))
				_stored_ammo[i] = instantiate_casing(thing, src)
	default_ammo_left = 0		//all expended.
	if(unsetempty)
		UNSETEMPTY(_stored_ammo)

/*													Can't do this, default_ammo_left wouldn't match. Welp. Maybe someone can figure this out.. later.
/obj/item/ammo_box/proc/initialize_to_index(index)
	if(index > max_ammo)
		CRASH("Index higher than max_ammo")
	LAZYINITLIST(_stored_ammo)
	_stored_ammo.len = max(_stored_ammo.len, index)
	for(var/i in 1 to index)
		if(istype(_stored_ammo[i], /obj/item/ammu_casing))
			continue
		else if(ispath(_stored_ammo[i]))
			_stored_ammo[i] = instantiate_casing(_stored_ammo[i], src)
			continue
		else if(_stored_ammo[i] == MAGAZINE_USE_COMPILETIME)
			for(var/I in i to index)
				if(default_ammo_left-- > 0)
					_stored_ammo[i] = instantiate_casing(ammo_type, src)
				else
					break
		else		//ehh the rest is null.
			_stored_ammo.len = i - 1
	if(default_ammo_left > 0)
		_stored_ammo.Insert(0, MAGAZINE_USE_COMPILETIME)			//still bullets left!
*/

/obj/item/ammo_box/proc/ammo_left(count_empty = MAGAZINE_COUNT_ALL)
	if(!LAZYLEN(_stored_ammo))
		return (count_empty == MAGAZINE_COUNT_EMPTY)? 0 : default_ammo_left
	if(count_empty == MAGAZINE_COUNT_ALL)
		return _stored_ammo.len + default_ammo_left
	else
		. = MAGAZINE_COUNT_LIVE? default_ammo_left : 0
		for(var/i in _stored_ammo)
			if(count_empty == MAGAZINE_COUNT_LIVE && ispath(i))
				.++
			else			//if this runtimes, not our fault someone messed the list up. It says DO NOT ACCESS!
				var/obj/item/ammu_casing/C = i
				if(count_empty == (C.is_spent()? MAGAZINE_COUNT_SPENT : MAGAZINE_COUNT_LIVE))
					.++

/obj/item/ammo_box/proc/get_index_first_spent()
	if(!LAZYLEN(_stored_ammo))
		return
	for(var/i in 1 to _stored_ammo.len)
		var/obj/item/ammu_casing/C = _stored_ammo[i]
		if(C.is_spent())
			return i

/obj/item/ammo_box/proc/get_indices_spent()
	. = list()
	if(!LAZYLEN(_stored_ammo))
		return
	for(var/i in 1 to _stored_ammo.len)
		var/obj/item/ammu_casing/C = _stored_ammo[i]
		if(C.is_spent())
			. += i


/obj/item/ammo_box/proc/space_left()
	if(!LAZYLEN(_stored_ammo))
		return max_ammo - default_ammo_left
	return max_ammo - (_stored_ammo.len + default_ammo_left)

//Do not auto vveditvar these.
/obj/item/ammo_box/proc/change_default_ammo_left(amt)
	if(!isnum(amt) || amt < 0)
		return FALSE
	default_ammo_left = CLAMP(amt, max_ammo - LAZYLEN(_stored_ammo), max_ammo)
	return TRUE

/obj/item/ammo_box/proc/change_max_ammo(amt)
	if(!isnum(amt) || amt < 0)
		return FALSE
	max_ammo = amt
	if(islist(_stored_ammo))
		_stored_ammo.len = min(amt, _stored_ammo.len)
	default_ammo_left = CLAMP(default_ammo_left, max_ammo - LAZYLEN(_stored_ammo), max_ammo)
	return TRUE
