/datum/language/demon
	id = LANGUAGE_ID_DAEDAL_DREMACHIR
	name = LANGUAGE_DAEMON
	//! set to common due to overwhelming playerbase saturation.
	translation_class = TRANSLATION_CLASS_DEFAULT_STANDARD_RACE
	desc = "The language spoken by the demons of Infernum, it's composed of deep chanting. It's rarely spoken off of Infernum due to the volume one has to exert."
	speech_verb = "chants"
	ask_verb = "croons"
	exclaim_verb = "incants"
	colour = "daemon" //So fancy
	key = "n"
	syllables = list("viepn","e","bag","docu","kar","xlaqf","raa","qwos","nen","ty","von","kytaf","xin","ty","ka","baak","hlafaifpyk","znu","agrith","na'ar","uah","plhu","six","fhler","bjel","scee","lleri",
	"dttm","aggr","uujl","hjjifr","wwuthaav",)
	shorthand = "DEM"

/datum/language/angel
	id = LANGUAGE_ID_DAEDAL_AURIL
	name = LANGUAGE_ENOCHIAN
	//! trialling putting it on rare; put it to common if everyone uses it
	translation_class = TRANSLATION_CLASS_DEFAULT_RARE_RACE
	desc = "The graceful language spoken by angels, composed of quiet hymns. Formally, Angels sing it."
	speech_verb = "sings"
	ask_verb = "hums"
	exclaim_verb = "loudly sings"
	colour = "enochian" //So fancy
	key = "i"
	syllables = list("salve","sum","loqui","operatur","iusta","et","permittit","facere","effercio","pluribus","enim","hoc",
	"mihi","wan","six","tartu")
	shorthand = "ANG"
