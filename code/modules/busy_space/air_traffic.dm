//Cactus, Speedbird, Dynasty, oh my

var/datum/lore/atc_controller/atc = new/datum/lore/atc_controller

/datum/lore/atc_controller
	var/delay_min = 25 MINUTES			//How long between ATC traffic, min.  Default is 40 mins. Slight reduction for +/- 5 consistency.
	var/delay_max = 35 MINUTES			//How long between ATC traffic, max.  Default is 25 mins.
	var/backoff_delay = 5 MINUTES		//How long to back off if we can't talk and want to.  Default is 5 mins.
	var/next_message					//When the next message should happen in world.time
	var/force_chatter_type				//Force a specific type of messages

	var/squelched = 0					//If ATC is squelched currently

/datum/lore/atc_controller/New()
	spawn(10 SECONDS) //Lots of lag at the start of a shift.
		msg("New shift beginning, resuming traffic control.")
	next_message = world.time + rand(delay_min,delay_max)
	process()

/datum/lore/atc_controller/process()
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
	global_announcer.autosay("[message]", sender ? sender : "[GLOB.using_map.starsys_name] Flight Control")

/datum/lore/atc_controller/proc/reroute_traffic(var/yes = 1)
	if(yes)
		if(!squelched)
			msg("Rerouting traffic away from [GLOB.using_map.station_name].")
		squelched = 1
	else
		if(squelched)
			msg("Resuming normal traffic routing around [GLOB.using_map.station_name].")
		squelched = 0

/datum/lore/atc_controller/proc/shift_ending(var/evac = 0)
	msg("Automated Tram departing [GLOB.using_map.station_name] for [GLOB.using_map.dock_name] on routine transfer route.","NT Automated Tram") //VOREStation Edit - Tram, tho.
	sleep(5 SECONDS)
	msg("Automated Tram, cleared to complete routine transfer from [GLOB.using_map.station_name] to [GLOB.using_map.dock_name].") //VOREStation Edit - Tram, tho.
	//TODO: update these to use a switchable value pulled from the map defines if we're going to have a rotation of maps

/datum/lore/atc_controller/proc/random_convo()
	var/one = pick(loremaster.organizations) //These will pick an index, not an instance
	var/two = pick(loremaster.organizations) //I'm now used for fake IFFs

	var/datum/lore/organization/source = loremaster.organizations[one] //Resolve to the instances
	var/datum/lore/organization/fakeiff = loremaster.organizations[two] //repurposed for new fun stuff

	//Let's get some mission parameters
	var/owner = source.short_name				//Use the short name
	var/prefix = pick(source.ship_prefixes)			//Pick a random prefix
	var/mission = source.ship_prefixes[prefix]		//The value of the prefix is the mission type that prefix does
	var/shipname = pick(source.ship_names)			//Pick a random ship name
	var/destname = pick(source.destination_names)		//destination is where?
	var/law_abiding = source.lawful				//do we fully observe system law (or are we otherwise favored by the system owners)?
	var/system_defense = source.sysdef			//are we system law?

	var/fakeowner = fakeiff.short_name
	var/fakeprefix = pick(fakeiff.ship_prefixes)		//Pick a random prefix
	var/fakeshipname = pick(fakeiff.ship_names)		//Pick a random ship name
	var/law_abiding2 = fakeiff.lawful
	var/system_defense2 = fakeiff.sysdef

	var/combined_name = "[owner][prefix] [shipname]"
	var/combined_fake_name = "[fakeowner][fakeprefix] [fakeshipname]"
	
	var/alt_atc_names = list("[GLOB.using_map.starsys_name] TraCon","[GLOB.using_map.starsys_name] System Control","[GLOB.using_map.starsys_name] Star Control","[GLOB.using_map.starsys_name] SysCon","[GLOB.using_map.starsys_name] Tower","[GLOB.using_map.starsys_name] Flight Control","[GLOB.using_map.starsys_name] STC","[GLOB.using_map.starsys_name] StarCon")
	var/mission_noun = pick(source.flight_types)		//pull from a list of owner-specific flight ops, to allow an extra dash of flavor
//	var/request_verb = list("requesting","calling for","asking for")	//defunct; always 'requesting' now - more formal

	//First response is 'yes', second is 'no'
	var/requests = list("[GLOB.using_map.station_short] transit clearance" = list("permission for transit granted", "permission for transit denied, contact regional on 953.5"),
						"planetary flight rules" = list("authorizing planetary flight rules", "denying planetary flight rules right now due to traffic"),
						"special flight rules" = list("authorizing special flight rules", "denying special flight rules, not allowed for your traffic class"),
						"current solar weather info" = list("sending you the relevant information via tightbeam", "cannot fulfill your request at the moment"),
						"nearby traffic info" = list("sending you current traffic info", "no available info in your area"),
						"remote telemetry data" = list("sending telemetry now", "no uplink from your ship, recheck your uplink and ask again"),
						"refueling information" = list("sending refueling information now", "depots currently experiencing fuel shortages, advise you move on"),
						"a current system time sync" = list("sending time sync ping to you now", "your ship isn't compatible with our time sync, set time manually"),
						"current system starcharts" = list("transmitting current starcharts", "your request is queued, overloaded right now")
						)

	//Random chance things for variety
	var/chatter_type = "normal"
	if(force_chatter_type)
		chatter_type = force_chatter_type
	else if(law_abiding && !system_defense) //I have to offload this from the chatter_type switch below and do it here, otherwise BYOND throws a shitfit for no discernable reason
		chatter_type = pick(5;"emerg",25;"policescan",25;"traveladvisory",30;"dockingrequestgeneric",30;"dockingrequestsupply",30;"dockingrequestrepair",30;"dockingrequestmedical",30;"dockingrequestsecurity",30;"undockingrequest","normal",30;"undockingdenied",30;"undockingdelayed")
	else if(system_defense && !law_abiding2 && !system_defense2) //no SDF scan/flee events with law-abiders or other SDF (in the rare event it manages to roll double SDF)
		chatter_type = pick(30;"policeshipscan",10;"policeshipflee",30;"dockingrequestgeneric",30;"dockingrequestsupply",30;"dockingrequestrepair",30;"dockingrequestmedical",30;"dockingrequestsecurity",30;"sdfbeginpatrol","normal")
	else if(system_defense)
		chatter_type = pick(30;"dockingrequestgeneric",30;"dockingrequestsupply",30;"dockingrequestrepair",30;"dockingrequestmedical",30;"dockingrequestsecurity",30;"undockingrequest",30;"sdfbeginpatrol","normal")
	else
		chatter_type = pick(5;"emerg",25;"policescan",10;"policeflee",10;"strangeactivity",25;"traveladvisory",30;"pathwarning",30;"dockingrequestgeneric",30;"dockingrequestdenied",30;"dockingrequestsupply",30;"dockingrequestrepair",30;"dockingrequestmedical",30;"dockingrequestsecurity",30;"undockingrequest",30;"undockingdenied",30;"undockingdelayed","normal")

	var/yes = prob(90) //Chance for them to say yes vs no

	var/request = pick(requests)
	var/callname = pick(alt_atc_names)
	var/response = requests[request][yes ? 1 : 2] //1 is yes, 2 is no

	// what you're about to witness is what feels like an extremely kludgy rework of the system, but it's more 'flexible' and allows events that aren't just ship-stc-ship
	// something more elegant could probably be done, but it won't be done by somebody as half-competent as me
	switch(chatter_type)
		if("emerg")
			var/problem = pick("We have hull breaches on multiple decks","We have unknown hostile life forms on board","Our primary drive is failing","We have asteroids impacting the hull","We're experiencing a total loss of engine power","We have hostile ships closing fast","There's smoke in the cockpit","We have unidentified boarders","Our life support has failed")
			msg("Mayday, mayday, mayday! This is [combined_name] declaring an emergency! [problem]!","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("[combined_name], this is [GLOB.using_map.starsys_name] Flight Control, copy. Switch to emergency responder channel [rand(700,999)].[rand(1,9)].")
			sleep(5 SECONDS)
			msg("Understood [GLOB.using_map.starsys_name] Flight Control, switching now.","[prefix] [shipname]")
		if("policescan")
			var/confirm = pick("Understood","Roger that","Affirmative")
			var/complain = pick("I hope this doesn't take too long.","Can we hurry this up?","Make it quick.","This better not take too long.")
			var/completed = pick("You're free to proceed.","Everything looks fine, carry on.","Apologies for the delay, you're clear.","Switch to [rand(700,999)].[rand(1,9)] and await further instruction.")
			msg("[combined_name], this is [GLOB.using_map.starsys_name] Flight Control, your [pick("ship","vessel","starship")] has been flagged for routine inspection. Hold position and prepare to be scanned.")
			sleep(5 SECONDS)
			msg("[confirm] [GLOB.using_map.starsys_name] Flight Control, holding position.","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("Your compliance is appreciated, [combined_name]. Scan commencing.")
			sleep(10 SECONDS)
			msg(complain,"[prefix] [shipname]")
			sleep(15 SECONDS)
			msg("[combined_name], this is [GLOB.using_map.starsys_name] Flight Control. Scan complete. [completed]")
		if("policeshipscan")
			var/confirm = pick("Understood","Roger that","Affirmative")
			var/complain = pick("I hope this doesn't take too long.","Can we hurry this up?","Make it quick.","This better not take too long.")
			var/completed = pick("You're free to proceed.","Everything looks fine, carry on.","Apologies for the delay, you're clear.","Switch to [rand(700,999)].[rand(1,9)] and await further instruction.")
			msg("[combined_fake_name], this is [combined_name], your [pick("ship","vessel","starship")] has been flagged for routine inspection. Hold position and prepare to be scanned.","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("[confirm] [combined_name], holding position.","[fakeprefix] [fakeshipname]")
			sleep(5 SECONDS)
			msg("Your compliance is appreciated, [combined_name]. Scan commencing.","[prefix] [shipname]")
			sleep(10 SECONDS)
			msg(complain,"[fakeprefix] [fakeshipname]")
			sleep(15 SECONDS)
			msg("[combined_fake_name], this is [combined_name]. Scan complete. [completed]","[prefix] [shipname]")
		if("policeshipflee")
			var/uhoh = pick("No can do chief, we got places to be.","Sorry but we've got places to be.","Not happening.","Ah fuck, who ratted us out this time?!","You'll never take me alive!","Hey, I have a cloaking device! You can't see me!","I'm going to need to ask for a refund on that stealth drive...","I'm afraid I can't do that, [shipname].")
			msg("[combined_fake_name], this is [combined_name], your [pick("ship","vessel","starship")] has been flagged for routine inspection. Hold position and prepare to be scanned.","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("[uhoh]","[fakeprefix] [fakeshipname]")
			sleep(5 SECONDS)
			msg("[GLOB.using_map.starsys_name] Defense Control, this is [combined_name], we have a situation here, Code Red. Requesting immediate reinforcement.","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("Defense Control copies, [combined_name], reinforcements en route. Switch further communications to encrypted band [rand(1000,1250)].[rand(1,9)].","[GLOB.using_map.starsys_name] Defense Control")
		if("policeflee")
			var/uhoh = pick("No can do chief, we got places to be.","Sorry but we've got places to be.","Not happening.","Ah fuck, who ratted us out this time?!","You'll never take me alive!","Hey, I have a cloaking device! You can't see me!","I'm going to need to ask for a refund on that stealth drive...","I'm afraid I can't do that, Control.")
			msg("[combined_fake_name], this is [GLOB.using_map.starsys_name] Flight Control, your [pick("ship","vessel","starship")] has been flagged for routine inspection. Hold position and prepare to be scanned.")
			sleep(5 SECONDS)
			msg("[uhoh]","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("This is [GLOB.using_map.starsys_name] Defense Control to all local assets, the [combined_fake_name] is broadcasting false IFF codes. Registry updated to [combined_name]: vector to interdict and detain. Control out.","[GLOB.using_map.starsys_name] Defense Control")
		if("strangeactivity")
			var/concern = pick("It looks like they're under attack.","I think they're being boarded.","We're not reading any lifesigns aboard.","There's a Vox Marauder right on top of them!","They're maneuvering erratically.","We're picking up some strange radiation patterns.","We can see multiple hull breaches from here.","They're leaking fuel everywhere.","Their drives are misfiring.")
			var/confirm = pick("Roger that","Affirmative","Understood","Thanks for the heads up")
			msg("[callname], this is [combined_name]. We're seeing some strange activity over on [combined_fake_name]. [concern]","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("[confirm], [combined_name]. Dispatching SysDef assets to investigate.")
			sleep(5 SECONDS)
			msg("SDC confirms investigate order, diverting assets.","[GLOB.using_map.starsys_name] Defense Control")
		if("traveladvisory")
			var/flightwarning = pick("Solar flare activity is spiking and expected to cause issues along main flight lanes [rand(1,33)], [rand(34,67)], and [rand(68,100)]","Pirate activity is on the rise, stay close to System Defense vessels","We're seeing a rise in illegal salvage operations, please report any unusual activity to the nearest SDF vessel","Vox Marauder activity is higher than usual, report any unusual activity to the nearest System Defense vessel","A quarantined [pick("fleet","convoy")] is passing through the system along route [rand(1,100)], please observe minimum safe distance","A prison [pick("fleet","convoy")] is passing through the system along route [rand(1,100)], please observe minimum safe distance","Traffic volume is higher than normal, expect processing delays","Anomalous bluespace activity detected, exercise caution","Smugglers have been particularly active lately, expect increased security scans","Depots are currently experiencing a fuel shortage, expect delays and higher rates","Asteroid mining has displaced debris dangerously close to main flight lanes on route [rand(1,100)], watch for potential impactors","[pick("Pirate","Vox Marauder")] and System Defense forces are currently engaged in skirmishes throughout the system, please steer clear of any active combat zones","A [pick("fuel tanker","cargo liner","passenger liner","freighter","transport ship")] has collided with a [pick("fuel tanker","cargo liner","passenger liner","freighter","transport ship")] near route [rand(1,100)], watch for debris and do not impede emergency service vessels","A [pick("fuel tanker","cargo liner","passenger liner","freighter","transport ship")] on route [rand(1,100)] has experienced total engine failure. Emergency response teams are en route, please observe minimum safe distances and do not impede emergency service vessels","Transit routes have been recalculated to adjust for planetary drift. Please synch your astronav computers as soon as possible to avoid delays and difficulties","[pick("Bounty hunters","System Defense officers")] are currently searching for a wanted fugitive, report any sightings of suspicious activity to your nearest System Defense agent","Mercenary contractors are currently conducting aggressive [pick("piracy","marauder")] suppression operations",10;"It's space carp breeding season. [pick("Stars","Gods","God","Goddess")] have mercy on you all, because the carp won't")
			msg("This is [GLOB.using_map.starsys_name] Flight Control to all vessels in the [GLOB.using_map.starsys_name] system. Priority travel advisory follows.")
			sleep(5 SECONDS)
			msg("[flightwarning]. Control out.")
		if("pathwarning")
			var/navhazard = pick ("a pocket of intense radiation","a pocket of unstable gas","a debris field","a secure installation","an active combat zone","a quarantined ship","a quarantined installation","a quarantined sector","a live-fire SDF training exercise","an ongoing Search & Rescue operation")
			var/confirm = pick("Understood","Roger that","Affirmative","Our bad","Thanks for the heads up")
			var/safetravels = pick("Fly safe out there","Good luck","Safe travels","Godspeed","Stars guide you","Don't let it happen again")
			msg("[combined_name], this is [GLOB.using_map.starsys_name] Flight Control, your [pick("ship","vessel","starship")] is approaching [navhazard], observe minimum safe distance and adjust your heading appropriately.")
			sleep(5 SECONDS)
			msg("[confirm] [GLOB.using_map.starsys_name] Flight Control, adjusting course.","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("Your compliance is appreciated, [combined_name]. [safetravels].")
		if("dockingrequestgeneric")
			var/appreciation = pick("Much appreciated","Many thanks","Understood","Cheers")
			var/dockingplan = pick("Starting final approach now.","Commencing docking procedures.","Autopilot engaged.","Approach vector locked in.","In the pipe, five by five.")
			msg("[callname], this is [combined_name], [pick("stopping by","passing through")] on our way to [destname], requesting permission to dock at [GLOB.using_map.dock_name].","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("[combined_name], this is [GLOB.using_map.starsys_name] Flight Control. Permission granted, proceed to landing pad [rand(1,42)]. Follow the green lights on your way in.")
			sleep(5 SECONDS)
			msg("[appreciation], [GLOB.using_map.starsys_name] Flight Control. [dockingplan]","[prefix] [shipname]")
		if("dockingrequestdenied")
			var/reason = pick("we don't have any free landing pads right now","we don't have any free landing pads large enough for your vessel","we don't have the necessary facilities for your vessel type or class","we can't verify your credentials","you're too far away, please close to ten thousand meters and resubmit your request")
			msg("[callname], this is [combined_name], [pick("stopping by","passing through")] on our way to [destname], requesting permission to dock at [GLOB.using_map.dock_name].","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("[combined_name], this is [GLOB.using_map.starsys_name] Flight Control. Request denied, [reason].")
			sleep(5 SECONDS)
			msg("Understood, [GLOB.using_map.starsys_name] Flight Control.","[prefix] [shipname]")
		if("dockingrequestsupply")
			var/intensifier = pick("very","pretty","critically","extremely","dangerously","desperately","kinda","a little","a bit","rather","terribly","dreadfully","getting","running")
			var/low_thing = pick("ammunition","oxygen","water","food","repair supplies","medical supplies","reaction mass","hydrogen fuel","phoron fuel","fuel",5;"tea",5;"coffee",5;"pizza",5;"beer",5;"snacks") //very low chance of a less serious shortage
			var/appreciation = pick("Much appreciated","Many thanks","Understood","You're a lifesaver","We owe you one","I owe you one","Perfect, thank you")
			var/dockingplan = pick("Starting final approach now.","Commencing docking procedures.","Autopilot engaged.","Approach vector locked in.","In the pipe, five by five.")
			msg("[callname], this is [combined_name]. We're [intensifier] low on [low_thing]. Requesting permission to dock at [GLOB.using_map.dock_name] for resupply.","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("[combined_name], this is [GLOB.using_map.starsys_name] Flight Control. Permission granted, proceed to landing pad [rand(1,42)]. Follow the green lights on your way in.")
			sleep(5 SECONDS)
			msg("[appreciation], [GLOB.using_map.starsys_name] Flight Control. [dockingplan]","[prefix] [shipname]")
		if("dockingrequestrepair")
			var/damagestate = pick("We're showing some hull damage","We're suffering minor system malfunctions","We're having some technical issues","We're overdue maintenance","We have several minor space debris impacts","We've got some battle damage here","Our reactor output is fluctuating","We're hearing some weird noises from the engines","Our artificial gravity generator has failed","Our life support is failing","Our water recycling system has shorted out","Our systems are glitching out","We just got caught in a solar flare","We had a close call with an asteroid","We have a minor [pick("fuel","water","oxygen")] leak","We have depressurized compartments","We have a hull breach","Our shield generator is on the fritz","Our RCS is acting up","One of our [pick("hydraulic","pneumatic")] systems has depressurized","Our repair bots are malfunctioning")
			var/appreciation = pick("Much appreciated","Many thanks","Understood","You're a lifesaver","We owe you one","I owe you one","Perfect, thank you")
			var/dockingplan = pick("Starting final approach now.","Commencing docking procedures.","Autopilot engaged.","Approach vector locked in.","In the pipe, five by five.")
			msg("[callname], this is [combined_name]. [damagestate]. Requesting permission to dock at [GLOB.using_map.dock_name] for repairs.","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("[combined_name], this is [GLOB.using_map.starsys_name] Flight Control. Permission granted, proceed to landing pad [rand(1,42)]. Follow the green lights on your way in. Repair crews are standing by, contact them on channel [rand(700,999)].[rand(1,9)].")
			sleep(5 SECONDS)
			msg("[appreciation], [GLOB.using_map.starsys_name] Flight Control. [dockingplan]","[prefix] [shipname]")
		if("dockingrequestmedical")
			var/medicalstate = pick("multiple casualties","several cases of radiation sickness","an unknown virus","an unknown infection","a critically injured VIP","sick refugees","multiple cases of food poisoning","injured passengers","sick passengers","injured engineers","wounded marines","a delicate situation","a pregnant passenger","injured castaways","escape pods","")
			var/appreciation = pick("Much appreciated","Many thanks","Understood","You're a lifesaver","We owe you one","I owe you one","Perfect, thank you")
			var/dockingplan = pick("Starting final approach now.","Commencing docking procedures.","Autopilot engaged.","Approach vector locked in.","In the pipe, five by five.")
			msg("[callname], this is [combined_name]. We have [medicalstate] on board. Requesting permission to dock at [GLOB.using_map.dock_name] for medical assistance.","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("[combined_name], this is [GLOB.using_map.starsys_name] Flight Control. Permission granted, proceed to landing pad [rand(1,42)]. Follow the green lights on your way in. Medtechs are standing by, contact them on channel [rand(700,999)].[rand(1,9)].")
			sleep(5 SECONDS)
			msg("[appreciation], [GLOB.using_map.starsys_name] Flight Control. [dockingplan]","[prefix] [shipname]")
		if("dockingrequestsecurity")
			var/species = pick("human","unathi","lizard","tajaran","skrell","akula","promethean","sergal","synthetic","teshari","vulpkanin","vox","zorren","hybrid","mixed-species")
			var/securitystate = pick("several [species] convicts","a captured pirate","a wanted criminal","[species] stowaways","incompetent [species] shipjackers","a delicate situation","a disorderly passenger","disorderly [species] passengers","ex-mutineers","a captured vox marauder","stolen goods","a container full of confiscated contraband","containers full of confiscated contraband",5;"a raging case of spiders") //gotta have a little something to lighten the mood now and then
			var/appreciation = pick("Much appreciated","Many thanks","Understood","You're a lifesaver","Perfect, thank you")
			var/dockingplan = pick("Starting final approach now.","Commencing docking procedures.","Autopilot engaged.","Approach vector locked in.","In the pipe, five by five.")
			msg("[callname], this is [combined_name]. We have [securitystate] on board and require security assistance. Requesting permission to dock at [GLOB.using_map.dock_name].","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("[combined_name], this is [GLOB.using_map.starsys_name] Flight Control. Permission granted, proceed to landing pad [rand(1,42)]. Follow the green lights on your way in. Security teams are standing by, contact them on channel [rand(700,999)].[rand(1,9)].")
			sleep(5 SECONDS)
			msg("[appreciation], [GLOB.using_map.starsys_name] Flight Control. [dockingplan]","[prefix] [shipname]")
		if("undockingrequest")
			var/safetravels = pick("Fly safe out there","Good luck","Safe travels","See you next week","Godspeed","Stars guide you")
			var/thanks = pick("Appreciated","Thanks","Don't worry about us","We'll be fine","You too","So long")
			msg("[callname], this is [combined_name] at [GLOB.using_map.dock_name], requesting permission to depart from pad [rand(1,42)].","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("[combined_name], this is [GLOB.using_map.starsys_name] Flight Control. Permission granted. Docking clamps released. [safetravels].")
			sleep(5 SECONDS)
			msg("[thanks], [GLOB.using_map.starsys_name] Flight Control. This is [combined_name] setting course for [destname], over and out.","[prefix] [shipname]")
		if("sdfbeginpatrol")
			var/safetravels = pick("Fly safe out there","Good luck","Good hunting","Safe travels","Godspeed","Stars guide you")
			var/thanks = pick("Appreciated","Thanks","Don't worry about us","We'll be fine","You too")
			msg("[callname], this is [combined_name] at [GLOB.using_map.dock_name], requesting permission to depart from pad [rand(1,42)] to begin system patrol.","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("[combined_name], this is [GLOB.using_map.starsys_name] Flight Control. Permission granted. Docking clamps released. [safetravels].")
			sleep(5 SECONDS)
			msg("[thanks], [GLOB.using_map.starsys_name] Flight Control. This is [combined_name] beginning system patrol, over and out.","[prefix] [shipname]")
		if("undockingdenied")
			var/denialreason = pick("Security is requesting a full cargo inspection","Your ship has been impounded for multiple [pick("security","safety")] violations","Your ship is currently under quarantine lockdown","We have reason to believe there's an issue with your papers","Security personnel are currently searching for a fugitive and have ordered all outbound ships remain grounded until further notice")
			msg("[callname], this is [combined_name] at [GLOB.using_map.dock_name], requesting permission to depart from pad [rand(1,42)].","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("Negative [combined_name], request denied. [denialreason].")
		if("undockingdelayed")
			var/denialreason = pick("Docking clamp malfunction, please hold","Fuel lines have not been secured","Ground crew are still on the pad","Loose containers are on the pad","Exhaust deflectors are not yet in position, please hold","There's heavy traffic right now, it's not safe for your vessel to launch","Another vessel has aerospace priority at this moment","Port officials are still aboard")
			var/pad = rand(1,42)
			var/safetravels = pick("Fly safe out there","Good luck","Safe travels","See you next week","Godspeed","Stars guide you")
			var/thanks = pick("Appreciated","Thanks","Don't worry about us","We'll be fine","You too","So long")
			msg("[callname], this is [combined_name] at [GLOB.using_map.dock_name], requesting permission to depart from pad [pad].","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("Negative [combined_name], request denied. [denialreason]. Try again in three minutes.")
			sleep(180 SECONDS) //yes, three minutes
			msg("[callname], this is [combined_name] at [GLOB.using_map.dock_name], requesting permission to depart from pad [pad].","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("[combined_name], this is [GLOB.using_map.starsys_name] Flight Control. Everything appears to be in order now, permission granted. Docking clamps released. [safetravels].")
			sleep(5 SECONDS)
			msg("[thanks], [GLOB.using_map.starsys_name] Flight Control. This is [combined_name] setting course for [destname], over and out.","[prefix] [shipname]")
		else //time for generic message
			msg("[callname], this is [combined_name] on [mission] [pick(mission_noun)] to [destname], requesting [request].","[prefix] [shipname]")
			sleep(5 SECONDS)
			msg("[combined_name], this is [GLOB.using_map.starsys_name] Flight Control, [response].")
			sleep(5 SECONDS)
			msg("[GLOB.using_map.starsys_name] Flight Control, [yes ? "thank you" : "understood"], good day.","[prefix] [shipname]")
	return //oops, forgot to restore this

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