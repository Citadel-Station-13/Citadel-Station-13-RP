/datum/holiday/easter
	name = HOLIDAY_EASTER
	desc = ""
	priority = 1

/datum/holiday/easter/ShouldCelebrate(dd, mm, yy, ww, ddd)
	var/a = yy % 19
	var/b = yy % 4
	var/c = yy % 7
	var/k = floor(yy/100)
	var/p = floor((13+8*k)/25)
	var/q = floor(k/4)
	var/m = (15-p+k-q) % 30
	var/n = (4+k-q) % 7
	var/d = (19*a + m) % 30
	var/e = (2*b + 4*c + 6*d + n) % 7

	var/x = d+e+22
	if(x < 32)
		return mm == 3 && dd == x
	return mm == 4 && dd == (d+e-9)
