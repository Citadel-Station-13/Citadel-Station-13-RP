/// Also, massive additions/refactors by Killian, because the original incarnation was full of holes
/// Cleaned up to be less shit, again.

GLOBAL_DATUM_INIT(lore_atc, /datum/lore/atc_controller, new)

/datum/lore/atc_controller
	//Shorter delays means more traffic, which gives the impression of a busier system, but also means a lot more radio noise
	/// How long between ATC traffic
	var/delay_min = 18 MINUTES
	/// Adjusted to give approx 3 per hour, will work out to 9-15 over a full shift
	var/delay_max = 25 MINUTES

	/// How long to wait before sending the first message of the shift.
	var/initial_delay = 2 MINUTES
	/// When the next message should happen in world.time - Making it default to min value
	var/next_message

	/// Force a specific type of messages
	var/force_chatter_type
	/// If ATC is squelched currently
	var/squelched = FALSE

	/// A block of frequencies so we can have them be static instead of being random for each call
	var/ertchannel
	var/medchannel
	var/engchannel
	var/secchannel
	var/sdfchannel


/datum/lore/atc_controller/New() //assuming global start this same or close to init.
	//generate our static event frequencies for the shift. alternately they can be completely fixed, up in the core block
	ertchannel = "[rand(700,749)].[rand(1,9)]"
	medchannel = "[rand(750,799)].[rand(1,9)]"
	engchannel = "[rand(800,849)].[rand(1,9)]"
	secchannel = "[rand(850,899)].[rand(1,9)]"
	sdfchannel = "[rand(900,999)].[rand(1,9)]"

	// 450 was the original time. Reducing to 300 due to lower init times on the server. If this is a problem, revert back to 450 as we had no ATC issues with that time.
	spawn(300 SECONDS) //Lots of lag at the start of a shift. Yes, the following lines *have* to be indented or they're not delayed by the spawn properly.
		/// HEY! if we have listiners for ssticker go use that instead of this snowflake.
		msg("Crew transfer complete. This shift's frequencies are as follows: Emergency Responders: [ertchannel]. Medical: [medchannel]. Engineering: [engchannel]. Security: [secchannel]. System Defense: [sdfchannel].")
		next_message = world.time + initial_delay
		START_PROCESSING(SSobj, src)

/datum/lore/atc_controller/process(delta_time)
	if(world.time >= next_message)
		next_message = world.time + rand(delay_min, delay_max)
		random_convo()

/datum/lore/atc_controller/proc/msg(message, sender)
	ASSERT(message)
	GLOB.global_announcer.autosay("[message]", sender ? sender : "[GLOB.using_map.dock_name] Control")

/datum/lore/atc_controller/proc/reroute_traffic(yes = TRUE)
	if(yes)
		if(!squelched)
			msg("Re-routing traffic and fleet patterns around [GLOB.using_map.station_name].")
		squelched = TRUE
		STOP_PROCESSING(SSobj, src) //muh performance
	else
		if(squelched)
			msg("Resuming normal fleet patterns and traffic.")
		squelched = FALSE
		START_PROCESSING(SSobj, src)

/datum/lore/atc_controller/proc/shift_ending(evac = FALSE)
	msg("[GLOB.using_map.shuttle_name], this is [GLOB.using_map.dock_name] Control, you are cleared to complete routine transfer from [GLOB.using_map.station_name] to [GLOB.using_map.dock_name].")
	sleep(5 SECONDS)
	if(QDELETED(src))
		return
	msg("[GLOB.using_map.shuttle_name] departing [GLOB.using_map.dock_name] for [GLOB.using_map.station_name] on routine transfer route. Estimated time to arrival: ten minutes.","[GLOB.using_map.shuttle_name]")

/// Next level optimzation for this: datumize the convo (see main holopads/holodisk!)
/datum/lore/atc_controller/proc/random_convo()
	/// Resolve to the instances
	// OKAY what's happening here is a lot less agony inducing than it might seem. All that's happening here is a weighted RNG choice between the listed options in a variable.
	// The first, [1], is for NanoTrasen Incorporated, while the second option is for ALL organizations including NT. You can add/adjust these options and weights to your hearts content.
	// ALL the companies and items this list pulls from can be found in the organizations.dm file in this same folder (busy_space).
	// I'm restoring this to unweighted: with further local tests NT is still *outrageously* common, far more common than the weighting implies
	// With a small list of ship names/identifiers, this can lead to situations like seemingly-identical ships landing multiple times without taking off again.
	var/datum/lore/organization/source = GLOB.loremaster.organizations[pick(GLOB.loremaster.organizations)]

	/// repurposed for new fun stuff
	var/datum/lore/organization/secondary = GLOB.loremaster.organizations[pick(GLOB.loremaster.organizations)]

	//Let's get some mission parameters, pick our first ship
	/// get the name - don't need to for now! uncommented to avoid compile warnings.
	//var/source_name = source.name

	/// Use the short name
	var/source_owner = source.short_name

	/// Pick a random prefix
	var/source_prefix = pick(source.ship_prefixes)

	/// The value of the prefix is the mission type that prefix does
	var/source_mission = source.ship_prefixes[source_prefix]

	/// Pick a random ship name
	var/source_shipname = pick(source.ship_names)

	/// Destination is where?
	var/source_destname = pick(source.destination_names)

	/// Which faction class do we belong to?
	var/source_org_type = source.org_type

	/// Are we part of the fleet? Not needed whilst fleet events are disabled
	// var/source_fleet = source.fleet

	/////////////

	//pick our second ship
	var/secondary_owner = secondary.short_name

	/// Pick a random prefix
	var/secondary_prefix = pick(secondary.ship_prefixes)

	/// Pick a random ship name
	var/secondary_shipname = pick(secondary.ship_names)

	/// Which faction class do we belong to?
	var/secondary_org_type = secondary.org_type

	/// Is this ship part of the fleet too?
	// Not set up yet. Leaving commented out until then.
	//var/secondary_fleet = secondary.fleet

	var/combined_first_name = "[source_owner][source_prefix] |[source_shipname]|"
	var/combined_second_name = "[secondary_owner][secondary_prefix] |[secondary_shipname]|"

	var/alt_atc_names = list("[GLOB.using_map.dock_name] Flight Control","[GLOB.using_map.dock_name] FliCon","[GLOB.using_map.dock_name] System Control","[GLOB.using_map.dock_name] Star Control","[GLOB.using_map.dock_name] SysCon","[GLOB.using_map.dock_name] Control","[GLOB.using_map.dock_name] STC","[GLOB.using_map.dock_name] StarCon")
	/// pull from a list of owner-specific flight ops, to allow an extra dash of flavor
	var/mission_noun = pick(source.flight_types)
	/// if our source has the complex_tasks flag, regenerate with a two-stage assignment
	if(source.complex_tasks)
		mission_noun = "[pick(source.task_types)] [pick(source.flight_types)]"

	//First response is 'yes', second is 'no', we need both or this falls over
	var/list/requests = list(
		"special flight rules" = list("authorizing special flight rules", "denying special flight rules, not allowed for your traffic class"),
		"current solar weather info" = list("sending you the relevant information via tightbeam", "your request has been queued, stand by"),
		"aerospace priority" = list("affirmative, aerospace priority is yours", "negative, another vessel has priority right now"),
		"system traffic info" = list("sending you current traffic info", "request queued, please hold"),
		"refueling information" = list("sending refueling information now", "depots currently experiencing fuel shortages, advise you move on"),
		"a current system time sync" = list("sending time sync ping to you now", "your ship isn't compatible with our time sync, set time manually"),
		"current system starcharts" = list("transmitting current starcharts", "your request is queued, overloaded right now")
	)

	//Random chance things for variety
	var/chatter_type = "normal"
	if(force_chatter_type)
		chatter_type = force_chatter_type
	//I have to offload this from the chatter_type switch below and do it here.
	/*
	else if(source_law_abiding && source_fleet)
		chatter_type = pickweight(list("fleettraffic" = 90, "emerg" = 10, "dockingrequestgeneric" = 10,"dockingrequestsupply" = 10,
		"dockingrequestrepair" = 10,"undockingrequest" = 5, "normal"))
	*/

	//RIP MBT. this might make travel advisories a little more common, but probably not significantly so given the odds involved
	else if(source_org_type == "retired" || secondary_org_type == "retired")
		chatter_type = "traveladvisory"
		
	//this is ugly but when I tried to use (not-smuggler-or-not-pirate)-and-pirate it tripped a pirate-v-pirate skirmish, still not sure why even after doublechecking all the orgtypes and the logic itself. might as well stick it up here so it takes priority over other combos.
	else if((source_org_type == "government" || source_org_type == "neutral" || source_org_type == "military" || source_org_type == "corporate" || source_org_type == "system defense") && secondary_org_type == "pirate")
		chatter_type = "distress"

	//this can probably just be retired in favour of the final 'else' block below at this point? not sure.
	else if((source_org_type == "government" || source_org_type == "neutral" || source_org_type == "military" || source_org_type == "corporate"))
		chatter_type = pickweight(list("emerg" = 5, "policescan" = 25, "traveladvisory" = 25,
		"pathwarning" = 30, "docking_request_chain" = 150, "undocking_request_chain" = 120,
		"normal"))

	//The following filters *always* fire their 'unique' event when they're tripped, simply because the conditions behind them are quite rare to begin with
	//just straight up funnel smugglers into always being caught, otherwise we get them asking for traffic info and stuff. if their disguises work then nobody is any the wiser.
	else if(source_org_type == "smugglers" && secondary_org_type != "system defense")
		chatter_type = "policeflee"

	//ditto, if an SDF ship catches them
	else if(source_org_type == "smugglers" && secondary_org_type == "system defense")
		chatter_type = "policeshipflee"

	else if(source_org_type == "pirate" && secondary_org_type == "system defense") //if we roll this combo instead, time for the SDF to do their fucking job
		chatter_type = "policeshipcombat"

	else if(source_org_type == "pirate" && secondary_org_type != "system defense") //but if we roll THIS combo, time to alert the SDF to get off their asses
		chatter_type = "hostiledetected"

	//SDF-specific events that need to filter based on the second party (basically just the following SDF-unique list with the soft-result ship scan thrown in)
	else if(source_org_type == "system defense" && (secondary_org_type == "government" || secondary_org_type == "neutral" || secondary_org_type == "military" || secondary_org_type == "corporate")) //let's see if we can narrow this down, I didn't see many ship-to-ship scans
		chatter_type = pickweight(list("policeshipscan" = 45, "sdfpatrolupdate", 
		"docking_request_chain" = 200, "undocking_request_chain" = 80, "normal"))

	//SDF-specific events that don't require the secondary at all, in the event that we manage to roll SDF + hostile/smuggler or something
	else if(source_org_type == "system defense")
		chatter_type = pickweight(list("sdfpatrolupdate", "docking_request_chain" = 60, "undocking_request_chain" = 60, "normal"))

	//if we somehow don't match any of the other existing filters once we've run through all of them
	else
		chatter_type = pickweight(list("emerg" = 10, "policescan" = 25, "traveladvisory" = 25,
		"pathwarning" = 30, "docking_request_chain" = 150, "undocking_request_chain" = 120,
		"normal"))

	//I probably should do some kind of pass here to work through all the possible combinations of major factors and see if the filtering list needs reordering or modifying, but I really can't be arsed

	//Chance for them to say yes vs no
	var/yes = prob(90)
	var/request = pick(requests)
	var/callname = pick(alt_atc_names)
	var/response = requests[request][yes ? 1 : 2] //1 is yes, 2 is no
	var/number = rand(1,42)
	var/zone = pick("Alpha", "Beta", "Gamma", "Delta", "Epsilon", "Zeta", "Eta",
		"Theta", "Iota", "Kappa", "Lambda", "Mu", "Nu", "Xi", "Omicron", "Pi",
		"Rho", "Sigma", "Tau", "Upsilon", "Phi", "Chi", "Psi", "Omega")
	//fallbacks in case someone sets the dock_type on the map datum to null- it defaults to "station" normally
	var/landing_zone = "LZ [zone]"
	var/landing_move = "landing request"
	var/landing_short = "land"
	switch(GLOB.using_map.dock_type)
		if("station")		//standard station pattern
			landing_zone = "docking bay [number]"
			landing_move = "docking request"
			landing_short = "dock"
		if("surface")		//formal installations with proper facilities
			landing_zone = "landing pad [number]"
			landing_move = "landing request"
			landing_short = "land"
		if("frontier")		//for frontier bases - landing spots are literally just open ground, maybe concrete at best
			landing_zone = "LZ [zone]"
			landing_move = "landing request"
			landing_short = "land"

	// what you're about to witness is what feels like an extremely kludgy rework of the system, but it's more 'flexible' and allows events that aren't just ship-stc-ship
	// something more elegant could probably be done, but it won't be done by somebody as half-competent as me
	switch(chatter_type)
		// Fleet specific chatter (This should be adjusted if new maps wildy detract from the similar set-up here. Station maps can still work for this if a nearby "Primary" facility is designated)
		if("fleettraffic")
			if(prob(90)) // Good & Neutral Fleet reports
				var/report = pick("All systems are clear and we're maintaining near sector patrol with the [GLOB.using_map.station_name]",
					"Mining patrol and operations are commencing now. We'll have a haul to return within the next [pick("10","15","20","25","30","40","45","50")] minutes",
					"Minor pirate activity was detected nearby. We're leading a small patrol of [pick("2","3","4")] frigates over to clear it out",
					"PARA operators on-board are helping with the local populace on a nearby planet and we'll be stuck here for rest of our crews' shift",
					"Our scout craft have returned with word of potential Vox shoals. Stand by for further updates",
					"Medical teams are currently deployed on a nearby planet providing aid after a recent [pick("natural disaster","ship crashed into the outpost","hostile attick")]",
					"We're currently analyzing a local wormhole. Please keep a safe distance from the vessel until further notice",
					"We have confirmed visuals of [rand(3,15)] Diona clinging onto the [GLOB.using_map.dock_name] hull. We'll have reports of first contact with them in a moment",
					"Scanners show the nearby sub-sector of space has increased hostile activity. We advise to route patrols closer to our research vessels, and flagship until we clear it",
					"The scout team is reporting much lower than usual hostile activity in the sub-sector",
					"Our vessel is undergoining early transfer procedures for the crew and should be at the [GLOB.using_map.dock_name] in roughly [pick("5","10","15")] minutes",
					"Mining teams report that they found a resource rich asteroid belt. They're requesting additional fleet support in case of a pirate attack",
					"All pending issues are resolved on the vessel and we're resuming normal fleet patterns now")
				msg("This is the [combined_first_name] reporting in to the [GLOB.using_map.dock_name] with fleet updates. [report].","[source_prefix] [source_shipname]")
				sleep(6 SECONDS)
				// To try and give a more organic response on Traffic Control
				if(prob(50))
					msg("This is [GLOB.using_map.dock_name]. Report received [source_prefix] [source_shipname]. Continue operations as normal.")
				else
					msg("[source_prefix] [source_shipname], thank you for your report. Please proceed operations as normal. [GLOB.using_map.dock_name], out.")
			else // For when the fleet has to report something unfortuante has happend
				var/bad_report = pick("Recent cultist activity on the nearby planet we scouted has deemed the area unsafe for exploration and mining operations",
					"The medical wing on our ship is over-capacity after the recent rescue operation of the crashed [pick("cruise ship", "trading vessel", "ship")] into a nearby [pick("station","outpost","colony","asteroid")]. We might need additional aid [pick("at this rate","soon","later")]",
					"A recent hostile boarding action has left our ship severely damaged and we're heading back to dock. We have multiple injured aboard",
					"The ships food supplies are running low after our hydroponics bay was destroyed due to [pick("uncontrolled plant growth","atmospheric failure","unruly crew")], and we're needing additional supplies",
					"A recent artifact we recovered on our ship has knocked out our [pick("life support","engines","gyros","AI")]",
					"We ran into an asteroid belt that wasn't picked up on our scanners and our engines are currently knocked out",
					"The ship is overrun with excessive vermin and its affecting crew productivity",
					"A recent fight with pirates has left [pick("one","two")] of our decks de-pressurized. We're attempting to reach the [GLOB.using_map.dock_name] for fleet repairs",
					"Our medical department is overwhelmed due to [pick("a viral outbreak","a meteor storm","a clown's joke gone wrong")], and we are in need of supplies and personnel",
					"Our gateway system is malfunctioning and we're dealing with a swarm of [pick("hostile aliens","hostiles in red cloaks","hostiles")]. Possible backup needed")
				msg("Attention [GLOB.using_map.dock_name], this is the [combined_first_name] with an urgent report for the fleet. [bad_report].","[source_prefix] [source_shipname]")
				sleep(5 SECONDS)
				if(prob(50))
					msg("Thank you for the update [source_prefix] [source_shipname]. We'll relay this to the needed Captains. [GLOB.using_map.dock_name], out.")
				else
					msg("Understood [source_prefix] [source_shipname]. Keep us updated on any changes or developments.")
					sleep(5 SECONDS)
					msg("Will do [GLOB.using_map.dock_name]. [source_shipname], over and out.","[source_prefix] [source_shipname]")
		// End of Fleet specific chatter
		//mayday call
		if("emerg")
			var/problem = pick("We have hull breaches on multiple decks",
				"We have unknown hostile life forms on board", "Our primary drive is failing",
				"We have asteroids impacting the hull", "We're experiencing a total loss of engine power",
				"We have hostile ships closing fast", "There's smoke in the cockpit",
				"We have unidentified boarders", "Our life support has failed",
				"We have hostiles in blood red clothes")
			msg("<b>Mayday, mayday, mayday!</b> This is [combined_first_name] declaring an emergency! [problem]!","[source_prefix] [source_shipname]")
			sleep(5 SECONDS)
			msg("[combined_first_name], this is [GLOB.using_map.dock_name] Control, copy. Switch to emergency responder channel [ertchannel].")
			sleep(5 SECONDS)
			msg("Understood [GLOB.using_map.dock_name] Control, switching now!","[source_prefix] [source_shipname]")
		//Control scan event: soft outcome
		if("policescan")
			var/confirm = pick("Understood","Roger that","Affirmative","Copy that")
			var/complain = pick("I hope this doesn't take too long.","Can we hurry this up?","Make it quick.","This better not take too long.","Is this really necessary?")
			var/completed = pick("You're free to proceed.","Everything looks fine, carry on.","You're clear, move along.","Apologies for the delay, you're clear.","Switch to channel [sdfchannel] and await further instruction.")
			msg("[combined_first_name], this is [GLOB.using_map.dock_name] Control, your [pick("ship","vessel","starship")] has been flagged for routine inspection. Hold position and prepare to be scanned.")
			sleep(5 SECONDS)
			msg("[confirm] [GLOB.using_map.dock_name] Control, holding position.","[source_prefix] [source_shipname]")
			sleep(5 SECONDS)
			msg("Your compliance is appreciated, [combined_first_name]. Scan commencing.")
			sleep(10 SECONDS)
			msg(complain,"[source_prefix] [source_shipname]")
			sleep(15 SECONDS)
			msg("[combined_first_name], this is [GLOB.using_map.dock_name] Control. Scan complete. [completed]")
		//Control scan event: hard outcome
		if("policeflee")
			var/uhoh = pick("No can do chief, we got places to be.","Sorry but we've got places to be.","Not happening.","Ah fuck, who ratted us out this time?!","You'll never take me alive!","Hey, I have a cloaking device! You can't see me!","I'm going to need to ask for a refund on that stealth drive...","I'm afraid I can't do that, Control.","Ah |hell|.","Fuck!","This isn't the ship you're looking for.","Well. This is awkward.","Uh oh.","I surrender!")
			msg("Unknown [pick("ship","vessel","starship")], this is [GLOB.using_map.dock_name] Control, identify yourself and submit to a full inspection. Flying without an active transponder is a violation of system regulations.")
			sleep(5 SECONDS)
			msg("[uhoh]","[source_shipname]")
			sleep(5 SECONDS)
			msg("This is [GLOB.using_map.starsys_name] Defense Control to all local assets: vector to interdict and detain [combined_first_name]. Control out.","[GLOB.using_map.starsys_name] Defense Control")
		//SDF scan event: soft outcome
		if("policeshipscan")
			var/confirm = pick("Understood","Roger that","Affirmative","Copy that")
			var/complain = pick("I hope this doesn't take too long.","Can we hurry this up?","Make it quick.","This better not take too long.","Is this really necessary?")
			var/completed = pick("You're free to proceed.","Everything looks fine, carry on.","You're clear. Move along.","Apologies for the delay, you're clear.","Switch to channel [sdfchannel] and await further instruction.")
			msg("[combined_second_name], this is [combined_first_name], your [pick("ship","vessel","starship")] has been flagged for routine inspection. Hold position and prepare to be scanned.","[source_prefix] [source_shipname]")
			sleep(5 SECONDS)
			msg("[confirm] [combined_first_name], holding position.","[secondary_prefix] [secondary_shipname]")
			sleep(5 SECONDS)
			msg("Your compliance is appreciated, [combined_second_name]. Scan commencing.","[source_prefix] [source_shipname]")
			sleep(10 SECONDS)
			msg(complain,"[secondary_prefix] [secondary_shipname]")
			sleep(15 SECONDS)
			msg("[combined_second_name], this is [combined_first_name]. Scan complete. [completed]","[source_prefix] [source_shipname]")
		//SDF scan event: hard outcome
		if("policeshipflee")
			var/uhoh = pick("No can do chief, we got places to be.","Sorry but we've got places to be.","Not happening.","Ah fuck, who ratted us out this time?!","You'll never take me alive!","Hey, I have a cloaking device! You can't see me!","I'm going to need to ask for a refund on that stealth drive...","I'm afraid I can't do that, |[source_shipname]|.","Ah |hell|.","Fuck!","This isn't the ship you're looking for.","Well. This is awkward.","Uh oh.","I surrender!")
			msg("Unknown [pick("ship","vessel","starship")], this is [combined_second_name], identify yourself and submit to a full inspection. Flying without an active transponder is a violation of system regulations.","[secondary_prefix] [secondary_shipname]")
			sleep(5 SECONDS)
			msg("[uhoh]","[source_shipname]")
			sleep(5 SECONDS)
			msg("[GLOB.using_map.starsys_name] Defense Control, this is [combined_second_name], we have a situation here, please advise.","[secondary_prefix] [secondary_shipname]")
			sleep(5 SECONDS)
			msg("Defense Control copies, [combined_second_name], reinforcements are en route. Switch further communications to encrypted band [sdfchannel].","[GLOB.using_map.starsys_name] Defense Control")
		//SDF scan event: engage primary in combat! fairly rare since it needs a pirate/vox + SDF roll
		if("policeshipcombat")
			var/battlestatus = pick("requesting reinforcements.","we need backup! Now!","holding steady.","we're holding our own for now.","we have them on the run.","they're trying to make a run for it!","we have them right where we want them.","we're badly outgunned!","we have them outgunned.","we're outnumbered here!","we have them outnumbered.","this'll be a cakewalk.",10;"notify their next of kin.")
			msg("[GLOB.using_map.starsys_name] Defense Control, this is [combined_second_name], engaging [combined_first_name] [pick("near route","in sector")] [rand(1,100)], [battlestatus]","[secondary_prefix] [secondary_shipname]")
			sleep(5 SECONDS)
			msg("[GLOB.using_map.starsys_name] Defense Control copies, [combined_second_name]. Keep us updated.","[GLOB.using_map.starsys_name] Defense Control")
		//SDF event: patrol update
		if("sdfpatrolupdate")
			var/statusupdate = pick("nothing unusual so far","nothing of note","everything looks clear so far","ran off some [pick("pirates","marauders")] near route [pick(1,100)], [pick("no","minor")] damage sustained, continuing patrol","situation normal, no suspicious activity yet","minor incident on route [pick(1,100)]","Code 7-X [pick("on route","in sector")] [pick(1,100)], situation is under control","seeing a lot of traffic on route [pick(1,100)]","caught a couple of smugglers [pick("on route","in sector")] [pick(1,100)]","sustained some damage in a skirmish just now, we're heading back for repairs")
			msg("[GLOB.using_map.starsys_name] Defense Control, this is [combined_first_name] reporting in, [statusupdate], over.","[source_prefix] [source_shipname]")
			sleep(5 SECONDS)
			msg("[GLOB.using_map.starsys_name] Defense Control copies, [combined_first_name]. Keep us updated, out.","[GLOB.using_map.starsys_name] Defense Control")
		//DefCon event: hostile found
		if("hostiledetected")
			var/orders = pick("Engage on sight","Engage with caution","Engage with extreme prejudice","Engage at will","Search and destroy","Bring them in alive, if possible","Interdict and detain","Keep your eyes peeled","Bring them in, dead or alive","Stay alert")
			msg("This is [GLOB.using_map.starsys_name] Defense Control to all SDF assets. Priority update follows.","[GLOB.using_map.starsys_name] Defense Control")
			sleep(5 SECONDS)
			msg("Be on the lookout for [combined_first_name], last sighted near route [rand(1,100)]. [orders]. DefCon, out.","[GLOB.using_map.starsys_name] Defense Control")
		//Ship event: distress call, under attack
		if("distress")
			msg("+Mayday, mayday, mayday!+ This is [combined_first_name] declaring an emergency! We are under attack by [combined_second_name]! Requesting immediate assistance!","[source_prefix] [source_shipname]")
			sleep(5 SECONDS)
			msg("[combined_first_name], this is [GLOB.using_map.starsys_name] Defense Control, copy. SDF is en route, contact on [sdfchannel].")
			sleep(5 SECONDS)
			msg("Understood [GLOB.using_map.starsys_name] Defense Control, switching now!","[source_prefix] [source_shipname]")
		//Control event: travel advisory
		if("traveladvisory")
			var/flightwarning = pick("Solar flare activity is spiking and expected to cause issues along main flight lanes [rand(1,33)], [rand(34,67)], and [rand(68,100)]",
			"Pirate activity is on the rise, stay close to System Defense vessels","We're seeing [pick("a rise","an increase","a surge")] in [pick("illegal","unauthorized","illicit","unlicensed")] salvage operations, please report any [pick("unusual","suspicious")] activity to the nearest SDF vessel via channel [sdfchannel]",
			"Vox Marauder activity is higher than usual, report any [pick("unusual","suspicious")] activity to the nearest System Defense vessel",
			"A quarantined [pick("fleet","convoy")] is passing through the system along route [rand(1,100)], please observe minimum safe distance",
			"A prison [pick("fleet","convoy")] is passing through the system along route [rand(1,100)], please observe minimum safe distance",
			"Traffic volume is higher than normal, expect processing delays","Anomalous bluespace activity detected along route [rand(1,100)], exercise caution",
			"Smugglers have been particularly active lately, expect increased security scans","Depots are currently experiencing a fuel shortage, expect delays and higher rates",
			"Asteroid mining has displaced debris dangerously close to main flight lanes on route [rand(1,100)], watch for potential impactors",
			"[pick("Pirate","Vox Marauder")] and System Defense forces are currently engaged in skirmishes throughout the system, please steer clear of any active combat zones",
			"A [pick("fuel tanker","cargo liner","passenger liner","freighter","transport ship")] has collided with a [pick("fuel tanker","cargo liner","passenger liner","freighter","transport ship")] near route [rand(1,100)], watch for debris and do not impede emergency service vessels",
			"A [pick("fuel tanker","cargo liner","passenger liner","freighter","transport ship")] on route [rand(1,100)] has experienced total engine failure. Emergency response teams are en route, please observe minimum safe distances and do not impede emergency service vessels",
			"Transit routes have been recalculated to adjust for planetary drift. Please synch your astronav computers as soon as possible to avoid delays and difficulties",
			"[pick("Bounty hunters","System Defense officers","Mercenaries")] are currently searching for a wanted fugitive, report any sightings of suspicious activity to System Defense via channel [sdfchannel]",
			"Mercenary contractors are currently conducting aggressive [pick("piracy","marauder")] suppression operations",10;"It's space carp breeding season. [pick("Stars","Gods","God","Goddess")] have mercy on you all, because the carp won't")
			msg("This is [GLOB.using_map.dock_name] Control to all vessels in the [GLOB.using_map.starsys_name] system. Priority travel advisory follows.")
			sleep(5 SECONDS)
			msg("[flightwarning]. Control out.")
		//Control event: warning to a specific vessel
		if("pathwarning")
			var/navhazard = pick("a pocket of intense radiation","a pocket of unstable gas","a debris field","a secure installation","an active combat zone","a quarantined ship","a quarantined installation","a quarantined sector","a live-fire SDF training exercise","an ongoing Search & Rescue operation")
			var/confirm = pick("Understood","Roger that","Affirmative","Our bad","Thanks for the heads up")
			var/safetravels = pick("Fly safe out there","Good luck","Safe travels","Godspeed","Stars guide you","Don't let it happen again")
			msg("[combined_first_name], this is [GLOB.using_map.dock_name] Control, your [pick("ship","vessel","starship")] is approaching [navhazard], observe minimum safe distance and adjust your heading appropriately.")
			sleep(5 SECONDS)
			msg("[confirm] [GLOB.using_map.dock_name] Control, adjusting course.","[source_prefix] [source_shipname]")
			sleep(5 SECONDS)
			msg("Your compliance is appreciated, [combined_first_name]. [safetravels].")

		//Ship event: docking request chained
		if("docking_request_chain")
			var/path
			if(source_org_type == "system defense") //SDF won't get completely denied, that would look weird
				path = pickweight(list("generic" = 50, "sdf patrol" = 75, "resupply" = 25,"emergency" = 25,"delayed" = 25))
			else
				path = pickweight(list("generic" = 75,"resupply" = 25,"emergency" = 25,"denied" = 25,"delayed" = 25))
			var/subpath = pick("repair","security","medical")
			var/dockingplan = pick("Starting final approach now.","Commencing landing procedures.","Autopilot engaged.","Approach vector locked in.","In the pipe, five by five.")
			var/confirm_positive = pick("Much appreciated","Many thanks","Understood","Perfect, thank you","Excellent, thanks","Great","Copy that") //standard confirms
			var/confirm_negative = pick("Understood","Copy that")
			var/confirm_special = pick("Much appreciated","Many thanks","Understood","Perfect, thank you","Excellent, thanks","Great","Copy that","You're a lifesaver","We owe you one","I owe you one","Perfect, thank you") //used for resupply/emergency subs
			if(path == "emergency")
				subpath = pick("security","medical","repair")
			if(path == "generic")
				msg("[callname], this is [combined_first_name], [pick("stopping by","passing through")] on our way to [source_destname], requesting permission to [landing_short].","[source_prefix] [source_shipname]")
				sleep(5 SECONDS)
				msg("[combined_first_name], this is [GLOB.using_map.dock_name] Control. Permission granted, proceed to [landing_zone]. Follow the green lights on your way in.")
				sleep(5 SECONDS)
				msg("[confirm_positive], [GLOB.using_map.dock_name] Control. [dockingplan]","[source_prefix] [source_shipname]")
			if(path == "sdf patrol")
				confirm_positive = pick("Copy","Understood","Affirmative","10-4","Roger that")
				msg("[callname], this is [combined_first_name], returning from our system patrol route, requesting permission to [landing_short].","[source_prefix] [source_shipname]")
				sleep(5 SECONDS)
				msg("[combined_first_name], this is [GLOB.using_map.dock_name] Control. Permission granted, proceed to [landing_zone]. Follow the green lights on your way in.")
				sleep(5 SECONDS)
				msg("[confirm_positive], [GLOB.using_map.dock_name] Control. [dockingplan]","[source_prefix] [source_shipname]")
			else if(path == "resupply")
				var/preintensifier = pick(75;"getting ",75;"running ","") //whitespace hack, sometimes they'll add a preintensifier, but not always
				var/intensifier = pick("very","pretty","critically","extremely","dangerously","desperately","kinda","a little","a bit","rather","sorta")
				var/low_thing = pick("ammunition","munitions","clean water","food","spare parts","medical supplies","reaction mass","gas","hydrogen fuel","phoron fuel","fuel",10;"tea",10;"coffee",10;"soda",10;"pizza",10;"beer",10;"booze",10;"vodka",10;"snacks") //low chance of a less serious shortage
				msg("[callname], this is [combined_first_name]. We're [preintensifier][intensifier] low on [low_thing]. Requesting permission to [landing_short] for resupply.","[source_prefix] [source_shipname]")
				sleep(5 SECONDS)
				msg("[combined_first_name], this is [GLOB.using_map.dock_name] Control. Permission granted, proceed to [landing_zone]. Follow the green lights on your way in.")
				sleep(5 SECONDS)
				msg("[confirm_special], [GLOB.using_map.dock_name] Control. [dockingplan]","[source_prefix] [source_shipname]")
			else if(path == "emergency")
				if(subpath == "repair")
					var/damagestate = pick("We've experienced some hull damage","We're suffering minor system malfunctions","We're having some technical issues","We're overdue maintenance","We have several minor space debris impacts","We've got some battle damage here","Our reactor output is fluctuating","We're hearing some weird noises from the [pick("engines","pipes","ducting","HVAC")]","Our artificial gravity generator has failed","Our life support is failing","Our environmental controls are busted","Our water recycling system has shorted out","Our navcomp is freaking out","Our systems are glitching out","We just got caught in a solar flare","We had a close call with an asteroid","We have a minor [pick("fuel","water","oxygen","gas")] leak","We have depressurized compartments","We have a hull breach","Our shield generator is on the fritz","Our RCS is acting up","One of our [pick("hydraulic","pneumatic")] systems has depressurized","Our repair bots are malfunctioning")
					msg("[callname], this is [combined_first_name]. [damagestate]. Requesting permission to [landing_short] for repairs and maintenance.","[source_prefix] [source_shipname]")
					sleep(5 SECONDS)
					msg("[combined_first_name], this is [GLOB.using_map.dock_name] Control. Permission granted, proceed to [landing_zone]. Follow the green lights on your way in. Repair crews are standing by, contact them on channel [engchannel].")
					sleep(5 SECONDS)
					msg("[confirm_special], [GLOB.using_map.dock_name] Control. [dockingplan]","[source_prefix] [source_shipname]")
				else if(subpath == "medical")
					var/medicalstate = pick("multiple casualties","several cases of radiation sickness","an unknown virus","an unknown infection","a critically injured VIP","sick refugees","multiple cases of food poisoning","injured passengers","sick passengers","injured engineers","wounded marines","a delicate situation","a pregnant passenger","injured castaways","recovered escape pods","unknown escape pods")
					msg("[callname], this is [combined_first_name]. We have [medicalstate] on board. Requesting permission to [landing_short] for medical assistance.","[source_prefix] [source_shipname]")
					sleep(5 SECONDS)
					msg("[combined_first_name], this is [GLOB.using_map.dock_name] Control. Permission granted, proceed to [landing_zone]. Follow the green lights on your way in. Medtechs are standing by, contact them on channel [medchannel].")
					sleep(5 SECONDS)
					msg("[confirm_special], [GLOB.using_map.dock_name] Control. [dockingplan]","[source_prefix] [source_shipname]")
				else if(subpath == "security")
					var/species = pick("human","unathi","lizard","tajaran","feline","skrell","akula","promethean","sergal","synthetic","robotic","teshari","avian","vulpkanin","canine","vox","zorren","hybrid","mixed-species","vox","grey","alien")
					var/securitystate = pick("several [species] convicts","a captured pirate","a wanted criminal","[species] stowaways","incompetent [species] shipjackers","a delicate situation","a disorderly passenger","disorderly [species] passengers","ex-mutineers","a captured vox marauder","captured vox marauders","stolen goods","a container full of confiscated contraband","containers full of confiscated contraband",5;"a very lost shadekin",5;"a raging case of [pick("spiders","crabs")]") //gotta have a little something to lighten the mood now and then
					msg("[callname], this is [combined_first_name]. We have [securitystate] on board and require security assistance. Requesting permission to [landing_short].","[source_prefix] [source_shipname]")
					sleep(5 SECONDS)
					msg("[combined_first_name], this is [GLOB.using_map.dock_name] Control. Permission granted, proceed to [landing_zone]. Follow the green lights on your way in. Security teams are standing by, contact them on channel [secchannel].")
					sleep(5 SECONDS)
					msg("[confirm_special], [GLOB.using_map.dock_name] Control. [dockingplan]","[source_prefix] [source_shipname]")
			else if(path == "denied")
				var/reason = pick("we don't have any landing pads large enough for your vessel","we don't have the necessary facilities for your vessel type or class")
				var/disappointed = pick("That's unfortunate. [combined_first_name], out.","Damn shame. We'll just have to keep moving. [combined_first_name], out.","[combined_first_name], out.")
				msg("[callname], this is [combined_first_name], [pick("stopping by","passing through")] on our way to [source_destname], requesting permission to [landing_short].","[source_prefix] [source_shipname]")
				sleep(5 SECONDS)
				msg("[combined_first_name], this is [GLOB.using_map.dock_name] Control. Request denied, [reason].")
				sleep(5 SECONDS)
				msg("[confirm_negative], [GLOB.using_map.dock_name] Control. [disappointed]","[source_prefix] [source_shipname]")
			else if(path == "delayed")
				var/delay = rand(2,5) //base delay in minutes
				var/reason = pick("we don't have any free landing pads right now, please hold for [num2text(delay)] minutes","you're too far away, please close to ten thousand meters","we're seeing heavy traffic around the landing pads right now, please hold for [num2text(delay)] minutes","we're currently cleaning up a fuel spill on one of our free pads, please hold for [num2text(delay)] minutes","there are loose containers on our free pads, stand by for a couple of minutes whilst we secure them","another vessel has aerospace priority right now, please hold for [num2text(delay)] minutes")
				msg("[callname], this is [combined_first_name], [pick("stopping by","passing through")] on our way to [source_destname], requesting permission to [landing_short].","[source_prefix] [source_shipname]")
				sleep(5 SECONDS)
				msg("[combined_first_name], this is [GLOB.using_map.dock_name] Control. Request denied, [reason] and resubmit your request.")
				sleep(5 SECONDS)
				msg("[confirm_negative], [GLOB.using_map.dock_name] Control.","[source_prefix] [source_shipname]")
				sleep(delay MINUTES)
				msg("[callname], this is [combined_first_name], resubmitting [landing_move].","[source_prefix] [source_shipname]")
				sleep (5 SECONDS)
				msg("[combined_first_name], this is [GLOB.using_map.dock_name] Control. Everything appears to be in order now, permission granted, proceed to [landing_zone]. Follow the green lights on your way in.")
				sleep(5 SECONDS)
				msg("[confirm_positive], [GLOB.using_map.dock_name] Control. [dockingplan]","[source_prefix] [source_shipname]")
		//Ship event: undocking request chain
		if("undocking_request_chain")
			var/path
			if(source_org_type == "system defense") //SDF won't get completely denied, that would look weird
				path = pickweight(list("standard" = 50, "sdf patrol start" = 75, "delayed" = 25))
			else
				path = pickweight(list("standard" = 75, "denied" = 25,"delayed" = 25))
			var/takeoff = pick("depart","launch","take off","dust off")
			var/safetravels = pick("Fly safe out there","Good luck","Safe travels","See you next week","Godspeed","Stars guide you")
			var/thanks = pick("Copy that","Understood","Appreciated","Thanks","Don't worry about us","We'll be fine","You too","So long")
			var/denialreason
			if(path == "standard")
				msg("[callname], this is [combined_first_name], requesting permission to [takeoff] from [landing_zone].","[source_prefix] [source_shipname]")
				sleep(5 SECONDS)
				msg("[combined_first_name], this is [GLOB.using_map.dock_name] Control. Permission granted. Docking clamps released. [safetravels].")
				sleep(5 SECONDS)
				msg("[thanks], [GLOB.using_map.dock_name] Control. This is [combined_first_name] setting course for [source_destname], out.","[source_prefix] [source_shipname]")
			else if(path == "sdf patrol start")
				safetravels = pick("Fly safe out there","Good luck","Safe travels","Good hunting","Godspeed","Stars guide you")
				msg("[callname], this is [combined_first_name], requesting permission to [takeoff] from [landing_zone] to begin system patrol.","[source_prefix] [source_shipname]")
				sleep(5 SECONDS)
				msg("[combined_first_name], this is [GLOB.using_map.dock_name] Control. Permission granted. Docking clamps released. [safetravels].")
				sleep(5 SECONDS)
				msg("[thanks], [GLOB.using_map.dock_name] Control. This is [combined_first_name] beginning system patrol, out.","[source_prefix] [source_shipname]")
			else if(path == "denied")
				denialreason = pick("Security is requesting a full cargo inspection","Your ship has been impounded for multiple [pick("security","safety")] violations","Your ship is currently under quarantine lockdown","We have reason to believe there's an issue with your papers","Security personnel are currently searching for a fugitive in the docking area and have ordered all outbound ships remain grounded until further notice")
				msg("[callname], this is [combined_first_name], requesting permission to [takeoff] from [landing_zone].","[source_prefix] [source_shipname]")
				sleep(5 SECONDS)
				msg("Negative [combined_first_name], request denied. [denialreason].")
			else if(path == "delayed")
				var/delay = rand(2,5) //base delay in minutes
				denialreason = pick("Docking clamp malfunction, please hold","Fuel lines have not been secured","Ground crew are still on the pad","Loose containers are on the pad","Exhaust deflectors are not yet in position, please hold","There's heavy traffic right now, it's not safe for your vessel to launch","Another vessel has aerospace priority at this moment","Port officials are still aboard")
				msg("[callname], this is [combined_first_name], requesting permission to [takeoff] from [landing_zone].","[source_prefix] [source_shipname]")
				sleep(5 SECONDS)
				msg("Negative [combined_first_name], request denied. [denialreason]. Try again in [num2text(delay)] minutes.")
				sleep(delay MINUTES)
				msg("[callname], this is [combined_first_name], re-requesting permission to depart from [landing_zone].","[source_prefix] [source_shipname]")
				sleep(5 SECONDS)
				msg("[combined_first_name], this is [GLOB.using_map.dock_name] Control. Everything appears to be in order now, permission granted. Docking clamps released. [safetravels].")
				sleep(5 SECONDS)
				msg("[thanks], [GLOB.using_map.dock_name] Control. This is [combined_first_name] setting course for [source_destname], out.","[source_prefix] [source_shipname]")
		else //time for generic message
			msg("[callname], this is [combined_first_name] on [source_mission] [pick(mission_noun)] to [source_destname], requesting [request].","[source_prefix] [source_shipname]")
			sleep(5 SECONDS)
			msg("[combined_first_name], this is [GLOB.using_map.dock_name] Control, [response].")
			sleep(5 SECONDS)
			msg("[GLOB.using_map.dock_name] Control, [yes ? "thank you" : "understood"], out.","[source_prefix] [source_shipname]")
	return //oops, forgot to restore this

	/*	//OLD BLOCK, for reference
		//Ship sends request to ATC
		msg(full_request,"[source_prefix] [source_shipname]"
		sleep(5 SECONDS)
		//ATC sends response to ship
		msg(full_response)
		sleep(5 SECONDS)
		//Ship sends response to ATC
		msg(full_closure,"[source_prefix] [source_shipname]")
		return
	*/
