/datum/mini_hud
	var/datum/hud/main_hud
	var/list/screenobjs = list()
	var/list/types_to_instantiate
	var/needs_processing = FALSE

/datum/mini_hud/New(var/datum/hud/other)
	apply_to_hud(other)
	if(needs_processing)
		START_PROCESSING(SSprocessing, src)

/datum/mini_hud/Destroy()
	main_hud?.remove_minihud(src)
	main_hud = null
	if(needs_processing)
		STOP_PROCESSING(SSprocessing, src)
	return ..()

// Apply to a real /datum/hud
/datum/mini_hud/proc/apply_to_hud(var/datum/hud/other)
	if(main_hud)
		unapply_to_hud(main_hud)
	main_hud = other
	main_hud.apply_minihud(src)

// Remove from a real /datum/hud
/datum/mini_hud/proc/unapply_to_hud(var/datum/hud/other)
	main_hud.remove_minihud(src)

// Update the hud
/datum/mini_hud/process(delta_time)
	return PROCESS_KILL // You shouldn't be here!

// Return a list of screen objects we use
/datum/mini_hud/proc/get_screen_objs(var/mob/M)
	return screenobjs

/datum/mini_hud/mech
	var/obj/vehicle/sealed/mecha/owner_mech
	var/atom/movable/screen/mech/power/power
	var/atom/movable/screen/mech/health/health
	var/atom/movable/screen/mech/air/air
	var/atom/movable/screen/mech/airtoggle/airtoggle

	needs_processing = TRUE

/datum/mini_hud/mech/New(var/datum/hud/other, var/obj/vehicle/sealed/mecha/owner)
	owner_mech = owner
	power = new ()
	health = new ()
	air = new ()
	airtoggle = new ()

	screenobjs = list(power, health, air, airtoggle)
	screenobjs += new /atom/movable/screen/mech/deco1
	screenobjs += new /atom/movable/screen/mech/deco2
	screenobjs += new /atom/movable/screen/mech/deco1_f
	screenobjs += new /atom/movable/screen/mech/deco2_f

	for(var/scr in screenobjs)
		var/atom/movable/screen/S = scr
		S.master = owner_mech
	..()

/datum/mini_hud/mech/Destroy()
	if(owner_mech)
		owner_mech.minihud = null
		owner_mech = null
	return ..()

/datum/mini_hud/mech/process(delta_time)
	if(!owner_mech)
		qdel(src)
		return

	var/obj/item/cell/mechcell = owner_mech.cell
	var/obj/machinery/portable_atmospherics/canister/mechtank = owner_mech.internal_tank

	var/charge_percentage = mechcell ? mechcell.charge / mechcell.maxcharge : 0
	var/air_percentage = mechtank ? clamp(mechtank.air_contents.total_moles / 1863.47, 0, 1) : 0
	var/health_percentage = owner_mech.percent_integrity()
	var/air_on = owner_mech.use_internal_tank

	power.icon_state = "pwr[round(charge_percentage / 0.2, 1)]"
	air.icon_state = "air[round(air_percentage / 0.2, 1)]"
	health.icon_state = "health[round(health_percentage / 0.2, 1)]"
	airtoggle.icon_state = "airon[air_on]"

/atom/movable/screen/mech
	icon = 'icons/mob/screen_rigmech.dmi'

/atom/movable/screen/mech/deco1
	name = "Mech Status"
	icon_state = "frame1_1"
	screen_loc = ui_mech_deco1

/atom/movable/screen/mech/deco2
	name = "Mech Status"
	icon_state = "frame1_2"
	screen_loc = ui_mech_deco2

/atom/movable/screen/mech/deco1_f
	name = "Mech Status"
	icon_state = "frame1_1_far"
	screen_loc = ui_mech_deco1_f

/atom/movable/screen/mech/deco2_f
	name = "Mech Status"
	icon_state = "frame1_2_far"
	screen_loc = ui_mech_deco2_f

/atom/movable/screen/mech/power
	name = "Charge Level"
	icon_state = "pwr5"
	screen_loc = ui_mech_pwr

/atom/movable/screen/mech/health
	name = "Integrity Level"
	icon_state = "health5"
	screen_loc = ui_mech_health

/atom/movable/screen/mech/air
	name = "Air Storage"
	icon_state = "air5"
	screen_loc = ui_mech_air

/atom/movable/screen/mech/airtoggle
	name = "Toggle Air"
	icon_state = "airoff"
	screen_loc = ui_mech_airtoggle

/atom/movable/screen/mech/airtoggle/Click()
	var/mob/living/carbon/human/user = usr
	if(!istype(user) || user.stat || user.incapacitated())
		return
	var/obj/vehicle/sealed/mecha/owner_mech = master
	if(user != owner_mech.occupant_legacy)
		return
	owner_mech.toggle_internal_tank()
