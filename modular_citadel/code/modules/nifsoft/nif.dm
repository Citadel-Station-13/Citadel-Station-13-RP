/* //////////////////////////////
The NIF has a proc API shared with NIFSofts, and you should not really ever
directly interact with this API. Procs like install(), uninstall(), etc should
not be directly called. If you want to install a new NIFSoft, pass the NIF in
the constructor for a new instance of the NIFSoft. If you want to force a NIFSoft
to be uninstalled, use imp_check to get a reference to it, and call
uninstall() only on the return value of that.

You can also set the stat of a NIF to NIF_TEMPFAIL without any issues to disable it.
*/ //////////////////////////////

//Holder on humans to prevent having to 'find' it every time
/mob/living/carbon/human/var/obj/item/device/nif/nif

//Nanotech Implant Foundation
/obj/item/device/nif
	name = "nanite implant framework"
	desc = "A general purpose nanoworking surface, in a box. Can print new \
	implants inside living hosts on the fly based on software uploads. Must be surgically \
	implanted in the head to work. May eventually wear out and break."

	var/stealth_name = null //If stealth_name is set the NIF will rename itself to it when installed, and unname itself to it when removed.
	var/typeletter = null //The typeletter will override the quality detail. Generally usable when using q-1 NIFs.

	icon = 'icons/obj/device_alt.dmi'
	icon_state = "nif_0"

	w_class = ITEMSIZE_TINY

	var/durability = 100					// Durability remaining
	var/bioadap = FALSE						// If ignores the Bioadaptive Multiplier in fancy new species
	var/quality = 2 						// How good an NIF it can support.
	var/nif_flags = 0						// Special Flags
	var/charge_use_multiplier 				// Some NIFs don't make you hungry.
	var/repair_multiplier = 1				// Some NIFs have varying benefits from "programmed nanomachines"

	var/install_blind = 3 MINUTES
	var/install_synchronize = 30 MINUTES
	var/install_quick = 1 MINUTES
	var/install_side_effect_chance = 98		//98% chance to not have side effects per tick.

	var/tmp/power_usage = 0						// Nifsoft adds to this
	var/tmp/mob/living/carbon/human/human		// Our owner!
	var/tmp/list/nifsofts[TOTAL_NIF_SOFTWARE]	// All our nifsofts
	var/tmp/list/nifsofts_life = list()			// Ones that want to be talked to on life()
	var/owner									// Owner character name
	var/examine_msg								//Message shown on examine.

	var/tmp/vision_flags = 0		// Flags implants set for faster lookups
	var/tmp/health_flags = 0
	var/tmp/combat_flags = 0
	var/tmp/other_flags = 0

	var/tmp/stat = NIF_PREINSTALL		// Status of the NIF
	var/tmp/install_done				// Time when install will finish
	var/tmp/open = FALSE				// If it's open for maintenance (1-3)
	var/tmp/should_be_in = BP_HEAD		// Organ we're supposed to be held in

	var/obj/item/device/communicator/commlink/comm		// The commlink requires this

	var/global/icon/big_icon
	var/global/click_sound = 'sound/items/nif_click.ogg'
	var/global/bad_sound = 'sound/items/nif_tone_bad.ogg'
	var/global/good_sound = 'sound/items/nif_tone_good.ogg'
	var/global/list/look_messages = list(
			"flicks their eyes around",
			"looks at something unseen",
			"reads some invisible text",
			"seems to be daydreaming",
			"focuses elsewhere for a moment")

	var/list/save_data

	var/list/planes_visible = list()

//Constructor comes with a free AR HUD
/obj/item/device/nif/New(var/newloc,var/wear,var/list/load_data)
	..(newloc)

	//First one to spawn in the game, make a big icon
	if(!big_icon)
		big_icon = new(icon,icon_state = "nif_full")

	//Put loaded data here if we loaded any
	save_data = islist(load_data) ? load_data.Copy() : list()
	var/saved_examine_msg = save_data["examine_msg"]

	//If it's an empty string, they want it blank. If null, it's never been saved, give default.
	if(isnull(saved_examine_msg))
		saved_examine_msg = "There's a certain spark to their eyes."
	examine_msg = saved_examine_msg

	var/rcus = FALSE //Repeat customer flag
	//If given a human on spawn (probably from persistence)
	if(ishuman(newloc))
		var/mob/living/carbon/human/H = newloc
		if(!quick_implant(H))
			WARNING("NIF spawned in [H] failed to implant")
			spawn(0)
				qdel(src)
			return FALSE
		else
			rcus = TRUE

	//Free civilian AR included
	load_starting_software(rcus)

	//If given wear (like when spawned) then done
	if(wear)
		durability = wear
		wear(0) //Just make it update.

	//Draw me yo.
	update_icon()

/obj/item/device/nif/proc/load_starting_software(var/repeat_customer = FALSE)
	if(repeat_customer)
		//Free Commlink for Return Customers
		new /datum/nifsoft/commlink(src)
	new /datum/nifsoft/ar_civ(src)

//Destructor cleans up references
/obj/item/device/nif/Destroy()
	human = null
	QDEL_NULL_LIST(nifsofts)
	QDEL_NULL(comm)
	nifsofts_life.Cut()
	return ..()

//Being implanted in some mob
/obj/item/device/nif/proc/implant(var/mob/living/carbon/human/H)
	var/obj/item/organ/brain = H.internal_organs_by_name[O_BRAIN]
	if(istype(brain))
		should_be_in = brain.parent_organ

	if(istype(H) && !H.nif && H.species && (loc == H.get_organ(should_be_in)))
		//if(!bioadap && (H.species.flags & NO_SCAN)) //NO_SCAN is the default 'too complicated' flag
		//	return FALSE //Commented out because removing bioadaptive aspect of NIFs

		human = H
		human.nif = src
		stat = NIF_INSTALLING
		H.verbs |= /mob/living/carbon/human/proc/set_nif_examine
		name = (stealth_name ? stealth_name : initial(name)) + (owner ? " ([owner])" : "")
		return TRUE

	return FALSE

//For debug or antag purposes
/obj/item/device/nif/proc/quick_implant(var/mob/living/carbon/human/H)
	if(istype(H))
		var/obj/item/organ/external/parent
		//Try to find their brain and put it near that
		var/obj/item/organ/brain = H.internal_organs_by_name[O_BRAIN]
		if(istype(brain))
			should_be_in = brain.parent_organ

		parent = H.get_organ(should_be_in)
		//Ok, nevermind then!
		if(!istype(parent))
			return FALSE
		forceMove(parent)
		parent.implants += src
		spawn(0) //Let the character finish spawning yo.
			if(H.mind)
				owner = H.mind.name
			implant(H)
		return TRUE

	return FALSE

//Being removed from some mob
/obj/item/device/nif/proc/unimplant(var/mob/living/carbon/human/H)
	var/datum/nifsoft/soulcatcher/SC = imp_check(NIF_SOULCATCHER)
	if(SC) //Clean up stored people, this is dirty but the easiest way.
		QDEL_NULL_LIST(SC.brainmobs)
		SC.brainmobs = list()
	stat = NIF_PREINSTALL
	vis_update()
	H.verbs |= /mob/living/carbon/human/proc/set_nif_examine
	H.nif = null
	human = null
	install_done = null
	update_icon()
	name = initial(name) + (owner ? " [owner]" : "")

//EMP adds wear and disables all nifsoft
/obj/item/device/nif/emp_act(var/severity)
	notify("Danger! Significant electromagnetic interference!",TRUE)
	for(var/nifsoft in nifsofts)
		if(nifsoft)
			var/datum/nifsoft/NS = nifsoft
			NS.deactivate()

	switch (severity)
		if (1)
			wear(rand(30,40))
		if (2)
			wear(rand(15,25))
		if (3)
			wear(rand(8,15))
		if (4)
			wear(rand(1,8))

//Wear update/check proc
/obj/item/device/nif/proc/wear(var/wear = 0)
	wear *= (rand(85,115) / 100) //Apparently rand() only takes integers.
	durability -= wear

	if(durability <= 0)
		notify("Danger! General system insta#^!($",TRUE)
		to_chat(human,"<span class='danger'>Your NIF vision overlays disappear and your head suddenly seems very quiet...</span>")
		stat = NIF_TEMPFAIL
		update_icon()

//Attackby proc, for maintenance
/obj/item/device/nif/attackby(obj/item/weapon/W, mob/user as mob)
	if(open == 0 && W.is_screwdriver())
		if(do_after(user, 4 SECONDS, src) && open == 0)
			user.visible_message("[user] unscrews and pries open \the [src].","<span class='notice'>You unscrew and pry open \the [src].</span>")
			playsound(user, 'sound/items/Screwdriver.ogg', 50, 1)
			open = 1
			update_icon()
	else if(open == 1 && istype(W,/obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/C = W
		if(C.get_amount() < 3)
			to_chat(user,"<span class='warning'>You need at least three coils of wire to add them to \the [src].</span>")
			return
		if(do_after(user, 6 SECONDS, src) && open == 1 && C.use(3))
			user.visible_message("[user] replaces some wiring in \the [src].","<span class='notice'>You replace any burned out wiring in \the [src].</span>")
			playsound(user, 'sound/items/Deconstruct.ogg', 50, 1)
			open = 2
			update_icon()
	else if(open == 2 && istype(W,/obj/item/device/multitool))
		if(do_after(user, 8 SECONDS, src) && open == 2)
			user.visible_message("[user] resets several circuits in \the [src].","<span class='notice'>You find and repair any faulty circuits in \the [src].</span>")
			open = 3
			update_icon()
	else if(open == 3 && W.is_screwdriver())
		if(do_after(user, 3 SECONDS, src) && open == 3)
			user.visible_message("[user] closes up \the [src].","<span class='notice'>You re-seal \the [src] for use once more.</span>")
			playsound(user, 'sound/items/Screwdriver.ogg', 50, 1)
			open = FALSE
			durability = initial(durability)
			stat = NIF_PREINSTALL
			update_icon()

//Icon updating
/obj/item/device/nif/update_icon()
	if(open)
		icon_state = "nif_open[open]"
	else
		switch(stat)
			if(NIF_PREINSTALL)
				icon_state = "nif_1"
			if(NIF_INSTALLING)
				icon_state = "nif_0"
			if(NIF_WORKING)
				icon_state = "nif_0"
			if(NIF_TEMPFAIL)
				icon_state = "nif_2"
			else
				icon_state = "nif_2"

//The (dramatic) install process
/obj/item/device/nif/proc/handle_install()
	if(human.stat || !human.mind) //No stuff while KO or not sleeved
		return FALSE

	//Firsties
	if(!install_done)
		if(human.mind.name == owner)
			install_done = world.time + (install_quick)
			notify("Welcome back, [owner]! Performing quick-calibration...")
		else if(!owner)
			install_done = world.time + (install_synchronize)
			notify("Adapting to new user...")
			sleep(5 SECONDS)
			notify("Adjoining optic [human.isSynthetic() ? "interface" : "nerve"], please be patient.",TRUE)
		else
			notify("You are not an authorized user for this device. Please contact [owner].",TRUE)
			unimplant()
			stat = NIF_TEMPFAIL
			return FALSE

	var/percent_done = (world.time - (install_done - install_synchronize)) / install_synchronize
	var/percent_blind = install_blind/install_synchronize

	if(human.client)
		human.client.screen.Add(global_hud.whitense) //This is the camera static

	//switch(percent_done) //This is 0.0 to 1.0 kinda percent.
	//Connecting to optical nerves
	if(percent_done < percent_blind)
		human.eye_blind = 5

	//Mapping brain
	else if(percent_done >= percent_blind && percent_done < ((install_synchronize - install_quick) / install_synchronize))
		if(prob(install_side_effect_chance)) return TRUE
		var/incident = rand(1,3)
		switch(incident)
			if(1)
				var/message = pick(list(
							"Your head throbs around your new implant!",
							"The skin around your recent surgery itches!",
							"A wave of nausea overtakes you as the world seems to spin!",
							"The floor suddenly seems to come up at you!",
							"There's a throbbing lump of ice behind your eyes!",
							"A wave of pain shoots down your neck!"
							))
				human.adjustHalLoss(35)
				human.custom_pain(message,35)
			if(2)
				human.Weaken(5)
				to_chat(human,"<span class='danger'>A wave of weakness rolls over you.</span>")
			if(3)
				human.Sleeping(5)
				to_chat(human,"<span class='danger'>You suddenly black out!</span>")

	//Finishing up
	else if(percent_done >= 1.0)
		stat = NIF_WORKING
		owner = human.mind.name
		name = (stealth_name ? stealth_name : initial(name)) + " ([owner])"
		if(comm)
			var/saved_name = save_data["commlink_name"]
			if(saved_name)
				comm.register_device(saved_name)
			else if(human)
				comm.register_device(human.name)
		notify("Calibration complete! User data stored!")

//Called each life() tick on the mob
/obj/item/device/nif/proc/life()
	if(!human || loc != human.get_organ(should_be_in))
		unimplant(human)
		return FALSE

	switch(stat)
		if(NIF_WORKING)
			//Perform our passive drain
			if(!use_charge(power_usage))
				stat = NIF_POWFAIL
				vis_update()
				notify("Insufficient energy!",TRUE)
				return FALSE

			//HUD update!
			//nif_hud.process_hud(human,1) //TODO VIS

			//Process all the ones that want that
			for(var/S in nifsofts_life)
				var/datum/nifsoft/nifsoft = S
				nifsoft.life(human)

		if(NIF_POWFAIL)
			if(human && human.nutrition < 100)
				return FALSE
			else
				stat = NIF_WORKING
				vis_update()
				notify("System Reboot Complete.")

		if(NIF_TEMPFAIL)
			//Something else has to take us out of tempfail
			return FALSE

		if(NIF_INSTALLING)
			handle_install()
			return FALSE

//Prints 'AR' messages to the user
/obj/item/device/nif/proc/notify(var/message,var/alert = 0)
	if(!human || stat == NIF_TEMPFAIL) return

	to_chat(human,"<b>\[\icon[src.big_icon]NIF\]</b> displays, \"<span class='[alert ? "danger" : "notice"]'>[message]</span>\"")
	if(prob(1)) human.visible_message("<span class='notice'>\The [human] [pick(look_messages)].</span>")
	if(alert)
		human << bad_sound
	else
		human << good_sound

//Called to spend nutrition, returns 1 if it was able to
/obj/item/device/nif/proc/use_charge(var/use_charge)
	if(stat != NIF_WORKING) return FALSE

	//You don't want us to take any? Well okay.
	if(!use_charge)
		return TRUE

	//Not enough nutrition/charge left.
	if(!human || human.nutrition < use_charge * charge_use_multiplier)
		return FALSE

	//Was enough, reduce and return.
	human.nutrition -= use_charge * charge_use_multiplier
	return TRUE

//Install a piece of software
/obj/item/device/nif/proc/install(var/datum/nifsoft/new_soft)
	if(stat == NIF_TEMPFAIL) return FALSE

	if(new_soft.complexity > quality && quality >= 0 && new_soft.complexity >=0) //Check complexity and avoid override.
		notify("The software \"[new_soft]\" is too complex for your NIF unit.", TRUE)
		return FALSE

	if(nifsofts[new_soft.list_pos])
		return FALSE

	if(human && !(nif_flags & NIF_FORCE_INSTALL))
		var/applies_to = new_soft.applies_to
		var/synth = human.isSynthetic()
		if(synth && !(applies_to & NIF_SYNTHETIC))
			notify("The software \"[new_soft]\" is not supported on your chassis type.",TRUE)
			return FALSE
		else if(!synth && !(applies_to & NIF_ORGANIC))
			notify("The software \"[new_soft]\" is not supported in organic life.",TRUE)
			return FALSE

	if(human)
		if((human.species.flags & NO_SCAN) && !bioadap) //Bioadap has been repurposed to disable the multiplier in some NIFs.
			wear(new_soft.wear * NIF_BIOADAPTIVE_MULTIPLIER) //Handles durability wear when the species is "bioadaptive". Currently set to 1 for no change.
		else
			wear(new_soft.wear)

	nifsofts[new_soft.list_pos] = new_soft
	power_usage += new_soft.p_drain

	if(new_soft.tick_flags == NIF_ALWAYSTICK)
		nifsofts_life += new_soft

	return TRUE

//Uninstall a piece of software
/obj/item/device/nif/proc/uninstall(var/datum/nifsoft/old_soft)
	var/datum/nifsoft/NS = nifsofts[old_soft.list_pos]
	if(!NS || NS != old_soft)
		return FALSE //what??

	nifsofts[old_soft.list_pos] = null
	power_usage -= old_soft.p_drain

	if(old_soft.tick_flags == NIF_ALWAYSTICK)
		nifsofts_life -= old_soft

	if(old_soft.active)
		old_soft.deactivate(force = TRUE)

	return TRUE

//Activate a nifsoft
/obj/item/device/nif/proc/activate(var/datum/nifsoft/soft)
	if(stat != NIF_WORKING) return FALSE

	if(human && !(nif_flags & NIF_FORCE_INSTALL))
		if(prob(5)) human.visible_message("<span class='notice'>\The [human] [pick(look_messages)].</span>")
		var/applies_to = soft.applies_to
		var/synth = human.isSynthetic()
		if(synth && !(applies_to & NIF_SYNTHETIC))
			notify("The software \"[soft]\" is not supported on your chassis type and will be uninstalled.",TRUE)
			uninstall(soft)
			return FALSE
		if(!synth && !(applies_to & NIF_ORGANIC))
			notify("The software \"[soft]\" is not supported in organic life and will be uninstalled.",TRUE)
			uninstall(soft)
			return FALSE
		human << click_sound

	if(!use_charge(soft.a_drain))
		notify("Not enough power to activate \"[soft]\" NIFsoft!",TRUE)
		return FALSE

	if(soft.tick_flags == NIF_ACTIVETICK)
		nifsofts_life += soft

	power_usage += soft.a_drain

	return TRUE

//Deactivate a nifsoft
/obj/item/device/nif/proc/deactivate(var/datum/nifsoft/soft)
	if(human)
		if(prob(5)) human.visible_message("<span class='notice'>\The [human] [pick(look_messages)].</span>")
		human << click_sound

	if(soft.tick_flags == NIF_ACTIVETICK)
		nifsofts_life -= soft

	power_usage -= soft.a_drain

	return TRUE

//Deactivate several nifsofts
/obj/item/device/nif/proc/deactivate_these(var/list/turn_off)
	for(var/N in turn_off)
		var/datum/nifsoft/NS = nifsofts[N]
		if(NS)
			NS.deactivate()

//Add a flag to one of the holders
/obj/item/device/nif/proc/set_flag(var/flag,var/hint)
	ASSERT(flag != null && hint)

	switch(hint)
		if(NIF_FLAGS_VISION)
			vision_flags |= flag
		if(NIF_FLAGS_HEALTH)
			health_flags |= flag
		if(NIF_FLAGS_COMBAT)
			combat_flags |= flag
		if(NIF_FLAGS_OTHER)
			other_flags |= flag
		else
			CRASH("Not a valid NIF set_flag hint: [hint]")

//Clear a flag from one of the holders
/obj/item/device/nif/proc/clear_flag(var/flag,var/hint)
	ASSERT(flag != null && hint)

	switch(hint)
		if(NIF_FLAGS_VISION)
			vision_flags &= ~flag
		if(NIF_FLAGS_HEALTH)
			health_flags &= ~flag
		if(NIF_FLAGS_COMBAT)
			combat_flags &= ~flag
		if(NIF_FLAGS_OTHER)
			other_flags &= ~flag
		else
			CRASH("Not a valid NIF clear_flag hint: [hint]")

//Check for an installed implant
/obj/item/device/nif/proc/imp_check(var/soft)
	if(stat != NIF_WORKING) return FALSE
	ASSERT(soft)

	if(ispath(soft))
		var/datum/nifsoft/path = soft
		soft = initial(path.list_pos)
	var/entry = nifsofts[soft]
	if(entry)
		return entry

//Check for a set flag
/obj/item/device/nif/proc/flag_check(var/flag,var/hint)
	if(stat != NIF_WORKING) return FALSE

	ASSERT(flag && hint)

	var/result = FALSE
	switch(hint)
		if(NIF_FLAGS_VISION)
			if(flag & vision_flags) result = TRUE
		if(NIF_FLAGS_HEALTH)
			if(flag & health_flags) result = TRUE
		if(NIF_FLAGS_COMBAT)
			if(flag & combat_flags) result = TRUE
		if(NIF_FLAGS_OTHER)
			if(flag & other_flags) result = TRUE
		else
			CRASH("Not a valid NIF flag hint: [hint]")

	return result

/obj/item/device/nif/proc/planes_visible()
	if(stat != NIF_WORKING)
		return list() //None!

	return planes_visible

/obj/item/device/nif/proc/add_plane(var/planeid = null)
	if(!planeid)
		return
	planes_visible |= planeid

/obj/item/device/nif/proc/del_plane(var/planeid = null)
	if(!planeid)
		return
	planes_visible -= planeid

/obj/item/device/nif/proc/vis_update()
	if(human)
		human.recalculate_vis()

// Alternate NIFs
/obj/item/device/nif/bad
	name = "bootleg NIF"
	desc = "A copy of a ripoff of a copy of a clone of... this can't be any good, right?"
	typeletter = "B"
	quality = -1 //Ignores quality restrictions
	durability = 30
	bioadap = TRUE
	charge_use_multiplier = 0.1

	emag_act(mob/user)
		if(open)
			var/obj/item/device/nif/newnif = new /obj/item/device/nif/sketchy()
			newnif.owner = owner
			newnif.open = open
			newnif.update_icon()

			newnif.forceMove(get_turf(src))
			QDEL_NULL(src)
		. = ..()

/obj/item/device/nif/sketchy //Ignores NIFSoft Vendor Access Restrictions, handled in the vendor. Not a free emag.
	name = "sketchy NIF"
	stealth_name = "bootleg NIF"
	desc = "An illegally modified NIF which is definitely major contraband, and malpractice to install."
	typeletter = "S"
	quality = -1 //Ignores quality restrictions
	durability = 20
	nif_flags = NIF_IGNORE_RESTRICTIONS
	bioadap = TRUE
	charge_use_multiplier = 0.75
	repair_multiplier = 0.05 //Some people be desperate.

/obj/item/device/nif/authentic //KHI removed, still the "best" you can get, minus special features
	name = "\improper Vey-Med NIF"
	desc = "Vey-Med's entry into the NIF market. Usually reserved for only the rich."
	quality = 4
	durability = 1000
	repair_multiplier = 5

/obj/item/device/nif/specialty
	name = "\improper specialty NIF"
	desc = "A high-endurance NIF with better nanites and programming. Produced by specialty manufacturers."
	quality = 3
	durability = 500
	charge_use_multiplier = 1.25

/obj/item/device/nif/bioadap
	name = "adaptive NIF"
	desc = "An intelligent NIF that can adapt certain NIFSofts for use outside of their intended audience. It's not perfect in this regard, however."
	quality = 3
	durability = 25
	bioadap = TRUE
	nif_flags = NIF_FORCE_INSTALL
	charge_use_multiplier = 1.1
	repair_multiplier = 0.5

/obj/item/device/nif/quality
	name = "quality NIF"
	desc = "A well-programmed NIF that can support higher-quality software than usual."
	quality = 4
	durability = 100

/obj/item/device/nif/durable
	name = "durable NIF"
	desc = "A durably-built NIF."
	quality = 2
	durability = 1000

/obj/item/device/nif/sandbox
	name = "sandboxed NIF"
	desc = "This NIF sandboxes all NIFSoft operation, and temporarily disables them for an instant every few seconds. \
	Allows removing Compliance Disks."
	quality = 2 //Gives you compliance-level programs without the risks of compliance disks.
	durability = 50 //But is less durable because of it.
	nif_flags = NIF_FORCE_DELETE

/obj/item/device/nif/backup
	name = "survivalist NIF"
	desc = "This NIF is preloaded with robust mind backup and soulcatcher utilities, and runs on a minimum of power."
	quality = 2
	durability = 40 //Not durable, but it does its best to keep you alive.
	install_blind = 1 MINUTES //Really fast because this is for paranoid people.
	install_synchronize = 20 MINUTES //Not so fast but no side-effects.
	install_side_effect_chance = 100
	charge_use_multiplier = 0.5 //Hunger Begone
	repair_multiplier = 8 //Only costs 5 units of nif repair stuff to fully repair. Mainly for speed of repair.

	load_starting_software()
		new /datum/nifsoft/mindbackup(src)
		new /datum/nifsoft/soulcatcher(src)
		. = ..()

// Cheap NIFs
/obj/item/device/nif/consumer //Buildable in Autolathe
	name = "consumer NIF"
	desc = "A mass-production NIF that can only run simple programs. Lasts practically forever. Installs almost instantly."
	quality = 0
	durability = 500
	install_blind = 1 MINUTES
	install_synchronize = 3 MINUTES
	charge_use_multiplier = 0.1
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	repair_multiplier = 5

/obj/item/device/nif/cheap //Needs only metal and glass to be built once unlocked in Research
	name = "cheap NIF"
	desc = "A cheap but capable NIF. Can run vision augments as well as simple programs, but nothing intensive. Lasts for a long while. Installs just about instantly."
	quality = 1
	durability = 250
	install_blind = 3 MINUTES
	install_synchronize = 5 MINUTES
	charge_use_multiplier = 0.2
	repair_multiplier = 5

// Weird NIFs

/obj/item/device/nif/preprogrammed //These are NIFs that come with some built in software, but they don't indicate what software on scan.
	name = "preprogrammed NIF"
	desc = "An NIF that's had some software permanently written to it."
	durability = 70

/obj/item/device/nif/preprogrammed/sizechange
	load_starting_software()
		new /datum/nifsoft/sizechange(src)
		. = ..()

// Reward NIFs

/obj/item/device/nif/reward //Lowpower Vey-Med
	name = "\improper awarded NIF"
	desc = "A rare NIF model that is usually awarded alongside medals."
	quality = 4
	durability = 1000
	charge_use_multiplier = 0.75
	repair_multiplier = 5

/obj/item/device/nif/reward/champion //Builtin Healing
	name = "\improper champion's NIF"
	desc = "A rare NIF model that is usually given to the victor of a battle."
	quality = 3
	durability = 100
	nif_flags = NIF_FORCE_INSTALL
	repair_multiplier = 5

	load_starting_software()
		new /datum/nifsoft/mindbackup(src)
		new /datum/nifsoft/medichines_org(src)
		new /datum/nifsoft/medichines_syn(src)
		. = ..()

/obj/item/device/nif/reward/syndicate //Basically an upgraded sketchy.
	name = "\improper illegal NIF"
	stealth_name = "adaptive NIF"
	desc = "A rare NIF model that is by no means legal in NT space."
	typeletter = "I"
	quality = -1
	durability = 50
	bioadap = TRUE
	charge_use_multiplier = 0.5
	nif_flags = NIF_IGNORE_RESTRICTIONS
	repair_multiplier = -0.1 //Don't 'chuu dare feed me them nanites.

/obj/item/device/nif/reward/command
	name = "\improper decorated NIF"
	desc = "A rare NIF model augmented with NT command programming."
	quality = 4
	durability = 100
	nif_flags = NIF_FORCE_DELETE

	load_starting_software()
		new /datum/nifsoft/ar_omni(src)
		new /datum/nifsoft/commlink(src)
		new /datum/nifsoft/crewmonitor(src)
		. = ..()

// For event use only, do not give to players.
/obj/item/device/nif/ultra //For adminspawn only. Kinda broken but whatever.
	name = "ultra NIF"
	desc = "You can't have gotten your hands on this, but it is the very best. (Only for event characters)"
	typeletter = "U"
	quality = -1
	durability = 65535
	install_blind = 1
	install_synchronize = 1
	install_quick = 1
	install_side_effect_chance = 100
	charge_use_multiplier = 0
	repair_multiplier = 65535
	nif_flags = 65535 //Just maxing this shit out, don't mind me.

	New(var/newloc,var/wear,var/list/load_data)
		if(load_data)
			log_and_message_admins("[src] was spawned at [newloc] with saved NIF data. It's not meant for persistency. If it's a player, they've been offered a choice of any other NIF instead.")
			if(ishuman(newloc))
				var/mob/living/carbon/human/H = newloc
				var/niftype
				niftype = input(H, "Ultra NIFs are non-persistent, pick another.", "NIF Select", null) as null|anything in ((typesof(/obj/item/device/nif)) - /obj/item/device/nif/ultra - /obj/item/device/nif/protean)
				if(niftype)
					new niftype(H)
					log_and_message_admins("[H] selected a [niftype] to replace their [src].")
					return
				QDEL_NULL(src)
			else
				. = ..()
		. = ..()

// Special-Case NIFs
/obj/item/device/nif/protean //Sandboxed because it's not an actual NIF, it's just being emulated by the protean.
	name = "emulated NIF"
	desc = "A mass of nanites emulating a fully-functional NIF. (Contact a coder if you see this description)"
	typeletter = "P"
	quality = -1
	durability = 15
	bioadap = TRUE
	nif_flags = NIF_FORCE_DELETE
	charge_use_multiplier = 0
	repair_multiplier = 0 //Proteans get no benefit from foreign nanites here.

	load_starting_software()
		new /datum/nifsoft/apc_recharge(src) //Mainly because they "do the same thing" for regular rechargers, though it's hidden.
		. = ..()

////////////////////////////////
// Special Promethean """surgery"""
/obj/item/device/nif/attack(mob/living/M, mob/living/user, var/target_zone)
	if(!ishuman(M) || !ishuman(user) || (M == user))
		return ..()

	var/mob/living/carbon/human/U = user
	var/mob/living/carbon/human/T = M

	if(istype(T.species,/datum/species/shapeshifter/promethean) && target_zone == BP_TORSO)
		if(T.w_uniform || T.wear_suit)
			to_chat(user,"<span class='warning'>Remove any clothing they have on, as it might interfere!</span>")
			return
		var/obj/item/organ/external/eo = T.get_organ(BP_TORSO)
		if(!T)
			to_chat(user,"<span class='warning'>They should probably regrow their torso first.</span>")
			return
		U.visible_message("<span class='notice'>[U] begins installing [src] into [T]'s chest by just stuffing it in.</span>",
		"<span class='notice'>You begin installing [src] into [T]'s chest by just stuffing it in.</span>",
		"There's a wet SQUISH noise.")
		if(do_mob(user = user, target = T, time = 200, target_zone = BP_TORSO))
			user.unEquip(src)
			forceMove(eo)
			eo.implants |= src
			implant(T)
			playsound(T,'sound/effects/slime_squish.ogg',50,1)
	else
		return ..()

/mob/living/carbon/human/proc/set_nif_examine()
	set name = "NIF Appearance"
	set desc = "If your NIF alters your appearance in some way, describe it here."
	set category = "OOC"

	if(!nif)
		verbs -= /mob/living/carbon/human/proc/set_nif_examine
		to_chat(src,"<span class='warning'>You don't have a NIF, not sure why this was here.</span>")
		return

	var/new_flavor = sanitize(input(src,"Describe how your NIF alters your appearance, like glowy eyes or metal plate on your head, etc. Be sensible. Clear this for no examine text. 128ch max.","Describe NIF", nif.examine_msg) as null|text, max_length = 128)
	//They clicked cancel or meanwhile lost their NIF
	if(!nif || isnull(new_flavor))
		return //No changes
	//Sanitize or user cleaned it entirely
	if(!new_flavor)
		nif.examine_msg = ""
		nif.save_data["examine_msg"] = ""
	else
		nif.examine_msg = new_flavor
		nif.save_data["examine_msg"] = new_flavor
