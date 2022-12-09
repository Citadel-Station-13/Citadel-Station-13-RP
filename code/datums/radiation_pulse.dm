/datum/radiation_burst
	/// numbers of emitters we're from
	var/emitter_count = 1
	/// intensity
	var/intensity
	/// falloff
	var/falloff
	/// max intensity
	var/highest

/datum/radiation_burst/New(intensity, falloff)
	src.intensity = src.highest = intensity
	src.falloff = falloff

/datum/radiation_pulse
	/// source
	var/turf/source
	/// falloff
	var/falloff
	/// casted lines - linked list
	var/datum/radiation_line/line_head
	/// remaining contamination
	var/remaining_contamination
	/// starting intensity
	var/original_intensity
	/// highest intensity in batch
	var/highest_intensity
	/// current intensity
	var/current
	/// current steps
	var/steps = 0
	/// emitter count in batch that are above radiation mob minimum/background
	var/emitter_count
	/// can we contaminate
	var/no_contaminate
	/// diagonal edges, cached by outermost and set to their intensities
	var/list/turf/diagonal_edges

/datum/radiation_pulse/New(turf/T, intensity, falloff, highest, count, can_contaminate = TRUE, remaining_contamination)
	src.source = T
	src.falloff = falloff
	src.original_intensity = src.current = intensity
	src.highest_intensity = highest || intensity
	src.emitter_count = count || 1
	src.no_contaminate = !can_contaminate
	src.remaining_contamination = intensity || remaining_contamination
	init()
	START_PROCESSING(SSradiation, src)

/datum/radiation_pulse/Destroy()
	SHOULD_CALL_PARENT(FALSE)
	STOP_PROCESSING(SSradiation, src)
	var/datum/radiation_line/line = line_head
	while(line)
		line.parent = null
		line.prev = null
		line = line.next
		// todo: comment this line when we're sure it'll work
		qdel(line)
	diagonal_edges = null
	return QDEL_HINT_QUEUE
	// return QDEL_HINT_IWILLGC

/datum/radiation_pulse/proc/init()
	ASSERT(source)
	diagonal_edges = list()
	var/starting_insulation = init_radiate(source)
	var/str = original_intensity
	var/datum/radiation_line/line
	line = new
	line_head = line
	line.dir = NORTH
	line.outer = TRUE
	line.current = source
	line.parent = src
	line.d1 = EAST
	line.d2 = WEST
	line.strength = str
	line.insulation = starting_insulation
	line.next = new
	line.next.prev = line
	line = line.next
	line.dir = SOUTH
	line.outer = TRUE
	line.current = source
	line.parent = src
	line.d1 = EAST
	line.d2 = WEST
	line.strength = str
	line.insulation = starting_insulation
	line.next = new
	line.next.prev = line
	line = line.next
	line.dir = EAST
	line.outer = TRUE
	line.current = source
	line.parent = src
	line.d1 = NORTH
	line.d2 = SOUTH
	line.strength = str
	line.insulation = starting_insulation
	line.next = new
	line.next.prev = line
	line = line.next
	line.dir = WEST
	line.outer = TRUE
	line.current = source
	line.parent = src
	line.d1 = NORTH
	line.d2 = SOUTH
	line.strength = str
	line.insulation = starting_insulation

/**
 * return insulation
 */
/datum/radiation_pulse/proc/init_radiate(turf/T)
	. = 1
	for(var/atom/movable/AM as anything in T)
		. *= AM.rad_insulation
		AM.irradiate(original_intensity, src)

/datum/radiation_pulse/proc/turf_radiate(turf/T, power)
	for(var/atom/movable/AM as anything in T)
		AM.irradiate(power, src)

/datum/radiation_pulse/process()
	propagate()

/datum/radiation_pulse/proc/propagate()
	var/datum/radiation_line/head = line_head
	if(!head)
		qdel(src)
		return
	++steps
	current = INVERSE_SQUARE(original_intensity, steps * falloff, 1)
	while(head)
		if(!head.current)
			head.next.prev = head.prev
			head.prev.next = head.next
			head = head.next
			continue
		head.propagate()
		head = head.next
	for(var/turf/T as anything in diagonal_edges)
		var/power = diagonal_edges[T]
		turf_radiate(T, power)
	diagonal_edges.len = 0

/datum/radiation_line
	/// current turf
	var/turf/current
	/// parent pulse
	var/datum/radiation_pulse/parent
	/// direction
	var/dir
	/// dir to split in
	var/d1
	/// dir to split in
	var/d2
	/// are we outermost?
	var/outer = FALSE
	/// strength
	var/strength
	/// next line
	var/datum/radiation_line/next
	/// prev line
	var/datum/radiation_line/prev
	/// current insulation
	var/insulation = 1

/datum/radiation_line/Destroy()
	SHOULD_CALL_PARENT(FALSE)
	return QDEL_HINT_QUEUE

/datum/radiation_line/proc/propagate()
	if(!current)
		CRASH("no current")
	// order:
	// 1. stage outer turf if needed
	// 2. radiate current turf
	//? sike; 1/2 swapped so insulation protects outer.
	// 3. falloff
	// 4. move forwards
	// 5. split if outer
	radiate(current, strength)
	if(outer)
		// stage
		var/turf/staging
		var/existing
		var/list/staged = parent.diagonal_edges
		if(d1)
			staging = get_step(current, d1)
			existing = staged[staging]
			staged[staging] = clamp(existing + strength * 0.75, existing, max(strength, existing))
		if(d2)
			staging = get_step(current, d2)
			existing = staged[staging]
			staged[staging] = clamp(existing + strength * 0.75, existing, max(strength, existing))
		// falloff
		strength = insulation * parent.current
		// move
		current = get_step(current, dir)
		// split
		split()
	else
		// falloff
		strength = insulation * parent.current
		// just move
		current = get_step(current, dir)

/datum/radiation_line/proc/split(outer_split)
	var/turf/splitting
	var/datum/radiation_line/split
	// we inject them behind us so we don't intsantly propagate
	if(d1)
		splitting = get_step(current, d1)
		split = new /datum/radiation_line
		split.current = splitting
		split.dir = dir
		split.d1 = d1
		split.outer = TRUE
		split.strength = strength
		split.insulation = insulation
		split.parent = parent
		prev?.next = split
		split.prev = prev
		split.next = src
		prev = split
	if(d2)
		splitting = get_step(current, d2)
		split = new /datum/radiation_line
		split.current = splitting
		split.dir = dir
		split.d2 = d2
		split.outer = TRUE
		split.strength = strength
		split.insulation = insulation
		split.parent = parent
		prev?.next = split
		split.prev = prev
		split.next = src
		prev = split

/datum/radiation_line/proc/radiate(turf/T, str)
	// cache
	var/datum/radiation_pulse/pulse = parent
	insulation *= T.rad_insulation
	T.rad_act(str, pulse)
	for(var/atom/movable/AM as anything in T)
		insulation *= AM.rad_insulation
		AM.irradiate(str, pulse)

/**
 * returns amount contaminated
 */
/atom/proc/irradiate(amount, datum/radiation_pulse/pulse)
	rad_act(amount, pulse)
	if(rad_flags & RAD_BLOCK_CONTENTS)
	else
		for(var/atom/A as anything in contents)
			A.irradiate(amount, pulse)
	if(rad_flags & RAD_NO_CONTAMINATE)
	else
		var/contamination = max(0, min(amount, pulse.highest_intensity) * RAD_CONTAMINATION_STR_COEFFICIENT - RAD_CONTAMINATION_STR_ADJUST) * rad_stickiness
		if(contamination)
			var/datum/component/radioactive/R = GetComponent(/datum/component/radioactive)
			if(R)
				R.constructive_interference(contamination)
			else
				AddComponent(/datum/component/radioactive, contamination)
