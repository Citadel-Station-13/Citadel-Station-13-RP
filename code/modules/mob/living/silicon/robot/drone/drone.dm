/mob/living/silicon/robot/drone
	name = "maintenance drone"
	real_name = "drone"
	icon = 'icons/mob/robots.dmi'
	icon_state = "repairbot"
	maxHealth = 35
	health = 35
	cell_emp_mult = 1
	universal_speak = 0
	universal_understand = 1
	gender = NEUTER
	pass_flags = ATOM_PASS_TABLE
	braintype = "Drone"
	lawupdate = 0
	density = 1
	req_access = list(access_engine, access_robotics)
	integrated_light_power = 3
	local_transmit = 1

	can_pull_size = ITEMSIZE_NO_CONTAINER
	can_pull_mobs = MOB_PULL_SMALLER
	can_enter_vent_with = list(
		/obj)

	mob_bump_flag = SIMPLE_ANIMAL
	mob_swap_flags = SIMPLE_ANIMAL
	mob_push_flags = SIMPLE_ANIMAL
	mob_always_swap = 1

	mob_size = MOB_SMALL // pulled here from a _vr file

	//Used for self-mailing.
	var/mail_destination = ""
	var/obj/machinery/drone_fabricator/master_fabricator
	var/law_type = /datum/ai_laws/drone
	var/module_type = /obj/item/robot_module/drone
	var/obj/item/hat
	var/hat_x_offset = 0
	var/hat_y_offset = -13
	var/serial_number = 0
	var/name_override = 0
	var/datum/drone_matrix/master_matrix
	var/upgrade_cooldown = 0
	var/list/matrix_upgrades

	var/foreign_droid = FALSE

	holder_type = /obj/item/holder/drone

	can_be_antagged = FALSE

/mob/living/silicon/robot/drone/Destroy()
	if(hat)
		hat.loc = get_turf(src)
	..()

/mob/living/silicon/robot/drone/ghost()
	. = ..()
	if (!ckey)
		death()

/mob/living/silicon/robot/drone/is_sentient()
	return FALSE

/mob/living/silicon/robot/drone/construction
	name = "construction drone"
	icon_state = "constructiondrone"
	law_type = /datum/ai_laws/construction_drone
	module_type = /obj/item/robot_module/drone/construction
	hat_x_offset = 1
	hat_y_offset = -12
	can_pull_mobs = MOB_PULL_SAME
	//holder_type = /obj/item/holder/drone/heavy
/mob/living/silicon/robot/drone/construction/matriarch
	name = "matriarch drone"
	module_type = /obj/item/robot_module/drone/construction/matriarch
	law_type = /datum/ai_laws/matriarch_drone
	maxHealth = 50
	health = 50
	integrated_light_power = 4
	name_override = 1
	var/matrix_tag
/mob/living/silicon/robot/drone/mining
	icon_state = "miningdrone"
	item_state = "constructiondrone"
	law_type = /datum/ai_laws/mining_drone
	module_type = /obj/item/robot_module/drone/mining
	hat_x_offset = 1
	hat_y_offset = -12
	can_pull_mobs = MOB_PULL_SAME

/mob/living/silicon/robot/drone/Initialize(mapload)
	. = ..()
	add_verb(src, /mob/living/proc/ventcrawl)
	add_verb(src, /mob/living/proc/hide)
	remove_language("Robot Talk")
	add_language("Robot Talk", 0)
	add_language("Drone Talk", 1)
	serial_number = rand(0,999)

	//They are unable to be upgraded, so let's give them a bit of a better battery.
	cell.maxcharge = 10000
	cell.charge = 10000

	// NO BRAIN.
	mmi = null

	//We need to screw with their HP a bit. They have around one fifth as much HP as a full borg.
	for(var/V in components) if(V != "power cell")
		var/datum/robot_component/C = components[V]
		C.max_damage = 10

	remove_verb(src, /mob/living/silicon/robot/verb/Namepick)
	updateicon()
	updatename()

/mob/living/silicon/robot/drone/init()
	if(!scrambledcodes && !foreign_droid)
		aiCamera = new/obj/item/camera/siliconcam/drone_camera(src)
	additional_law_channels["Drone"] = ":d"
	if(!laws) laws = new law_type
	if(!module) module = new module_type(src)

	flavor_text = "It's a tiny little repair drone. The casing is stamped with an corporate logo and the subscript: '[GLOB.using_map.company_name] Recursive Repair Systems: Fixing Tomorrow's Problem, Today!'"
	playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 0)

//Redefining some robot procs...

/mob/living/silicon/robot/drone/construction/matriarch/Namepick()
	set category = "Robot Commands"
	if(custom_name)
		return 0

	spawn(0)
		var/drone_name = sanitizeSafe(input(src, "Select a first-name suffix for your maintenance drone, for example, 'Bishop' would appear as 'matriach maintenance drone (Bishop)'. (Max length: 16 Characters)", "Name Suffix Selection"), 16)
		if(!drone_name)
			drone_name = pick("Ripley", "Tano", "Data")
		real_name = "[initial(name)] ([drone_name])"
		name = real_name

/mob/living/silicon/robot/drone/SetName(pickedName as text)
	// Would prefer to call the grandparent proc but this isn't possible, so..
	real_name = pickedName
	name = real_name

/mob/living/silicon/robot/drone/updatename()
	if(name_override)
		return

	real_name = "[initial(name)] ([serial_number])"
	name = real_name

/mob/living/silicon/robot/drone/updateicon()

	cut_overlays()
	var/list/overlays_to_add = list()
	if(stat == 0)
		overlays_to_add += "eyes-[icon_state]"
	else
		overlays_to_add -= "eyes"
	if(hat) // Let the drones wear hats.
		var/mutable_appearance/MA = hat.render_mob_appearance(src, SLOT_ID_HEAD, BODYTYPE_DEFAULT)
		MA.pixel_x = hat_x_offset
		MA.pixel_y = hat_y_offset
		overlays_to_add += MA

	add_overlay(overlays_to_add)

/mob/living/silicon/robot/drone/choose_icon()
	return

/mob/living/silicon/robot/drone/pick_module()
	return

/mob/living/silicon/robot/drone/proc/wear_hat(var/obj/item/new_hat)
	if(hat)
		return
	hat = new_hat
	new_hat.loc = src
	updateicon()

//Drones cannot be upgraded with borg modules so we need to catch some items before they get used in ..().
/mob/living/silicon/robot/drone/attackby(var/obj/item/W, var/mob/user)

	if(user.a_intent == "help" && istype(W, /obj/item/clothing/head))
		if(hat)
			to_chat(user, "<span class='warning'>\The [src] is already wearing \the [hat].</span>")
			return
		if(!user.attempt_insert_item_for_installation(W, src))
			return
		wear_hat(W)
		user.visible_message("<span class='notice'>\The [user] puts \the [W] on \the [src].</span>")
		return
	else if(istype(W, /obj/item/borg/upgrade/))
		to_chat(user, "<span class='danger'>\The [src] is not compatible with \the [W].</span>")
		return

	else if (W.is_crowbar())
		to_chat(user, "<span class='danger'>\The [src] is hermetically sealed. You can't open the case.</span>")
		return

	else if (istype(W, /obj/item/card/id)||istype(W, /obj/item/pda))
		var/datum/gender/TU = GLOB.gender_datums[user.get_visible_gender()]
		if(stat == 2)

			if(!config_legacy.allow_drone_spawn || emagged || health < -35) //It's dead, Dave.
				to_chat(user, "<span class='danger'>The interface is fried, and a distressing burned smell wafts from the robot's interior. You're not rebooting this one.</span>")
				return

			if(!allowed(usr))
				to_chat(user, "<span class='danger'>Access denied.</span>")
				return

			user.visible_message("<span class='danger'>\The [user] swipes [TU.his] ID card through \the [src], attempting to reboot it.</span>", "<span class='danger'>>You swipe your ID card through \the [src], attempting to reboot it.</span>")
			var/drones = 0
			for(var/mob/living/silicon/robot/drone/D in GLOB.player_list)
				drones++
			if(drones < config_legacy.max_maint_drones)
				request_player()
			return

		else
			user.visible_message("<span class='danger'>\The [user] swipes [TU.his] ID card through \the [src], attempting to shut it down.</span>", "<span class='danger'>You swipe your ID card through \the [src], attempting to shut it down.</span>")

			if(emagged)
				return

			if(allowed(usr))
				shut_down()
			else
				to_chat(user, "<span class='danger'>Access denied.</span>")

		return

	..()

/mob/living/silicon/robot/drone/emag_act(var/remaining_charges, var/mob/user)
	if(!client || stat == 2)
		to_chat(user, "<span class='danger'>There's not much point subverting this heap of junk.</span>")
		return

	if(emagged)
		to_chat(src, "<span class='danger'>\The [user] attempts to load subversive software into you, but your hacked subroutines ignore the attempt.</span>")
		to_chat(user, "<span class='danger'>You attempt to subvert [src], but the sequencer has no effect.</span>")
		return

	to_chat(user, "<span class='danger'>You swipe the sequencer across [src]'s interface and watch its eyes flicker.</span>")

	to_chat(src, "<span class='danger'>You feel a sudden burst of malware loaded into your execute-as-root buffer. Your tiny brain methodically parses, loads and executes the script.</span>")

	log_game("[key_name(user)] emagged drone [key_name(src)]. Laws overridden.")
	var/time = time2text(world.realtime,"hh:mm:ss")
	lawchanges.Add("[time] <B>:</B> [user.name]([user.key]) emagged [name]([key])")

	emagged = 1
	lawupdate = 0
	connected_ai = null
	clear_supplied_laws()
	clear_inherent_laws()
	laws = new /datum/ai_laws/syndicate_override
	var/datum/gender/TU = GLOB.gender_datums[user.get_visible_gender()]
	set_zeroth_law("Only [user.real_name] and people [TU.he] designate[TU.s] as being such are operatives.")

	to_chat(src, "<b>Obey these laws:</b>")
	laws.show_laws(src)
	to_chat(src, "<span class='danger'>ALERT: [user.real_name] is your new master. Obey your new laws and \his commands.</span>")
	return 1

//DRONE LIFE/DEATH

//For some goddamn reason robots have this hardcoded. Redefining it for our fragile friends here.
/mob/living/silicon/robot/drone/updatehealth()
	if(status_flags & GODMODE)
		health = maxHealth
		set_stat(CONSCIOUS)
		return
	health = maxHealth - (getBruteLoss() + getFireLoss())
	return

//Easiest to check this here, then check again in the robot proc.
//Standard robots use config for crit, which is somewhat excessive for these guys.
//Drones killed by damage will gib.
/mob/living/silicon/robot/drone/handle_regular_UI_updates()
	var/turf/T = get_turf(src)
	if(!T || health <= -35 )
		timeofdeath = world.time
		death() //Possibly redundant, having trouble making death() cooperate.
		gib()
		return
	..()

//DRONE MOVEMENT.
/mob/living/silicon/robot/drone/Process_Spaceslipping(var/prob_slip)
	return 0

//CONSOLE PROCS
/mob/living/silicon/robot/drone/proc/law_resync()
	if(stat != DEAD)
		if(emagged)
			to_chat(src, "<span class='danger'>You feel something attempting to modify your programming, but your hacked subroutines are unaffected.</span>")
		else
			to_chat(src, "<span class='danger'>A reset-to-factory directive packet filters through your data connection, and you obediently modify your programming to suit it.</span>")
			full_law_reset()
			show_laws()

/mob/living/silicon/robot/drone/proc/shut_down()
	if(stat != DEAD)
		if(emagged)
			to_chat(src, "<span class='danger'>You feel a system kill order percolate through your tiny brain, but it doesn't seem like a good idea to you.</span>")
		else
			to_chat(src, "<span class='danger'>You feel a system kill order percolate through your tiny brain, and you obediently destroy yourself.</span>")
			death()

/mob/living/silicon/robot/drone/proc/full_law_reset()
	clear_supplied_laws(1)
	clear_inherent_laws(1)
	clear_ion_laws(1)
	laws = new law_type

//Reboot procs.

/mob/living/silicon/robot/drone/proc/request_player()
	for(var/mob/observer/dead/O in GLOB.player_list)
		if(jobban_isbanned(O, "Cyborg"))
			continue
		if(O.client)
			if(O.client.prefs.be_special & BE_PAI)
				question(O.client)

/mob/living/silicon/robot/drone/proc/question(var/client/C)
	spawn(0)
		if(!C || jobban_isbanned(C,"Cyborg"))	return
		var/response = alert(C, "Someone is attempting to reboot a maintenance drone. Would you like to play as one?", "Maintenance drone reboot", "Yes", "No", "Never for this round")
		if(!C || ckey)
			return
		if(response == "Yes")
			transfer_personality(C)
		else if (response == "Never for this round")
			C.prefs.be_special ^= BE_PAI

/mob/living/silicon/robot/drone/proc/transfer_personality(var/client/player)

	if(!player) return

	src.ckey = player.ckey

	if(player.mob && player.mob.mind)
		player.mob.mind.transfer_to(src)

	lawupdate = 0
	to_chat(src, "<b>Systems rebooted</b>. Loading base pattern maintenance protocol... <b>loaded</b>.")
	full_law_reset()
	welcome_drone()

/mob/living/silicon/robot/drone/proc/welcome_drone()
	to_chat(src, "<b>You are a maintenance drone, a tiny-brained robotic repair machine</b>.")
	to_chat(src, "You have no individual will, no personality, and no drives or urges other than your laws.")
	to_chat(src, "Remember,  you are <b>lawed against interference with the crew</b>. Also remember, <b>you DO NOT take orders from the AI.</b>")
	to_chat(src, "Use <b>say ;Hello</b> to talk to other drones and <b>say Hello</b> to speak silently to your nearby fellows.")

/mob/living/silicon/robot/drone/add_robot_verbs()
	add_verb(src, silicon_subsystems)

/mob/living/silicon/robot/drone/remove_robot_verbs()
	remove_verb(src, silicon_subsystems)

/mob/living/silicon/robot/drone/construction/welcome_drone()
	to_chat(src, "<b>You are a construction drone, an autonomous engineering and fabrication system.</b>.")
	to_chat(src, "You are assigned to a Sol Central construction project. The name is irrelevant. Your task is to complete construction and subsystem integration as soon as possible.")
	to_chat(src, "Use <b>:d</b> to talk to other drones and <b>say</b> to speak silently to your nearby fellows.")
	to_chat(src, "<b>You do not follow orders from anyone; not the AI, not humans, and not other synthetics.</b>.")

/mob/living/silicon/robot/drone/construction/init()
	..()
	flavor_text = "It's a bulky construction drone stamped with a Sol Central glyph."

/mob/living/silicon/robot/drone/mining/init()
	..()
	flavor_text = "It's a bulky mining drone stamped with a Grayson logo."

/mob/living/silicon/robot/drone/construction/matriarch/init()
	..()
	add_verb(src, /mob/living/silicon/robot/verb/Namepick)
	flavor_text = "It's a small matriarch drone. The casing is stamped with an corporate logo and the subscript: '[GLOB.using_map.company_name] Recursive Repair Systems: Heart Of The Swarm!'"

/mob/living/silicon/robot/drone/construction/matriarch/welcome_drone()
	to_chat(src, "<b>You are a matriarch maintenance drone, a tiny-brained robotic repair machine</b>.")
	to_chat(src, "You have no individual will, no personality, and no drives or urges other than your laws.")
	to_chat(src, "Remember,  you are <b>lawed against interference with the crew</b>. Also remember, <b>you DO NOT take orders from the AI.</b>")
	to_chat(src, "Use <b>say ;Hello</b> to talk to other drones and <b>say Hello</b> to speak silently to your nearby fellows.")

/mob/living/silicon/robot/drone/construction/matriarch/Initialize()
	. = ..()
	matrix_tag = "[GLOB.using_map.company_name]"

/mob/living/silicon/robot/drone/construction/matriarch/shut_down()
	return

/mob/living/silicon/robot/drone/construction/matriarch/transfer_personality(client/player)
	. = ..()
	assign_drone_to_matrix(src, matrix_tag)
	master_matrix.message_drones(SPAN_NOTICE("Energy surges through your circuits. The matriarch has come online."))

/mob/living/silicon/robot/drone/construction/matriarch/ghostize(can_reenter_corpse, should_set_timer)
	. = ..()
	if(can_reenter_corpse || stat == DEAD)
		return
	if(src in living_mob_list) // needs to exist to reopen spawn atom
		if(master_matrix)
			master_matrix.remove_drone(WEAKREF(src))
			master_matrix.message_drones(SPAN_NOTICE("Your circuits dull. The matriarch has gone offline."))
			master_matrix = null
		updatename(initial(name))
		request_player()
