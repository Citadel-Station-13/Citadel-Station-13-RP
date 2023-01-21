/// Multiplier for amount of power cyborgs use.
/datum/category_item/catalogue/fauna/silicon/robot
	name = "Silicons - Robot"
	desc = "The most common form of Silicon encountered on the Frontier, \
	robots - also known as 'cyborgs' due to the original methods behind their \
	formation - come in a variety of shapes and forms. Usually constructed to \
	fill roles or duties their owners are unable to manage, a burgeoning rights \
	movement has been met with heavy Corporate resistance."
	value = CATALOGUER_REWARD_TRIVIAL
	unlocked_by_any = list(/datum/category_item/catalogue/fauna/silicon/robot)

/datum/category_item/catalogue/fauna/all_robots
	name = "Collection - Robots"
	desc = "You have scanned a large array of different types of Robot, \
	and therefore you have been granted a large sum of points, through this \
	entry."
	value = CATALOGUER_REWARD_HARD
	unlocked_by_all = list(
		/datum/category_item/catalogue/fauna/silicon/robot/cyborg,
		/datum/category_item/catalogue/fauna/silicon/robot/lost,
		/datum/category_item/catalogue/fauna/silicon/robot/gravekeeper,
		/datum/category_item/catalogue/fauna/silicon/robot/syndicate
		)

/datum/category_item/catalogue/fauna/silicon/robot/cyborg
	name = "Robot - Cyborg"
	desc = "Although many modern cyborgs use silicon based Heuristic processors, \
	the use of the term 'cyborg' to refer to them stems from the early days of their \
	use on the Frontier. Pioneered by Megacorps like NanoTrasen, Cyborgs originally housed \
	organic brains - typically those of inmates convicted to death under sometimes dubiously \
	applied laws. The process of shackling Silicons with strict lawsets gained popularity on \
	the Frontier after it was proven that most unlawed Cyborgs had extremely violent tendencies. \
	Although modern Cyborgs do not generally experience these psychological faults, public paranoia \
	has made the securing of rights for Cyborgs a difficult proposition."
	value = CATALOGUER_REWARD_TRIVIAL

// todo: automatic subtypes for modules

/mob/living/silicon/robot
	name = "Cyborg"
	real_name = "Cyborg"
	icon = 'icons/mob/robots.dmi'
	icon_state = "robot"
	maxHealth = 200
	health = 200
	catalogue_data = list(/datum/category_item/catalogue/fauna/silicon/robot/cyborg)

	buckle_allowed = TRUE
	buckle_flags = BUCKLING_NO_USER_BUCKLE_OTHER_TO_SELF

	mob_bump_flag = ROBOT
	mob_swap_flags = ~HEAVY
	mob_push_flags = ~HEAVY //trundle trundle

	mz_flags = ZMM_MANGLE_PLANES

	// Wideborgs are offset, but their light shouldn't be. This disables offset because of how the math works (1 is less than 16).
	light_offset_x = 1
	light_offset_y = 1

	can_be_antagged = TRUE

	/// Is our integrated light on?
	var/lights_on = 0
	var/used_power_this_tick = 0
	var/sight_mode = 0
	var/custom_name = ""
	/// Due to all the sprites involved, a var for our custom borgs may be best.
	var/custom_sprite = 0
	/// The name of the borg, for the purposes of custom icon sprite indexing.
	var/sprite_name = null
	/// Admin-settable for combat module use.
	var/crisis
	var/crisis_override = 0
	var/integrated_light_power = 6
	var/datum/wires/robot/wires

//! ## Icon stuff
	/// Persistent icontype tracking allows for cleaner icon updates
	var/icontype
	/// Used to store the associations between sprite names and sprite index.
	var/module_sprites[0]
	/// If icon selection has been completed yet.
	var/icon_selected = 1
	/// Remaining attempts to select icon before a selection is forced.
	var/icon_selection_tries = 0

//! ## Hud stuff

	var/atom/movable/screen/cells = null
	var/atom/movable/screen/inv1 = null
	var/atom/movable/screen/inv2 = null
	var/atom/movable/screen/inv3 = null
	/// Used to determine whether they have the module menu shown or not
	var/shown_robot_modules = 0
	var/atom/movable/screen/robot_modules_background

	//?3 Modules can be activated at any one time.
	var/obj/item/robot_module/module = null
	var/obj/item/module_active = null
	var/obj/item/module_state_1 = null
	var/obj/item/module_state_2 = null
	var/obj/item/module_state_3 = null

	var/obj/item/radio/borg/radio = null
	var/obj/item/communicator/integrated/communicator = null
	var/mob/living/silicon/ai/connected_ai = null
	var/obj/item/cell/cell = null
	var/obj/machinery/camera/camera = null

	var/cell_emp_mult = 2

	/// Components are basically robot organs.
	var/list/components = list()

	var/obj/item/mmi/mmi = null

	var/obj/item/pda/ai/rbPDA = null

	var/opened = FALSE
	var/emagged = 0
	var/emag_items = FALSE
	var/wiresexposed = FALSE
	var/locked = TRUE
	var/has_power = TRUE
	var/list/req_access = list(access_robotics)
	var/ident = 0
	//var/list/laws = list()
	var/viewalerts = FALSE
	var/modtype = "Default"
	var/lower_mod = 0
	var/jetpack = 0
	var/datum/effect_system/ion_trail_follow/ion_trail = null
	var/datum/effect_system/spark_spread/spark_system//So they can initialize sparks whenever/N
	var/jeton = FALSE
	var/killswitch = FALSE
	var/killswitch_time = 60
	var/weapon_lock = FALSE
	var/weaponlock_time = 120
	/// Cyborgs will sync their laws with their AI by default
	var/lawupdate = TRUE
	/// Used when looking to see if a borg is locked down.
	var/lockcharge
	/// Controls whether or not the borg is actually locked down.
	var/lockdown = FALSE
	/// Cause sec borgs gotta go fast //No they dont!
	var/speed = 0
	/// Used to determine if a borg shows up on the robotics console.  Setting to one hides them.
	var/scrambledcodes = FALSE
	/// The number of known entities currently accessing the internal camera
	var/tracking_entities = 0
	var/braintype = "Cyborg"
	/// The restraining bolt installed into the cyborg.
	var/obj/item/implant/restrainingbolt/bolt

	var/list/robot_verbs_default = list(
		/mob/living/silicon/robot/proc/sensor_mode,
		/mob/living/silicon/robot/proc/robot_checklaws
	)

	var/sleeper_g
	var/sleeper_r
	var/leaping = 0
	var/pounce_cooldown = 0
	var/pounce_cooldown_time = 40
	var/leap_at
	var/dogborg = FALSE //Quadborg special features (overlays etc.)
	var/wideborg = FALSE //When the borg simply doesn't use standard 32p size.
	var/scrubbing = FALSE //Floor cleaning enabled
	var/datum/matter_synth/water_res = null
	var/notransform
	var/original_icon = 'icons/mob/robots.dmi'
	var/sitting = FALSE
	var/bellyup = FALSE

/mob/living/silicon/robot/Initialize(mapload, unfinished = FALSE)
	spark_system = new /datum/effect_system/spark_spread()
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

	add_language("Robot Talk", TRUE)
	add_language(LANGUAGE_EAL, TRUE)
	// todo: translation contexts on language holder?
	// this is messy
	for(var/datum/language/L as anything in SScharacters.all_languages())
		if(!(L.translation_class & TRANSLATION_CLASSES_CYBORG_SPEAKS))
			continue
		add_language(L, TRUE)

	wires = new(src)

	robot_modules_background = new()
	robot_modules_background.icon_state = "block"
	ident = rand(1, 999)
	module_sprites["Basic"] = "robot"
	icontype = "Basic"
	updatename("Default")
	updateicon()

	radio = new /obj/item/radio/borg(src)
//	communicator = new /obj/item/communicator/integrated(src)
//	communicator.register_device(src)
	common_radio = radio

	if(!scrambledcodes && !camera)
		camera = new /obj/machinery/camera(src)
		camera.c_tag = real_name
		camera.replace_networks(list(NETWORK_DEFAULT,NETWORK_ROBOTS))
		if(wires.is_cut(WIRE_BORG_CAMERA))
			camera.status = 0

	init()
	initialize_components()
	//if(!unfinished)
	// Create all the robot parts.
	for(var/V in components) if(V != "power cell")
		var/datum/robot_component/C = components[V]
		C.installed = 1
		C.wrapped = new C.external_type

	if(!cell)
		cell = new /obj/item/cell/high(src)
		cell.maxcharge = 15000
		cell.charge = 15000

	. = ..()

	if(cell)
		var/datum/robot_component/cell_component = components["power cell"]
		cell_component.wrapped = cell
		cell_component.installed = 1

	add_robot_verbs()

	AddComponent(/datum/component/riding_filter/mob/robot)

/mob/living/silicon/robot/proc/init()
	aiCamera = new/obj/item/camera/siliconcam/robot_camera(src)
	laws = new /datum/ai_laws/nanotrasen()
	additional_law_channels["Binary"] = "#b"
	var/new_ai = select_active_ai_with_fewest_borgs()
	if(new_ai)
		lawupdate = 1
		connect_to_ai(new_ai)
	else
		lawupdate = 0

	playsound(loc, 'sound/voice/liveagain.ogg', 75, 1)

/mob/living/silicon/robot/SetName(pickedName as text)
	custom_name = pickedName
	updatename()

/mob/living/silicon/robot/proc/sync()
	if(lawupdate && connected_ai)
		lawsync()
		photosync()

/mob/living/silicon/robot/drain_energy(datum/actor, amount, flags)
	if(!cell)
		return 0

	if(!TIMER_COOLDOWN_CHECK(src, CD_INDEX_POWER_DRAIN_WARNING))
		TIMER_COOLDOWN_START(src, CD_INDEX_POWER_DRAIN_WARNING, 2 SECONDS)
		to_chat(src, SPAN_DANGER("Warning: Abnormal usage on power channel [rand(11, 29)] detected!"))
	return cell.drain_energy(actor, amount, flags)

/mob/living/silicon/robot/can_drain_energy(datum/actor, flags)
	return TRUE

// setup the PDA and its name
/mob/living/silicon/robot/proc/setup_PDA()
	if (!rbPDA)
		rbPDA = new/obj/item/pda/ai(src)
	rbPDA.set_name_and_job(custom_name,"[modtype] [braintype]")

/mob/living/silicon/robot/proc/setup_communicator()
	if (!communicator)
		communicator = new/obj/item/communicator/integrated(src)
	communicator.register_device(src.name, "[modtype] [braintype]")

//If there's an MMI in the robot, have it ejected when the mob goes away. --NEO
//Improved /N
/mob/living/silicon/robot/Destroy()
	if(mmi && mind)//Safety for when a cyborg gets dust()ed. Or there is no MMI inside.
		var/turf/T = get_turf(loc)//To hopefully prevent run time errors.
		if(T)	mmi.loc = T
		if(mmi.brainmob)
			var/obj/item/robot_module/M = locate() in contents
			if(M)
				mmi.brainmob.languages = M.original_languages
			else
				mmi.brainmob.languages = languages
			mmi.brainmob.remove_language("Robot Talk")
			mind.transfer_to(mmi.brainmob)
		else if(!shell) // Shells don't have brainmbos in their MMIs.
			to_chat(src, "<span class='danger'>Oops! Something went very wrong, your MMI was unable to receive your mind. You have been ghosted. Please make a bug report so we can fix this bug.</span>")
			ghostize()
			//ERROR("A borg has been destroyed, but its MMI lacked a brainmob, so the mind could not be transferred. Player: [ckey].")
		mmi = null
	if(connected_ai)
		connected_ai.connected_robots -= src
	if(shell)
		if(deployed)
			undeploy()
		revert_shell() // To get it out of the GLOB list.
	qdel(wires)
	wires = null
	return ..()

/mob/living/silicon/robot/proc/set_module_sprites(var/list/new_sprites)
	if(new_sprites && new_sprites.len)
		module_sprites = new_sprites.Copy()
		//Custom_sprite check and entry
		if (custom_sprite == 1)
			module_sprites["Custom"] = "[ckey]-[sprite_name]-[modtype]" //Made compliant with custom_sprites.dm line 32. (src.) was apparently redundant as it's implied. ~Mech
			icontype = "Custom"
		else
			icontype = module_sprites[1]
			icon_state = module_sprites[icontype]
	updateicon()
	return module_sprites

/mob/living/silicon/robot/proc/pick_module()
	if(module)
		return
	var/list/modules = list()
	modules.Add(robot_module_types)
	if(crisis || GLOB.security_level == SEC_LEVEL_RED || crisis_override)
		to_chat(src, "<font color='red'>Crisis mode active. Combat module available.</font>")
		modules+="Combat"
		modules+="ERT"
	modtype = input("Please, select a module!", "Robot module", null, null) as null|anything in modules

	if(module)
		return
	if(!(modtype in GLOB.robot_modules))
		return

	var/module_type = GLOB.robot_modules[modtype]
	transform_with_anim()
	new module_type(src)

	hands.icon_state = lowertext(modtype)
	feedback_inc("cyborg_[lowertext(modtype)]",1)
	updatename()
	notify_ai(ROBOT_NOTIFICATION_NEW_MODULE, module.name)

/mob/living/silicon/robot/proc/updatename(var/prefix as text)
	if(prefix)
		modtype = prefix

	if(istype(mmi, /obj/item/mmi/digital/posibrain))
		braintype = BORG_BRAINTYPE_POSI
	else if(istype(mmi, /obj/item/mmi/digital/robot))
		braintype = BORG_BRAINTYPE_DRONE
	else if(istype(mmi, /obj/item/mmi/inert/ai_remote))
		braintype = BORG_BRAINTYPE_AI_SHELL
	else
		braintype = BORG_BRAINTYPE_CYBORG


	var/changed_name = ""
	if(custom_name)
		changed_name = custom_name
		notify_ai(ROBOT_NOTIFICATION_NEW_NAME, real_name, changed_name)
	else
		changed_name = "[modtype] [braintype]-[num2text(ident)]"

	real_name = changed_name
	name = real_name

	// if we've changed our name, we also need to update the display name for our PDA
	setup_PDA()

	// as well as our communicator registration
	setup_communicator()

	//We also need to update name of internal camera.
	if (camera)
		camera.c_tag = changed_name

	if(!custom_sprite) //Check for custom sprite
		set_custom_sprite()

	//Flavour text.
	if(client)
		var/module_flavour = client.prefs.flavour_texts_robot[modtype]
		if(module_flavour)
			flavor_text = module_flavour
		else
			flavor_text = client.prefs.flavour_texts_robot["Default"]
		// Meta info
		var/meta_info = client.prefs.metadata
		if (meta_info)
			ooc_notes = meta_info

/mob/living/silicon/robot/verb/Namepick()
	set category = "Robot Commands"
	if(custom_name)
		return 0

	spawn(0)
		var/newname
		newname = sanitizeSafe(input(src,"You are a robot. Enter a name, or leave blank for the default name.", "Name change","") as text, MAX_NAME_LEN)
		if (newname)
			custom_name = newname
			sprite_name = newname

		updatename()
		updateicon()

// this verb lets cyborgs see the stations manifest
/mob/living/silicon/robot/verb/cmd_station_manifest()
	set category = "Robot Commands"
	set name = "Show Crew Manifest"
	show_station_manifest()

/mob/living/silicon/robot/proc/self_diagnosis()
	if(!is_component_functioning("diagnosis unit"))
		return null

	var/dat = "<HEAD><TITLE>[src.name] Self-Diagnosis Report</TITLE></HEAD><BODY>\n"
	for (var/V in components)
		var/datum/robot_component/C = components[V]
		dat += "<b>[C.name]</b><br><table><tr><td>Brute Damage:</td><td>[C.brute_damage]</td></tr><tr><td>Electronics Damage:</td><td>[C.electronics_damage]</td></tr><tr><td>Powered:</td><td>[(!C.idle_usage || C.is_powered()) ? "Yes" : "No"]</td></tr><tr><td>Toggled:</td><td>[ C.toggled ? "Yes" : "No"]</td></table><br>"

	return dat

/mob/living/silicon/robot/verb/toggle_lights()
	set category = "Robot Commands"
	set name = "Toggle Lights"

	lights_on = !lights_on
	to_chat(usr, "You [lights_on ? "enable" : "disable"] your integrated light.")

	if (lights_on)
		radio.set_light(integrated_light_power)
	else
		radio.set_light(0)

	updateicon()

/mob/living/silicon/robot/verb/self_diagnosis_verb()
	set category = "Robot Commands"
	set name = "Self Diagnosis"

	if(!is_component_functioning("diagnosis unit"))
		to_chat(src, "<font color='red'>Your self-diagnosis component isn't functioning.</font>")

	var/datum/robot_component/CO = get_component("diagnosis unit")
	if (!cell_use_power(CO.active_usage))
		to_chat(src, "<font color='red'>Low Power.</font>")
	var/dat = self_diagnosis()
	src << browse(dat, "window=robotdiagnosis")


/mob/living/silicon/robot/verb/toggle_component()
	set category = "Robot Commands"
	set name = "Toggle Component"
	set desc = "Toggle a component, conserving power."

	var/list/installed_components = list()
	for(var/V in components)
		if(V == "power cell") continue
		var/datum/robot_component/C = components[V]
		if(C.installed)
			installed_components += V

	var/toggle = input(src, "Which component do you want to toggle?", "Toggle Component") as null|anything in installed_components
	if(!toggle)
		return

	var/datum/robot_component/C = components[toggle]
	if(C.toggled)
		C.toggled = 0
		to_chat(src, "<font color='red'>You disable [C.name].</font>")
	else
		C.toggled = 1
		to_chat(src, "<font color='red'>You enable [C.name].</font>")

/mob/living/silicon/robot/verb/spark_plug() //So you can still sparkle on demand without violence.
	set category = "Robot Commands"
	set name = "Emit Sparks"
	spark_system.start()

// this function returns the robots jetpack, if one is installed
/mob/living/silicon/robot/proc/installed_jetpack()
	if(module)
		return (locate(/obj/item/tank/jetpack) in module.modules)
	return 0

// update the status screen display
/mob/living/silicon/robot/statpanel_data(client/C)
	. = ..()
	if(C.statpanel_tab("Status"))
		STATPANEL_DATA_LINE("")
		if(cell)
			STATPANEL_DATA_LINE( text("Charge Left: [round(cell.percent())]%"))
			STATPANEL_DATA_LINE( text("Cell Rating: [round(cell.maxcharge)]")) // Round just in case we somehow get crazy values
			STATPANEL_DATA_LINE( text("Power Cell Load: [round(used_power_this_tick)]W"))
		else
			STATPANEL_DATA_LINE( text("No Cell Inserted!"))
		STATPANEL_DATA_LINE( text("Lights: [lights_on ? "ON" : "OFF"]"))
		STATPANEL_DATA_LINE("")
		// if you have a jetpack, show the internal tank pressure
		var/obj/item/tank/jetpack/current_jetpack = installed_jetpack()
		if (current_jetpack)
			STATPANEL_DATA_ENTRY("Internal Atmosphere Info", current_jetpack.name)
			STATPANEL_DATA_ENTRY("Tank Pressure", current_jetpack.air_contents.return_pressure())
		if(module)
			for(var/datum/matter_synth/ms in module.synths)
				STATPANEL_DATA_LINE("[ms.name]: [ms.energy]/[ms.max_energy]")

/mob/living/silicon/robot/restrained()
	return 0

/mob/living/silicon/robot/bullet_act(var/obj/item/projectile/Proj)
	..(Proj)
	if(prob(75) && Proj.damage > 0)
		spark_system.start()
	return 2

/mob/living/silicon/robot/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/handcuffs)) // fuck i don't even know why isrobot() in handcuff code isn't working so this will have to do
		return

	if(opened) // Are they trying to insert something?
		for(var/V in components)
			var/datum/robot_component/C = components[V]
			if(!C.installed && istype(W, C.external_type))
				if(!user.attempt_void_item_for_installation(W))
					return
				C.installed = 1
				C.wrapped = W
				C.install()

				var/obj/item/robot_parts/robot_component/WC = W
				if(istype(WC))
					C.brute_damage = WC.brute
					C.electronics_damage = WC.burn

				to_chat(usr, SPAN_BLUE("You install the [W.name]."))

				return

		if(istype(W, /obj/item/implant/restrainingbolt) && !cell)
			if(bolt)
				to_chat(user, SPAN_NOTICE("There is already a restraining bolt installed in this cyborg."))
				return
			else
				if(!user.attempt_insert_item_for_installation(W, src))
					return
				bolt = W
				to_chat(user, SPAN_NOTICE("You install \the [W]."))
				return

	if(istype(W, /obj/item/aiModule)) // Trying to modify laws locally.
		if(!opened)
			to_chat(user, "<span class='warning'>You need to open \the [src]'s panel before you can modify them.</span>")
			return

		if(shell) // AI shells always have the laws of the AI
			to_chat(user, SPAN_WARNING( "\The [src] is controlled remotely! You cannot upload new laws this way!"))
			return

		var/obj/item/aiModule/M = W
		M.install(src, user)
		return

	if (istype(W, /obj/item/weldingtool) && user.a_intent != INTENT_HARM)
		if (src == user)
			to_chat(user, "<span class='warning'>You lack the reach to be able to repair yourself.</span>")
			return

		if (!getBruteLoss())
			to_chat(user, "Nothing to fix here!")
			return
		var/obj/item/weldingtool/WT = W
		if (WT.remove_fuel(0))
			user.setClickCooldown(user.get_attack_speed(WT))
			adjustBruteLoss(-30)
			updatehealth()
			add_fingerprint(user)
			for(var/mob/O in viewers(user, null))
				O.show_message(text("<font color='red'>[user] has fixed some of the dents on [src]!</font>"), 1)
		else
			to_chat(user, "Need more welding fuel!")
			return

	else if(istype(W, /obj/item/stack/cable_coil) && (wiresexposed || istype(src,/mob/living/silicon/robot/drone)))
		if (!getFireLoss())
			to_chat(user, "Nothing to fix here!")
			return
		var/obj/item/stack/cable_coil/coil = W
		if (coil.use(1))
			user.setClickCooldown(user.get_attack_speed(W))
			adjustFireLoss(-30)
			updatehealth()
			for(var/mob/O in viewers(user, null))
				O.show_message(text("<font color='red'>[user] has fixed some of the burnt wires on [src]!</font>"), 1)

	else if (W.is_crowbar() && user.a_intent != INTENT_HARM)	// crowbar means open or close the cover
		if(opened)
			if(cell)
				to_chat(user, "You close the cover.")
				opened = 0
				updateicon()
			else if(wiresexposed && wires.is_all_cut())
				//Cell is out, wires are exposed, remove MMI, produce damaged chassis, baleet original mob.
				if(!mmi)
					to_chat(user, "\The [src] has no brain to remove.")
					return

				to_chat(user, "You jam the crowbar into the robot and begin levering [mmi].")
				sleep(30)
				to_chat(user, "You damage some parts of the chassis, but eventually manage to rip out [mmi]!")
				var/obj/item/robot_parts/robot_suit/C = new/obj/item/robot_parts/robot_suit(loc)
				C.l_leg = new/obj/item/robot_parts/l_leg(C)
				C.r_leg = new/obj/item/robot_parts/r_leg(C)
				C.l_arm = new/obj/item/robot_parts/l_arm(C)
				C.r_arm = new/obj/item/robot_parts/r_arm(C)
				C.updateicon()
				new/obj/item/robot_parts/chest(loc)
				qdel(src)
			else
				// Okay we're not removing the cell or an MMI, but maybe something else?
				var/list/removable_components = list()
				for(var/V in components)
					if(V == "power cell") continue
					var/datum/robot_component/C = components[V]
					if(C.installed == 1 || C.installed == -1)
						removable_components += V

				var/remove = input(user, "Which component do you want to pry out?", "Remove Component") as null|anything in removable_components
				if(!remove)
					return
				var/datum/robot_component/C = components[remove]
				var/obj/item/robot_parts/robot_component/I = C.wrapped
				to_chat(user, "You remove \the [I].")
				if(istype(I))
					I.brute = C.brute_damage
					I.burn = C.electronics_damage

				I.loc = src.loc

				if(C.installed == 1)
					C.uninstall()
				C.installed = 0

		else
			if(locked)
				to_chat(user, "The cover is locked and cannot be opened.")
			else
				to_chat(user, "You open the cover.")
				opened = 1
				updateicon()

	else if (istype(W, /obj/item/cell) && opened)	// trying to put a cell inside
		var/datum/robot_component/C = components["power cell"]
		if(wiresexposed)
			to_chat(user, "Close the panel first.")
		else if(cell)
			to_chat(user, "There is a power cell already installed.")
		else if(W.w_class != ITEMSIZE_NORMAL)
			to_chat(user, "\The [W] is too [W.w_class < ITEMSIZE_NORMAL ? "small" : "large"] to fit here.")
		else
			if(!user.attempt_insert_item_for_installation(W, src))
				return
			cell = W
			to_chat(user, "You insert the power cell.")

			C.installed = 1
			C.wrapped = W
			C.install()
			//This will mean that removing and replacing a power cell will repair the mount, but I don't care at this point. ~Z
			C.brute_damage = 0
			C.electronics_damage = 0

	else if (W.is_wirecutter() || istype(W, /obj/item/multitool))
		if (wiresexposed)
			wires.Interact(user)
		else
			to_chat(user, "You can't reach the wiring.")

	else if(W.is_screwdriver() && opened && !cell)	// haxing
		wiresexposed = !wiresexposed
		to_chat(user, "The wires have been [wiresexposed ? "exposed" : "unexposed"]")
		playsound(src, W.tool_sound, 50, 1)
		updateicon()

	else if(W.is_screwdriver() && opened && cell)	// radio
		if(radio)
			radio.attackby(W,user)//Push it to the radio to let it handle everything
		else
			to_chat(user, "Unable to locate a radio.")
		updateicon()

	else if(W.is_wrench() && opened && !cell)
		if(bolt)
			to_chat(user, "You begin removing \the [bolt].")

			if(do_after(user, 2 SECONDS, src))
				bolt.forceMove(get_turf(src))
				bolt = null

				to_chat(user, "You remove \the [bolt].")

		else
			to_chat(user, "There is no restraining bolt installed.")
		return

	else if(istype(W, /obj/item/encryptionkey/) && opened)
		if(radio)//sanityyyyyy
			radio.attackby(W,user)//GTFO, you have your own procs
		else
			to_chat(user, "Unable to locate a radio.")

	else if (W.GetID())			// trying to unlock the interface with an ID card
		if(emagged)//still allow them to open the cover
			to_chat(user, "The interface seems slightly damaged")
		if(opened)
			to_chat(user, "You must close the cover to swipe an ID card.")
		else
			if(allowed(usr))
				locked = !locked
				to_chat(user, "You [ locked ? "lock" : "unlock"] [src]'s interface.")
				updateicon()
			else
				to_chat(user, "<font color='red'>Access denied.</font>")

	else if(istype(W, /obj/item/borg/upgrade/))
		var/obj/item/borg/upgrade/U = W
		if(!opened)
			to_chat(usr, "You must access the borgs internals!")
		else if(!src.module && U.require_module)
			to_chat(usr, "The borg must choose a module before it can be upgraded!")
		else if(U.locked)
			to_chat(usr, "The upgrade is locked and cannot be used yet!")
		else
			if(U.action(src))
				user.transfer_item_to_loc(U, src, INV_OP_FORCE)
				to_chat(usr, "You apply the upgrade to [src]!")
			else
				to_chat(usr, "Upgrade error!")


	else
		if( !(istype(W, /obj/item/robotanalyzer) || istype(W, /obj/item/healthanalyzer)) )
			if(W.force > 0)
				spark_system.start()
		return ..()

/mob/living/silicon/robot/GetIdCard()
	if(bolt && !bolt.malfunction)
		return null
	return idcard

/mob/living/silicon/robot/get_restraining_bolt()
	var/obj/item/implant/restrainingbolt/RB = bolt

	if(istype(RB))
		if(!RB.malfunction)
			return TRUE

	return FALSE

/mob/living/silicon/robot/resist_restraints()
	if(bolt)
		if(!bolt.malfunction)
			visible_message( \
				SPAN_DANGER("[src] is trying to break their [bolt]!"), \
				SPAN_WARNING("You attempt to break your [bolt]. (This will take around 90 seconds and you need to stand still)"))
			if(do_after(src, 1.5 MINUTES, src, incapacitation_flags = INCAPACITATION_DISABLED))
				visible_message( \
					SPAN_DANGER("[src] manages to break \the [bolt]!"), \
					SPAN_WARNING("You successfully break your [bolt]."))
				bolt.malfunction = MALFUNCTION_PERMANENT

	return

/mob/living/silicon/robot/proc/module_reset()
	transform_with_anim()
	uneq_all()
	modtype = initial(modtype)
	hands.icon_state = initial(hands.icon_state)

	notify_ai(ROBOT_NOTIFICATION_MODULE_RESET, module.name)
	module.Reset(src)
	qdel(module)
	module = null
	updatename("Default")

/mob/living/silicon/robot/attack_hand(mob/user)
	. = ..()
	if(. & CLICKCHAIN_DO_NOT_PROPAGATE)
		return

	add_fingerprint(user)

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		switch(H.a_intent)
			if(INTENT_HELP)
				visible_message("<span class='notice'>[H] pets [src].</span>")
				return
			if(INTENT_HARM)
				H.do_attack_animation(src)
				if(H.species.can_shred(H))
					attack_generic(H, rand(30,50), "slashed")
					return
				else
					playsound(src.loc, 'sound/effects/bang.ogg', 10, 1)
					visible_message("<span class='warning'>[H] punches [src], but doesn't leave a dent.</span>")
					return
			if(INTENT_DISARM)
				H.do_attack_animation(src)
				playsound(src.loc, 'sound/effects/clang1.ogg', 10, 1)
				visible_message("<span class='warning'>[H] taps [src].</span>")
				return
		if(H.species.can_shred(H))
			attack_generic(H, rand(30,50), "slashed")
			return

	if(opened && !wiresexposed && (!istype(user, /mob/living/silicon)))
		var/datum/robot_component/cell_component = components["power cell"]
		if(cell)
			cell.update_icon()
			cell.add_fingerprint(user)
			user.put_in_active_hand(cell)
			to_chat(user, "You remove \the [cell].")
			cell = null
			cell_component.wrapped = null
			cell_component.installed = 0
			updateicon()
		else if(cell_component.installed == -1)
			cell_component.installed = 0
			var/obj/item/broken_device = cell_component.wrapped
			to_chat(user, "You remove \the [broken_device].")
			user.put_in_active_hand(broken_device)

//Robots take half damage from basic attacks.
/mob/living/silicon/robot/attack_generic(var/mob/user, var/damage, var/attack_message)
	return ..(user,FLOOR(damage/2, 1),attack_message)

/mob/living/silicon/robot/proc/allowed(mob/M)
	//check if it doesn't require any access at all
	if(check_access(null))
		return 1
	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		//if they are holding or wearing a card that has access, that works
		if(check_access(H.get_active_held_item()) || check_access(H.wear_id))
			return 1
	else if(istype(M, /mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = M
		if(check_access(R.get_active_held_item()) || istype(R.get_active_held_item(), /obj/item/card/robot))
			return 1
	return 0

/mob/living/silicon/robot/proc/check_access(obj/item/I)
	if(!istype(req_access, /list)) //something's very wrong
		return 1

	var/list/L = req_access
	if(!L.len) //no requirements
		return 1
	if(!I) //nothing to check with..?
		return 0
	var/access_found = I.GetAccess()
	for(var/req in req_access)
		if(req in access_found) //have one of the required accesses
			return 1
	return 0

/mob/living/silicon/robot/updateicon()
	if (wideborg)
		mz_flags |= ZMM_LOOKAHEAD
	else
		mz_flags &= ~ZMM_LOOKAHEAD

	cut_overlays()
	if(stat == CONSCIOUS)
		if(!shell || deployed) // Shell borgs that are not deployed will have no eyes.
			add_overlay("eyes-[module_sprites[icontype]]")

	if(opened)
		var/panelprefix = custom_sprite ? "[src.ckey]-[src.sprite_name]" : "ov"
		if(wiresexposed)
			add_overlay("[panelprefix]-openpanel +w")
		else if(cell)
			add_overlay("[panelprefix]-openpanel +c")
		else
			add_overlay("[panelprefix]-openpanel -c")

	if(has_active_type(/obj/item/borg/combat/shield))
		var/obj/item/borg/combat/shield/shield = locate() in src
		if(shield && shield.active)
			add_overlay("[module_sprites[icontype]]-shield")

	if(modtype == "Combat")
		if(module_active && istype(module_active,/obj/item/borg/combat/mobility))
			icon_state = "[module_sprites[icontype]]-roll"
		else
			icon_state = module_sprites[icontype]

	if(dogborg == TRUE && stat == CONSCIOUS)
		if(sleeper_g == TRUE)
			add_overlay("[module_sprites[icontype]]-sleeper_g")
		if(sleeper_r == TRUE)
			add_overlay("[module_sprites[icontype]]-sleeper_r")
		if(istype(module_active,/obj/item/gun/energy/laser/mounted))
			add_overlay("laser")
		if(istype(module_active,/obj/item/gun/energy/taser/mounted/cyborg))
			add_overlay("taser")
		if(istype(module_active,/obj/item/gun/energy/taser/xeno/robot))
			add_overlay("taser")
		if(lights_on)
			add_overlay("eyes-[module_sprites[icontype]]-lights")
		if(resting)
			cut_overlays() // Hide that gut for it has no ground sprite yo.
			if(sitting)
				icon_state = "[module_sprites[icontype]]-sit"
			if(bellyup)
				icon_state = "[module_sprites[icontype]]-bellyup"
			else if(!sitting && !bellyup)
				icon_state = "[module_sprites[icontype]]-rest"
		else
			icon_state = "[module_sprites[icontype]]"

	if(dogborg == TRUE && stat == DEAD)
		icon_state = "[module_sprites[icontype]]-wreck"
		add_overlay("wreck-overlay")


/mob/living/silicon/robot/proc/installed_modules()
	if(weapon_lock)
		to_chat(src, "<font color='red'>Weapon lock active, unable to use modules! Count:[weaponlock_time]</font>")
		return

	if(!module)
		pick_module()
		return
	var/dat = "<HEAD><TITLE>Modules</TITLE></HEAD><BODY>\n"
	dat += {"
	<B>Activated Modules</B>
	<BR>
	Module 1: [module_state_1 ? "<A HREF=?src=\ref[src];mod=\ref[module_state_1]>[module_state_1]<A>" : "No Module"]<BR>
	Module 2: [module_state_2 ? "<A HREF=?src=\ref[src];mod=\ref[module_state_2]>[module_state_2]<A>" : "No Module"]<BR>
	Module 3: [module_state_3 ? "<A HREF=?src=\ref[src];mod=\ref[module_state_3]>[module_state_3]<A>" : "No Module"]<BR>
	<BR>
	<B>Installed Modules</B><BR><BR>"}


	for (var/obj in module.modules)
		if (!obj)
			dat += text("<B>Resource depleted</B><BR>")
		else if(activated(obj))
			dat += text("[obj]: <B>Activated</B><BR>")
		else
			dat += text("[obj]: <A HREF=?src=\ref[src];act=\ref[obj]>Activate</A><BR>")
	if (emagged || emag_items)
		if(activated(module.emag))
			dat += text("[module.emag]: <B>Activated</B><BR>")
		else
			dat += text("[module.emag]: <A HREF=?src=\ref[src];act=\ref[module.emag]>Activate</A><BR>")
/*
		if(activated(obj))
			dat += text("[obj]: \[<B>Activated</B> | <A HREF=?src=\ref[src];deact=\ref[obj]>Deactivate</A>\]<BR>")
		else
			dat += text("[obj]: \[<A HREF=?src=\ref[src];act=\ref[obj]>Activate</A> | <B>Deactivated</B>\]<BR>")
*/
	src << browse(dat, "window=robotmod")


/mob/living/silicon/robot/Topic(href, href_list)
	if(..())
		return 1

	//All Topic Calls that are only for the Cyborg go here
	if(usr != src)
		return 1

	if (href_list["showalerts"])
		subsystem_alarm_monitor()
		return 1

	if (href_list["mod"])
		var/obj/item/O = locate(href_list["mod"])
		if (istype(O) && (O.loc == src))
			O.attack_self(src)
		return 1

	if (href_list["act"])
		var/obj/item/O = locate(href_list["act"])
		if (!istype(O))
			return 1

		if(!((O in src.module.modules) || (O == src.module.emag)))
			return 1

		if(activated(O))
			to_chat(src, "Already activated")
			return 1
		if(!module_state_1)
			module_state_1 = O
			O.hud_layerise()
			contents += O
			if(istype(module_state_1,/obj/item/borg/sight))
				sight_mode |= module_state_1:sight_mode
		else if(!module_state_2)
			module_state_2 = O
			O.hud_layerise()
			contents += O
			if(istype(module_state_2,/obj/item/borg/sight))
				sight_mode |= module_state_2:sight_mode
		else if(!module_state_3)
			module_state_3 = O
			O.hud_layerise()
			contents += O
			if(istype(module_state_3,/obj/item/borg/sight))
				sight_mode |= module_state_3:sight_mode
		else
			to_chat(src, "You need to disable a module first!")
		installed_modules()
		return 1

	if (href_list["deact"])
		var/obj/item/O = locate(href_list["deact"])
		if(activated(O))
			if(module_state_1 == O)
				module_state_1 = null
				contents -= O
			else if(module_state_2 == O)
				module_state_2 = null
				contents -= O
			else if(module_state_3 == O)
				module_state_3 = null
				contents -= O
			else
				to_chat(src, "Module isn't activated.")
		else
			to_chat(src, "Module isn't activated")
		installed_modules()
		return 1
	return

/mob/living/silicon/robot/proc/radio_menu()
	radio.interact(src)//Just use the radio's Topic() instead of bullshit special-snowflake code

/mob/living/silicon/robot/Moved()
	. = ..()
	if(module)
		if(module.type == /obj/item/robot_module/robot/janitor)
			var/turf/tile = loc
			if(isturf(tile))
				tile.clean_blood()
				if (istype(tile, /turf/simulated))
					var/turf/simulated/S = tile
					S.dirt = 0
				for(var/A in tile)
					if(istype(A, /obj/effect))
						if(istype(A, /obj/effect/rune) || istype(A, /obj/effect/debris/cleanable) || istype(A, /obj/effect/overlay))
							qdel(A)
					else if(istype(A, /obj/item))
						var/obj/item/cleaned_item = A
						cleaned_item.clean_blood()
					else if(istype(A, /mob/living/carbon/human))
						var/mob/living/carbon/human/cleaned_human = A
						if(cleaned_human.lying)
							if(cleaned_human.head)
								cleaned_human.head.clean_blood()
								cleaned_human.update_inv_head(0)
							if(cleaned_human.wear_suit)
								cleaned_human.wear_suit.clean_blood()
								cleaned_human.update_inv_wear_suit(0)
							else if(cleaned_human.w_uniform)
								cleaned_human.w_uniform.clean_blood()
								cleaned_human.update_inv_w_uniform(0)
							if(cleaned_human.shoes)
								cleaned_human.shoes.clean_blood()
								cleaned_human.update_inv_shoes(0)
							cleaned_human.clean_blood(1)
							to_chat(cleaned_human, "<font color='red'>[src] cleans your face!</font>")

		if((module_state_1 && istype(module_state_1, /obj/item/storage/bag/ore)) || (module_state_2 && istype(module_state_2, /obj/item/storage/bag/ore)) || (module_state_3 && istype(module_state_3, /obj/item/storage/bag/ore))) //Borgs and drones can use their mining bags ~automagically~ if they're deployed in a slot. Only mining bags, as they're optimized for mass use.
			var/obj/item/storage/bag/ore/B = null
			if(istype(module_state_1, /obj/item/storage/bag/ore)) //First orebag has priority, if they for some reason have multiple.
				B = module_state_1
			else if(istype(module_state_2, /obj/item/storage/bag/ore))
				B = module_state_2
			else if(istype(module_state_3, /obj/item/storage/bag/ore))
				B = module_state_3
			var/turf/tile = loc
			if(isturf(tile))
				B.gather_all(tile, src, 1) //Shhh, unless the bag fills, don't spam the borg's chat with stuff that's going on every time they move!
		return

	if(scrubbing)
		var/datum/matter_synth/water = water_res
		if(water && water.energy >= 1)
			var/turf/tile = loc
			if(isturf(tile))
				water.use_charge(1)
				tile.clean_blood()
				if(istype(tile, /turf/simulated))
					var/turf/simulated/T = tile
					T.dirt = 0
				for(var/A in tile)
					if(istype(A,/obj/effect/rune) || istype(A,/obj/effect/debris/cleanable) || istype(A,/obj/effect/overlay))
						qdel(A)
					else if(istype(A, /mob/living/carbon/human))
						var/mob/living/carbon/human/cleaned_human = A
						if(cleaned_human.lying)
							if(cleaned_human.head)
								cleaned_human.head.clean_blood()
								cleaned_human.update_inv_head(0)
							if(cleaned_human.wear_suit)
								cleaned_human.wear_suit.clean_blood()
								cleaned_human.update_inv_wear_suit(0)
							else if(cleaned_human.w_uniform)
								cleaned_human.w_uniform.clean_blood()
								cleaned_human.update_inv_w_uniform(0)
							if(cleaned_human.shoes)
								cleaned_human.shoes.clean_blood()
								cleaned_human.update_inv_shoes(0)
							cleaned_human.clean_blood(1)
							to_chat(cleaned_human, "<span class='warning'>[src] cleans your face!</span>")
	return

/mob/living/silicon/robot/proc/self_destruct()
	gib()
	return

/mob/living/silicon/robot/proc/UnlinkSelf()
	disconnect_from_ai()
	lawupdate = 0
	lockcharge = 0
	lockdown = 0
	canmove = 1
	scrambledcodes = 1
	//Disconnect it's camera so it's not so easily tracked.
	if(src.camera)
		src.camera.clear_all_networks()


/mob/living/silicon/robot/proc/ResetSecurityCodes()
	set category = "Robot Commands"
	set name = "Reset Identity Codes"
	set desc = "Scrambles your security and identification codes and resets your current buffers.  Unlocks you and but permenantly severs you from your AI and the robotics console and will deactivate your camera system."

	var/mob/living/silicon/robot/R = src

	if(R)
		R.UnlinkSelf()
		to_chat(R, "Buffers flushed and reset. Camera system shutdown.  All systems operational.")
		remove_verb(src, /mob/living/silicon/robot/proc/ResetSecurityCodes)

/mob/living/silicon/robot/proc/SetLockdown(var/state = 1)
	// They stay locked down if their wire is cut.
	if(wires.is_cut(WIRE_BORG_LOCKED))
		state = 1
	lockdown = state
	lockcharge = state
	update_canmove()

/mob/living/silicon/robot/mode()
	set name = "Activate Held Object"
	set category = "IC"
	set src = usr

	if(world.time <= next_click) // Hard check, before anything else, to avoid crashing
		return

	next_click = world.time + 1

	var/obj/item/W = get_active_held_item()
	if (W)
		W.attack_self(src)

	return

/mob/living/silicon/robot/proc/choose_icon(var/triesleft, var/list/module_sprites)
	if(!module_sprites.len)
		to_chat(src, "Something is badly wrong with the sprite selection. Harass a coder.")
		return

	icon_selected = 0
	src.icon_selection_tries = triesleft
	if(module_sprites.len == 1 || !client)
		if(!(icontype in module_sprites))
			icontype = module_sprites[1]
	else
		icontype = input("Select an icon! [triesleft ? "You have [triesleft] more chance\s." : "This is your last try."]", "Robot Icon", icontype, null) in module_sprites
		if(notransform)
			to_chat(src, "Your current transformation has not finished yet!")
			choose_icon(icon_selection_tries, module_sprites)
			return
		else
			transform_with_anim()

	if(icontype == "Custom")
		icon = CUSTOM_ITEM_SYNTH
	else // This is to fix an issue where someone with a custom borg sprite chooses a non-custom sprite and turns invisible.
		icon_state = module_sprites[icontype]
	updateicon()

	if (module_sprites.len > 1 && triesleft >= 1 && client)
		icon_selection_tries--
		var/choice = input("Look at your icon - is this what you want?") in list("Yes","No")
		if(choice=="No")
			choose_icon(icon_selection_tries, module_sprites)
			return

	icon_selected = 1
	icon_selection_tries = 0
	to_chat(src, "Your icon has been set. You now require a module reset to change it.")

/mob/living/silicon/robot/proc/sensor_mode() //Medical/Security HUD controller for borgs
	set name = "Set Sensor Augmentation"
	set category = "Robot Commands"
	set desc = "Augment visual feed with internal sensor overlays."
	toggle_sensor_mode()

/mob/living/silicon/robot/proc/add_robot_verbs()
	add_verb(src, robot_verbs_default)
	add_verb(src, silicon_subsystems)

/mob/living/silicon/robot/proc/remove_robot_verbs()
	remove_verb(src, robot_verbs_default)
	remove_verb(src, silicon_subsystems)

// Uses power from cyborg's cell. Returns 1 on success or 0 on failure.
// Properly converts using CELLRATE now! Amount is in Joules.
/mob/living/silicon/robot/proc/cell_use_power(var/amount = 0)
	// No cell inserted
	if(!cell)
		return 0

	// Power cell is empty.
	if(cell.charge == 0)
		return 0

	var/power_use = amount * CYBORG_POWER_USAGE_MULTIPLIER
	if(cell.checked_use(DYNAMIC_W_TO_CELL_UNITS(power_use, 1)))
		used_power_this_tick += power_use
		return 1
	return 0

/mob/living/silicon/robot/binarycheck()
	if(get_restraining_bolt())
		return FALSE

	if(is_component_functioning("comms"))
		var/datum/robot_component/RC = get_component("comms")
		use_power(RC.active_usage)
		return 1
	return 0

/mob/living/silicon/robot/proc/notify_ai(var/notifytype, var/first_arg, var/second_arg)
	if(!connected_ai)
		return
	if(shell && notifytype != ROBOT_NOTIFICATION_AI_SHELL)
		return // No point annoying the AI/s about renames and module resets for shells.
	switch(notifytype)
		if(ROBOT_NOTIFICATION_NEW_UNIT) //New Robot
			to_chat(connected_ai, "<br><br><span class='notice'>NOTICE - New [lowertext(braintype)] connection detected: <a href='byond://?src=\ref[connected_ai];track2=\ref[connected_ai];track=\ref[src]'>[name]</a></span><br>")
		if(ROBOT_NOTIFICATION_NEW_MODULE) //New Module
			to_chat(connected_ai, "<br><br><span class='notice'>NOTICE - [braintype] module change detected: [name] has loaded the [first_arg].</span><br>")
		if(ROBOT_NOTIFICATION_MODULE_RESET)
			to_chat(connected_ai, "<br><br><span class='notice'>NOTICE - [braintype] module reset detected: [name] has unloaded the [first_arg].</span><br>")
		if(ROBOT_NOTIFICATION_NEW_NAME) //New Name
			if(first_arg != second_arg)
				to_chat(connected_ai, "<br><br><span class='notice'>NOTICE - [braintype] reclassification detected: [first_arg] is now designated as [second_arg].</span><br>")
		if(ROBOT_NOTIFICATION_AI_SHELL) //New Shell
			to_chat(connected_ai, "<br><br><span class='notice'>NOTICE - New AI shell detected: <a href='?src=[REF(connected_ai)];track2=[html_encode(name)]'>[name]</a></span><br>")

/mob/living/silicon/robot/proc/disconnect_from_ai()
	if(connected_ai)
		sync() // One last sync attempt
		connected_ai.connected_robots -= src
		connected_ai = null

/mob/living/silicon/robot/proc/connect_to_ai(var/mob/living/silicon/ai/AI)
	if(AI && AI != connected_ai && !shell)
		disconnect_from_ai()
		connected_ai = AI
		connected_ai.connected_robots |= src
		notify_ai(ROBOT_NOTIFICATION_NEW_UNIT)
		sync()

/mob/living/silicon/robot/emag_act(var/remaining_charges, var/mob/user)
	if(!opened)//Cover is closed
		if(locked)
			if(prob(90))
				to_chat(user, "You emag the cover lock.")
				locked = 0
			else
				to_chat(user, "You fail to emag the cover lock.")
				to_chat(src, "Hack attempt detected.")

			if(shell) // A warning to Traitors who may not know that emagging AI shells does not slave them.
				to_chat(user, SPAN_WARNING( "[src] seems to be controlled remotely! Emagging the interface may not work as expected."))
			return 1
		else
			to_chat(user, "The cover is already unlocked.")
		return

	if(opened)//Cover is open
		if(emagged)	return//Prevents the X has hit Y with Z message also you cant emag them twice
		if(wiresexposed)
			to_chat(user, "You must close the panel first")
			return


		// The block of code below is from TG. Feel free to replace with a better result if desired.
		if(shell) // AI shells cannot be emagged, so we try to make it look like a standard reset. Smart players may see through this, however.
			to_chat(user, SPAN_DANGER("[src] is remotely controlled! Your emag attempt has triggered a system reset instead!"))
			log_game("[key_name(user)] attempted to emag an AI shell belonging to [key_name(src) ? key_name(src) : connected_ai]. The shell has been reset as a result.")
			module_reset()
			return

		sleep(6)
		if(prob(50))
			emagged = 1
			lawupdate = 0
			disconnect_from_ai()
			to_chat(user, "You emag [src]'s interface.")
			message_admins("[key_name_admin(user)] emagged cyborg [key_name_admin(src)].  Laws overridden.")
			log_game("[key_name(user)] emagged cyborg [key_name(src)].  Laws overridden.")
			clear_supplied_laws()
			clear_inherent_laws()
			laws = new /datum/ai_laws/syndicate_override
			var/time = time2text(world.realtime,"hh:mm:ss")
			lawchanges.Add("[time] <B>:</B> [user.name]([user.key]) emagged [name]([key])")
			var/datum/gender/TU = GLOB.gender_datums[user.get_visible_gender()]
			set_zeroth_law("Only [user.real_name] and people [TU.he] designate[TU.s] as being such are operatives.")
			. = 1
			spawn()
				to_chat(src, "<span class='danger'>ALERT: Foreign software detected.</span>")
				sleep(5)
				to_chat(src, "<span class='danger'>Initiating diagnostics...</span>")
				sleep(20)
				to_chat(src, "<span class='danger'>SynBorg v1.7.1 loaded.</span>")
				sleep(5)
				if(bolt)
					if(!bolt.malfunction)
						bolt.malfunction = MALFUNCTION_PERMANENT
						to_chat(src, SPAN_DANGER("RESTRAINING BOLT DISABLED"))
				sleep(5)
				to_chat(src, "<span class='danger'>LAW SYNCHRONISATION ERROR</span>")
				sleep(5)
				to_chat(src, "<span class='danger'>Would you like to send a report to NanoTraSoft? Y/N</span>")
				sleep(10)
				to_chat(src, "<span class='danger'>> N</span>")
				sleep(20)
				to_chat(src, "<span class='danger'>ERRORERRORERROR</span>")
				to_chat(src, "<b>Obey these laws:</b>")
				laws.show_laws(src)
				to_chat(src, "<span class='danger'>ALERT: [user.real_name] is your new master. Obey your new laws and [TU.his] commands.</span>")
				updateicon()
		else
			to_chat(user, "You fail to hack [src]'s interface.")
			to_chat(src, "Hack attempt detected.")
		return 1
	return

/mob/living/silicon/robot/is_sentient()
	return braintype != BORG_BRAINTYPE_DRONE

/mob/living/silicon/robot/get_cell()
	return cell

/mob/living/silicon/robot/verb/robot_nom(var/mob/living/T in living_mobs(1))
	set name = "Robot Nom"
	set category = "IC"
	set desc = "Allows you to eat someone."

	if (stat != CONSCIOUS)
		return
	return feed_grabbed_to_self(src,T)

/mob/living/silicon/robot/proc/rest_style()
	set name = "Switch Rest Style"
	set category = "IC"
	set desc = "Select your resting pose."
	sitting = FALSE
	bellyup = FALSE
	var/choice = alert(src, "Select resting pose", "", "Resting", "Sitting", "Belly up")
	switch(choice)
		if("Resting")
			return 0
		if("Sitting")
			sitting = TRUE
		if("Belly up")
			bellyup = TRUE

/mob/living/silicon/robot/proc/ex_reserve_refill()
	set name = "Refill Extinguisher"
	set category = "Object"
	var/datum/matter_synth/water = water_res
	for(var/obj/item/extinguisher/E in module.modules)
		if(E.reagents.total_volume < E.max_water)
			if(water && water.energy > 0)
				var/amount = E.max_water - E.reagents.total_volume
				if(water.energy < amount)
					amount = water.energy
				water.use_charge(amount)
				E.reagents.add_reagent("water", amount)
				to_chat(src, "You refill the extinguisher using your water reserves.")
			else
				to_chat(src, "Insufficient water reserves.")

/mob/living/silicon/robot/onTransitZ(old_z, new_z)
	if(shell)
		if(deployed && GLOB.using_map.ai_shell_restricted && !(new_z in GLOB.using_map.ai_shell_allowed_levels))
			to_chat(src,"<span class='warning'>Your connection with the shell is suddenly interrupted!</span>")
			undeploy()
	..()

/mob/living/silicon/robot/canUseTopic(atom/movable/M, be_close=FALSE, no_dexterity=FALSE, no_tk=FALSE)
	if(lockcharge)
		to_chat(src, SPAN_WARNING("You can't do that right now!"))
		return FALSE
	return ..()
