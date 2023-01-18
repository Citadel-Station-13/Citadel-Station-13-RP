// todo: refactor _job.dm
/datum/controller/subsystem/job

/datum/controller/subsystem/job/proc/job_by_id(id)
	RETURN_TYPE(/datum/job)
	return job_lookup[id]

/datum/controller/subsystem/job/proc/job_by_type(path)
	RETURN_TYPE(/datum/job)
	return type_occupations[path]

// todo: this should not be used most of the time, id/type is better
/datum/controller/subsystem/job/proc/job_by_title(title)
	RETURN_TYPE(/datum/job)
	return name_occupations[title]

/datum/controller/subsystem/job/proc/all_job_ids(faction)
	RETURN_TYPE(/list)
	. = list()
	if(faction)
		for(var/datum/job/J as anything in occupations)
			if(J.faction != faction)
				continue
			. += J.id
	else
		for(var/id as anything in job_lookup)
			. += id

/datum/controller/subsystem/job/proc/all_job_types(faction)
	RETURN_TYPE(/list)
	. = list()
	if(faction)
		for(var/datum/job/J as anything in occupations)
			if(J.faction != faction)
				continue
			. += J.type
	else
		for(var/path as anything in type_occupations)
			. += path

// todo: avoid doing this where possible, id/type is better
/datum/controller/subsystem/job/proc/all_job_titles(faction)
	RETURN_TYPE(/list)
	. = list()
	if(faction)
		for(var/datum/job/J as anything in occupations)
			if(J.faction != faction)
				continue
			. += J.title
	else
		for(var/title as anything in name_occupations)
			. += title

/datum/controller/subsystem/job/proc/all_jobs(faction)
	RETURN_TYPE(/list)
	. = list()
	if(faction)
		for(var/datum/job/J as anything in occupations)
			if(J.faction != faction)
				continue
			. += J
	else
		for(var/datum/job/J as anything in occupations)
			. += J
