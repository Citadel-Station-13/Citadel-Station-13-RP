/datum/category_item/catalogue/technology/turret
	name = "Turrets"
	desc = "This imtimidating machine is essentially an automated gun. It is able to \
	scan its immediate environment, and if it determines that a threat is nearby, it will \
	open up, aim the barrel of the weapon at the threat, and engage it until the threat \
	goes away, it dies (if using a lethal gun), or the turret is destroyed. This has made them \
	well suited for long term defense for a static position, as electricity costs much \
	less than hiring a person to stand around. Despite this, the lack of a sapient entity's \
	judgement has sometimes lead to tragedy when turrets are poorly configured.\
	<br><br>\
	Early models generally had simple designs, and would shoot at anything that moved, with only \
	the option to disable it remotely for maintenance or to let someone pass. More modern iterations \
	of turrets have instead replaced those simple systems with intricate optical sensors and \
	image recognition software that allow the turret to distinguish between several kinds of \
	entities, and to only engage whatever their owners configured them to fight against.\
	Some models also have the ability to switch between a lethal and non-lethal mode.\
	<br><br>\
	Today's cutting edge in static defense development has shifted away from improving the \
	software of the turret, and instead towards the hardware. The newest solutions for \
	automated protection includes new hardware capabilities such as thicker armor, more \
	advanced integrated weapons, and some may even have been built with EM hardening in \
	mind."
	value = CATALOGUER_REWARD_MEDIUM

// todo: /obj/machinery/turret
// todo: spatial grid listeners
/obj/machinery/porta_turret
	name = "turret"
	catalogue_data = list(/datum/category_item/catalogue/technology/turret)
	icon = 'icons/obj/turrets.dmi'
	icon_state = "turret_cover_normal"
	anchored = TRUE

	density = FALSE
	/// This turret uses and requires power.
	use_power = TRUE
	/// When inactive, this turret takes up constant 50 Equipment power.
	idle_power_usage = 50
	/// When active, this turret takes up constant 300 Equipment power.
	active_power_usage = 300
	/// Drains power from the EQUIPMENT channel.
	power_channel = EQUIP
	req_one_access = list(ACCESS_SECURITY_EQUIPMENT, ACCESS_COMMAND_BRIDGE)

	integrity = 200
	integrity_max = 200

	//* Firing Configuration *//
	/// delay between shots in deciseconds
	///
	/// * decimal values are valid
	/// * if we are firing a burst, this is from the end of the burst.
	var/fire_delay = 1.5 SECONDS
	/// burst amount
	var/fire_burst = 1
	/// burst delay
	var/fire_burst_spacing = 1.5
	/// allow shooting non-center-mass
	///
	/// * This makes the turret into a toxic PvPer.
	/// * This is a dangerous flag to set.
	var/fire_curve_shots = FALSE
	/// Do we suppressive fire?
	///
	/// * This means we fire off center mass as long as they're vaguely in view.
	/// * if [fire_curve_shots] is on, this means we aim center at a pixel that should hit them.
	var/fire_suppressive = FALSE
	/// Suppressive fire dispersion deviation
	var/fire_suppressive_dispersion_deviation = 5

	//* Turret Configuration *//
	/// our range
	var/engagement_range = 7
	/// our maximum engagement range (for already engaged targets)
	var/disengagement_range = 12

	//* Projectile Configuration *//
	/// projectile type to fire. overrides every other projectile_use_* when set
	//  todo: mode support
	var/projectile_use_type

	//* State *//
	/// last time we fired
	var/last_fire
	/// next time we can fire
	var/next_fire

	//* Legacy below. *//

	/// If the turret cover is "open" and the turret is raised.
	var/raised = FALSE
	/// If the turret is currently opening or closing its cover.
	var/raising= FALSE
	/// If the turret slowly repairs itself.
	var/auto_repair = FALSE
	/// If the turret's behaviour control access is locked.
	var/locked = TRUE
	/// If the turret responds to control panels.
	var/controllock = FALSE

	/// The type of weapon installed.
	var/installation = /obj/item/gun/projectile/energy/gun
	/// The charge of the gun inserted.
	var/gun_charge = 0
	/// Holder for bullettype.
	var/projectile = null
	/// Holder for the shot when emagged.
	var/lethal_projectile = null
	/// Holder for power needed.
	// todo: rework this
	var/reqpower = 750
	var/turret_type = "normal"
	var/icon_color = "blue"
	var/lethal_icon_color = "blue"

	/// Checks if the perp is set to arrest.
	var/check_arrest = TRUE
	/// Checks if a security record exists at all.
	var/check_records = TRUE
	/// Checks if it can shoot people that have a weapon they aren't authorized to have.
	var/check_weapons = FALSE
	/// If this is active, the turret shoots everything that does not meet the access requirements.
	var/check_access = TRUE
	/// Checks if it can shoot at unidentified lifeforms. (ie xenos)
	var/check_anomalies = TRUE
	/// If active, will shoot at anything not an AI or cyborg.
	var/check_synth	 = FALSE
	/// If active, will fire on anything, including synthetics.
	var/check_all = FALSE
	/// If active, AI cannot use this.
	var/ailock = FALSE
	/// If active, will shoot to kill when lethals are also on.
	var/check_down = FALSE
	/// If set, will not fire at people in the same faction for any reason.
	var/faction = null

	/// If set to TRUE, the turret gets pissed off and shoots at people nearby. (unless they have sec access!)
	var/attacked = FALSE

	/// Determines if the turret is on.
	var/enabled = TRUE
	/// Whether in lethal or stun mode.
	var/lethal = FALSE
	/// Determines if the turret is disabled.
	var/disabled = FALSE

	/// What sound should play when the turret fires.
	var/shot_sound
	/// What sound should play when the emagged turret fires.
	var/lethal_shot_sound

	/// The spark system, used for generating... sparks?
	var/datum/effect_system/spark_spread/spark_system

	var/wrenching = FALSE

	/// Last target fired at, prevents turrets from erratically firing at all valid targets in range.
	var/last_target
	/// When a turret pops up, then finds nothing to shoot at, this number decrements until 0, when it pops down.
	var/timeout = 10
	/// If false, salvaging doesn't give you anything.
	var/can_salvage = TRUE

/obj/machinery/porta_turret/Initialize(mapload)
	// create AI holder
	ai_holder = new /datum/ai_holder/turret(src)

	//Sets up a spark system
	spark_system = new /datum/effect_system/spark_spread
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

	setup()

	// If turrets ever switch overlays, this will need to be cached and reapplied each time overlays_cut() is called.
	var/image/turret_opened_overlay = image(icon, "open_[turret_type]")
	turret_opened_overlay.layer = layer-0.1
	add_overlay(turret_opened_overlay)
	return ..()

/obj/machinery/porta_turret/Destroy()
	qdel(spark_system)
	spark_system = null
	return ..()

/obj/machinery/porta_turret/can_catalogue(mob/user) // Dead turrets can't be scanned.
	if(machine_stat & BROKEN)
		to_chat(user, SPAN_WARNING("\The [src] was destroyed, so it cannot be scanned."))
		return FALSE
	return ..()

/obj/machinery/porta_turret/update_icon()
	. = ..()
	if(machine_stat & BROKEN) // Turret is dead.
		icon_state = "destroyed_target_prism_[turret_type]"

	else if(raised || raising)
		// Turret is open.
		if(powered() && enabled)
			// Trying to shoot someone.
			if(lethal)
				icon_state = "[lethal_icon_color]_target_prism_[turret_type]"
			else
				icon_state = "[icon_color]_target_prism_[turret_type]"

		else
			// Disabled.
			icon_state = "grey_target_prism_[turret_type]"

	else
		// Its closed.
		icon_state = "turret_cover_[turret_type]"


/obj/machinery/porta_turret/proc/setup()
	// TEMPORARY: shitty autodetection code, turrets should just fire with the actual gun
	//            by proccing async_firing_cycle at some point but for now this is how it is
	var/const/default_path = /obj/item/gun/projectile/energy/laser
	var/const/default_projectile = /obj/projectile/beam/midlaser

	var/obj/item/gun/projectile/energy/autodetect = installation || default_path
	if(ispath(autodetect))
		autodetect = new autodetect
	var/datum/firemode/energy/autodetect_firemode = autodetect.firemode
	var/obj/projectile/P = autodetect_firemode?.projectile_type || default_projectile

	projectile = P
	lethal_projectile = projectile
	shot_sound = initial(P.fire_sound)
	lethal_shot_sound = shot_sound

	if(istype(P, /obj/projectile/energy))
		icon_color = "orange"

	else if(istype(P, /obj/projectile/beam/stun))
		icon_color = "blue"

	else if(istype(P, /obj/projectile/beam/lasertag))
		icon_color = "blue"

	else if(istype(P, /obj/projectile/beam))
		icon_color = "red"

	else
		icon_color = "blue"

	lethal_icon_color = icon_color

	weapon_setup(installation)

/obj/machinery/porta_turret/proc/weapon_setup(guntype)
	switch(guntype)
		if(/obj/item/gun/projectile/energy/gun/burst)
			lethal_icon_color = "red"
			lethal_projectile = /obj/projectile/beam/burstlaser
			lethal_shot_sound = 'sound/weapons/Laser.ogg'
			fire_burst = 3
			fire_burst_spacing = 1.5

		if(/obj/item/gun/projectile/energy/phasegun)
			icon_color = "orange"
			lethal_icon_color = "orange"
			lethal_projectile = /obj/projectile/energy/phase/heavy
			fire_delay = 1 SECOND

		if(/obj/item/gun/projectile/energy/gun)
			lethal_icon_color = "red"
			lethal_projectile = /obj/projectile/beam	//If it has, going to kill mode
			lethal_shot_sound = 'sound/weapons/Laser.ogg'

		if(/obj/item/gun/projectile/energy/gun/nuclear)
			lethal_icon_color = "red"
			lethal_projectile = /obj/projectile/beam	//If it has, going to kill mode
			lethal_shot_sound = 'sound/weapons/Laser.ogg'

		if(/obj/item/gun/projectile/energy/xray)
			lethal_icon_color = "green"
			lethal_projectile = /obj/projectile/beam/xray
			projectile = /obj/projectile/beam/stun // Otherwise we fire xrays on both modes.
			lethal_shot_sound = 'sound/weapons/eluger.ogg'
			shot_sound = 'sound/weapons/Taser.ogg'

/obj/machinery/porta_turret/proc/isLocked(mob/user)
	if(ailock && issilicon(user))
		to_chat(user, SPAN_NOTICE("There seems to be a firewall preventing you from accessing this device."))
		return TRUE

	if(locked && !issilicon(user))
		to_chat(user, SPAN_NOTICE("Controls locked."))
		return TRUE
	return FALSE

/obj/machinery/porta_turret/attack_ai(mob/user)
	if(isLocked(user))
		return

	nano_ui_interact(user)

/obj/machinery/porta_turret/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	if(isLocked(user))
		return

	nano_ui_interact(user)

/obj/machinery/porta_turret/nano_ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = TRUE)
	var/data[0]
	data["access"] = !isLocked(user)
	data["locked"] = locked
	data["enabled"] = enabled
	data["is_lethal"] = 1
	data["lethal"] = lethal

	if(data["access"])
		var/settings[0]
		settings[++settings.len] = list("category" = "Neutralize All Non-Synthetics", "setting" = "check_synth", "value" = check_synth)
		settings[++settings.len] = list("category" = "Check Weapon Authorization", "setting" = "check_weapons", "value" = check_weapons)
		settings[++settings.len] = list("category" = "Check Security Records", "setting" = "check_records", "value" = check_records)
		settings[++settings.len] = list("category" = "Check Arrest Status", "setting" = "check_arrest", "value" = check_arrest)
		settings[++settings.len] = list("category" = "Check Access Authorization", "setting" = "check_access", "value" = check_access)
		settings[++settings.len] = list("category" = "Check misc. Lifeforms", "setting" = "check_anomalies", "value" = check_anomalies)
		settings[++settings.len] = list("category" = "Neutralize All Entities", "setting" = "check_all", "value" = check_all)
		settings[++settings.len] = list("category" = "Neutralize Downed Entities", "setting" = "check_down", "value" = check_down)
		data["settings"] = settings

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "turret_control.tmpl", "Turret Controls", 500, 300)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/porta_turret/proc/HasController()
	var/area/A = get_area(src)
	return A && A.turret_controls.len > 0

/obj/machinery/porta_turret/CanUseTopic(mob/user)
	if(HasController())
		to_chat(user, SPAN_NOTICE("Turrets can only be controlled using the assigned turret controller."))
		return UI_CLOSE

	if(isLocked(user))
		return UI_CLOSE

	if(!anchored)
		to_chat(user, SPAN_NOTICE("\The [src] has to be secured first!"))
		return UI_CLOSE

	return ..()

/obj/machinery/porta_turret/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["command"] && href_list["value"])
		var/value = text2num(href_list["value"])
		if(href_list["command"] == "enable")
			enabled = value
		else if(href_list["command"] == "lethal")
			lethal = value
		else if(href_list["command"] == "check_synth")
			check_synth = value
		else if(href_list["command"] == "check_weapons")
			check_weapons = value
		else if(href_list["command"] == "check_records")
			check_records = value
		else if(href_list["command"] == "check_arrest")
			check_arrest = value
		else if(href_list["command"] == "check_access")
			check_access = value
		else if(href_list["command"] == "check_anomalies")
			check_anomalies = value
		else if(href_list["command"] == "check_all")
			check_all = value
		else if(href_list["command"] == "check_down")
			check_down = value

		return 1

/obj/machinery/porta_turret/power_change()
	// todo: machinery/proc/on_online(), machinery/proc/on_offline()?
	if(powered() && !is_integrity_broken())
		ai_holder?.set_enabled(TRUE)
		machine_stat &= ~NOPOWER
		update_icon()
	else
		ai_holder?.set_enabled(FALSE)
		spawn(rand(0, 15))
			machine_stat |= NOPOWER
			update_icon()

/obj/machinery/porta_turret/attackby(obj/item/I, mob/user)
	if(machine_stat & BROKEN)
		if(I.is_crowbar())
			//If the turret is destroyed, you can remove it with a crowbar to
			//try and salvage its components
			to_chat(user, "<span class='notice'>You begin prying the metal coverings off.</span>")
			if(do_after(user, 20))
				if(can_salvage && prob(70))
					to_chat(user, "<span class='notice'>You remove the turret and salvage some components.</span>")
					if(installation)
						var/obj/item/gun/projectile/energy/Gun = new installation(loc)
						Gun.obj_cell_slot.cell.charge = gun_charge
						Gun.update_icon()
					if(prob(50))
						new /obj/item/stack/material/steel(loc, rand(1,4))
					if(prob(50))
						new /obj/item/assembly/prox_sensor(loc)
				else
					to_chat(user, "<span class='notice'>You remove the turret but did not manage to salvage anything.</span>")
				qdel(src) // qdel

	else if(I.is_wrench())
		if(enabled || raised)
			to_chat(user, "<span class='warning'>You cannot unsecure an active turret!</span>")
			return
		if(wrenching)
			to_chat(user, "<span class='warning'>Someone is already [anchored ? "un" : ""]securing the turret!</span>")
			return
		if(!anchored && isinspace())
			to_chat(user, "<span class='warning'>Cannot secure turrets in space!</span>")
			return

		user.visible_message(\
				"<span class='warning'>[user] begins [anchored ? "un" : ""]securing the turret.</span>", \
				"<span class='notice'>You begin [anchored ? "un" : ""]securing the turret.</span>" \
			)

		wrenching = TRUE
		if(do_after(user, 50 * I.tool_speed))
			//This code handles moving the turret around. After all, it's a portable turret!
			if(!anchored)
				playsound(loc, I.tool_sound, 100, 1)
				anchored = TRUE
				update_icon()
				to_chat(user, "<span class='notice'>You secure the exterior bolts on the turret.</span>")
			else if(anchored)
				playsound(loc, I.tool_sound, 100, 1)
				anchored = FALSE
				to_chat(user, "<span class='notice'>You unsecure the exterior bolts on the turret.</span>")
				update_icon()
		wrenching = FALSE

	else if(istype(I, /obj/item/card/id)||istype(I, /obj/item/pda))
		//Behavior lock/unlock mangement
		if(allowed(user))
			locked = !locked
			to_chat(user, "<span class='notice'>Controls are now [locked ? "locked" : "unlocked"].</span>")
			updateUsrDialog()
		else
			to_chat(user, "<span class='notice'>Access denied.</span>")

	else
		return ..()

/obj/machinery/porta_turret/emag_act(remaining_charges, mob/user)
	if(!emagged)
		//Emagging the turret makes it go bonkers and stun everyone. It also makes
		//the turret shoot much, much faster.
		to_chat(user, "<span class='warning'>You short out [src]'s threat assessment circuits.</span>")
		visible_message("[src] hums oddly...")
		emagged = TRUE
		controllock = TRUE
		enabled = FALSE //turns off the turret temporarily
		sleep(60) //6 seconds for the traitor to gtfo of the area before the turret decides to ruin his shit
		enabled = TRUE //turns it back on. The cover popUp() popDown() are automatically called in process(), no need to define it here
		fire_delay *= 0.5 // :trol:
		return 1

/obj/machinery/porta_turret/damage_integrity(amount, gradual, do_not_break)
	. = ..()
	if(!gradual && prob(45) && amount > 5)
		spark_system.start()

/obj/machinery/porta_turret/on_bullet_act(obj/projectile/proj, impact_flags, list/bullet_act_args)
	. = ..()
	aggro_for(6 SECONDS)
	if(proj.firer)
		// todo: proper AI provoke API.
		var/datum/ai_holder/turret/snowflake_ai_holder = ai_holder
		snowflake_ai_holder.retaliate(proj.firer)

/obj/machinery/porta_turret/on_melee_act(mob/attacker, obj/item/weapon, datum/melee_attack/attack_style, target_zone, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_ATTACK_ABORT)
		return
	if(. > 0)
		aggro_for(6 SECONDS, attacker)
	// todo: proper AI provoke API.
	var/datum/ai_holder/turret/snowflake_ai_holder = ai_holder
	snowflake_ai_holder.retaliate(attacker)

/obj/machinery/porta_turret/emp_act(severity)
	if(enabled)
		//if the turret is on, the EMP no matter how severe disables the turret for a while
		//and scrambles its settings, with a slight chance of having an emag effect
		check_arrest = prob(50)
		check_records = prob(50)
		check_weapons = prob(50)
		check_access = prob(20)	// check_access is a pretty big deal, so it's least likely to get turned on
		check_anomalies = prob(50)
		if(prob(5))
			emagged = TRUE

		enabled=0
		spawn(rand(60,600))
			if(!enabled)
				enabled = TRUE

	..()

/obj/machinery/porta_turret/atom_break()
	. = ..()
	spark_system.start()	//creates some sparks because they look cool
	update_icon()
	// todo: ugh this shouldn't work this way
	power_change()

/obj/machinery/porta_turret/atom_fix()
	. = ..()
	// todo: ugh this shouldn't work this way
	power_change()

/obj/machinery/porta_turret/process(delta_time)
	//the main machinery process
	if(machine_stat & (NOPOWER|BROKEN))
		//if the turret has no power or is broken, make the turret pop down if it hasn't already
		popDown()
		return

	if(!enabled)
		//if the turret is off, make it pop down
		popDown()
		return

	timeout--
	if(timeout <= 0)
		spawn()
			popDown() // no valid targets, close the cover

	if(auto_repair && (integrity < integrity_max))
		use_power(20000)
		heal_integrity(1)

// todo: put this on ai holder side
/obj/machinery/porta_turret/proc/assess_living(mob/living/L)
	L = ismovable(L)? L.get_mob() : null

	if(!istype(L))
		return TURRET_NOT_TARGET

	if(L.invisibility >= INVISIBILITY_LEVEL_ONE) // Cannot see him. see_invisible is a mob-var
		return TURRET_NOT_TARGET

	if(faction && L.has_iff_faction(faction))
		return TURRET_NOT_TARGET

	if(!emagged && issilicon(L) && check_all == FALSE)	// Don't target silica, unless told to neutralize everything.
		return TURRET_NOT_TARGET

	if(L.stat == DEAD && !emagged)		//if the perp is dead, no need to bother really
		return TURRET_NOT_TARGET	//move onto next potential victim!

	if(emagged)		// If emagged not even the dead get a rest
		return L.stat ? TURRET_SECONDARY_TARGET : TURRET_PRIORITY_TARGET

	// todo: target var should make this unnecessary, but maybe have it just pass through the AI?
	if(lethal && locate(/mob/living/silicon/ai) in get_turf(L))		//don't accidentally kill the AI!
		return TURRET_NOT_TARGET

	if(check_synth || check_all)	//If it's set to attack all non-silicons or everything, target them!
		if(L.stat != CONSCIOUS)
			return check_down ? TURRET_SECONDARY_TARGET : TURRET_NOT_TARGET
		return TURRET_PRIORITY_TARGET

	if(iscuffed(L)) // If the target is handcuffed, leave it alone
		return TURRET_NOT_TARGET

	if(isanimal(L)) // Animals are not so dangerous
		return check_anomalies ? TURRET_SECONDARY_TARGET : TURRET_NOT_TARGET

	if(isxenomorph(L) || isalien(L)) // Xenos are dangerous
		return check_anomalies ? TURRET_PRIORITY_TARGET	: TURRET_NOT_TARGET

	if(ishuman(L))	//if the target is a human, analyze threat level
		if(assess_perp(L) < 4)
			return TURRET_NOT_TARGET	//if threat level < 4, keep going

	if(L.stat != CONSCIOUS && (lethal || emagged))		//if the perp is lying down, it's still a target but a less-important target
		return check_down ? TURRET_SECONDARY_TARGET : TURRET_NOT_TARGET

	return TURRET_PRIORITY_TARGET	//if the perp has passed all previous tests, congrats, it is now a "shoot-me!" nominee

/obj/machinery/porta_turret/proc/assess_perp(mob/living/carbon/human/H)
	if(!H || !istype(H))
		return 0

	if(emagged)
		return 10

	return H.assess_perp(src, check_access, check_weapons, check_records, check_arrest)

// todo: the ai holder should control pop up / down.

/obj/machinery/porta_turret/proc/popUp()	//pops the turret up
	if(disabled)
		return
	if(raising || raised)
		return
	if(machine_stat & BROKEN)
		return
	set_raised_raising(raised, 1)
	update_icon()

	// they should be awake but just in case
	var/datum/ai_holder/turret/turret_ai = ai_holder
	turret_ai.wake()

	var/atom/flick_holder = new /atom/movable/porta_turret_cover(loc)
	flick_holder.layer = layer + 0.1
	flick("popup_[turret_type]", flick_holder)
	sleep(10)
	qdel(flick_holder)

	set_raised_raising(1, 0)
	update_icon()
	timeout = max(10, timeout)

/obj/machinery/porta_turret/proc/popDown()	//pops the turret down
	last_target = null
	if(disabled)
		return
	if(raising || !raised)
		return
	if(machine_stat & BROKEN)
		return
	set_raised_raising(raised, 1)
	update_icon()

	// they should already be idle but just in case
	var/datum/ai_holder/turret/turret_ai = ai_holder
	turret_ai.idle()

	var/atom/flick_holder = new /atom/movable/porta_turret_cover(loc)
	flick_holder.layer = layer + 0.1
	flick("popdown_[turret_type]", flick_holder)
	sleep(10)
	qdel(flick_holder)

	set_raised_raising(0, 0)
	update_icon()

/obj/machinery/porta_turret/proc/set_raised_raising(incoming_raised, incoming_raising)
	raised = incoming_raised
	raising = incoming_raising
	set_density(raised || raising)
	density = raised || raising

/**
 * @return TRUE on success
 */
/obj/machinery/porta_turret/proc/try_fire_at(atom/target, angle)
	if(disabled || !enabled || is_integrity_broken())
		return FALSE
	if(is_on_cooldown())
		return FALSE
	return fire_at(target, angle)

/obj/machinery/porta_turret/proc/fire_at(atom/target, angle)
	// are we raised?
	if(!raised)
		return FALSE
	// do we even have a target
	if(isnull(target) && isnull(angle))
		return FALSE
	// are they on turf on our level?
	if(target && (!target.x || target.z != z))
		return FALSE
	// do we need to resolve angle?
	if(isnull(angle))
		angle = arctan(y - target.y, x - target.x)
	// face
	if(target)
		setDir(get_dir(src, target))
	else
		setDir(angle2dir(angle))

	// fire
	last_fire = world.time
	next_fire = world.time + fire_delay + ((fire_burst - 1) * fire_burst_spacing)
	update_icon()

	INVOKE_ASYNC(src, PROC_REF(fire_at_impl), target, angle)

/obj/machinery/porta_turret/proc/fire_at_impl(atom/target, angle)
	for(var/i in 1 to fire_burst)
		// todo: track target if they've moved
		var/real_angle = angle
		if(fire_suppressive)
			var/dispersion = gaussian(0, fire_suppressive_dispersion_deviation)
			real_angle += dispersion
		shoot(target, real_angle)
		use_power(reqpower)
		sleep(fire_burst_spacing)

/obj/machinery/porta_turret/proc/shoot(atom/target, angle)
	var/obj/projectile/proj
	if(projectile_use_type)
		proj = new projectile_use_type(loc)
		playsound(loc, proj.fire_sound || lethal_shot_sound || shot_sound, 75, TRUE)
	else if(emagged || lethal)
		proj = new lethal_projectile(loc)
		playsound(loc, lethal_shot_sound, 75, TRUE)
	else
		proj = new projectile(loc)
		playsound(loc, shot_sound, 75, TRUE)

	//Turrets aim for the center of mass by default.
	//If the target is grabbing someone then the turret smartly aims for extremities
	// todo: this doesn't even do anything lol grab code doesn't care :/
	var/def_zone
	var/obj/item/grab/G = locate() in target
	if(G && G.state >= GRAB_NECK) //works because mobs are currently not allowed to upgrade to NECK if they are grabbing two people.
		def_zone = pick(BP_HEAD, BP_L_HAND, BP_R_HAND, BP_L_FOOT, BP_R_FOOT, BP_L_ARM, BP_R_ARM, BP_L_LEG, BP_R_LEG)
	else
		def_zone = pick(BP_TORSO, BP_GROIN)

	//Shooting Code:
	proj.firer = src
	proj.def_zone = def_zone
	proj.original_atom = target
	proj.fire(angle)

/obj/machinery/porta_turret/proc/aggro_for(seconds, mob/aggressor)
	timeout = round(seconds / 2)
	spawn(-1)
		popUp()

//* Firing - Cooldown *//

/**
 * @return TRUE if the turret is ready to shoot
 */
/obj/machinery/porta_turret/proc/is_on_cooldown()
	return next_fire > world.time

/**
 * @return ds until we can fire
 */
/obj/machinery/porta_turret/proc/get_remaining_cooldown()
	return max(0, next_fire - world.time)

// todo: everything below this line should be redone

/datum/turret_checks
	var/enabled
	var/lethal
	var/check_synth
	var/check_access
	var/check_records
	var/check_arrest
	var/check_weapons
	var/check_anomalies
	var/check_all
	var/ailock

/obj/machinery/porta_turret/proc/setState(datum/turret_checks/TC)
	if(controllock)
		return
	enabled = TC.enabled
	lethal = TC.lethal

	check_synth = TC.check_synth
	check_access = TC.check_access
	check_records = TC.check_records
	check_arrest = TC.check_arrest
	check_weapons = TC.check_weapons
	check_anomalies = TC.check_anomalies
	check_all = TC.check_all
	ailock = TC.ailock

	power_change()

/atom/movable/porta_turret_cover
	icon = 'icons/obj/turrets.dmi'
	mouse_opacity = FALSE
