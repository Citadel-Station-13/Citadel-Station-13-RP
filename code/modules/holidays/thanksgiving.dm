/datum/holiday/thanksgiving
	name = HOLIDAY_THANKSGIVING
	desc = "Originally an old holiday from Earth, Thanksgiving follows many of the \
					traditions that its predecessor did, such as having a large feast (turkey often included), gathering with family, and being thankful \
					for what one has in life."

/datum/holiday/thanksgiving/ShouldCelebrate(dd, mm, yy, ww, ddd)
	return dd < 28 && dd > 20 && ddd == "Thursday"
