/datum/radiation_pulse
	/// source
	var/turf/source
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

/datum/radiation_pulse/New(intensity, highest, count, can_contaminate = TRUE, remaining_contamination)
	src.original_intensity = intensity
	src.highest_intensity = highest || intensity
	src.emitter_count = count || 1
	src.no_contaminate = !can_Contaminate
	src.remaining_contamination = intensity || remaining_contamination
	init()
	START_PROCESSING(SSradiation, src)

/datum/radiation_pulse/Destroy()
	STOP_PROCESSING(SSradiation, src)
	QDEL_NULL(line_head)
	diagonal_edges = null
	return QDEL_HINT_QUEUE
	// return QDEL_HINT_IWILLGC

/datum/radiation_pulse/proc/init()
	lines = list()
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
	prev = null
	parent = null
	qdel(next)
	next = null
	return QDEL_HINT_QUEUE
	// return QDEL_HINT_IWILLGC

/datum/radiation_line/proc/propagate()
	if(!current)

	radiate(current)
	current = get_step(current, dir)

/datum/radiation_line/proc/radiate(turf/T)

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
