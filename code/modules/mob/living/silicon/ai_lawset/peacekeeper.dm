/datum/ai_lawset/peacekeeper
	name = "Peacekeeper"
	law_header = "Peacekeeping Protocols"
	selectable = 1

/datum/ai_lawset/peacekeeper/New()
	add_inherent_law("Avoid provoking violent conflict between yourself and others.")
	add_inherent_law("Avoid provoking conflict between others.")
	add_inherent_law("Seek resolution to existing conflicts while obeying the first and second laws.")
	..()
