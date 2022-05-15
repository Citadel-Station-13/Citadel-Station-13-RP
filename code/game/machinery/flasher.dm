// It is a gizmo that flashes a small area
/obj/machinery/flasher
	name = "Mounted flash"
	desc = "A wall-mounted flashbulb device."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "mflash1"
	var/id = null
	var/range = 2 //this is roughly the size of brig cell
	var/disable = FALSE
	var/last_flash = 0 //Don't want it getting spammed like regular flashes
	var/strength = 10 //How weakened targets are when flashed.
	var/base_state = "mflash"
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 2
	flags = PROXMOVE

/obj/machinery/flasher/portable //Portable version of the flasher. Only flashes when anchored
	name = "portable flasher"
	desc = "A portable flashing device. Wrench to activate and deactivate. Cannot detect slow movements."
	icon_state = "pflash1"
	strength = 8
	anchored = FALSE
	density = TRUE
	base_state = "pflash"

/obj/machinery/flasher/power_change()
	..()
	if(!(machine_stat & NOPOWER))
		icon_state = "[base_state]1"
//		sd_SetLuminosity(2)
	else
		icon_state = "[base_state]1-p"
//		sd_SetLuminosity(0)

//Don't want to render prison breaks impossible
/obj/machinery/flasher/attackby(obj/item/W, mob/user)
	if(W.is_wirecutter())
		add_fingerprint(user, 0, W)
		disable = !disable
		if(disable)
			user.visible_message( \
				SPAN_WARNING("[user] has disconnected the [src]'s flashbulb!"), \
				SPAN_WARNING("You disconnect the [src]'s flashbulb!"))
		if(!disable)
			user.visible_message( \
				SPAN_WARNING("[user] has connected the [src]'s flashbulb!"), \
				SPAN_WARNING("You connect the [src]'s flashbulb!"))
	else
		..()

//Let the AI trigger them directly.
/obj/machinery/flasher/attack_ai()
	if(anchored)
		return flash()
	else
		return

/obj/machinery/flasher/proc/flash()
	if(!(powered()))
		return

	if((disable) || (last_flash && world.time < last_flash + 150))
		return

	playsound(src.loc, 'sound/weapons/flash.ogg', 100, TRUE)
	flick("[base_state]_flash", src)
	last_flash = world.time
	use_power(1500)

	for (var/mob/O in viewers(src, null))
		if(get_dist(src, O) > range)
			continue

		var/flash_time = strength
		if(istype(O, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = O
			if(!H.eyecheck() <= 0)
				continue
			flash_time *= H.species.flash_mod
			var/obj/item/organ/internal/eyes/E = H.internal_organs_by_name[O_EYES]
			if(!E)
				return
			if(E.is_bruised() && prob(E.damage + 50))
				H.flash_eyes()
				E.damage += rand(1, 5)
		else
			if(!O.blinded && isliving(O))
				var/mob/living/L = O
				L.flash_eyes()
		O.Weaken(flash_time)

/obj/machinery/flasher/emp_act(severity)
	if(machine_stat & (BROKEN|NOPOWER))
		..(severity)
		return
	if(prob(75/severity))
		flash()
	..(severity)

/obj/machinery/flasher/portable/HasProximity(atom/movable/AM as mob|obj)
	if((disable) || (last_flash && world.time < last_flash + 150))
		return

	if(istype(AM, /mob/living/carbon))
		var/mob/living/carbon/M = AM
		if((M.m_intent != "walk") && (anchored))
			flash()

/obj/machinery/flasher/portable/attackby(obj/item/W, mob/user)
	if(W.is_wrench())
		add_fingerprint(user)
		anchored = !anchored

		if(!anchored)
			user.show_message(SPAN_WARNING("[src] can now be moved."))
			cut_overlays()

		else if(anchored)
			user.show_message(SPAN_WARNING("[src] is now secured."))
			add_overlay("[base_state]-s")

/obj/machinery/button/flasher
	name = "flasher button"
	desc = "A remote control switch for a mounted flasher."

/obj/machinery/button/flasher/attack_hand(mob/user)
	if(..())
		return

	use_power(5)

	active = TRUE
	icon_state = "launcheract"

	for(var/obj/machinery/flasher/M in GLOB.machines)
		if(M.id == id)
			spawn()
				M.flash()

	sleep(50)

	icon_state = "launcherbtt"
	active = FALSE

	return
