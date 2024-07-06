/datum/firemode/energy/emitter_rifle
	projectile_type = /obj/projectile/beam/emitter
	charge_cost = 900
	fire_delay = 1 SECONDS

/obj/item/gun/energy/ermitter
	name = "Ermitter rifle"
	desc = "A industrial energy projector turned into a crude, portable weapon - the Tyrmalin answer to armored hardsuits used by pirates. What it lacks in precision, it makes up for in firepower. The 'Ermitter' rifle cell receptacle has been heavily modified."
	icon_state = "ermitter_gun"
	item_state = "pulse"
	firemodes = list(/datum/firemode/energy/emitter_rifle)
	cell_initial = /obj/item/cell
	accept_cell_initial = /obj/item/cell
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	heavy = TRUE
	damage_force = 10
	origin_tech = list(TECH_COMBAT = 3, TECH_ENGINEERING = 3, TECH_MAGNET = 2)
	materials_base = list(MAT_STEEL = 2000, MAT_GLASS = 1000)
	one_handed_penalty = 50

/obj/item/gun/energy/ionrifle/pistol/tyrmalin
	name = "botbuster pistol"
	desc = "These jury-rigged pistols are sometimes fielded by Tyrmalin facing synthetic pirates or malfunctioning machinery. Capable of discharging a single ionized bolt before needing to recharge, they're often treated as holdout or ambush weapons."
	icon_state = "botbuster"

	#warn impl - sprites

/obj/item/gun/projectile/ballistic/pirate/junker_pistol
	name = "scrap pistol"
	desc = "A strange handgun made from industrial parts. It appears to accept multiple rounds thanks to an internal magazine. Favored by Tyrmalin wannabe-gunslingers."
	icon_state = "junker_pistol"
	item_state = "revolver"
	load_method = SINGLE_CASING
	w_class = WEIGHT_CLASS_SMALL
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ILLEGAL = 3)
	recoil = 3
	handle_casings = CYCLE_CASINGS
	max_shells = 3

/obj/item/gun/projectile/ballistic/rocket/tyrmalin
	name = "rokkit launcher"
	desc = "A sloppily machined tube designed to function as a recoilless rifle. Sometimes used by Tyrmalin defense teams. It draws skeptical looks even amongst their ranks."
	icon_state = "rokkitlauncher"
	item_state = "rocket"
	handle_casings = HOLD_CASINGS
	unstable = 1

/obj/item/gun/projectile/ballistic/rocket/tyrmalin/consume_next_projectile(mob/user as mob)
	. = ..()
	if(.)
		if(unstable)
			switch(rand(1,100))
				if(1 to 5)
					to_chat(user, "<span class='danger'>The rocket primer activates early!</span>")
					icon_state = "rokkitlauncher-malfunction"
					spawn(rand(2 SECONDS, 5 SECONDS))
						if(src && !destroyed)
							visible_message("<span class='critical'>\The [src] detonates!</span>")
							destroyed = 1
							explosion(get_turf(src), -1, 0, 2, 3)
							qdel(src)
					return ..()
				if(6 to 20)
					to_chat(user, "<span class='notice'>The rocket flares out in the tube!</span>")
					playsound(src, 'sound/machines/button.ogg', 25)
					icon_state = "rokkitlauncher-broken"
					destroyed = 1
					name = "broken rokkit launcher"
					desc = "The tube has burst outwards like a sausage."
					return
				if(21 to 100)
					return 1

		if(destroyed)
			to_chat(user, "<span class='notice'>The [src] is broken!</span>")
			handle_click_empty()
			return

/obj/item/gun/projectile/ballistic/rocket/tyrmalin/Fire(atom/target, mob/living/user, clickparams, pointblank, reflex)
	. = ..()
	if(destroyed)
		to_chat(user, "<span class='notice'>\The [src] is completely inoperable!</span>")
		handle_click_empty()

/obj/item/gun/projectile/ballistic/rocket/tyrmalin/attack_hand(mob/user, list/params)
	if(user.get_inactive_held_item() == src && destroyed)
		to_chat(user, "<span class='danger'>\The [src]'s chamber is too warped to extract the casing!</span>")
		return
	else
		return ..()

/obj/item/gun/projectile/ballistic/rocket/tyrmalin/attackby(var/obj/item/A as obj, mob/user as mob)
	. = ..()
	if(A.is_material_stack_of(/datum/material/plasteel))
		var/obj/item/stack/material/M = A
		if(M.use(1))
			var/obj/item/tyrmalin_rocket_assembly/R = new /obj/item/tyrmalin_rocket_assembly(get_turf(src))
			to_chat(user, "<span class='notice'>You reinforce the weapon's barrel and open the maintenance hatch. The electronics are...missing?</span>")
			user.temporarily_remove_from_inventory(src, INV_OP_FORCE | INV_OP_SHOULD_NOT_INTERCEPT | INV_OP_SILENT)
			user.put_in_active_hand(R)
			qdel(src)

/obj/item/tyrmalin_rocket_assembly
	name = "advanced rokkit launcher assembly"
	desc = "A Tyrmalin rokkit launcher that has been partially disassembled and reinforced with more reliable materials. It's missing some wires."
	icon = 'icons/obj/items.dmi'
	icon_state = "rokkitassembly1"
	var/build_step = 0

/obj/item/tyrmalin_rocket_assembly/attackby(var/obj/item/W as obj, mob/user as mob)

	switch(build_step)
		if(0)
			if(istype(W, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/C = W
				if (C.get_amount() < 1)
					to_chat(user, "<span class='warning'>You need one coil of wire to wire \the [src].</span>")
					return
				to_chat(user, "<span class='notice'>You start to wire \the [src].</span>")
				if(do_after(user, 40))
					if(C.use(1))
						build_step++
						to_chat(user, "<span class='notice'>You add wires to the internal assembly.</span>")
						name = "wired advanced rokkit launcher assembly"
						desc = "This aseembly looks like it needs a power control module."
						icon_state = "rokkitassembly2"

		if(1)
			if(istype(W, /obj/item/module/power_control))
				if(!user.attempt_insert_item_for_installation(W, src))
					return
				build_step++
				to_chat(user, "<span class='notice'>You add \the [W] to \the [src].</span>")
				name = "programmed advanced rokkit launcher assembly"
				desc = "It seems ready for assembly."
				icon_state = "rokkitassembly3"

		if(2)
			if(W.is_screwdriver())
				playsound(src, W.tool_sound, 100, 1)
				to_chat(user, "<span class='notice'>You begin installing the board...</span>")
				if(do_after(user, 40))
					build_step++
					to_chat(user, "<span class='notice'>You close the hatch and complete the advanced rokkit launcher.</span>")
					var/turf/T = get_turf(src)
					new /obj/item/gun/projectile/ballistic/rocket/tyrmalin_advanced(T)
					qdel(src)

/obj/item/tyrmalin_rocket_assembly/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	.=..()
	update_icon()

/obj/item/gun/projectile/ballistic/rocket/tyrmalin_advanced
	name = "advanced rokkit launcher"
	desc = "A compact missile launcher fielded by Tyrmalin mech hunters. It looks more sturdy and refined than the prior iteration."
	icon_state = "rokkitlauncher_adv"

/obj/item/gun/projectile/ballistic/rocket/tyrmalin_advanced/update_icon_state()
	. = ..()
	if(loaded.len)
		icon_state = "[initial(icon_state)]-loaded"
	else
		icon_state = "[initial(icon_state)]"
