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
	use on the Frontier. Pioneered by Megacorps like Nanotrasen, Cyborgs originally housed \
	organic brains - typically those of inmates convicted to death under sometimes dubiously \
	applied laws. The process of shackling Silicons with strict lawsets gained popularity on \
	the Frontier after it was proven that most unlawed Cyborgs had extremely violent tendencies. \
	Although modern Cyborgs do not generally experience these psychological faults, public paranoia \
	has made the securing of rights for Cyborgs a difficult proposition."
	value = CATALOGUER_REWARD_TRIVIAL

// todo: automatic subtypes for modules

/**
 * ## Composition
 *
 * Robots are / will be made out of:
 *
 * * chassis - determines baseline functionality and support
 * * iconsets - determines sprites
 *
 * WIP. Modules, components, etc, are next.
 */
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

	zmm_flags = ZMM_MANGLE_PLANES

	// Wideborgs are offset, but their light shouldn't be. This disables offset because of how the math works (1 is less than 16).
	light_offset_x = 1
	light_offset_y = 1

	can_be_antagged = TRUE

	//* Composition *//

	/// set to instance to init as that instance
	var/datum/prototype/robot_iconset/iconset
	/// set to instance to init as that instance
	var/datum/prototype/robot_chassis/chassis
	var/datum/robot_provisioning/chassis_provisioning
	/// set to instance to init as that instance
	var/datum/prototype/robot_module/module
	var/datum/robot_provisioning/module_provisioning

	/// all installed upgrades
	/// * some upgrades are consumed on install, and therefore won't be in here
	var/list/obj/item/robot_upgrade/upgrades

	//* Configuration *//

	/// Allowed selection groups for robot module picking
	/// * Null = cannot pick anything, so, uh, don't fuck around with this.
	/// todo: module based?
	var/list/conf_module_pick_selection_groups
	/// Disallowed selection groups for robot module picking
	/// * Overrides pick_selection_groups and things like
	///   red alert default groups
	var/list/conf_module_pick_selection_groups_excluded
	/// Initial default lawset
	/// * An instance or a type is accepted
	/// todo: module based?
	var/conf_default_lawset_type = /datum/ai_lawset/nanotrasen
	/// Auto connect to AI
	/// todo: module bsaed?
	var/conf_auto_ai_link = TRUE
	/// Bootup sound
	var/conf_reboot_sound = 'sound/voice/liveagain.ogg'
	/// MMI type to make if we have none
	var/conf_mmi_create_type = /obj/item/mmi
	/// Create cell type if it doesn't exist
	var/conf_cell_create_type = /obj/item/cell/high/plus

	//* Inventory *//

	inventory = /datum/inventory/robot
	/// Resources store
	#warn make on new
	var/datum/robot_resource_store/resources

	//* State *//

	/// If set, we are a blank slate, and are allowed to pick a module and frame.
	var/can_repick_module = TRUE
	/// If set, we are able to repick our frame.
	/// * This does not imply [can_repick_module]. If this is set, and that isn't,
	///   and we already have a module, we can repick our frame but not our module.
	var/can_repick_frame = TRUE
	/// Currently active voluntary sprite variation for rest.
	/// * Reset upon stopping resting.
	/// * This is the ID of the variation.
	#warn impl picker
	var/picked_resting_variation

	//* Movement *//
	/// Base movement speed in tiles / second
	var/movement_base_speed = 4.5

	//* -- Legacy Below -- *//

	/// legacy: are we floor scrubbing?
	var/legacy_floor_scrubbing = FALSE

	/// Is our integrated light on?
	var/lights_on = 0
	var/used_power_this_tick = 0
	var/sight_mode = 0
	var/custom_name = ""
	/// The name of the borg, for the purposes of custom icon sprite indexing.
	var/sprite_name = null
	/// Admin-settable for combat module use.
	var/crisis
	var/crisis_override = 0
	var/integrated_light_power = 4.5
	var/datum/wires/robot/wires

	var/atom/movable/screen/cells = null

	//?3 Modules can be activated at any one time.
	var/obj/item/robot_module_legacy/module_legacy = null

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
	var/emagged = FALSE
	var/emag_items = FALSE
	var/wiresexposed = FALSE
	var/locked = TRUE
	var/has_power = TRUE
	var/list/req_access = list(ACCESS_SCIENCE_ROBOTICS)
	var/ident = 0
	var/viewalerts = FALSE
	var/modtype = "Default"
	var/jetpack = 0
	var/datum/effect_system/ion_trail_follow/ion_trail = null
	var/datum/effect_system/spark_spread/spark_system

	/// Cyborgs will sync their laws with their AI by default
	var/lawupdate = TRUE
	/// Used when looking to see if a borg is locked down.
	var/lockcharge
	/// Controls whether or not the borg is actually locked down.
	var/lockdown = FALSE
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

	var/leaping = 0
	var/pounce_cooldown = 0
	var/pounce_cooldown_time = 40
	var/leap_at
	var/scrubbing = FALSE //Floor cleaning enabled

	var/shell = FALSE
	var/deployed = FALSE
	var/mob/living/silicon/ai/mainframe = null

/mob/living/silicon/robot/Initialize(mapload, unfinished = FALSE)
	spark_system = new /datum/effect_system/spark_spread()
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

	add_language("Robot Talk", TRUE)
	add_language(LANGUAGE_EAL, TRUE)
	// todo: translation contexts on language holder?
	// this is messy
	for(var/datum/prototype/language/L as anything in RSlanguages.fetch_subtypes_immutable(/datum/prototype/language))
		if(!(L.translation_class & TRANSLATION_CLASSES_CYBORG_SPEAKS))
			continue
		add_language(L, TRUE)

	wires = new(src)

	ident = rand(1, 999)
	updatename("Default")

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
		cell = conf_cell_create_type

	. = ..()

	if(cell)
		var/datum/robot_component/cell_component = components["power cell"]
		cell_component.wrapped = cell
		cell_component.installed = 1

	add_robot_verbs()

	AddComponent(/datum/component/riding_filter/mob/robot)

	update_icon()

/mob/living/silicon/robot/proc/init()
	aiCamera = new /obj/item/camera/siliconcam/robot_camera(src)

	if(istype(conf_default_lawset_type, /datum/ai_lawset))
		var/datum/ai_lawset/conf_default_lawset_instance = conf_default_lawset_type
		laws = conf_default_lawset_instance.clone()
	else if(ispath(conf_default_lawset_type, /datum/ai_lawset))
		laws = new conf_default_lawset_type
	else if(IS_ANONYMOUS_TYPEPATH(conf_default_lawset_type))
		laws = new conf_default_lawset_type
	else
		laws = new /datum/ai_lawset
	if(conf_auto_ai_link)
		var/new_ai = select_active_ai_with_fewest_borgs()
		if(new_ai)
			lawupdate = 1
			connect_to_ai(new_ai)
		else
			lawupdate = 0

	additional_law_channels["Binary"] = "#b"

	if(conf_mmi_create_type && !mmi)
		mmi = new /obj/item/mmi/digital/robot(src)

	playsound(src, conf_reboot_sound, 75, TRUE)

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
	wipe_for_gc()
	if(mmi && mind)//Safety for when a cyborg gets dust()ed. Or there is no MMI inside.
		var/turf/T = get_turf(loc)//To hopefully prevent run time errors.
		if(T)	mmi.loc = T
		if(mmi.brainmob)
			var/obj/item/robot_module_legacy/M = locate() in contents
			if(M)
				mmi.brainmob.languages = M.original_languages
			else
				mmi.brainmob.languages = languages
			mmi.brainmob.remove_language("Robot Talk")
			mind.transfer(mmi.brainmob)
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

	// todo: more customization for light colors / lights / whatever
	if (lights_on)
		radio.set_light(integrated_light_power, 2, l_color = module?.light_color || "#FFFFFF", angle = LIGHT_WIDE)
	else
		radio.set_light(0)

/mob/living/silicon/robot/verb/self_diagnosis_verb()
	set category = "Robot Commands"
	set name = "Self Diagnosis"

	if(!is_component_functioning("diagnosis unit"))
		to_chat(src, "<font color='red'>Your self-diagnosis component isn't functioning.</font>")

	var/datum/robot_component/CO = get_component("diagnosis unit")
	if (!legacy_cell_use_power(CO.active_usage))
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

/mob/living/silicon/robot/verb/toggle_cover()
	set category = "Robot Commands"
	set name = "Toggle Cover"
	locked = !locked
	to_chat(src, "You [ locked ? "lock" : "unlock"] your interface.")

// this function returns the robots jetpack, if one is installed
/mob/living/silicon/robot/proc/installed_jetpack()
	return locate(/obj/item/tank/jetpack) in inventory.robot_modules

// update the status screen display
/mob/living/silicon/robot/statpanel_data(client/C)
	. = ..()
	if(C.statpanel_tab("Status"))
		INJECT_STATPANEL_DATA_LINE(., "")
		if(cell)
			INJECT_STATPANEL_DATA_LINE(., "Charge Left: [round(cell.percent())]%")
			INJECT_STATPANEL_DATA_LINE(., "Cell Rating: [round(cell.maxcharge)]") // Round just in case we somehow get crazy values
			INJECT_STATPANEL_DATA_LINE(., "Power Cell Load: [round(used_power_this_tick)]W")
		else
			INJECT_STATPANEL_DATA_LINE(., "No Cell Inserted!")
		INJECT_STATPANEL_DATA_LINE(., "Lights: [lights_on ? "ON" : "OFF"]")
		INJECT_STATPANEL_DATA_LINE(., "")
		// if you have a jetpack, show the internal tank pressure
		var/obj/item/tank/jetpack/current_jetpack = installed_jetpack()
		if (current_jetpack)
			INJECT_STATPANEL_DATA_ENTRY(., "Internal Atmosphere Info", current_jetpack.name)
			INJECT_STATPANEL_DATA_ENTRY(., "Tank Pressure", current_jetpack.air_contents.return_pressure())
		// todo: robot panel; this shouldn't be in statpanel, it's not critical data
		if(resources)
			for(var/key in resources.provisioned_stack_store)
				var/datum/robot_resource/resource = resources.provisioned_stack_store
				INJECT_STATPANEL_DATA_LINE(., "[resource.name]: [resource.amount]/[resource.amount_max]")
			for(var/key in resources.provisioned_material_store)
				var/datum/robot_resource/resource = resources.provisioned_material_store
				INJECT_STATPANEL_DATA_LINE(., "[resource.name]: [resource.amount]/[resource.amount_max]")
			for(var/key in resources.provisioned_reagent_store)
				var/datum/robot_resource/resource = resources.provisioned_reagent_store
				INJECT_STATPANEL_DATA_LINE(., "[resource.name]: [resource.amount]/[resource.amount_max]")
			for(var/key in resources.provisioned_resource_store)
				var/datum/robot_resource/resource = resources.provisioned_resource_store
				INJECT_STATPANEL_DATA_LINE(., "[resource.name]: [resource.amount]/[resource.amount_max]")

/mob/living/silicon/robot/restrained()
	return 0

/mob/living/silicon/robot/on_bullet_act(obj/projectile/proj, impact_flags, list/bullet_act_args)
	. = ..()
	if(. & PROJECTILE_IMPACT_FLAGS_UNCONDITIONAL_ABORT)
		return
	// todo: why is this in bullet act and not where we take damage maybe?
	if(prob(75) && proj.damage_force > 0)
		spark_system.start()

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
			user.setClickCooldownLegacy(user.get_attack_speed_legacy(WT))
			adjustBruteLoss(-30)
			update_health()
			add_fingerprint(user)
			for(var/mob/O in viewers(user, null))
				O.show_message(SPAN_RED("[user] has fixed some of the dents on [src]!"), SAYCODE_TYPE_VISIBLE)
		else
			to_chat(user, "Need more welding fuel!")
			return

	else if(istype(W, /obj/item/stack/cable_coil) && (wiresexposed || istype(src,/mob/living/silicon/robot/drone)))
		if (!getFireLoss())
			to_chat(user, "Nothing to fix here!")
			return
		var/obj/item/stack/cable_coil/coil = W
		if (coil.use(1))
			user.setClickCooldownLegacy(user.get_attack_speed_legacy(W))
			adjustFireLoss(-30)
			update_health()
			for(var/mob/O in viewers(user, null))
				O.show_message(SPAN_RED("[user] has fixed some of the burnt wires on [src]!"), SAYCODE_TYPE_VISIBLE)

	else if (W.is_crowbar() && user.a_intent != INTENT_HARM)	// crowbar means open or close the cover
		if(opened)
			if(cell)
				to_chat(user, "You close the cover.")
				opened = 0
				update_icon()
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
				update_icon()

	else if (istype(W, /obj/item/cell) && opened)	// trying to put a cell inside
		var/datum/robot_component/C = components["power cell"]
		if(wiresexposed)
			to_chat(user, "Close the panel first.")
		else if(cell)
			to_chat(user, "There is a power cell already installed.")
		else if(W.w_class != WEIGHT_CLASS_NORMAL)
			to_chat(user, "\The [W] is too [W.w_class < WEIGHT_CLASS_NORMAL ? "small" : "large"] to fit here.")
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
		update_icon()

	else if(W.is_screwdriver() && opened && cell)	// radio
		if(radio)
			radio.attackby(W,user)//Push it to the radio to let it handle everything
		else
			to_chat(user, "Unable to locate a radio.")

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
			else
				to_chat(user, "<font color='red'>Access denied.</font>")

	else
		if( !(istype(W, /obj/item/robotanalyzer) || istype(W, /obj/item/healthanalyzer)) )
			if(W.damage_force > 0)
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
			if(do_after(src, 1.5 MINUTES, src, mobility_flags = MOBILITY_CAN_RESIST))
				visible_message( \
					SPAN_DANGER("[src] manages to break \the [bolt]!"), \
					SPAN_WARNING("You successfully break your [bolt]."))
				bolt.malfunction = MALFUNCTION_PERMANENT

/mob/living/silicon/robot/proc/module_reset()
	notify_ai(ROBOT_NOTIFICATION_MODULE_RESET, module.get_display_name())
	updatename("Default")

/mob/living/silicon/robot/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
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
			update_icon()
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

/mob/living/silicon/robot/Topic(href, href_list)
	if(..())
		return 1

	//All Topic Calls that are only for the Cyborg go here
	if(usr != src)
		return 1

	if (href_list["showalerts"])
		subsystem_alarm_monitor()
		return 1

	if(href_list["character_profile"])
		if(!profile)
			profile = new(src)
		profile.ui_interact(usr)

	return

/mob/living/silicon/robot/proc/radio_menu()
	radio.interact(src)//Just use the radio's Topic() instead of bullshit special-snowflake code

/mob/living/silicon/robot/Moved()
	. = ..()
	if(legacy_floor_scrubbing)
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

	for(var/obj/item/storage/bag/ore/ore_bag in inventory.get_held_items())
		if(ore_bag)
			if(isturf(loc))
				var/turf/tile = loc
				ore_bag.obj_storage?.interacted_mass_pickup(new /datum/event_args/actor(src), tile)
			break

/mob/living/silicon/robot/proc/self_destruct()
	gib()

/mob/living/silicon/robot/proc/UnlinkSelf()
	disconnect_from_ai()
	lawupdate = 0
	lockcharge = 0
	lockdown = 0
	scrambledcodes = 1
	update_stat(update_mobility = FALSE)
	update_mobility()
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
	update_mobility()

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
/mob/living/silicon/robot/proc/legacy_cell_use_power(var/amount = 0)
	if(!amount)
		return TRUE
	. = draw_checked_power(amount)
	used_power_this_tick += .
	return . ? TRUE : FALSE

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
			laws = new /datum/ai_lawset/syndicate
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
		else
			to_chat(user, "You fail to hack [src]'s interface.")
			to_chat(src, "Hack attempt detected.")
		return 1
	return

/mob/living/silicon/robot/is_sentient()
	return braintype != BORG_BRAINTYPE_DRONE

/mob/living/silicon/robot/get_cell(inducer)
	return cell

/mob/living/silicon/robot/verb/robot_nom(var/mob/living/T in living_mobs(1))
	set name = "Robot Nom"
	set category = VERB_CATEGORY_IC
	set desc = "Allows you to eat someone."

	if (stat != CONSCIOUS)
		return
	return feed_grabbed_to_self(src,T)

/mob/living/silicon/robot/canUseTopic(atom/movable/M, be_close=FALSE, no_dexterity=FALSE, no_tk=FALSE)
	if(lockcharge)
		to_chat(src, SPAN_WARNING("You can't do that right now!"))
		return FALSE
	return ..()
