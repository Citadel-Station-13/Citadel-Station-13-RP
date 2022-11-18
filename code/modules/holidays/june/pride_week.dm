/datum/holiday/pride_week
	name = PRIDE_WEEK
	begin_month = JUNE
	// Stonewall was June 28th, this captures its week.
	begin_day = 23
	end_day = 29

	var/static/list/rainbow_colors = list(
		COLOR_PRIDE_PURPLE,
		COLOR_PRIDE_BLUE,
		COLOR_PRIDE_GREEN,
		COLOR_PRIDE_YELLOW,
		COLOR_PRIDE_ORANGE,
		COLOR_PRIDE_RED,
	)

/// Given an atom, will return what color it should be to match the pride flag.
/datum/holiday/pride_week/proc/get_floor_tile_color(atom/atom)
	var/turf/turf = get_turf(atom)
	return rainbow_colors[(turf.y % rainbow_colors.len) + 1]
