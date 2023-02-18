/**
 * holder datum for loot
 */
/datum/prototype/loot_table
	anonymous = TRUE
	namespace = "LootTable"

	/// paths of either /atom/movable's or /datum/prototype/loot_pack's to chance
	/// string ids will be treated as loot pack prototype ids.
	/// * null's in chance will be treated as 1.
	/// * for performance, putting large chances first is best.
	var/list/contents
	/// cached amount of all probabilities
	var/cached_tally

/**
 * draw amount
 *
 * returns typepaths, loot table typepaths, or identifiers, associated to amount.
 */
/datum/prototype/loot_table/proc/draw(amount)
	if(amount == 1)
		return list(draw_single() = 1)
	return draw_multi(amount)

/**
 * draw amount, converts to typepaths for spawning
 */
/datum/prototype/loot_table/proc/draw_and_resolve(amount)
	. = list()
	var/list/drawn = draw(amount)
	for(var/thing in drawn)
		if(ispath(thing, /datum/prototype/loot_pack) || istext(thing))
			var/datum/prototype/loot_pack/resolved = SSrepository.fetch(thing)
			var/multiplier = drawn[thing]
			if(!istype(resolved))
				CRASH("invalid resolution of [thing]: [resolved]")
			var/list/paths = resolved.flatten()
			for(var/path in paths)
				.[path] = paths[path] * multiplier + .[path]
		else if(ispath(thing, /atom/movable))
			.[thing] = drawn[thing] + .[thing]

/datum/prototype/loot_table/proc/cache_tally()
	. = 0
	for(var/thing in contents)
		. += contents[thing] || 1
	cached_tally = .

/datum/prototype/loot_table/proc/draw_single()
	var/total = cached_tally || cache_tally()
	var/rng = rand(1, total)
	for(var/thing in contents)
		rng -= contents[thing] || 1
		if(rng <= 0)
			return thing

/datum/prototype/loot_table/proc/draw_multi(amt)
	if(amt <= 5)
		// too small to justify the binary insert
		. = list()
		for(var/i in 1 to amt)
			. += draw_single()
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
	for(var/thing in contents)
		current += contents[thing] || 1
		for(var/i in to_pick_pointer to to_pick_len)
			if(to_pick[i] <= current)
				.[thing] += 1
				// move past
				++to_pick_pointer
				continue
			// too big, break and tick up
			break

/**
 * spawn contents at
 */
/datum/prototype/loot_table/proc/instantiate(atom/location, amt)
	var/list/got = draw(amt)
	var/safety = 75 // there's no way you need more than this
	for(var/thing in got)
		var/making = got[thing]
		if(ispath(thing, /obj/item/stack))
			new thing(location, making)
		else if(ispath(thing, /datum/prototype/loot_pack) || istext(thing))
			var/datum/prototype/loot_pack/pack = SSrepository.fetch(thing)
			if(!pack)
				stack_trace("failed to fetch pack for [thing]")
				continue
			if(!--safety)
				CRASH("attempted to spawn more than 75 objects")
			pack.instantiate(location)
		else
			for(var/i in 1 to making)
				if(!--safety)
					CRASH("attempted to spawn more than 75 objects")
				new thing(location)
