/**
 * holder datum for loot packs
 * can be used alone or in loot tables
 */
/datum/prototype/loot_pack
	anonymous = TRUE
	namespace = "LootPack"
	abstract_type = /datum/prototype/loot_pack
	/// items that always spawn associated to amount (defaulting to 1)
	var/list/always
	/// items that are associated to chance; nulls are allowed.
	var/list/some
	/// standard amount for the "some" list when none is provided
	var/amt = 0

	// todo: amt high, amt low

	/// cached tally of some
	var/cached_tally

/**
 * get list of paths associated to amounts
 * association can be 0 or null, in that case, process it on *YOUR END* to be 1!
 *
 * this is not deterministic unless the pack itself is deterministic
 */
/datum/prototype/loot_pack/proc/flatten(amount = amt)
	SHOULD_NOT_OVERRIDE(TRUE)
	var/list/intrinsic = always?.Copy() || list()
	var/list/extra = draw(amount)
	for(var/thing in extra)
		intrinsic[thing] = extra[thing] + intrinsic[thing]
	return intrinsic

/datum/prototype/loot_pack/proc/cache_tally()
	SHOULD_NOT_OVERRIDE(TRUE)
	. = 0
	for(var/thing in some)
		. += some[thing] || 1
	cached_tally = .

/**
 * get x random amount of "some"
 */
/datum/prototype/loot_pack/proc/draw(amount)
	if(amount == 1)
		. = list()
		var/got = draw_single()
		// we don't use list(got = 1) because byond will break if we do that :/
		if(got)
			.[got] = 1
		return
	return draw_multi(amount)

/datum/prototype/loot_pack/proc/draw_single()
	SHOULD_NOT_OVERRIDE(TRUE)
	var/total = cached_tally || cache_tally()
	var/rng = rand(1, total)
	for(var/thing in some)
		rng -= some[thing] || 1
		if(rng <= 0)
			return thing

/datum/prototype/loot_pack/proc/draw_multi(amt)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(amt <= 5)
		// too small to justify the binary insert
		. = list()
		for(var/i in 1 to amt)
			var/got = draw_single()
			if(got)
				. += got
		return
	var/total = cached_tally || cache_tally()
	var/list/to_pick = list()
	var/left
	var/right
	var/mid
	// insert first
	to_pick += rand(1, total)
	var/to_pick_len = 1
	for(var/i in 2 to amt)
		var/rng = rand(1, total)
		// binary insert
		left = 1
		right = to_pick_len
		mid = (left + right) >> 1
		while(left < right)
			if(to_pick[mid] <= rng)
				left = mid + 1
			else
				right = mid
			mid = (left + right) >> 1
		mid = to_pick[mid] > rng? mid : mid + 1
		to_pick.Insert(mid, rng)
		to_pick_len++
	// to_pick is low to high
	// pick algorithm: go from low to high, tallying; anything above something = spawn.
	var/current = 0
	. = list()
	var/to_pick_pointer = 1
	for(var/thing in some)
		current += some[thing] || 1
		for(var/i in to_pick_pointer to to_pick_len)
			if(to_pick[i] <= current)
				if(thing)
					.[thing] += 1
				// move past
				++to_pick_pointer
				continue
			// too big, break and tick up
			break
/**
 * are we deterministic?
 */
/datum/prototype/loot_pack/proc/is_deterministic()
	return !amt

/**
 * spawn always at
 */
/datum/prototype/loot_pack/proc/instantiate(atom/location, amount = amt)
	var/safety = 50 // no way you ever need more than this. if you think you do, rethink.
	var/list/got = flatten(amount)
	for(var/path in got)
		var/making = got[path] || 1
		if(ispath(path, /obj/item/stack))
			new path(location, making)
		else
			for(var/i in 1 to making)
				if(!--safety)
					CRASH("attempted to spawn more than 50 objects")
				new path(location)

/**
 * with a list of types, does a no-holds-barred drawing from them
 *
 * the only restriction is not spawning abstract_type objets.
 * if an abstract type is picked, this just goes forwards without refunding.
 */
/datum/prototype/loot_pack/proc/chaotic_draw(list/paths, amount = 1)
	. = list()
	for(var/i in 1 to amount)
		var/datum/got = pick(paths)
		if(initial(got.abstract_type) == got)
			continue // just skip
		.[got] += 1
