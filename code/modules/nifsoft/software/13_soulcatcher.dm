//These two also have NIF FLAG representations. These are the local setting representations.
#define NIF_SC_CATCHING_ME			0x1
#define NIF_SC_CATCHING_OTHERS		0x2
//These are purely local setings flags, without global representation.
#define NIF_SC_ALLOW_EARS			0x4
#define NIF_SC_ALLOW_EYES			0x8
#define NIF_SC_BACKUPS				0x10
#define NIF_SC_PROJECTING			0x20

#define SOULCATCHER_RANGE 7

///////////
// Soulcatcher - Like a posibrain, sorta!
/datum/nifsoft/soulcatcher
	name = "Soulcatcher"
	desc = "A mind storage and processing system capable of capturing and supporting human-level minds in a small VR space."
	list_pos = NIF_SOULCATCHER
	cost = 25 //If I wanna trap people's minds and lood them, then by god I'll do so.
	wear = 1
	p_drain = 0.01

	var/setting_flags = (NIF_SC_CATCHING_OTHERS|NIF_SC_ALLOW_EARS|NIF_SC_ALLOW_EYES|NIF_SC_BACKUPS|NIF_SC_PROJECTING)
	var/list/brainmobs = list()
	var/inside_flavor = "A small completely white room with a couch, and a window to what seems to be the outside world. A small sign in the corner says 'Configure Me'."
	var/visibility = TRUE
	var/list/visibility_exceptions = list()
	var/list/visibility_blacklist = list()

/datum/nifsoft/soulcatcher/New()
	..()
	load_settings()

/datum/nifsoft/soulcatcher/Destroy()
	QDEL_LIST_NULL(brainmobs)
	return ..()

/datum/nifsoft/soulcatcher/activate()
	if((. = ..()))
		show_settings(nif.human)
		spawn(0)
			deactivate()

/datum/nifsoft/soulcatcher/stat_text()
	return "Change Settings ([brainmobs.len] minds)"

/datum/nifsoft/soulcatcher/install()
	if((. = ..()))
		//nif.set_flag(NIF_O_SCOTHERS,NIF_FLAGS_OTHER)	//Only required on install if the flag is in the default setting_flags list defined few lines above.
		if(nif?.human)
			add_verb(nif.human, /mob/living/carbon/human/proc/nsay)
			add_verb(nif.human, /mob/living/carbon/human/proc/nme)

/datum/nifsoft/soulcatcher/uninstall()
	QDEL_LIST_NULL(brainmobs)
	if((. = ..()) && nif?.human) //Sometimes NIFs are deleted outside of a human
		remove_verb(nif.human, /mob/living/carbon/human/proc/nsay)
		remove_verb(nif.human, /mob/living/carbon/human/proc/nme)

/datum/nifsoft/soulcatcher/proc/save_settings()
	if(!nif)
		return
	nif.save_data["[list_pos]"] = inside_flavor
	var/list/save_data = list()
	save_data["vis"] = visibility
	save_data["vis_exceptions"] = visibility_exceptions
	save_data["vis_blacklist"] = visibility_blacklist
	nif.save_data["[list_pos]_actual"] = save_data
	return TRUE

/datum/nifsoft/soulcatcher/proc/load_settings()
	if(!nif)
		return
	var/load = nif.save_data["[list_pos]"]
	// todo: refactor nifs i'm going to get Fucking Violent if i see this kind of shit again
	// why the fuck was it not a list in the first place?
	// jfc get out.
	var/list/save_data = nif.save_data["[list_pos]_actual"]
	if(!islist(save_data))
		save_data = list()
	if(load)
		inside_flavor = load
	if(!isnull(save_data["vis"]))
		visibility = save_data["vis"]
	if(islist(save_data["vis_exceptions"]))
		visibility_exceptions = save_data["vis_exceptions"]
	if(islist(save_data["vis_blacklist"]))
		visibility_blacklist = save_data["vis_blacklist"]
	return TRUE

/datum/nifsoft/soulcatcher/proc/visibility_check(ckey)
	ckey = ckey(ckey)
	if(islist(visibility_blacklist))
		if(ckey in visibility_blacklist)
			return FALSE
	if(visibility)
		return TRUE
	if(islist(visibility_exceptions))
		if(ckey in visibility_exceptions)
			return TRUE
	return FALSE

/datum/nifsoft/soulcatcher/proc/notify_into(var/message)
	var/sound = nif.good_sound

	to_chat(nif.human,"<b>\[[icon2html(thing = nif.big_icon, target = nif.human)]NIF\]</b> <b>Soulcatcher</b> displays, \"<span class='notice nif'>[message]</span>\"")
	SEND_SOUND(nif.human, sound)

	for(var/brainmob in brainmobs)
		var/mob/living/carbon/brain/caught_soul/CS = brainmob
		to_chat(CS,"<b>\[[icon2html(thing = nif.big_icon, target = CS)]NIF\]</b> <b>Soulcatcher</b> displays, \"<span class='notice nif'>[message]</span>\"")
		SEND_SOUND(brainmob, sound)

/datum/nifsoft/soulcatcher/proc/say_into(var/message, var/mob/living/sender, var/mob/eyeobj)
	message = trim(message)
	if(!length(message))
		return
	message = sender.say_emphasis(message)
	var/sender_name = eyeobj ? eyeobj.name : sender.name

	//AR Projecting
	if(eyeobj)
		sender.eyeobj.visible_message("<b>[sender_name]</b> says, \"[message]\"")

	//Not AR Projecting
	else
		to_chat(nif.human,"<span class='game say nif'><b>\[[icon2html(thing = nif.big_icon, target = nif.human)]NIF\]</b> <b>[sender_name]</b> speaks, \"[message]\"</span>")
		for(var/mob/living/carbon/brain/caught_soul/CS as anything in brainmobs)
			to_chat(CS,"<span class='game say nif'><b>\[[icon2html(thing = nif.big_icon, target = CS)]NIF\]</b> <b>[sender_name]</b> speaks, \"[message]\"</span>")

	log_nsay(message,nif.human.real_name,sender)

/datum/nifsoft/soulcatcher/proc/emote_into(var/message, var/mob/living/sender, var/mob/eyeobj)
	message = trim(message)
	if(!length(message))
		return
	message = sender.say_emphasis(message)
	var/sender_name = eyeobj ? eyeobj.name : sender.name

	//AR Projecting
	if(eyeobj)
		sender.eyeobj.visible_message("[sender_name] [message]")

	//Not AR Projecting
	else
		to_chat(nif.human,"<span class='emote nif'><b>\[[icon2html(thing = nif.big_icon, target = nif.human)]NIF\]</b> <b>[sender_name]</b> [message]</span>")
		for(var/mob/living/carbon/brain/caught_soul/CS as anything in brainmobs)
			to_chat(CS,"<span class='emote nif'><b>\[[icon2html(thing = nif.big_icon, target = CS)]NIF\]</b> <b>[sender_name]</b> [message]</span>")

	log_nme(message,nif.human.real_name,sender)

/datum/nifsoft/soulcatcher/proc/show_settings(var/mob/living/carbon/human/H)
	set waitfor = FALSE
	var/settings_list = list(
	"Catching You \[[setting_flags & NIF_SC_CATCHING_ME ? "Enabled" : "Disabled"]\]" = NIF_SC_CATCHING_ME,
	"Catching Prey \[[setting_flags & NIF_SC_CATCHING_OTHERS ? "Enabled" : "Disabled"]\]" = NIF_SC_CATCHING_OTHERS,
	"Ext. Hearing \[[setting_flags & NIF_SC_ALLOW_EARS ? "Enabled" : "Disabled"]\]" = NIF_SC_ALLOW_EARS,
	"Ext. Vision \[[setting_flags & NIF_SC_ALLOW_EYES ? "Enabled" : "Disabled"]\]" = NIF_SC_ALLOW_EYES,
//	"Mind Backups \[[setting_flags & NIF_SC_BACKUPS ? "Enabled" : "Disabled"]\]" = NIF_SC_BACKUPS,
	"AR Projecting \[[setting_flags & NIF_SC_PROJECTING ? "Enabled" : "Disabled"]\]" = NIF_SC_PROJECTING,
	"Design Inside",
	"Visibility \[[visibility? "Visible to Observers" : "Invisible to Observers"]\]" = "Visibility",
	"Visibility Exceptions ([length(visibility_exceptions)])" = "Exceptions",
	"Visibility Blacklist ([length(visibility_blacklist)])" = "Blacklist",
	"Erase Contents")
	var/choice = tgui_input_list(nif.human,"Select a setting to modify:","Soulcatcher NIFSoft", settings_list)
	if(choice in settings_list)
		var/associative = settings_list[choice]
		switch(associative)
			if("Visibility")
				if(visibility)
					visibility = FALSE
					notify_into("Network visibility disabled.")
				else
					visibility = TRUE
					notify_into("Network visibility enabled.")
				save_settings()
				return

			if("Exceptions")
				var/assembled = islist(visibility_exceptions)? visibility_exceptions.Join("<br>") : "None!"
				to_chat(nif.human, SPAN_NOTICE("[assembled]"))
				to_chat(nif.human, SPAN_BOLDNOTICE("These ckeys above will always be allowed to see and request a soulcatcher join, even if visibility is off."))
				var/toggle = input(nif.human, "What ckey do you want to add/remove to the whitelist?", "Whitelist") as text|null
				if(!toggle)
					return
				toggle = ckey(toggle)
				if(toggle in visibility_exceptions)
					visibility_exceptions -= toggle
					to_chat(nif.human, SPAN_BOLDNOTICE("[toggle] removed from exceptions."))
				else
					visibility_exceptions += toggle
					to_chat(nif.human, SPAN_BOLDNOTICE("[toggle] added to exceptions."))
				save_settings()
				return

			if("Blacklist")
				var/assembled = islist(visibility_blacklist)? visibility_blacklist.Join("<br>") : "None!"
				to_chat(nif.human, SPAN_NOTICE("[assembled]"))
				to_chat(nif.human, SPAN_BOLDNOTICE("These ckeys above will never be allowed to see your soulcatcher and request to join, even while visibility is on."))
				var/toggle = input(nif.human, "What ckey do you want to add/remove to the blacklist?", "Blacklist") as text|null
				if(!toggle)
					return
				toggle = ckey(toggle)
				if(toggle in visibility_blacklist)
					visibility_blacklist -= toggle
					to_chat(nif.human, SPAN_BOLDNOTICE("[toggle] removed from blacklist."))
				else
					visibility_blacklist += toggle
					to_chat(nif.human, SPAN_BOLDNOTICE("[toggle] added to blacklist."))
				save_settings()
				return

		switch(choice)
			if("Design Inside")
				var/new_flavor = input(nif.human, "Type what the prey sees after being 'caught'. This will be \
				printed after an intro ending with: \"Around you, you see...\" to the prey. If you already \
				have prey, this will be printed to them after \"Your surroundings change to...\". Limit 2048 char.", \
				"VR Environment", html_decode(inside_flavor)) as message
				new_flavor = sanitize(new_flavor, MAX_MESSAGE_LEN*2)
				inside_flavor = new_flavor
				nif.notify("Updating VR environment...")
				for(var/mob/living/carbon/brain/caught_soul/CS as anything in brainmobs)
					to_chat(CS,"<span class='notice'>Your surroundings change to...</span>\n[inside_flavor]")
				save_settings()
				return TRUE

			if("Erase Contents")
				var/mob/living/carbon/brain/caught_soul/brainpick = tgui_input_list(nif.human,"Select a mind to delete:","Erase Mind", brainmobs)

				var/warning = tgui_alert(nif.human,"Are you SURE you want to erase \"[brainpick]\"?","Erase Mind",list("CANCEL","DELETE"))
				if(warning == "DELETE")
					brainmobs -= brainpick
					qdel(brainpick)
				return TRUE

			//Must just be a flag without special handling then.
			else
				var/flag = settings_list[choice]
				return toggle_setting(flag)

/datum/nifsoft/soulcatcher/proc/toggle_setting(var/flag)
	setting_flags ^= flag

	var/notify_message
	//Special treatment
	switch(flag)
/*		if(NIF_SC_BACKUPS)
			if(setting_flags & NIF_SC_BACKUPS)
				notify_message = "Mind backup system enabled."
			else
				notify_message = "Mind backup system disabled."
*/
		if(NIF_SC_CATCHING_ME)
			if(setting_flags & NIF_SC_CATCHING_ME)
				nif.set_flag(NIF_O_SCMYSELF,NIF_FLAGS_OTHER)
			else
				nif.clear_flag(NIF_O_SCMYSELF,NIF_FLAGS_OTHER)
		if(NIF_SC_CATCHING_OTHERS)
			if(setting_flags & NIF_SC_CATCHING_OTHERS)
				nif.set_flag(NIF_O_SCOTHERS,NIF_FLAGS_OTHER)
			else
				nif.clear_flag(NIF_O_SCOTHERS,NIF_FLAGS_OTHER)
		if(NIF_SC_ALLOW_EARS)
			if(setting_flags & NIF_SC_ALLOW_EARS)
				for(var/mob/living/carbon/brain/caught_soul/brainmob as anything in brainmobs)
					brainmob.ext_deaf = FALSE
				notify_message = "External audio input enabled."
			else
				for(var/mob/living/carbon/brain/caught_soul/brainmob as anything in brainmobs)
					brainmob.ext_deaf = TRUE
				notify_message = "External audio input disabled."
		if(NIF_SC_ALLOW_EYES)
			if(setting_flags & NIF_SC_ALLOW_EYES)
				for(var/mob/living/carbon/brain/caught_soul/brainmob as anything in brainmobs)
					brainmob.ext_blind = FALSE
				notify_message = "External video input enabled."
			else
				for(var/mob/living/carbon/brain/caught_soul/brainmob as anything in brainmobs)
					brainmob.ext_blind = TRUE
				notify_message = "External video input disabled."

	if(notify_message)
		notify_into(notify_message)

	return TRUE

	//Complex version for catching in-round characters
/datum/nifsoft/soulcatcher/proc/catch_mob(var/mob/M)
	if(!M.mind)
		return

	//Create a new brain mob
	var/mob/living/carbon/brain/caught_soul/brainmob = new(nif)
	brainmob.nif = nif
	brainmob.soulcatcher = src
	brainmob.container = src
	brainmob.set_stat(CONSCIOUS)
	brainmob.silent = FALSE
	dead_mob_list -= brainmob
	brainmob.add_language(LANGUAGE_GALCOM)
	brainmobs |= brainmob

	//Put the mind and player into the mob
	// login should handle the perspective reset, now that nif is set.
	M.mind.transfer_to(brainmob)
	brainmob.name = brainmob.mind.name
	brainmob.real_name = brainmob.mind.name

	//If we caught our owner, special settings.
	if(M == nif.human)
		brainmob.ext_deaf = FALSE
		brainmob.ext_blind = FALSE
		brainmob.parent_mob = TRUE

	//If they have these values, apply them
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		brainmob.dna = H.dna
		brainmob.ooc_notes = H.ooc_notes
		brainmob.timeofhostdeath = H.timeofdeath
		SStranscore.m_backup(brainmob.mind,0) //It does ONE, so medical will hear about it.

	//Else maybe they're a joining ghost
	else if(isobserver(M))
		brainmob.transient = TRUE
		qdel(M) //Bye ghost

	//Give them a flavortext message
	var/message = "<span class='notice'>Your vision fades in a haze of static, before returning.</span>\n\
					Around you, you see...\n\
					[inside_flavor]"

	to_chat(brainmob,message)

	//Reminder on how this works to host
	if(brainmobs.len == 1) //Only spam this on the first one
		to_chat(nif.human,"<span class='notice'>Your occupant's messages/actions can only be seen by you, and you can \
		send messages that only they can hear/see by using the NSay and NMe verbs (or the *nsay and *nme emotes).</span>")

	//Announce to host and other minds
	notify_into("New mind loaded: [brainmob.name]")
	return TRUE

////////////////
//The caught mob
/mob/living/carbon/brain/caught_soul
	name = "recorded mind"
	desc = "A mind recorded and being played on digital hardware."
	use_me = 1
	var/ext_deaf = FALSE		//Forbidden from 'ear' access on host
	var/ext_blind = FALSE		//Forbidden from 'eye' access on host
	var/parent_mob = FALSE		//If we've captured our owner
	var/transient = FALSE		//Someone who ghosted into the NIF
	var/client_missing = 0		//How long the client has been missing
	universal_understand = TRUE

	var/obj/item/nif/nif
	var/datum/nifsoft/soulcatcher/soulcatcher
	var/identifying_gender

/mob/living/carbon/brain/caught_soul/Login()
	..()
	plane_holder.set_vis(VIS_AUGMENTED, TRUE)
	identifying_gender = client.prefs.identifying_gender
	reset_perspective((nif?.human) || nif)

/mob/living/carbon/brain/caught_soul/Destroy()
	if(soulcatcher)
		soulcatcher.notify_into("Mind unloaded: [name]")
		soulcatcher.brainmobs -= src
		soulcatcher = null
	if(eyeobj)
		reenter_soulcatcher()
		eyeobj = null //This SHOULD be null already, reenter_soulcatcher destroys and nulls it, but safety first.
	container = null
	nif = null
	return ..()

/mob/living/carbon/brain/caught_soul/ghostize(can_reenter_corpse)
	. = ..()
	if(!can_reenter_corpse)
		if(nif)
			qdel(src)

/mob/living/carbon/brain/caught_soul/Life(seconds, times_fired)
	if(!mind || !key)
		qdel(src)
		return TRUE

	if((. = ..()))
		return

	if(!parent_mob && !transient &&(life_tick % 150 == 0) && soulcatcher.setting_flags & NIF_SC_BACKUPS)
		SStranscore.m_backup(mind,0) //Passed 0 means "Don't touch the nif fields on the mind record"

	life_tick++

	if(!client)
		if(++client_missing == 300)
			qdel(src)
		return
	else
		client_missing = 0

	if(parent_mob)
		return

	//If they're blinded
	if(ext_blind)
		eye_blind = 5
		client.screen.Remove(GLOB.global_hud.whitense)
		overlay_fullscreen("blind", /atom/movable/screen/fullscreen/scaled/blind)
	else
		eye_blind = 0
		clear_fullscreen("blind")
		client.screen.Add(GLOB.global_hud.whitense)

	//If they're deaf
	if(ext_deaf)
		ear_deaf = 5
	else
		ear_deaf = 0

/mob/living/carbon/brain/caught_soul/hear_say()
	if(ext_deaf || !client)
		return FALSE
	..()

/mob/living/carbon/brain/caught_soul/show_message(msg, type, alt, alt_type)
	if(ext_blind || !client)
		return FALSE
	..()

/mob/living/carbon/brain/caught_soul/me_verb_subtle()
	set hidden = TRUE

	return FALSE

/mob/living/carbon/brain/caught_soul/whisper()
	set hidden = TRUE

	return FALSE

/mob/living/carbon/brain/caught_soul/face_atom(var/atom/A)
	if(eyeobj)
		return eyeobj.face_atom(A)
	else
		return ..(A)

/mob/living/carbon/brain/caught_soul/setDir(var/direction)
	if(eyeobj)
		return eyeobj.setDir(direction)
	else
		return ..(direction)

/mob/living/carbon/brain/caught_soul/say(var/message, var/datum/language/speaking = null, var/verb="says", var/alt_name="", var/whispering = 0)
	if(silent)
		return FALSE
	soulcatcher.say_into(message,src,eyeobj)

/mob/living/carbon/brain/caught_soul/eastshift()
	eyeobj?.eastshift()

/mob/living/carbon/brain/caught_soul/westshift()
	eyeobj?.westshift()

/mob/living/carbon/brain/caught_soul/northshift()
	eyeobj?.northshift()

/mob/living/carbon/brain/caught_soul/southshift()
	eyeobj?.southshift()

/mob/living/carbon/brain/caught_soul/allow_examine(atom/A)
	return TRUE

/mob/living/carbon/brain/caught_soul/emote(var/act,var/m_type=1,var/message = null)
	if(silent)
		return FALSE
	if (act == "me")
		if(silent)
			return
		if (src.client)
			if (client.prefs.muted & MUTE_IC)
				to_chat(src, SPAN_WARNING("You cannot send IC messages (muted)."))
				return
		if (stat)
			return
		if(!(message))
			return
		return custom_emote(m_type, message)
	else
		return FALSE

/mob/living/carbon/brain/caught_soul/custom_emote(var/m_type, var/message)
	if(silent)
		return FALSE
	soulcatcher.emote_into(message,src,eyeobj)

/mob/living/carbon/brain/caught_soul/resist()
	set name = "Resist"
	set category = "IC"

	to_chat(src,SPAN_WARNING("There's no way out! You're stuck in VR."))

/mob/living/carbon/brain/caught_soul/set_typing_indicator(state)
	return eyeobj?.set_typing_indicator(state)

///////////////////
//A projected AR soul thing
/mob/observer/eye/ar_soul
	plane = PLANE_AUGMENTED
	icon = 'icons/obj/machines/ar_elements.dmi'
	icon_state = "beacon"
	var/mob/living/carbon/human/parent_human

/mob/observer/eye/ar_soul/Initialize(mapload, mob/brainmob, mob/living/carbon/human/human)
	ASSERT(brainmob && brainmob.client)
	. = ..()

	owner = brainmob				//Set eyeobj's owner
	parent_human = human			//E-z reference to human

	name = "[brainmob.name] (AR)"	//Set the name
	real_name = brainmob.real_name	//And the OTHER name

	forceMove(get_turf(parent_human))
	RegisterSignal(parent_human, COMSIG_MOVABLE_MOVED, .proc/human_moved)

	//Time to play dressup
	if(brainmob.client.prefs)
		var/mob/living/carbon/human/dummy/dummy = new
		brainmob.client.prefs.dress_preview_mob(dummy)
		dummy.regenerate_icons()
		var/image/alpha_mask = new
		alpha_mask.icon = 'icons/effects/effects.dmi'
		alpha_mask.icon_state = "scanline"
		alpha_mask.layer = FLY_LAYER
		alpha_mask.blend_mode = BLEND_SUBTRACT
		alpha_mask.color = list(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-2,1,1,1,1)
		dummy.add_overlay(alpha_mask)
		dummy.compile_overlays()
		dummy.alpha = 192

		// remove hudlist
		dummy.cut_overlay(dummy.hud_list)
		// appearance clone immediately
		appearance = dummy.appearance
		plane = PLANE_AUGMENTED
		qdel(dummy)

/mob/observer/eye/ar_soul/Destroy()
	if(parent_human) //It's POSSIBLE they've been deleted before the NIF somehow
		UnregisterSignal(parent_human, COMSIG_MOVABLE_MOVED)
	return ..()

/mob/observer/eye/ar_soul/EyeMove(n, direct)
	var/initial = initial(sprint)
	var/max_sprint = 50

	if(cooldown && cooldown < world.timeofday)
		sprint = initial

	for(var/i = 0; i < max(sprint, initial); i += 20)
		var/turf/stepn = get_turf(get_step(src, direct))
		if(stepn)
			setDir(direct)
			if(get_dist(parent_human, stepn) <= SOULCATCHER_RANGE)
				forceMove(stepn)

	cooldown = world.timeofday + 5
	if(acceleration)
		sprint = min(sprint + 0.5, max_sprint)
	else
		sprint = initial
	return 1

/mob/observer/eye/ar_soul/proc/human_moved()
	if(get_dist(parent_human,src) > SOULCATCHER_RANGE)
		forceMove(get_turf(parent_human))

///////////////////
//The catching hook
/hook/death/proc/nif_soulcatcher(var/mob/living/carbon/human/H)
	if(!istype(H) || !H.mind) return TRUE //Hooks must return TRUE

	if(isbelly(H.loc)) //Died in someone
		var/obj/belly/B = H.loc
		var/mob/living/carbon/human/HP = B.owner
		if(istype(HP) && HP.nif && HP.nif.flag_check(NIF_O_SCOTHERS,NIF_FLAGS_OTHER))
			var/datum/nifsoft/soulcatcher/SC = HP.nif.imp_check(NIF_SOULCATCHER)
			SC.catch_mob(H)
	else if(H.nif && H.nif.flag_check(NIF_O_SCMYSELF,NIF_FLAGS_OTHER)) //They are caught in their own NIF
		var/datum/nifsoft/soulcatcher/SC = H.nif.imp_check(NIF_SOULCATCHER)
		SC.catch_mob(H)

	return TRUE

///////////////////
//Verbs for humans
/mob/living/carbon/human/proc/nsay(message as text)
	set name = "NSay"
	set desc = "Speak into your NIF's Soulcatcher."
	set category = "IC"

	src.nsay_act(message)

/mob/proc/nsay_act(message)
	to_chat(src, SPAN_WARNING("You must be a humanoid with a NIF implanted to use that."))

/mob/living/carbon/human/nsay_act(message)
	if(stat != CONSCIOUS)
		to_chat(src, SPAN_WARNING("You can't use NSay while unconscious."))
		return
	if(!nif)
		to_chat(src, SPAN_WARNING("You can't use NSay without a NIF."))
		return
	var/datum/nifsoft/soulcatcher/SC = nif.imp_check(NIF_SOULCATCHER)
	if(!SC)
		to_chat(src, SPAN_WARNING("You need the Soulcatcher software to use NSay."))
		return
	if(!SC.brainmobs.len)
		to_chat(src, SPAN_WARNING("You need a loaded mind to use NSay."))
		return
	if(!message)
		message = input(usr, "Type a message to say.","Speak into Soulcatcher") as message|null
	if(message)
		var/sane_message = sanitize(message)
		SC.say_into(sane_message,src)

/mob/living/carbon/human/proc/nme(message as message|null)
	set name = "NMe"
	set desc = "Emote into your NIF's Soulcatcher."
	set category = "IC"

	src.nme_act(message)

/mob/proc/nme_act(message)
	to_chat(src, SPAN_WARNING("You must be a humanoid with a NIF implanted to use that."))

/mob/living/carbon/human/nme_act(message)
	if(stat != CONSCIOUS)
		to_chat(src, SPAN_WARNING("You can't use NMe while unconscious."))
		return
	if(!nif)
		to_chat(src, SPAN_WARNING("You can't use NMe without a NIF."))
		return
	var/datum/nifsoft/soulcatcher/SC = nif.imp_check(NIF_SOULCATCHER)
	if(!SC)
		to_chat(src, SPAN_WARNING("You need the Soulcatcher software to use NMe."))
		return
	if(!SC.brainmobs.len)
		to_chat(src, SPAN_WARNING("You need a loaded mind to use NMe."))
		return

	if(!message)
		message = input(usr, "Type an action to perform.","Emote into Soulcatcher") as message|null
	if(message)
		var/sane_message = sanitize(message)
		SC.emote_into(sane_message,src)

///////////////////
//Verbs for soulbrains
/mob/living/carbon/brain/caught_soul/verb/examine_surroundings()
	set name = "Examine Surroundings"
	set desc = "Examine the interior of the soulcatcher you're in."
	set category = "Soulcatcher"

	to_chat(src, "Around you, you see...<br>[soulcatcher?.inside_flavor]")

/mob/living/carbon/brain/caught_soul/verb/ar_project()
	set name = "AR Project"
	set desc = "Project your form into Augmented Reality for those around your predator with the appearance of your loaded character."
	set category = "Soulcatcher"

	if(eyeobj)
		to_chat(src,"<span class='warning'>You're already projecting in AR!</span>")
		return

	if(!(soulcatcher.setting_flags & NIF_SC_PROJECTING))
		to_chat(src,"<span class='warning'>Projecting from this NIF has been disabled!</span>")
		return

	if(!client || !client.prefs)
		return //Um...

	eyeobj = new/mob/observer/eye/ar_soul(src, src, nif.human)
	soulcatcher.notify_into("[src] now AR projecting.")

/mob/living/carbon/brain/caught_soul/verb/jump_to_owner()
	set name = "Jump to Owner"
	set desc = "Jump your projection back to the owner of the soulcatcher you're inside."
	set category = "Soulcatcher"

	if(!eyeobj)
		to_chat(src,"<span class='warning'>You're not projecting into AR!</span>")
		return

	eyeobj.forceMove(get_turf(nif))

/mob/living/carbon/brain/caught_soul/verb/reenter_soulcatcher()
	set name = "Re-enter Soulcatcher"
	set desc = "Leave AR projection and drop back into the soulcatcher."
	set category = "Soulcatcher"

	if(!eyeobj)
		to_chat(src,"<span class='warning'>You're not projecting into AR!</span>")
		return

	QDEL_NULL(eyeobj)
	soulcatcher.notify_into("[src] ended AR projection.")

/mob/living/carbon/brain/caught_soul/verb/nsay(message as text|null)
	set name = "NSay"
	set desc = "Speak into the NIF's Soulcatcher (circumventing AR speaking)."
	set category = "Soulcatcher"

	if(!message)
		message = input("Type a message to say.","Speak into Soulcatcher") as text|null
	message = sanitize(message)
	if(message)
		soulcatcher.say_into(message,src,null)

/mob/living/carbon/brain/caught_soul/verb/nme(message as text|null)
	set name = "NMe"
	set desc = "Emote into the NIF's Soulcatcher (circumventing AR speaking)."
	set category = "Soulcatcher"

	if(!message)
		message = input("Type an action to perform.","Emote into Soulcatcher") as message|null
	message = sanitize(message)
	if(message)
		soulcatcher.emote_into(message,src,null)
