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

	// our normal health
	health = 50
	maxHealth = 50

	// our emitter max health, health, regen, and when we last went to 0 emitter health (0 means we are alive currently)
	var/emitter_max_health = 50
	var/emitter_health = 50
	var/emitter_health_regen = 1
	var/last_emitter_death = 0

	emote_type = 2		// pAIs emotes are heard, not seen, so they can be seen through a container (eg. person)
	pass_flags = 1
	mob_size = MOB_SMALL

	var/speed = 1 // We move slightly slower than normal living things

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
	var/obj/item/shell	// The shell we inhabit
	var/obj/item/paicard/card // The card we belong to, it is not always our shell, but it is linked to us regardless
	var/obj/item/radio/radio		// Our primary radio
	var/obj/item/communicator/integrated/communicator	// Our integrated communicator.
	var/obj/item/pda/ai/pai/pda = null // Our integrated PDA

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
		"Fennec" = "pai-fen",
		"Bear" = "pai-bear"
		)

	var/global/list/possible_say_verbs = list(
		"Robotic" = list("states","declares","queries"),
		"Natural" = list("says","yells","asks"),
		"Beep" = list("beeps","beeps loudly","boops"),
		"Chirp" = list("chirps","chirrups","cheeps"),
		"Feline" = list("purrs","yowls","meows"),
		"Canine" = list("yaps","barks","woofs"),
		)

	// shell transformation
	var/obj/item/clothing/last_uploaded_path
	var/obj/item/clothing/base_uploaded_path
	var/uploaded_snowflake_worn_state
	var/uploaded_color

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

	var/obj/machinery/door/hackdoor		// The airlock being hacked
	var/hackprogress = 0				// Possible values: 0 - 1000, >= 1000 means the hack is complete and will be reset upon next check
	var/hack_aborted = 0

	var/obj/item/integated_radio/signal/sradio // AI's signaller

	var/current_pda_messaging = null

	var/people_eaten = 0

	// space movement related
	var/last_space_movement = 0

	// transformation component
	var/datum/component/object_transform/transform_component

	var/icon/last_rendered_hologram_icon

	var/list/scanned_objects = list()
	var/last_scanned_time = 0

/mob/living/silicon/pai/Initialize(mapload)
	. = ..()
	shell = loc
	if(istype(shell, /obj/item/paicard))
		card = loc
	sradio = new(src)
	communicator = new(src)
	if(shell)
		transform_component = AddComponent(/datum/component/object_transform, shell, "neatly folds inwards, compacting down to a rectangular card", "folds outwards, expanding into a mobile form.")
	if(card && !card.radio)
		card.radio = new /obj/item/radio(src.card)
		radio = card.radio

	add_verb(src, /mob/living/silicon/pai/proc/choose_chassis)
	add_verb(src, /mob/living/silicon/pai/proc/choose_verbs)
	add_verb(src, /mob/living/proc/set_size)

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

/mob/living/silicon/pai/update_icon(animate = TRUE)
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
	if(resting)
		update_transform(animate) // because when our chassis changes we dont want to stay rotated because only holograms rotate!!

	// if in hologram form, chassis is null, and we need to make sure we are offset correctly
	var/initial_base_pixel_x = initial(src.base_pixel_x)
	if(!chassis)
		var/icon_width = last_rendered_hologram_icon.Width()
		set_base_pixel_x(initial_base_pixel_x + ((32 - icon_width) / 2))
	else
		set_base_pixel_x(initial_base_pixel_x)


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

// changing the shell
/mob/living/silicon/pai/proc/switch_shell(obj/item/new_shell)
	// setup transform text
	if(istype(new_shell, /obj/item/paicard))
		transform_component.to_object_text = "neatly folds inwards, compacting down to a rectangular card"
	else
		transform_component.to_object_text = "neatly folds inwards, compacting down into their shell"

	// if our shell is clothing, drop any accessories first
	if(istype(shell, /obj/item/clothing))
		var/obj/item/clothing/C = shell
		for(var/obj/item/clothing/accessory/A in C.accessories)
			C.remove_accessory(null, A)

	// swap the shell, if the old shell is our card we keep it, otherwise we delete it because it's not important
	shell = new_shell
	var/obj/item/old_shell = transform_component.swap_object(new_shell)
	if(istype(old_shell, /obj/item/paicard))
		old_shell.forceMove(src)
	else
		QDEL_NULL(old_shell)

	// some sanity stuff because this is also putting us inside an object so we want to interrupt a couple of possible things such as pulling, resting, eating, viewing camera
	release_vore_contents()
	stop_pulling()
	update_perspective()
	set_resting(FALSE)
	update_mobility()
	remove_verb(src, /mob/living/silicon/pai/proc/pai_nom)

	// also we can interrupt our hologram display
	card.stop_displaying_hologram()

	// pass attack self on to the card regardless of our shell
	if(!istype(new_shell, /obj/item/paicard))
		RegisterSignal(shell, COMSIG_ITEM_ATTACK_SELF, PROC_REF(pass_attack_self_to_card))

// changing the shell into clothing
/mob/living/silicon/pai/proc/change_shell_by_path(obj/item/clothing/object_path)
	if(!can_change_shell())
		return FALSE

	last_special = world.time + 20

	var/obj/item/clothing/base_clothing_path = get_base_clothing_path(object_path)
	var/obj/item/clothing/new_object = new base_clothing_path
	new_object.name = "[src.name] (pAI)"
	new_object.desc = src.desc
	new_object.icon = initial(object_path.icon)
	new_object.icon_state = initial(object_path.icon_state)
	new_object.slot_flags = initial(object_path.slot_flags)
	new_object.icon_mob_y_align = initial(object_path.icon_mob_y_align)
	new_object.worn_render_flags = initial(object_path.worn_render_flags)
	new_object.accessory_render_legacy = initial(object_path.accessory_render_legacy)

	if(istype(new_object, /obj/item/clothing/under))
		var/obj/item/clothing/under/U = new_object
		var/obj/item/clothing/under/under_path = object_path
		U.snowflake_worn_state = initial(under_path.snowflake_worn_state)
		if(!length(U.snowflake_worn_state))
			U.snowflake_worn_state = U.icon_state
	new_object.forceMove(src.loc)
	switch_shell(new_object)
	return TRUE

/mob/living/silicon/pai/proc/pass_attack_self_to_card()
	if(istype(shell.loc, /mob/living/carbon))
		card.attack_self(shell.loc)

/mob/living/silicon/pai/proc/get_base_clothing_path(obj/item/clothing/path)
	if(ispath(path, /obj/item/clothing/accessory))
		return /obj/item/clothing/accessory
	if(initial(path.slot_flags) & SLOT_HEAD)
		return /obj/item/clothing/head
	if(initial(path.slot_flags) & SLOT_ICLOTHING)
		return /obj/item/clothing/under
	if(initial(path.slot_flags) & SLOT_EYES)
		return /obj/item/clothing/glasses
	if(initial(path.slot_flags) & SLOT_GLOVES)
		return /obj/item/clothing/gloves
	if(initial(path.slot_flags) & SLOT_MASK)
		return /obj/item/clothing/mask
	if(initial(path.slot_flags) & SLOT_FEET)
		return /obj/item/clothing/shoes
	if(initial(path.slot_flags) & SLOT_OCLOTHING)
		return /obj/item/clothing/suit

/mob/living/silicon/pai/AltClickOn(var/atom/A)
	if((isobj(A) || ismob(A)) && in_range_of(src, A) && !istype(A, /obj/item/paicard))
		if(world.time > last_scanned_time + 600)
			last_scanned_time = world.time
			scan_object(A)
			to_chat(src, "You scan the [A.name]")
		else
			to_chat(src, "You need to wait [((last_scanned_time+600) - world.time)/10] seconds to scan another object.")

/mob/living/silicon/pai/proc/scan_object(var/atom/A)
	var/icon/hologram_icon = render_hologram_icon(A, 210, TRUE, TRUE, "_pai")
	var/hologram_width = hologram_icon.Width()
	var/width_adjustment = (32 - hologram_width) / 2

	var/image/I = image(hologram_icon)
	I.color = rgb(204,255,204)
	I.pixel_y = 30
	I.pixel_x = width_adjustment
	I.appearance_flags = RESET_TRANSFORM | KEEP_APART
	scanned_objects[A.name] = I

	// more than 10 items? remove the oldest object (index 0) in the list
	if(length(scanned_objects) > 10)
		scanned_objects.Cut(0, 1)

/mob/living/silicon/pai/proc/get_holo_image()
	return render_hologram_icon(usr.client.prefs.render_to_appearance(PREF_COPY_TO_FOR_RENDER | PREF_COPY_TO_NO_CHECK_SPECIES | PREF_COPY_TO_UNRESTRICTED_LOADOUT), 210)