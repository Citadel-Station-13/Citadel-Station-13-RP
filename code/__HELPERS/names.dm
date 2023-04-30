var/church_name = null
/proc/church_name()
	if (church_name)
		return church_name

	var/name = ""

	name += pick("Holy", "United", "First", "Second", "Last")

	if (prob(20))
		name += " Space"

	name += " " + pick("Church", "Cathedral", "Body", "Worshippers", "Movement", "Witnesses")
	name += " of [religion_name()]"

	return name

/proc/command_name()
	if(istype(GLOB.using_map))
		return GLOB.using_map.boss_name

/proc/change_command_name(var/name)

	GLOB.using_map.boss_name = name

	return name

var/religion_name = null
/proc/religion_name()
	if (religion_name)
		return religion_name

	var/name = ""

	name += pick("bee", "science", "edu", "captain", "assistant", "monkey", "alien", "space", "unit", "sprocket", "gadget", "bomb", "revolution", "beyond", "station", "goon", "robot", "ivor", "hobnob")
	name += pick("ism", "ia", "ology", "istism", "ites", "ick", "ian", "ity")

	return capitalize(name)

/proc/system_name()
	return GLOB.using_map.starsys_name

/proc/station_name()
	if (GLOB.using_map.station_name)
		return GLOB.using_map.station_name

	var/random = rand(1,5)
	var/name = ""
	var/new_station_name = null

	//Rare: Pre-Prefix
	if (prob(10))
		name = pick("Imperium", "Heretical", "Cuban", "Psychic", "Elegant", "Common", "Uncommon", "Rare", "Unique", "Houseruled", "Religious", "Atheist", "Traditional", "Houseruled", "Mad", "Super", "Ultra", "Secret", "Top Secret", "Deep", "Death", "Zybourne", "Central", "Main", "Government", "Uoi", "Fat", "Automated", "Experimental", "Augmented")
		new_station_name = name + " "

	// Prefix
	switch(Holiday)
		//get normal name
		if(null,"",0)
			name = pick("", "Stanford", "Dorf", "Alium", "Prefix", "Clowning", "Aegis", "Ishimura", "Scaredy", "Death-World", "Mime", "Honk", "Rogue", "MacRagge", "Ultrameens", "Safety", "Paranoia", "Explosive", "Neckbear", "Donk", "Muppet", "North", "West", "East", "South", "Slant-ways", "Widdershins", "Rimward", "Expensive", "Procreatory", "Imperial", "Unidentified", "Immoral", "Carp", "Ork", "Pete", "Control", "Nettle", "Aspie", "Class", "Crab", "Fist","Corrogated","Skeleton","Race", "Fatguy", "Gentleman", "Capitalist", "Communist", "Bear", "Beard", "Derp", "Space", "Spess", "Star", "Moon", "System", "Mining", "Neckbeard", "Research", "Supply", "Military", "Orbital", "Battle", "Science", "Asteroid", "Home", "Production", "Transport", "Delivery", "Extraplanetary", "Orbital", "Correctional", "Robot", "Hats", "Pizza")
			if(name)
				new_station_name += name + " "

		//For special days like christmas, easter, new-years etc ~Carn
		if("Friday the 13th")
			name = pick("Mike","Friday","Evil","Myers","Murder","Deathly","Stabby")
			new_station_name += name + " "
			random = 13
		else
			//get the first word of the Holiday and use that
			var/i = findtext(Holiday," ",1,0)
			name = copytext(Holiday,1,i)
			new_station_name += name + " "

	// Suffix
	name = pick("Station", "Fortress", "Frontier", "Suffix", "Death-trap", "Space-hulk", "Lab", "Hazard","Spess Junk", "Fishery", "No-Moon", "Tomb", "Crypt", "Hut", "Monkey", "Bomb", "Trade Post", "Fortress", "Village", "Town", "City", "Edition", "Hive", "Complex", "Base", "Facility", "Depot", "Outpost", "Installation", "Drydock", "Observatory", "Array", "Relay", "Monitor", "Platform", "Construct", "Hangar", "Prison", "Center", "Port", "Waystation", "Factory", "Waypoint", "Stopover", "Hub", "HQ", "Office", "Object", "Fortification", "Colony", "Planet-Cracker", "Roost", "Fat Camp")
	new_station_name += name + " "

	// ID Number
	switch(random)
		if(1)
			new_station_name += "[rand(1, 99)]"
		if(2)
			new_station_name += pick("Alpha", "Beta", "Gamma", "Delta", "Epsilon", "Zeta", "Eta", "Theta", "Iota", "Kappa", "Lambda", "Mu", "Nu", "Xi", "Omicron", "Pi", "Rho", "Sigma", "Tau", "Upsilon", "Phi", "Chi", "Psi", "Omega")
		if(3)
			new_station_name += pick("II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X", "XI", "XII", "XIII", "XIV", "XV", "XVI", "XVII", "XVIII", "XIX", "XX")
		if(4)
			new_station_name += pick("Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "Golf", "Hotel", "India", "Juliet", "Kilo", "Lima", "Mike", "November", "Oscar", "Papa", "Quebec", "Romeo", "Sierra", "Tango", "Uniform", "Victor", "Whiskey", "X-ray", "Yankee", "Zulu")
		if(5)
			new_station_name += pick("One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen")
		if(13)
			new_station_name += pick("13","XIII","Thirteen")


	if(config_legacy?.server_name)
		world.name = "[config_legacy.server_name]: [name]"
	else
		world.name = new_station_name

	return new_station_name

// Is this even used?
/proc/world_name(var/name)

	GLOB.using_map.station_name = name

	if(config_legacy?.server_name)
		world.name = "[config_legacy.server_name]: [name]"
	else
		world.name = name

	return name

var/syndicate_name = null
/proc/syndicate_name()
	if (syndicate_name)
		return syndicate_name

	var/name = ""

	// Prefix
	name += pick("Clandestine", "Prima", "Blue", "Zero-G", "Max", "Blasto", "Waffle", "North", "Omni", "Newton", "Cyber", "Bonk", "Gene", "Gib")

	// Suffix
	if (prob(80))
		name += " "

		// Full
		if (prob(60))
			name += pick("Syndicate", "Consortium", "Collective", "Corporation", "Group", "Holdings", "Biotech", "Industries", "Systems", "Products", "Chemicals", "Enterprises", "Family", "Creations", "International", "Intergalactic", "Interplanetary", "Foundation", "Positronics", "Hive")
		// Broken
		else
			name += pick("Syndi", "Corp", "Bio", "System", "Prod", "Chem", "Inter", "Hive")
			name += pick("", "-")
			name += pick("Tech", "Sun", "Co", "Tek", "X", "Inc", "Code")
	// Small
	else
		name += pick("-", "*", "")
		name += pick("Tech", "Sun", "Co", "Tek", "X", "Inc", "Gen", "Star", "Dyne", "Code", "Hive")

	syndicate_name = name
	return name


//Traitors and traitor silicons will get these. Revs will not.
var/syndicate_code_phrase//Code phrase for traitors.
var/syndicate_code_response//Code response for traitors.

	/*
	Should be expanded.
	How this works:
	Instead of "I'm looking for James Smith," the traitor would say "James Smith" as part of a conversation.
	Another traitor may then respond with: "They enjoy running through the void-filled vacuum of the derelict."
	The phrase should then have the words: James Smith.
	The response should then have the words: run, void, and derelict.
	This way assures that the code is suited to the conversation and is unpredicatable.
	Obviously, some people will be better at this than others but in theory, everyone should be able to do it and it only enhances roleplay.
	Can probably be done through "{ }" but I don't really see the practical benefit.
	One example of an earlier system is commented below.
	-N
	*/

/proc/generate_code_phrase()//Proc is used for phrase and response in master_controller.dm

	var/code_phrase = ""//What is returned when the proc finishes.
	var/words = pick(//How many words there will be. Minimum of two. 2, 4 and 5 have a lesser chance of being selected. 3 is the most likely.
		50; 2,
		200; 3,
		50; 4,
		25; 5
	)

	var/safety[] = list(1,2,3)//Tells the proc which options to remove later on.
	var/nouns[] = list("love","hate","anger","peace","pride","sympathy","bravery","loyalty","honesty","integrity","compassion","charity","success","courage","deceit","skill","beauty","brilliance","pain","misery","beliefs","dreams","justice","truth","faith","liberty","knowledge","thought","information","culture","trust","dedication","progress","education","hospitality","leisure","trouble","friendships", "relaxation")
	var/drinks[] = list("vodka and tonic","gin fizz","bahama mama","manhattan","black Russian","whiskey soda","long island tea","margarita","Irish coffee"," manly dwarf","Irish cream","doctor's delight","Beepksy Smash","tequila sunrise","brave bull","gargle blaster","bloody mary","whiskey cola","white Russian","vodka martini","martini","Cuba libre","kahlua","vodka","wine","moonshine")
	var/locations[] = teleportlocs.len ? teleportlocs : drinks//if null, defaults to drinks instead.

	var/names[] = list()
	for(var/datum/data/record/t in data_core.general)//Picks from crew manifest.
		names += t.fields["name"]

	var/maxwords = words//Extra var to check for duplicates.

	for(words,words>0,words--)//Randomly picks from one of the choices below.

		if(words==1&&(1 in safety)&&(2 in safety))//If there is only one word remaining and choice 1 or 2 have not been selected.
			safety = list(pick(1,2))//Select choice 1 or 2.
		else if(words==1&&maxwords==2)//Else if there is only one word remaining (and there were two originally), and 1 or 2 were chosen,
			safety = list(3)//Default to list 3

		switch(pick(safety))//Chance based on the safety list.
			if(1)//1 and 2 can only be selected once each to prevent more than two specific names/places/etc.
				switch(rand(1,2))//Mainly to add more options later.
					if(1)
						if(names.len&&prob(70))
							code_phrase += pick(names)
						else
							code_phrase += pick(pick(GLOB.first_names_male, GLOB.first_names_female))
							code_phrase += " "
							code_phrase += pick(GLOB.last_names)
					if(2)
						code_phrase += pick(SSjob.all_job_titles())//Returns a job.
				safety -= 1
			if(2)
				switch(rand(1,2))//Places or things.
					if(1)
						code_phrase += pick(drinks)
					if(2)
						code_phrase += pick(locations)
				safety -= 2
			if(3)
				switch(rand(1,3))//Nouns, adjectives, verbs. Can be selected more than once.
					if(1)
						code_phrase += pick(nouns)
					if(2)
						code_phrase += pick(GLOB.adjectives)
					if(3)
						code_phrase += pick(GLOB.verbs)
		if(words==1)
			code_phrase += "."
		else
			code_phrase += ", "

	return code_phrase

/**
 * This will update a mob's name, real_name, mind.name, data_core records, pda and id.
 * Calling this proc without an oldname will only update the mob and skip updating the pda, id and records. ~Carn
 */
/mob/proc/fully_replace_character_name(oldname, newname)
	if(!newname)
		return FALSE
	real_name = newname
	name = newname
	if (mind)
		mind.name = newname
	if (dna)
		dna.real_name = real_name

	if(oldname)
		// Update the datacore records! This is goig to be a bit costly.
		for(var/list/L in list(data_core.general, data_core.medical, data_core.security, data_core.locked))
			for(var/datum/data/record/R in L)
				if (R.fields["name"] == oldname)
					R.fields["name"] = newname
					break

		// Update our pda and id if we have them on our person.
		var/list/searching = get_all_contents()
		var/search_id = 1
		var/search_pda = 1

		for(var/A in searching)
			if(search_id && istype(A,/obj/item/card/id))
				var/obj/item/card/id/ID = A
				if (ID.registered_name == oldname)
					ID.registered_name = newname
					ID.name = "[newname]'s ID Card ([ID.assignment])"
					if(!search_pda)
						break
					search_id = 0

			else if(search_pda && istype(A,/obj/item/pda))
				var/obj/item/pda/PDA = A
				if (PDA.owner == oldname)
					PDA.owner = newname
					PDA.name = "PDA-[newname] ([PDA.ownjob])"
					if(!search_id)
						break
					search_pda = 0
	return TRUE

/**
 * Generalised helper proc for letting mobs rename themselves.
 * Used for the AI name prompt and apparently /used/ to be use for Clowns too.
 * TODO: Change this to use the new role ID system when it's ready.
 */
/mob/proc/rename_self(role)
	spawn(0)
		var/oldname = real_name
		// var/time_passed = world.time
		var/newname

		// We get 3 attempts to pick a suitable name.
		for(var/i=1,i<=3,i++)
			// newname = input(src,"You are \a [role]. Would you like to change your name to something else?", "Name change",oldname) as text
			newname = tgui_input_text(src, "You are \a [role].  Would you like to change your name to something else?", "Name change", oldname, MAX_NAME_LEN, timeout = 3000)

			// Returns null if the name doesn't meet some basic requirements. Tidies up a few other things like bad-characters.
			newname = sanitizeName(newname)

			for(var/mob/living/M in GLOB.player_list)
				if(M == src)
					continue
				if(!newname || M.real_name == newname)
					newname = null
					break

			// That's a suitable name!
			if(newname)
				break
			to_chat(src, "Sorry, that [role]-name wasn't appropriate, please try another. It's possibly too long/short, has bad characters or is already taken.")

		// We'll stick with the oldname then.
		if(!newname)
			return

		if(cmptext("ai",role))
			if(isAI(src))
				var/mob/living/silicon/ai/A = src
				// Don't bother with the records update crap.
				oldname = null
				// to_chat(world, "<b>[newname] is the AI!</b>")
				// world << sound('sound/AI/newAI.ogg')
				// Set eyeobj name.
				A.SetName(newname)

		fully_replace_character_name(oldname, newname)
