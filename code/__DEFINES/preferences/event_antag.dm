// /datum/preferences/var/event_preferences
/// High chaos antagonist roles involving violence and action, heists, hostages, etc.
#define EVENT_PREF_BE_ANTAGONIST_CHAOTIC		(1<<0)
/// Milder antagonist roles involving things like espionage, breaking and entry, theft, etc.
#define EVENT_PREF_BE_ANTAGONIST_MILD			(1<<1)
/// Being a hostage
#define EVENT_PREF_BE_HOSTAGE					(1<<2)
/// Being killed
#define EVENT_PREF_BE_KILLED					(1<<3)
/// Be kidnapped
#define EVENT_PREF_BE_KIDNAPPED					(1<<4)
/// Volunteer for calmer events, e.g. traders
#define EVENT_PREF_CALM_EVENT_CHARACTERS		(1<<5)

GLOBAL_LIST_INIT(event_role_list, list(
	"Be Chaotic Antagonist" = EVENT_PREF_BE_ANTAGONIST_CHAOTIC,
	"Be Mild Antagonist" = EVENT_PREF_BE_ANTAGONIST_MILD,
	"Be Hostage" = EVENT_PREF_BE_HOSTAGE,
	"Be Killed" = EVENT_PREF_BE_KILLED,
	"Be Calm/Misc Event Characters" = EVENT_PREF_CALM_EVENT_CHARACTERS
))

GLOBAL_LIST_INIT(event_role_descs, list(
	"[EVENT_PREF_BE_ANTAGONIST_CHAOTIC]" = SPAN_NOTICE("<b>Chaotic Antagonists:</b> Volunteer to partake in more chaotic and high-action/violent antagonism, like murder, hostage taking, destruction, high-risk sabotage, heists, etc."),
	"[EVENT_PREF_BE_ANTAGONIST_MILD]" = SPAN_NOTICE("<b>Mild Antagonists:</b> Volunteer to partake in more mild-mannered antagonism, like theft, infiltration, espionage, causing general ruckuses, etc. This doesn't mean you will never be \
	involved in violence, but these roles are far lower octane than full-on chaotic."),
	"[EVENT_PREF_BE_HOSTAGE]" = SPAN_NOTICE("<b>Hostage:</b> Volunteer to be hostage by some more dangerous threats."),
	"[EVENT_PREF_BE_KILLED]" = SPAN_NOTICE("<b>Killed in Action:</b> Volunteer to be the target of assassins, killers, etc. This may or may not result in you being revivable."),
	"[EVENT_PREF_CALM_EVENT_CHARACTERS]" = SPAN_NOTICE("<b>Misc Event Characters:</b> Volunteer to be some more mild and random event characters: Traders, lost robots, all kinds of things that don't fit into anything else.")
))
