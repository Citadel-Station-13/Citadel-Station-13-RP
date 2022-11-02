/obj/item/plastique
	name = "plastic explosives"
	desc = "Used to put holes in specific areas without too much extra hole."
	gender = PLURAL
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "plastic-explosive0"
	item_state = "plasticx"
	item_flags = ITEM_NOBLUDGEON
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_ILLEGAL = 2)
	var/datum/wires/explosive/c4/wires = null
	var/timer = 10
	var/atom/target = null
	var/open_panel = 0
	var/image_overlay = null
	var/blast_dev = -1
	var/blast_heavy = -1
	var/blast_light = 2
	var/blast_flash = 3

/obj/item/plastique/Initialize(mapload)
	. = ..()
	wires = new(src)
	image_overlay = image('icons/obj/assemblies.dmi', "plastic-explosive2")

/obj/item/plastique/Destroy()
	qdel(wires)
	wires = null
	return ..()

/obj/item/plastique/attackby(var/obj/item/I, var/mob/user)
	if(I.is_screwdriver())
		open_panel = !open_panel
		to_chat(user, "<span class='notice'>You [open_panel ? "open" : "close"] the wire panel.</span>")
		playsound(src, I.tool_sound, 50, 1)
	else if(I.is_wirecutter() || istype(I, /obj/item/multitool) || istype(I, /obj/item/assembly/signaler ))
		wires.Interact(user)
	else
		..()

/obj/item/plastique/attack_self(mob/user as mob)
	var/newtime = input(usr, "Please set the timer.", "Timer", 10) as num
	if(user.get_active_held_item() == src)
		newtime = clamp(newtime, 10, 60000)
		timer = newtime
		to_chat(user, "Timer set for [timer] seconds.")

/obj/item/plastique/afterattack(atom/movable/target, mob/user, flag)
	if (!flag)
		return
	if (ismob(target) || istype(target, /turf/unsimulated) || istype(target, /turf/simulated/shuttle) || istype(target, /obj/item/storage/) || istype(target, /obj/item/clothing/accessory/storage/) || istype(target, /obj/item/clothing/under))
		return
	to_chat(user, "Planting explosives...")
	user.do_attack_animation(target)

	if(do_after(user, 50) && in_range(user, target))
		if(!user.attempt_void_item_for_installation(src))
			return
		src.target = target

		if (ismob(target))
			add_attack_logs(user, target, "planted [name] on with [timer] second fuse")
			user.visible_message("<span class='danger'>[user.name] finished planting an explosive on [target.name]!</span>")
		else
			message_admins("[key_name(user, user.client)](<A HREF='?_src_=holder;adminmoreinfo=\ref[user]'>?</A>) planted [src.name] on [target.name] at ([target.x],[target.y],[target.z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[target.x];Y=[target.y];Z=[target.z]'>JMP</a>) with [timer] second fuse",0,1)
			log_game("[key_name(user)] planted [src.name] on [target.name] at ([target.x],[target.y],[target.z]) with [timer] second fuse")

		target.overlays += image_overlay
		to_chat(user, "Bomb has been planted. Timer counting down from [timer].")
		spawn(timer*10)
			explode(get_turf(target))

/obj/item/plastique/proc/explode(var/location)
	if(!target)
		target = get_atom_on_turf(src)
	if(!target)
		target = src
	if(location)
		explosion(location, blast_dev, blast_heavy, blast_light, blast_flash)

	if(target)
		if (istype(target, /turf/simulated/wall))
			var/turf/simulated/wall/W = target
			W.dismantle_wall(1,1,1)
		else if(istype(target, /mob/living))
			LEGACY_EX_ACT(target, 2, null) // c4 can't gib mobs anymore.
		else
			LEGACY_EX_ACT(target, 1, null)
	if(target)
		target.overlays -= image_overlay
	qdel(src)

/obj/item/plastique/attack(mob/M as mob, mob/user as mob, def_zone)
	return

/obj/item/plastique/seismic
	name = "seismic charge"
	desc = "Used to dig holes in specific areas without too much extra hole."

	blast_heavy = 2
	blast_light = 4
	blast_flash = 7

/obj/item/plastique/seismic/attackby(var/obj/item/I, var/mob/user)
	. = ..()
	if(open_panel)
		if(istype(I, /obj/item/stock_parts/micro_laser))
			var/obj/item/stock_parts/SP = I
			var/new_blast_power = max(1, round(SP.rating / 2) + 1)
			if(new_blast_power > blast_heavy)
				if(!user.attempt_consume_item_for_construction(I))
					return
				to_chat(user, "<span class='notice'>You install \the [I] into \the [src].</span>")
				blast_heavy = new_blast_power
				blast_light = blast_heavy + round(new_blast_power * 0.5)
				blast_flash = blast_light + round(new_blast_power * 0.75)
			else
				to_chat(user, "<span class='notice'>The [I] is not any better than the component already installed into this charge!</span>")
	return .

/obj/item/plastique/seismic/locked
	desc = "Used to dig holes in specific areas without too much extra hole. Has extra mechanism that safely implodes the bomb if it is used in close proximity to the facility."

/obj/item/plastique/seismic/locked/explode(var/location)
	if(!target)
		target = get_atom_on_turf(src)
	if(!target)
		target = src

	var/turf/T = get_turf(target)
	if(onstation_weapon_locked(T.z))
		target.visible_message("<span class='danger'>\The [src] lets out a loud beep as safeties trigger, before imploding and falling apart.</span>")
		target.overlays -= image_overlay
		qdel(src)
		return 0
	else
		return ..()
