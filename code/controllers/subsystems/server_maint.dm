#define PING_BUFFER_TIME 25

SUBSYSTEM_DEF(server_maint)
	name = "Server Tasks"
	wait = 20
	flags = SS_POST_FIRE_TIMING
	priority = FIRE_PRIORITY_SERVER_MAINT
	init_order = INIT_ORDER_SERVER_MAINT
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT
	var/list/currentrun_clients

/datum/controller/subsystem/server_maint/PreInit()
	world.hub_password = "" //quickly! before the hubbies see us.

/datum/controller/subsystem/server_maint/Initialize(timeofday)
	if(config.hub_visibility)
		world.update_hub_visibility(TRUE)
	return ..()

/datum/controller/subsystem/server_maint/fire(resumed = FALSE)
	if(!resumed)
		if(listclearnulls(GLOB.clients))
			log_world("Found a null in clients list!")
		src.currentrun_clients = GLOB.clients.Copy()

	var/list/currentrun_clients = src.currentrun_clients
	//var/round_started = SSticker.HasRoundStarted()

	/*
	var/kick_inactive = CONFIG_GET(flag/kick_inactive)
	var/afk_period
	if(kick_inactive)
		afk_period = CONFIG_GET(number/afk_period)
	*/
	var/kick_inactive = config.kick_inactive
	var/afk_period = kick_inactive MINUTES

	for(var/I in currentrun_clients)
		var/client/C = I
		//handle kicking inactive players

		/*
		if(round_started && kick_inactive && !C.holder && C.is_afk(afk_period))
			var/cmob = C.mob
			if (!isnewplayer(cmob) || !SSticker.queued_players.Find(cmob))
				log_access("AFK: [key_name(C)]")
				to_chat(C, "<span class='userdanger'>You have been inactive for more than [DisplayTimeText(afk_period)] and have been disconnected.</span><br><span class='danger'You may reconnect via the button in the file menu or by <b><u><a href='byond://winset?command=.reconnect'>clicking here to reconnect</a></b></u></span>")
				QDEL_IN(C, 1) //to ensure they get our message before getting disconnected
				continue
		*/
		if(afk_period && C.is_afk(afk_period) && !C.holder)
			do_inactivity_kick(C)
/*
		if (!(!C || world.time - C.connection_time < PING_BUFFER_TIME || C.inactivity >= (wait-1)))
			winset(C, null, "command=.update_ping+[world.time+world.tick_lag*TICK_USAGE_REAL/100]")
*/

		if (MC_TICK_CHECK) //one day, when ss13 has 1000 people per server, you guys are gonna be glad I added this tick check
			return

/datum/controller/subsystem/server_maint/proc/do_inactivity_kick(client/C)
	to_chat(C,"<span class='warning'>You have been inactive for more than [config.kick_inactive] minute\s and have been disconnected.</span>")
	var/information
	if(C.mob)
		if(ishuman(C.mob))
			var/job
			var/mob/living/carbon/human/H = C.mob
			var/datum/data/record/R = find_general_record("name", H.real_name)
			if(R)
				job = R.fields["real_rank"]
			if(!job && H.mind)
				job = H.mind.assigned_role
			if(!job && H.job)
				job = H.job
			if(job)
				information = " while [job]."

		else if(issilicon(C.mob))
			information = " while a silicon."
			if(isAI(C.mob))
				var/mob/living/silicon/ai/A = C.mob
				empty_playable_ai_cores += new /obj/structure/AIcore/deactivated(A.loc)
				GLOB.global_announcer.autosay("[A] has been moved to intelligence storage.", "Artificial Intelligence Oversight")
				A.clear_client()
				information = " while an AI."

	var/adminlinks
	adminlinks = " (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[C.mob.x];Y=[C.mob.y];Z=[C.mob.z]'>JMP</a>|<A HREF='?_src_=holder;cryoplayer=\ref[C.mob]'>CRYO</a>)"

	log_and_message_admins("being kicked for AFK[information][adminlinks]", C.mob)

	qdel(C)

/datum/controller/subsystem/server_maint/Shutdown()
	/*
	kick_clients_in_lobby("<span class='boldannounce'>The round came to an end with you in the lobby.</span>", TRUE) //second parameter ensures only afk clients are kicked
	var/server = CONFIG_GET(string/server)
	for(var/thing in GLOB.clients)
		if(!thing)
			continue
		var/client/C = thing
		var/datum/chatOutput/co = C.chatOutput
		if(co)
			co.ehjax_send(data = "roundrestart")
		if(server)	//if you set a server location in config.txt, it sends you there instead of trying to reconnect to the same world address. -- NeoFite
			C << link("byond://[server]")
	var/datum/tgs_version/tgsversion = world.TgsVersion()
	if(tgsversion)
		SSblackbox.record_feedback("text", "server_tools", 1, tgsversion.raw_parameter)
	*/

#undef PING_BUFFER_TIMe
