SUBSYSTEM_DEF(sun)
	name = "Sun"
	wait = 1 MINUTE
	var/static/datum/sun/sun = new

/datum/controller/subsystem/sun/fire()
	sun.calc_position()
