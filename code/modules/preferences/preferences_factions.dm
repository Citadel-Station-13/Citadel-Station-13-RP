GLOBAL_LIST_EMPTY(seen_citizenships)
GLOBAL_LIST_EMPTY(seen_systems)
GLOBAL_LIST_EMPTY(seen_factions)
GLOBAL_LIST_EMPTY(seen_antag_factions)
GLOBAL_LIST_EMPTY(seen_religions)

//Commenting this out for now until I work the lists it into the event generator/journalist/chaplain.
/proc/UpdateFactionList(mob/living/carbon/human/M)
	/*if(M && M.client && M.client.prefs)
		seen_citizenships |= M.client.prefs.citizenship
		seen_systems      |= M.client.prefs.home_system
		seen_factions     |= M.client.prefs.faction
		seen_religions    |= M.client.prefs.religion*/
	return

GLOBAL_LIST_INIT(citizenship_choices,list(
	"Earth",
	"Mars",
	"Luna",
	"Adhomai",
	"Moghes",
	"Meralar",
	"Qerr'balak"
	))

GLOBAL_LIST_INIT(home_system_choices,list(
	"Sol",
	"S'rand'marr",
	"Nyx",
	"Tau Ceti",
	"Qerr'valis",
	"Epsilon Ursae Minoris",
	"Rarkajar",
	"Frontier Space"
	))

GLOBAL_LIST_INIT(faction_choices,list(
	"NanoTrasen",
	"Vey Med",
	"Ward-Takahashi GMB",
	"Free Trade Union"
	))

GLOBAL_LIST_EMPTY(antag_faction_choices)	//Should be populated after brainstorming. Leaving as blank in case brainstorming does not occur.

GLOBAL_LIST_INIT(antag_visiblity_choices,list(
	"Hidden",
	"Shared",
	"Known"
	))

GLOBAL_LIST_INIT(religion_choices,list(
	"Unitarianism",
	"Neopaganism",
	"Islam",
	"Christianity",
	"Judaism",
	"Hinduism",
	"Buddhism",
	"Pleromanism",
	"Spectralism",
	"Phact Shintoism",
	"Kishari Faith",
	"Hauler Faith",
	"Nock",
	"Singulitarian Worship",
	"Xilar Qall",
	"Tajr-kii Rarkajar",
	"The Brass Order",
	"Agnosticism",
	"Deism"
	))
