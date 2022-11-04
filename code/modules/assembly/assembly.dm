#define WIRE_RECEIVE (1<<0)
#define WIRE_PULSE (1<<1)
#define WIRE_PULSE_SPECIAL (1<<2)
#define WIRE_RADIO_RECEIVE (1<<3)
#define WIRE_RADIO_PULSE (1<<4)
#define ASSEMBLY_BEEP_VOLUME 5

/obj/item/assembly
	name = "assembly"
	desc = "A small electronic device that should never exist."
	icon = 'icons/obj/assemblies/new_assemblies.dmi'
	icon_state = ""
	w_class = ITEMSIZE_SMALL
	matter = list(MAT_STEEL = 100)
	throw_force = 2
	throw_speed = 3
	throw_range = 10
	drop_sound = 'sound/items/drop/component.ogg'
	pickup_sound =  'sound/items/pickup/component.ogg'
	origin_tech = list(TECH_MAGNET = 1)
	worn_render_flags = WORN_RENDER_SLOT_NO_RENDER | WORN_RENDER_INHAND_NO_RENDER

	var/secured = 1
	var/list/attached_overlays = null
	var/obj/item/assembly_holder/holder = null
	var/cooldown = FALSE //To prevent spam
	var/wires = WIRE_RECEIVE | WIRE_PULSE

/obj/item/assembly/Destroy()
	holder = null
	return ..()

/obj/item/assembly/proc/holder_movement()
	return

/obj/item/assembly/proc/process_cooldown()
	if(cooldown)
		return FALSE
	cooldown = TRUE
	VARSET_IN(src, cooldown, FALSE, 2 SECONDS)
	return TRUE

/obj/item/assembly/proc/pulsed(var/radio = 0)
	if(holder && (wires & WIRE_RECEIVE))
		activate()
	if(radio && (wires & WIRE_RADIO_RECEIVE))
		activate()
	return TRUE

/obj/item/assembly/proc/pulse(var/radio = 0)
	if(holder && (wires & WIRE_PULSE))
		holder.process_activation(src, 1, 0)
	if(holder && (wires & WIRE_PULSE_SPECIAL))
		holder.process_activation(src, 0, 1)
	return TRUE

/obj/item/assembly/proc/activate()
	if(!secured || !process_cooldown())
		return FALSE
	return TRUE

/obj/item/assembly/proc/toggle_secure()
	secured = !secured
	update_icon()
	return secured

/obj/item/assembly/proc/attach_assembly(var/obj/item/assembly/A, var/mob/user)
	holder = new/obj/item/assembly_holder(get_turf(src))
	if(holder.attach(A,src,user))
		to_chat(user, SPAN_NOTICE("You attach \the [A] to \the [src]!"))
		return TRUE

/obj/item/assembly/attackby(obj/item/W as obj, mob/user as mob)
	if(isassembly(W))
		var/obj/item/assembly/A = W
		if((!A.secured) && (!secured))
			attach_assembly(A,user)
			return
	if(W.is_screwdriver())
		if(toggle_secure())
			to_chat(user, SPAN_NOTICE("\The [src] is ready!"))
		else
			to_chat(user, SPAN_NOTICE("\The [src] can now be attached!"))
		return
	return ..()

/obj/item/assembly/process(delta_time)
	return PROCESS_KILL

/obj/item/assembly/examine(mob/user)
	. = ..()
	if((in_range(src, user) || loc == user))
		if(secured)
			. += "\The [src] is ready!"
		else
			. += "\The [src] can be attached!"
	return


/obj/item/assembly/attack_self(mob/user as mob)
	if(!user)
		return FALSE
	user.set_machine(src)
	ui_interact(user)
	return TRUE

/obj/item/device/assembly/ui_state(mob/user)
	return GLOB.deep_inventory_state

/obj/item/device/assembly/ui_interact(mob/user, datum/tgui/ui)
	return // tgui goes here

/obj/item/device/assembly/ui_host()
	if(istype(loc, /obj/item/assembly_holder))
		return loc.ui_host()
	return ..()
