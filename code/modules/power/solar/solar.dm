#define SOLAR_MAX_DIST 40
/// Will start itself if config allows it (default is no).
#define SOLAR_AUTO_START_CONFIG 2
GLOBAL_VAR_INIT(solar_gen_rate, 1500)
GLOBAL_LIST_EMPTY(solars_list)

/obj/machinery/power/solar
	name = "solar panel"
	desc = "A solar electrical generator."
	icon = 'icons/obj/power.dmi'
	icon_state = "sp_base"
	anchored = 1
	density = 1
	use_power = USE_POWER_OFF
	idle_power_usage = 0
	active_power_usage = 0
	integrity = 100
	integrity_max = 100

	var/id = 0
	var/sunfrac = 0
	var/adir = SOUTH // actual dir
	var/ndir = SOUTH // target dir
	var/turn_angle = 0
	var/obj/machinery/power/solar_control/control = null

/obj/machinery/power/solar/Initialize(mapload)
	. = ..()
	connect_to_network()
	update_icon()

/obj/machinery/power/solar/Destroy()
	unset_control() //remove from control computer
	return ..()

//set the control of the panel to a given computer if closer than SOLAR_MAX_DIST
/obj/machinery/power/solar/proc/set_control(var/obj/machinery/power/solar_control/SC)
	if(SC && (get_dist(src, SC) > SOLAR_MAX_DIST))
		return 0
	control = SC
	return 1

//set the control of the panel to null and removes it from the control list of the previous control computer if needed
/obj/machinery/power/solar/proc/unset_control()
	if(control)
		control.connected_panels.Remove(src)
	control = null

/obj/machinery/power/solar/attackby(obj/item/I, mob/living/user, list/params, clickchain_flags, damage_multiplier)
	// todo: tool act
	if(I.is_crowbar())
		playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
		user.visible_message("<span class='notice'>[user] begins to take the glass off the solar panel.</span>")
		if(do_after(user, 50))
			playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
			user.visible_message("<span class='notice'>[user] takes the glass off the solar panel.</span>")
			deconstruct(ATOM_DECONSTRUCT_DISASSEMBLED)
			return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
		return CLICKCHAIN_DO_NOT_PROPAGATE
	return ..()

/obj/machinery/solar/drop_products(method, atom/where)
	. = ..()
	switch(method)
		if(ATOM_DECONSTRUCT_DISASSEMBLED)
			drop_product(method, new /obj/structure/frame2/solar_panel/anchored, where)
		else
			for(var/i in 1 to 2)
				new /obj/item/material/shard(where)

/obj/machinery/power/solar/update_icon()
	..()
	cut_overlays()
	if(machine_stat & BROKEN)
		add_overlay(image('icons/obj/power.dmi', icon_state = "solar_panel-b", layer = FLY_LAYER))
	else
		add_overlay(image('icons/obj/power.dmi', icon_state = "solar_panel", layer = FLY_LAYER))
		setDir(angle2dir(adir))
	return

//calculates the fraction of the SSsun.sunlight that the panel recieves
/obj/machinery/power/solar/proc/update_solar_exposure()
	var/p_angle = 180
	var/solar_brightness = 1

	var/datum/planet/our_planet = null
	var/turf/T = get_turf(src)
	if(T.outdoors && (T.z <= SSplanets.z_to_planet.len))
		our_planet = SSplanets.z_to_planet[z]

	if(our_planet && istype(our_planet))
		solar_brightness = our_planet.sun_apparent_brightness * 1.3
		var/time_num = text2num(our_planet.current_time.show_time("hh")) + text2num(our_planet.current_time.show_time("mm")) / 60
		var/hours_in_day = our_planet.current_time.seconds_in_day / (1 HOURS)
		var/sunangle_by_time = (time_num / hours_in_day) * 360 // day as progress from 0 to 1 * 360
		p_angle = abs(adir - sunangle_by_time)
	else
		if(!SSsun.sun)
			return
		//find the smaller angle between the direction the panel is facing and the direction of the SSsun.sun (the sign is not important here)
		p_angle = min(abs(adir - SSsun.sun.angle), 360 - abs(adir - SSsun.sun.angle))

	sunfrac = max(cos(p_angle), 0) * solar_brightness

/obj/machinery/power/solar/process(delta_time)//TODO: remove/add this from machines to save on processing as needed ~Carn PRIORITY
	if(machine_stat & BROKEN)
		return
	if(!control) //if there's the panel is not linked to a solar control computer, no need to proceed
		return

	if(!sunfrac) //Not getting any sun, so why process
		return

	if(powernet)
		if(powernet == control.powernet)//check if the panel is still connected to the computer
			var/sgen = GLOB.solar_gen_rate * sunfrac
			add_avail(sgen * 0.001)
			control.gen += sgen
		else //if we're no longer on the same powernet, remove from control computer
			unset_control()

/obj/machinery/power/solar/atom_break()
	. = ..()
	machine_stat |= BROKEN
	unset_control()
	update_icon()

/obj/machinery/power/solar/atom_fix()
	. = ..()
	machine_stat &= ~(BROKEN)
	update_icon()

/obj/item/paper/solar
	name = "paper- 'Going green! Setup your own solar array instructions.'"
	info = "<h1>Welcome</h1><p>At greencorps we love the environment, and space. With this package you are able to help mother nature and produce energy without any usage of fossil fuel or phoron! Singularity energy is dangerous while solar energy is safe, which is why it's better. Now here is how you setup your own solar array.</p><p>You can make a solar panel by wrenching the solar assembly onto a cable node. Adding a glass panel, reinforced or regular glass will do, will finish the construction of your solar panel. It is that easy!</p><p>Now after setting up 19 more of these solar panels you will want to create a solar tracker to keep track of our mother nature's gift, the SSsun.sun. These are the same steps as before except you insert the tracker equipment circuit into the assembly before performing the final step of adding the glass. You now have a tracker! Now the last step is to add a computer to calculate the SSsun.sun's movements and to send commands to the solar panels to change direction with the SSsun.sun. Setting up the solar computer is the same as setting up any computer, so you should have no trouble in doing that. You do need to put a wire node under the computer, and the wire needs to be connected to the tracker.</p><p>Congratulations, you should have a working solar array. If you are having trouble, here are some tips. Make sure all solar equipment are on a cable node, even the computer. You can always deconstruct your creations if you make a mistake.</p><p>That's all to it, be safe, be green!</p>"
