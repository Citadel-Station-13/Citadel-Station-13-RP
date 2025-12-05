/datum/holiday/friday_thirteen
	name = HOLIDAY_FRIDAY_THIRTEEN
	desc = "Friday the 13th is a superstitious day, associated with bad luck and misfortune."
	priority = 1

/datum/holiday/friday_thirteen/ShouldCelebrate(dd, mm, yy, ww, ddd)
	return dd == 13 && ddd == "Friday"
