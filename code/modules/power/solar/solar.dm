#define SOLAR_MAX_DIST 40
/// Will never start itself.
#define SOLAR_AUTO_START_NO     0
/// Will always start itself.
#define SOLAR_AUTO_START_YES    1
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
	var/obscured = 0
	var/sunfrac = 0
	var/adir = SOUTH // actual dir
	var/ndir = SOUTH // target dir
	var/turn_angle = 0
	var/obj/machinery/power/solar_control/control = null

/obj/machinery/power/solar/Initialize(mapload, obj/item/solar_assembly/S)
	. = ..()
	update_icon()
	connect_to_network()

/obj/machinery/power/solar/Destroy()
	unset_control() //remove from control computer
	return ..()

/obj/machinery/power/solar/can_drain_energy(datum/actor, flags)
	return FALSE

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
	if(!SSsun.sun)
		return
	if(obscured)
		sunfrac = 0
		return

	//find the smaller angle between the direction the panel is facing and the direction of the SSsun.sun (the sign is not important here)
	var/p_angle = min(abs(adir - SSsun.sun.angle), 360 - abs(adir - SSsun.sun.angle))

	if(p_angle > 90)			// if facing more than 90deg from SSsun.sun, zero output
		sunfrac = 0
		return

	sunfrac = cos(p_angle) ** 2
	//isn't the power recieved from the incoming light proportionnal to cos(p_angle) (Lambert's cosine law) rather than cos(p_angle)^2 ?

/obj/machinery/power/solar/process(delta_time)//TODO: remove/add this from machines to save on processing as needed ~Carn PRIORITY
	if(machine_stat & BROKEN)
		return
	if(!SSsun.sun || !control) //if there's no SSsun.sun or the panel is not linked to a solar control computer, no need to proceed
		return

	if(powernet)
		if(powernet == control.powernet)//check if the panel is still connected to the computer
			if(obscured) //get no light from the SSsun.sun, so don't generate power
				return
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

//trace towards SSsun.sun to see if we're in shadow
/obj/machinery/power/solar/proc/occlusion()

	var/ax = x		// start at the solar panel
	var/ay = y
	var/turf/T = null

	for(var/i = 1 to 20)		// 20 steps is enough
		ax += SSsun.sun.dx	// do step
		ay += SSsun.sun.dy

		T = locate( round(ax,0.5),round(ay,0.5),z)

		if(!T || T.x == 1 || T.x==world.maxx || T.y==1 || T.y==world.maxy)		// not obscured if we reach the edge
			break

		if(T.opacity)			// if we hit a solid turf, panel is obscured
			obscured = 1
			return

	obscured = 0		// if hit the edge or stepped 20 times, not obscured
	update_solar_exposure()

/obj/machinery/power/solar/fake/Initialize(mapload, obj/item/solar_assembly/S)
	. = ..(mapload, S, FALSE)

/obj/machinery/power/solar/fake/process(delta_time)
	return PROCESS_KILL

/obj/item/paper/solar
	name = "paper- 'Going green! Setup your own solar array instructions.'"
	info = "<h1>Welcome</h1><p>At greencorps we love the environment, and space. With this package you are able to help mother nature and produce energy without any usage of fossil fuel or phoron! Singularity energy is dangerous while solar energy is safe, which is why it's better. Now here is how you setup your own solar array.</p><p>You can make a solar panel by wrenching the solar assembly onto a cable node. Adding a glass panel, reinforced or regular glass will do, will finish the construction of your solar panel. It is that easy!</p><p>Now after setting up 19 more of these solar panels you will want to create a solar tracker to keep track of our mother nature's gift, the SSsun.sun. These are the same steps as before except you insert the tracker equipment circuit into the assembly before performing the final step of adding the glass. You now have a tracker! Now the last step is to add a computer to calculate the SSsun.sun's movements and to send commands to the solar panels to change direction with the SSsun.sun. Setting up the solar computer is the same as setting up any computer, so you should have no trouble in doing that. You do need to put a wire node under the computer, and the wire needs to be connected to the tracker.</p><p>Congratulations, you should have a working solar array. If you are having trouble, here are some tips. Make sure all solar equipment are on a cable node, even the computer. You can always deconstruct your creations if you make a mistake.</p><p>That's all to it, be safe, be green!</p>"

/proc/rate_control(var/S, var/V, var/C, var/Min=1, var/Max=5, var/Limit=null) //How not to name vars
	var/href = "<A href='?src=\ref[S];rate control=1;[V]"
	var/rate = "[href]=-[Max]'>-</A>[href]=-[Min]'>-</A> [(C?C : 0)] [href]=[Min]'>+</A>[href]=[Max]'>+</A>"
	if(Limit) return "[href]=-[Limit]'>-</A>"+rate+"[href]=[Limit]'>+</A>"
	return rate
