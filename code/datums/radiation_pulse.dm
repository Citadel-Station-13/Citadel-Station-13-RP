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
	/// emitter count in batch that are above radiation mob minimum/background
	var/emitter_count
	/// can we contaminate
	var/no_contaminate
	/// diagonal edges, cached by outermost and set to their intensities
	var/list/turf/diagonal_edges

/datum/radiation_pulse/New(turf/T, intensity, falloff, highest, count, can_contaminate = TRUE, remaining_contamination)
	src.source = T
	src.falloff = falloff
	src.original_intensity = intensity
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
	diagonal_edges = list()

/**
 * return insulation
 */
/datum/radiation_pulse/proc/init_radiate(turf/T)
	. = 1

/datum/radiation_pulse/proc/turf_radiate(turf/T, power)

/datum/radiation_pulse/process()
	propagate()

/datum/radiation_pulse/proc/propagate()
	var/datum/radiation_line/head = line_head
	if(!head)
		qdel(src)
		return
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

/datum/radiation_line/Destroy()
	SHOULD_CALL_PARENT(FALSE)
	return QDEL_HINT_QUEUE

/datum/radiation_line/proc/propagate()
	if(!current)
		CRASH("no current")
	// order:
	// 1. stage outer turf if needed
	// 2. radiate current turf
	// 3. falloff
	// 4. split if outer
	radiate(current, strength)
	if(outer)
		outer--
		if(!outer)
			split(TRUE)
	current = get_step(current, dir)

/datum/radiation_line/proc/split(outer_split)
	var/turf/splitting
	var/datum/radiation_line/split
	if(d1)
		splitting = get_step(current, d1)
		split = new /datum/radiation_line
		split.current = splitting
		split.dir = dir
		split.d1 = d1
		split.outer = outer_split?
		split.strength = strength
		split.prev = src
		split.next = next
		next = split
	if(d2)
		splitting = get_step(current, d2)
		split = new /datum/radiation_line
		split.current = splitting
		split.dir = dir
		split.d2 = d2
		split.outer = outer
		split.strength = strength
		split.prev = src
		split.next = next
		next = split

/datum/radiation_line/proc/radiate(turf/T, str)
	// cache
	var/datum/radiation_pulse/pulse = parent
	T.rad_act(str, pulse)
	for(var/atom/movable/AM as anything in T)
		AM.irradiate(str, pulse)

/**
 * returns amount contaminated
 */
/atom/proc/irradiate(amount, datum/radiation_line/line)
	rad_act(amount, line)
	if(rad_flags & RAD_BLOCK_CONTENTS)
	else
		for(var/atom/A as anything in contents)
			A.irradiate(amount, line)
	if(rad_flags & RAD_NO_CONTAMINATE)
	else
		var/contamination = max(0, amount * RAD_CONTAMINATION_STR_COEFFICIENT - RAD_CONTAMINATION_STR_ADJUST)
		if(contamination)
			var/datum/component/radioactive/R = GetComponent(/datum/component/radioactive)
			if(R)
				R.constructive_interference(contamination)
			else
				AddComponent(/datum/component/radioactive, contamination)
