//Cactus, Speedbird, Dynasty, oh my

var/datum/lore/atc_controller/atc = new/datum/lore/atc_controller

/datum/lore/atc_controller
	var/delay_max = 2 MINUTES			//How long between ATC traffic, max.  Default is 25 mins.
	var/delay_min = 4 MINUTES			//How long between ATC traffic, min.  Default is 40 mins.
	var/backoff_delay = 5 MINUTES		//How long to back off if we can't talk and want to.  Default is 5 mins.
	var/next_message					//When the next message should happen in world.time
	var/force_chatter_type				//Force a specific type of messages

	var/squelched = 0					//If ATC is squelched currently

/datum/lore/atc_controller/New()
	spawn(10 SECONDS) //Lots of lag at the start of a shift.
		msg("New shift beginning, resuming traffic control.")
	next_message = world.time + rand(delay_min,delay_max)
	process()

/datum/lore/atc_controller/proc/process()
	if(world.time >= next_message)
		if(squelched)
			next_message = world.time + backoff_delay
		else
			next_message = world.time + rand(delay_min,delay_max)
			random_convo()

	spawn(1 MINUTE) //We don't really need high-accuracy here.
		process()

/datum/lore/atc_controller/proc/msg(var/message,var/sender)
	ASSERT(message)
	global_announcer.autosay("[message]", sender ? sender : "[using_map.station_short] Control")

/datum/lore/atc_controller/proc/reroute_traffic(var/yes = 1)
	if(yes)
		if(!squelched)
			msg("Rerouting traffic away from [using_map.station_name].")
		squelched = 1
	else
		if(squelched)
			msg("Resuming normal traffic routing around [using_map.station_name].")
		squelched = 0

/datum/lore/atc_controller/proc/shift_ending(var/evac = 0)
	msg("Automated Tram departing [using_map.station_name] for [using_map.dock_name] on routine transfer route.","NT Automated Tram") //VOREStation Edit - Tram, tho.
	sleep(5 SECONDS)
	msg("Automated Tram, cleared to complete routine transfer from [using_map.station_name] to [using_map.dock_name].") //VOREStation Edit - Tram, tho.

/datum/lore/atc_controller/proc/random_convo()
	var/one = pick(loremaster.organizations) //These will pick an index, not an instance
	var/two = pick(loremaster.organizations)

	var/datum/lore/organization/source = loremaster.organizations[one] //Resolve to the instances
	var/datum/lore/organization/dest = loremaster.organizations[two]

	//Let's get some mission parameters
	var/owner = source.short_name					//Use the short name
	var/prefix = pick(source.ship_prefixes)			//Pick a random prefix
	var/mission = source.ship_prefixes[prefix]		//The value of the prefix is the mission type that prefix does
	var/shipname = pick(source.ship_names)			//Pick a random ship name to go with it
	var/destname = pick(dest.destination_names)			//Pick a random holding from the destination

	var/combined_name = "[owner] [prefix] [shipname]"
	var/alt_atc_names = list("[using_map.station_short] TraCon","[using_map.station_short] Control","[using_map.station_short] STC","[using_map.station_short] StarCon")
	var/wrong_atc_names = list("Sol Command","New Reykjavik StarCon", "[using_map.dock_name]")
	var/mission_noun = list("flight","mission","route","operation")
	var/request_verb = list("requesting","calling for","asking for")

	//First response is 'yes', second is 'no'
	var/requests = list("[using_map.station_short] transit clearance" = list("permission for transit granted", "permission for transit denied, contact regional on 953.5"),
						"planetary flight rules" = list("authorizing planetary flight rules", "denying planetary flight rules right now due to traffic"),
						"special flight rules" = list("authorizing special flight rules", "denying special flight rules, not allowed for your traffic class"),
						"current solar weather info" = list("sending you the relevant information via tightbeam", "cannot fulfill your request at the moment"),
						"nearby traffic info" = list("sending you current traffic info", "no available info in your area"),
						"remote telemetry data" = list("sending telemetry now", "no uplink from your ship, recheck your uplink and ask again"),
						"refueling information" = list("sending refueling information now", "no fuel for your ship class in this sector"),
						"a current system time sync" = list("sending time sync ping to you now", "your ship isn't compatible with our time sync, set time manually"),
						"current system starcharts" = list("transmitting current starcharts", "your request is queued, overloaded right now"),
						//STC can't possibly oversee every single jump into and out of the system, nor should they try to
/*						"permission to engage FTL" = list("permission to engage FTL granted, good day", "permission denied, wait for current traffic to pass"),
						"permission to transit system" = list("permission to transit granted, good day", "permission denied, wait for current traffic to pass"),
						"permission to depart system" = list("permission to depart granted, good day", "permission denied, wait for current traffic to pass"),
						"permission to enter system" = list("good day, permission to enter granted", "permission denied, wait for current traffic to pass"),*/
						)

	//Random chance things for variety
	var/chatter_type = "normal"
	if(force_chatter_type)
		chatter_type = force_chatter_type
	else
		chatter_type = pick(2;"emerg",5;"wrong_freq","policescan","policeflee","pathwarning","dockingrequestgeneric","dockingrequestdenied","dockingrequestsupply","dockingrequestrepair","dockingrequestmedical","dockingrequestsecurity","undockingrequest","normal") //Be nice to have wrong_lang...

	var/yes = prob(90) //Chance for them to say yes vs no

	var/request = pick(requests)
	var/callname = pick(alt_atc_names)
	var/response = requests[request][yes ? 1 : 2] //1 is yes, 2 is no

	//	var/full_request
	//	var/full_response
	//	var/full_closure

	switch(chatter_type)
		if("wrong_freq")
			callname = pick(wrong_atc_names)
			msg("[callname], this is [combined_name] on a [mission] [pick(mission_noun)] to [destname], [pick(request_verb)] [request].","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("[combined_name], this is [using_map.station_short] Control, wrong frequency. Switch to [rand(700,999)].[rand(1,9)].")
			sleep(5 SECONDS)
			msg("[using_map.station_short] Control, understood, apologies.","[prefix] [shipname]")
		if("emerg")
			var/problem = pick("hull breaches on multiple decks","unknown life forms on board","a drive about to go critical","asteroids impacting the hull","a total loss of engine power","hostile ships closing fast","unidentified boarders")
			msg("This is [combined_name] declaring an emergency! We have [problem]!","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("[combined_name], this is [using_map.station_short] Control, copy. Switch to emergency responder channel [rand(700,999)].[rand(1,9)].")
			sleep(5 SECONDS)
			msg("Understood [using_map.station_short] Control, switching now.","[prefix] [shipname]")
		if("policescan")
			var/confirm = pick("Understood","Roger that","Affirmative")
			var/complain = pick("I hope this doesn't take too long.","Can we hurry this up?","Make it quick.","This better not take too long.")
			var/completed = pick("You're free to proceed.","Everything looks fine, carry on.","Apologies for the delay, you're clear.","Switch to [rand(700,999)].[rand(1,9)] and await further instruction.")
			msg("[combined_name], this is [using_map.station_short] Control, your ship has been flagged for routine inspection. Hold position and prepare to be scanned.")
			sleep(5 SECONDS)
			msg("[confirm] [using_map.station_short] Control, holding position.","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("Your compliance is appreciated, [combined_name]. Scan commencing.")
			sleep(10 SECONDS)
			msg("[complain] We're on a [mission] [pick(mission_noun)] to [destname].","[prefix] [shipname]")
			sleep(15 SECONDS)
			msg("[combined_name], this is [using_map.station_short] Control. Scan complete. [completed]")
		if("policeflee")
			var/uhoh = pick("No can do chief, we got places to be.","Sorry but we've got places to be.","Not happening.","Ah fuck, who ratted us out this time?!","You'll never take me alive!")
			msg("[combined_name], this is [using_map.station_short] Control, your ship has been flagged for routine inspection. Hold position and prepare to be scanned.")
			sleep(5 SECONDS)
			msg("[uhoh]","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("This is [using_map.station_short] Control to all local security vessels; interdict and detain [combined_name]. Control out.")
		if("pathwarning")
			var/navhazard = pick ("a pocket of intense radiation","a pocket of unstable gas","a debris field","a secure installation","an active combat zone","a quarantined ship","a quarantined installation","a quarantined sector")
			var/confirm = pick("Understood","Roger that","Affirmative","Thanks for the heads up")
			var/safetravels = pick("Fly safe out there","Good luck","Safe travels","See you next week","Godspeed","Stars guide you")
			msg("[combined_name], this is [using_map.station_short] Control, your ship is approaching [navhazard], please adjust heading to [rand(1,360)].")
			sleep(5 SECONDS)
			msg("[confirm] [using_map.station_short] Control, adjusting course.","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("Your compliance is appreciated, [combined_name]. [safetravels].")
		if("dockingrequestgeneric")
			var/appreciation = pick("Much appreciated","Many thanks","Understood")
			var/dockingplan = pick("Starting final approach now.","Commencing docking procedures.","Autopilot engaged.")
			msg("[callname], this is [combined_name], requesting permission to dock.","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("[combined_name], this is [using_map.station_short] Control. Permission granted, proceed to landing pad [rand(1,24)]. Follow the green lights on your way in.")
			sleep(5 SECONDS)
			msg("[appreciation], [using_map.station_short] Control. [dockingplan]","[prefix] [shipname]")		
		if("dockingrequestdenied")
			var/reason = pick("don't have any free landing pads right now","don't have any landing pads large enough for your vessel","don't have the necessary facilities for your vessel type or class","can't verify your credentials")
			msg("[callname], this is [combined_name], requesting permission to dock.","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("[combined_name], this is [using_map.station_short] Control. Permission denied, we [reason].")
			sleep(5 SECONDS)
			msg("Understood, [using_map.station_short] Control.","[prefix] [shipname]")		
		if("dockingrequestsupply")
			var/intensifier = pick("very","pretty","critically","extremely","dangerously","desperately","kinda")
			var/low_thing = pick("ammunition","oxygen","water","food","medical supplies","reaction mass","hydrogen fuel","phoron fuel","fuel","beans","air freshener","booze","beer")
			var/appreciation = pick("Much appreciated","Many thanks","Understood","You're a lifesaver")
			var/dockingplan = pick("Starting final approach now.","Commencing docking procedures.","Autopilot engaged.")
			msg("[callname], this is [combined_name]. We're [intensifier] low on [low_thing] and need to resupply. Requesting permission to dock.","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("[combined_name], this is [using_map.station_short] Control. Permission granted, proceed to landing pad [rand(1,24)]. Follow the green lights on your way in.")
			sleep(5 SECONDS)
			msg("[appreciation], [using_map.station_short] Control. [dockingplan]","[prefix] [shipname]")
		if("dockingrequestrepair")
			var/damagestate = pick("a little banged up","missing some paint","suffering minor system malfunctions","having some technical issues","overdue maintenance","hearing some weird noises from the engines")
			var/appreciation = pick("Much appreciated","Many thanks","Understood","You're a lifesaver")
			var/dockingplan = pick("Starting final approach now.","Commencing docking procedures.","Autopilot engaged.")
			msg("[callname], this is [combined_name]. We're [damagestate]. Requesting permission to dock for repairs.","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("[combined_name], this is [using_map.station_short] Control. Permission granted, proceed to landing pad [rand(1,24)]. Follow the green lights on your way in. Repair crews are standing by.")
			sleep(5 SECONDS)
			msg("[appreciation], [using_map.station_short] Control. [dockingplan]","[prefix] [shipname]")
		if("dockingrequestmedical")
			var/medicalstate = pick("multiple casualties","several cases of radiation sickness","an unknown virus","a critically injured VIP","sick refugees","multiple cases of food poisoning","injured passengers","wounded marines","a delicate situation")
			var/appreciation = pick("Much appreciated","Many thanks","Understood","You're a lifesaver")
			var/dockingplan = pick("Starting final approach now.","Commencing docking procedures.","Autopilot engaged.")
			msg("[callname], this is [combined_name]. We have [medicalstate] on board. Requesting permission to dock for medical assistance.","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("[combined_name], this is [using_map.station_short] Control. Permission granted, proceed to landing pad [rand(1,24)]. Follow the green lights on your way in. Medtechs are standing by. Please follow standard quarantine procedures.")
			sleep(5 SECONDS)
			msg("[appreciation], [using_map.station_short] Control. [dockingplan]","[prefix] [shipname]")
		if("dockingrequestsecurity")
			var/securitystate = pick("several prisoners","a captured pirate","a wanted man","stowaways","incompetent shipjackers","a delicate situation")
			var/appreciation = pick("Much appreciated","Many thanks","Understood","You're a lifesaver")
			var/dockingplan = pick("Starting final approach now.","Commencing docking procedures.","Autopilot engaged.")
			msg("[callname], this is [combined_name]. We have [securitystate] on board and require security assistance. Requesting permission to dock.","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("[combined_name], this is [using_map.station_short] Control. Permission granted, proceed to landing pad [rand(1,24)]. Follow the green lights on your way in. Security teams are standing by for your arrival.")
			sleep(5 SECONDS)
			msg("[appreciation], [using_map.station_short] Control. [dockingplan]","[prefix] [shipname]")
		if("undockingrequest")
			var/safetravels = pick("Fly safe out there","Good luck","Safe travels","See you next week","Godspeed","Stars guide you")
			msg("[callname], this is [combined_name], requesting permission to depart from pad [rand(1,24)].","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("[combined_name], this is [using_map.station_short] Control. Permission granted. Docking clamps released. [safetravels].")
		else
			msg("[callname], this is [combined_name] on a [mission] [pick(mission_noun)] to [destname], [pick(request_verb)] [request].","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("[combined_name], this is [using_map.station_short] Control, [response].")
			sleep(5 SECONDS)
			msg("[using_map.station_short] Control, [yes ? "thank you" : "understood"], good day.","[prefix] [shipname]")

/*	//OLD BLOCK, for reference
	//Ship sends request to ATC
	msg(full_request,"[prefix] [shipname]"
	sleep(5 SECONDS)
	//ATC sends response to ship
	msg(full_response)
	sleep(5 SECONDS)
	//Ship sends response to ATC
	msg(full_closure,"[prefix] [shipname]")
	return
*/