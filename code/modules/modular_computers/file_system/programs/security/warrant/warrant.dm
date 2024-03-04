/datum/datacore
	var/list/warrants = list()

/datum/data/record/warrant
	var/warrant_id
	var/static/warrant_uid = 0

/datum/data/record/warrant/New()
	..()
	warrant_id = warrant_uid++
