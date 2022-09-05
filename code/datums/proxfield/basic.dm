/datum/proxfield/basic

/datum/proxfield/basic/square
	/// radius
	var/radius = 3

/datum/proxfield/basic/square/Init(radius)
	if(isnum(radius))
		if(radius < 0 || radius > 7)
			stack_trace("invalid radius")
			radius = clamp(radius, 0, 7)
		src.radius = radius
	else
		stack_trace("no radius number")
	return ..()

/datum/proxfield/basic/square/Turfs()
	#warn impl
