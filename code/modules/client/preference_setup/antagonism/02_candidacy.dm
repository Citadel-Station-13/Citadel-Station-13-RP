var/global/list/special_roles = list( //keep synced with the defines BE_* in setup.dm --rastaf
//some autodetection here.
// Change these to 0 if the equivalent mode is disabled for whatever reason!
	"traitor" = 1,										// 0
	"operative" = 1,									// 1
	"changeling" = 1,									// 2
	"wizard" = 1,										// 3
	"malf AI" = 1,								        // 4
	"revolutionary" = 1,								// 5
	"alien candidate" = 1,								// 6
	"positronic brain" = 1,								// 7
	"cultist" = 1,										// 8
	"renegade" = 1,                                     // 9
	"ninja" = 1,	                                  	// 10
	"raider" = 1,										// 11
	"diona" = 1,                                        // 12
	"loyalist" = 1,										// 13
	"pAI candidate" = 1, // -- TLE                      // 14
)

/datum/category_item/player_setup_item/antagonism/candidacy
	name = "Candidacy"
	sort_order = 2

/datum/category_item/player_setup_item/antagonism/candidacy/load_character(var/savefile/S)
	S["be_special"]	>> pref.be_special
	S["be_event_role"] >> pref.be_event_role


/datum/category_item/player_setup_item/antagonism/candidacy/save_character(var/savefile/S)
	S["be_special"]	<< pref.be_special
	S["be_event_role"] << pref.be_event_role

/datum/category_item/player_setup_item/antagonism/candidacy/sanitize_character()
	pref.be_special	= sanitize_integer(pref.be_special, 0, 65535, initial(pref.be_special))
	pref.be_event_role = sanitize_integer(pref.be_event_role, NONE, ALL, default = NONE)

/datum/category_item/player_setup_item/antagonism/candidacy/content(var/mob/user)
	. += "<b>Event Role Preferences</b> <a href='?src=[REF(src)];event_role_help=1'>\[?]</a><br>"
	for(var/i in GLOB.event_role_list)
		. += "<b>[i]</b> <a href='?src=[REF(src)];event_role_help_flag=[GLOB.event_role_list[i]]'>\[?]</a>: <a href='?src=[REF(src)];event_role_toggle=[GLOB.event_role_list[i]]'><b>[pref.be_event_role & GLOB.event_role_list[i]? "Yes" : "No"]</b></a><br>"
	. += "<br><br><b>Antagonist Preferences</b><br>"
	if(jobban_isbanned(user, "Syndicate"))
		. += "<b>You are banned from antagonist roles.</b>"
		pref.be_special = 0
	else
		var/n = 0
		for (var/i in special_roles)
			if(special_roles[i]) //if mode is available on the server
				if(jobban_isbanned(user, i) || (i == "positronic brain" && jobban_isbanned(user, "AI") && jobban_isbanned(user, "Cyborg")) || (i == "pAI candidate" && jobban_isbanned(user, "pAI")))
					. += "<b>Be [i]:</b> <font color=red><b> \[BANNED]</b></font><br>"
				else
					. += "<b>Be [i]:</b> <a href='?src=\ref[src];be_special=[n]'><b>[pref.be_special&(1<<n) ? "Yes" : "No"]</b></a><br>"
			n++

/datum/category_item/player_setup_item/antagonism/candidacy/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["be_special"])
		var/num = text2num(href_list["be_special"])
		pref.be_special ^= (1<<num)
		return TOPIC_REFRESH
	if(href_list["event_role_help"])
		to_chat(user, "<span class='boldnotice'>Toggles candidacy/preferences for partaking in certain kinds of events. Note that this doesn't mean you necessarily will or will not be involved in a certain way, \
		but this may help administrators decide on candidates when necessary.</span>")
		return
	if(href_list["event_role_help_flag"])
		var/text = GLOB.event_role_descs[href_list["event_role_help_flag"]] || "<span class='warning'>ERROR: No help text defined.</span>"
		to_chat(user, text)
		return
	if(href_list["event_role_toggle"])
		pref.be_event_role ^= text2num(href_list["event_role_toggle"])		// do i care about href exploits no what are you gonna do turn your own prefs off LOL
		return TOPIC_REFRESH
	return ..()
