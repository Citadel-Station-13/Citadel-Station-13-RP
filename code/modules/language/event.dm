// todo: dynamic language creation system we shouldn't have this
//For your event purposes.
/datum/language/occursus
	name = LANGUAGE_EVENT1
	desc = "The Powers That Be have seen it fit to grace you with a special language that sounds like... something. This description should be overridden by the time you see this."
	speech_verb = "says"
	ask_verb = "asks"
	exclaim_verb = "shouts"
	colour = "warning"
	key = "]"
	language_flags = RESTRICTED
	syllables = list("chan","ange","thi","se")

//for your antag purposes.
/datum/language/minbus
	id = LANGUAGE_ID_EVENT_2
	name = LANGUAGE_MINBUS
	desc = "The Powers That Be have seen it fit to grace you with a special language that sounds like Russian for some reason."
	speech_verb = "says"
	ask_verb = "asks"
	exclaim_verb = "shouts"
	colour = "deadsay"
	key = "r"
	machine_understands = 0
	language_flags = RESTRICTED
	syllables = list("rus","zem","ave","groz","ski","ska","ven","konst","pol","lin","svy",
	"danya","da","mied","zan","das","krem","myka","cyka","blyat","to","st","no","na","ni",
	"ko","ne","en","po","ra","li","on","byl","cto","eni","ost","ol","ego","ver","stv","pro")

