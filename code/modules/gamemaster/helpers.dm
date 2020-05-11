// Tell the game master that something dangerous happened, e.g. someone dying.
/datum/controller/subsystem/gamemaster/proc/adjust_danger(var/amt)
	amt = amt * danger_modifier
	danger = round( CLAMP(danger + amt, 0, 1000), 0.1)

// Tell the game master that something interesting happened.
/datum/controller/subsystem/gamemaster/proc/adjust_staleness(var/amt)
	amt = amt * staleness_modifier
	staleness = round( CLAMP(staleness + amt, -50, 200), 0.1)