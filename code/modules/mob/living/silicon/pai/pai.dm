/datum/category_item/catalogue/fauna/silicon/pai
	name = "Silicons - pAI"
	desc = "There remains some dispute over whether the 'p' stands \
	for 'pocket', 'personal', or 'portable'. Regardless, the pAI is a \
	modern marvel. Consumer grade Artificial Intelligence, many pAI are \
	underclocked or sharded versions of larger Intelligence matrices. \
	Some, in fact, are splintered and limited copies of organic brain states."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/silicon/pai
	name = "pAI"
	icon = 'icons/mob/pai_vr.dmi'
	icon_state = "pai-repairbot"

	emote_type = 2		// pAIs emotes are heard, not seen, so they can be seen through a container (eg. person)
	pass_flags = 1
	mob_size = MOB_SMALL

	catalogue_data = list(/datum/category_item/catalogue/fauna/silicon/pai)

	holder_type = /obj/item/holder/pai

	can_pull_size = ITEMSIZE_SMALL
	can_pull_mobs = MOB_PULL_SMALLER

	idcard_type = /obj/item/card/id
	silicon_privileges = PRIVILEGES_PAI
	var/idaccessible = 0

	var/network = "SS13"
	var/obj/machinery/camera/current = null

	var/ram = 100	// Used as currency to purchase different abilities
	var/list/software = list()
	var/userDNA		// The DNA string of our assigned user
	var/obj/item/paicard/card	// The card we inhabit
	var/obj/item/radio/radio		// Our primary radio
	var/obj/item/communicator/integrated/communicator	// Our integrated communicator.

	var/chassis = "pai-repairbot"   // A record of your chosen chassis.
	var/global/list/possible_chassis = list(
		"Drone" = "pai-repairbot",
		"Cat" = "pai-cat",
		"Mouse" = "pai-mouse",
		"Monkey" = "pai-monkey",
		"Corgi" = "pai-borgi",
		"Fox" = "pai-fox",
		"Parrot" = "pai-parrot",
		"Rabbit" = "pai-rabbit",
		"Bear" = "pai-bear",
		"Fennec" = "pai-fen",
		"Fennec" = "pai-typezero",
		)

	var/global/list/possible_say_verbs = list(
		"Robotic" = list("states","declares","queries"),
		"Natural" = list("says","yells","asks"),
		"Beep" = list("beeps","beeps loudly","boops"),
		"Chirp" = list("chirps","chirrups","cheeps"),
		"Feline" = list("purrs","yowls","meows"),
		"Canine" = list("yaps","barks","woofs"),
		)

	/// The cable we produce and use when door or camera jacking.
	var/obj/item/pai_cable/cable

	var/master				// Name of the one who commands us
	var/master_dna			// DNA string for owner verification
							// Keeping this separate from the laws var, it should be much more difficult to modify
	var/pai_law0 = "Serve your master."
	var/pai_laws				// String for additional operating instructions our master might give us

	var/silence_time			// Timestamp when we were silenced (normally via EMP burst), set to null after silence has faded

// Various software-specific vars

	var/temp				// General error reporting text contained here will typically be shown once and cleared
	var/screen				// Which screen our main window displays
	var/subscreen			// Which specific function of the main screen is being displayed

	var/obj/item/pda/ai/pai/pda = null

	var/secHUD = 0			// Toggles whether the Security HUD is active or not
	var/medHUD = 0			// Toggles whether the Medical  HUD is active or not

	var/medical_cannotfind = 0
	var/datum/data/record/medicalActive1		// Datacore record declarations for record software
	var/datum/data/record/medicalActive2

	var/security_cannotfind = 0
	var/datum/data/record/securityActive1		// Could probably just combine all these into one
	var/datum/data/record/securityActive2

	var/obj/machinery/door/hackdoor		// The airlock being hacked
	var/hackprogress = 0				// Possible values: 0 - 1000, >= 1000 means the hack is complete and will be reset upon next check
	var/hack_aborted = 0

	var/obj/item/integated_radio/signal/sradio // AI's signaller

	var/translator_on = 0 // keeps track of the translator module

	var/current_pda_messaging = null

	var/people_eaten = 0

/mob/living/silicon/pai/Initialize(mapload)
	. = ..()
	card = loc
	sradio = new(src)
	communicator = new(src)
	if(card)
		if(!card.radio)
			card.radio = new /obj/item/radio(src.card)
		radio = card.radio

	add_verb(src, /mob/living/silicon/pai/proc/choose_chassis)
	add_verb(src, /mob/living/silicon/pai/proc/choose_verbs)

	//PDA
	pda = new(src)
	spawn(5)
		pda.ownjob = "Personal Assistant"
		pda.owner = "[src]"
		pda.name = pda.owner + " (" + pda.ownjob + ")"
		pda.toff = 1

/mob/living/silicon/pai/Login()
	..()
	// Meta Info for pAI
	if(client.prefs)
		ooc_notes = client.prefs.metadata

// this function shows the information about being silenced as a pAI in the Status panel
/mob/living/silicon/pai/proc/show_silenced()
	. = list()
	if(src.silence_time)
		var/timeleft = round((silence_time - world.timeofday)/10 ,1)
		STATPANEL_DATA_LINE("Communications system reboot in -[(timeleft / 60) % 60]:[add_zero(num2text(timeleft % 60), 2)]")

/mob/living/silicon/pai/statpanel_data(client/C)
	. = ..()
	if(C.statpanel_tab("Status"))
		. += show_silenced()

// No binary for pAIs.
/mob/living/silicon/pai/binarycheck()
	return 0

// See software.dm for Topic()
/mob/living/silicon/pai/canUseTopic(atom/movable/movable, be_close = FALSE, no_dexterity = FALSE, no_tk = FALSE)
	// Resting is just an aesthetic feature for them.
	return ..(movable, be_close, no_dexterity, no_tk)

/mob/living/silicon/pai/update_icon()
	..()
	update_fullness_pai()
	if(!people_eaten && !resting)
		icon_state = "[chassis]"
	else if(!people_eaten && resting)
		icon_state = "[chassis]_rest"
	else if(people_eaten && !resting)
		icon_state = "[chassis]_full"
	else if(people_eaten && resting)
		icon_state = "[chassis]_rest_full"

/// camera handling
/mob/living/silicon/pai/check_eye(var/mob/user as mob)
	if (!src.current)
		return -1
	return 0

/mob/living/silicon/pai/proc/switchCamera(var/obj/machinery/camera/C)
	if (!C)
		unset_machine()
		reset_perspective()
		return 0
	if (stat == 2 || !C.status || !(src.network in C.network))
		return 0

	// ok, we're alive, camera is good and in our network...

	set_machine(src)
	current = C
	reset_perspective(C)
	return 1

/mob/living/silicon/pai/reset_perspective(datum/perspective/P, apply = TRUE, forceful = TRUE, no_optimizations)
	. = ..()
	cameraFollow = null

// vore-related stuff
/mob/living/silicon/pai/proc/update_fullness_pai() //Determines if they have something in their stomach. Copied and slightly modified.
	var/new_people_eaten = 0
	for(var/belly in vore_organs)
		var/obj/belly/B = belly
		for(var/mob/living/M in B)
			new_people_eaten += M.size_multiplier
	people_eaten = min(1, new_people_eaten)

