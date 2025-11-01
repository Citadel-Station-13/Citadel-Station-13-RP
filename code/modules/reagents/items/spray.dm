/obj/item/reagent_containers/spray
	name = "spray bottle"
	desc = "A spray bottle, with an unscrewable top."
	icon = 'icons/obj/janitor.dmi'
	icon_state = "cleaner"
	item_state = "cleaner"
	item_flags = ITEM_NO_BLUDGEON | ITEM_ENCUMBERS_WHILE_HELD
	atom_flags = OPENCONTAINER
	slot_flags = SLOT_BELT | SLOT_HOLSTER
	throw_force = 3
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 2
	throw_range = 10
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10) //Set to null instead of list, if there is only one.
	suit_storage_class = SUIT_STORAGE_CLASS_SOFTWEAR | SUIT_STORAGE_CLASS_HARDWEAR
	var/spray_size = 3
	var/list/spray_sizes = list(1,3)
	volume = 250
	materials_base = list(MAT_GLASS = 1500, MAT_STEEL = 250)

/obj/item/reagent_containers/spray/Initialize(mapload)
	. = ..()
	remove_obj_verb(src, /obj/item/reagent_containers/verb/set_APTFT)

/obj/item/reagent_containers/spray/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	if(istype(target, /obj/item/storage) || istype(target, /obj/structure/table) || istype(target, /obj/structure/closet) || istype(target, /obj/item/reagent_containers) || istype(target, /obj/structure/sink) || istype(target, /obj/structure/janitorialcart))
		return

	if(istype(target, /spell))
		return

	if(clickchain_flags & CLICKCHAIN_HAS_PROXIMITY)
		if(standard_dispenser_refill(user, target))
			return

	if(reagents.total_volume < amount_per_transfer_from_this)
		to_chat(user, "<span class='notice'>\The [src] is empty!</span>")
		return

	Spray_at(target, user, (clickchain_flags & CLICKCHAIN_HAS_PROXIMITY))

	user.setClickCooldownLegacy(4)

	if(reagents.has_reagent("sacid"))
		message_admins("[key_name_admin(user)] fired sulphuric acid from \a [src].")
		log_game("[key_name(user)] fired sulphuric acid from \a [src].")
	if(reagents.has_reagent("pacid"))
		message_admins("[key_name_admin(user)] fired Polyacid from \a [src].")
		log_game("[key_name(user)] fired Polyacid from \a [src].")
	if(reagents.has_reagent("lube"))
		message_admins("[key_name_admin(user)] fired Space lube from \a [src].")
		log_game("[key_name(user)] fired Space lube from \a [src].")
	return

/obj/item/reagent_containers/spray/proc/Spray_at(atom/A as mob|obj, mob/user as mob, proximity)
	playsound(src.loc, 'sound/effects/spray2.ogg', 50, 1, -6)
	if (A.density && proximity)
		A.visible_message("[usr] sprays [A] with [src].")
		reagents.splash(A, amount_per_transfer_from_this)
	else
		spawn(0)
			var/obj/effect/water/chempuff/D = new/obj/effect/water/chempuff(get_turf(src))
			var/turf/my_target = get_turf(A)
			D.create_reagents(amount_per_transfer_from_this)
			if(!src)
				return
			reagents.trans_to_obj(D, amount_per_transfer_from_this)
			D.color = D.reagents.get_color()
			D.set_up(my_target, spray_size, 10)
	return

/obj/item/reagent_containers/spray/attack_self(mob/user, datum/event_args/actor/actor)
	if(!possible_transfer_amounts)
		return
	amount_per_transfer_from_this = next_list_item(amount_per_transfer_from_this, possible_transfer_amounts)
	spray_size = next_list_item(spray_size, spray_sizes)
	to_chat(user, "<span class='notice'>You adjusted the pressure nozzle. You'll now use [amount_per_transfer_from_this] units per spray.</span>")

/obj/item/reagent_containers/spray/examine(mob/user, dist)
	. = ..()
	if(loc == user)
		. += "[round(reagents.total_volume)] units left."

/obj/item/reagent_containers/spray/verb/empty()

	set name = "Empty Tank"
	set category = VERB_CATEGORY_OBJECT
	set src in usr

	if (alert(usr, "Are you sure you want to empty that?", "Empty Tank:", "Yes", "No") != "Yes")
		return
	if(isturf(usr.loc))
		to_chat(usr, "<span class='notice'>You empty \the [src] onto the floor.</span>")
		reagents.splash(usr.loc, reagents.total_volume)

//space cleaner
/obj/item/reagent_containers/spray/cleaner
	name = "space cleaner"
	desc = "BLAM!-brand non-foaming space cleaner!"

/obj/item/reagent_containers/spray/cleaner/drone
	name = "space cleaner"
	desc = "BLAM!-brand non-foaming space cleaner!"
	volume = 50

/obj/item/reagent_containers/spray/cleaner/Initialize(mapload)
	. = ..()
	reagents.add_reagent("cleaner", volume)

/obj/item/reagent_containers/spray/sterilizine
	name = "sterilizine"
	desc = "Great for hiding incriminating bloodstains and sterilizing scalpels."

/obj/item/reagent_containers/spray/sterilizine/Initialize(mapload)
	. = ..()
	reagents.add_reagent("sterilizine", volume)

/obj/item/reagent_containers/spray/pepper
	name = "pepperspray"
	desc = "Manufactured by UhangInc, used to blind and down an opponent quickly."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "pepperspray"
	item_state = "pepperspray"
	suit_storage_class = SUIT_STORAGE_CLASS_SOFTWEAR
	possible_transfer_amounts = null
	volume = 40
	worth_intrinsic = 85
	var/safety = TRUE
	materials_base = list(MAT_STEEL = 1000)

/obj/item/reagent_containers/spray/pepper/Initialize(mapload)
	. = ..()
	reagents.add_reagent("condensedcapsaicin", volume)

/obj/item/reagent_containers/spray/pepper/examine(mob/user, dist)
	. = ..()
	. += "The safety is [safety ? "on" : "off"]."

/obj/item/reagent_containers/spray/pepper/attack_self(mob/user, datum/event_args/actor/actor)
	safety = !safety
	to_chat(usr, "<span class = 'notice'>You switch the safety [safety ? "on" : "off"].</span>")

/obj/item/reagent_containers/spray/pepper/Spray_at(atom/A as mob|obj)
	if(safety)
		to_chat(usr, "<span class = 'warning'>The safety is on!</span>")
		return
	. = ..()

/obj/item/reagent_containers/spray/waterflower
	name = "water flower"
	desc = "A seemingly innocent sunflower...with a twist."
	icon = 'icons/obj/device.dmi'
	icon_state = "sunflower"
	item_state = "sunflower"
	amount_per_transfer_from_this = 1
	possible_transfer_amounts = null
	volume = 10
	drop_sound = 'sound/items/drop/herb.ogg'
	pickup_sound = 'sound/items/pickup/herb.ogg'
	materials_base = list(MAT_PLASTIC = 500)

/obj/item/reagent_containers/spray/waterflower/Initialize(mapload)
	. = ..()
	reagents.add_reagent("water", volume)

/obj/item/reagent_containers/spray/chemsprayer
	name = "chem sprayer"
	desc = "A utility used to spray large amounts of reagent in a given area."
	icon = 'icons/obj/gun/launcher.dmi'
	icon_state = "chemsprayer"
	item_state = "chemsprayer"
	throw_force = 3
	w_class = WEIGHT_CLASS_NORMAL
	possible_transfer_amounts = null
	volume = 600
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_ENGINEERING = 3)
	materials_base = list(MAT_STEEL = 5000, MAT_GLASS = 1000)

/obj/item/reagent_containers/spray/chemsprayer/Spray_at(atom/A as mob|obj)
	var/direction = get_dir(src, A)
	var/turf/T = get_turf(A)
	var/turf/T1 = get_step(T,turn(direction, 90))
	var/turf/T2 = get_step(T,turn(direction, -90))
	var/list/the_targets = list(T, T1, T2)

	for(var/a = 1 to 3)
		spawn(0)
			if(reagents.total_volume < 1) break
			var/obj/effect/water/chempuff/D = new/obj/effect/water/chempuff(get_turf(src))
			var/turf/my_target = the_targets[a]
			D.create_reagents(amount_per_transfer_from_this)
			if(!src)
				return
			playsound(src.loc, 'sound/effects/spray2.ogg', 50, 1, -6)
			reagents.trans_to_obj(D, amount_per_transfer_from_this)
			D.set_color()
			D.set_up(my_target, rand(6, 8), 2)
	return

/obj/item/reagent_containers/spray/plantbgone
	name = "Plant-B-Gone"
	desc = "Kills those pesky weeds!"
	icon = 'icons/obj/hydroponics_machines.dmi'
	icon_state = "plantbgone"
	item_state = "plantbgone"
	volume = 100
	materials_base = list(MAT_PLASTIC = 1000)

/obj/item/reagent_containers/spray/plantbgone/Initialize(mapload)
	. = ..()
	reagents.add_reagent("plantbgone", volume)

/obj/item/reagent_containers/spray/pestbgone
	name = "Pest-B-Gone"
	desc = "Rated for pests up to 1:3 scale!"
	icon = 'icons/obj/hydroponics_machines.dmi'
	icon_state = "pestbgone"
	item_state = "pestbgone"
	volume = 100
	materials_base = list(MAT_PLASTIC = 1000)

/obj/item/reagent_containers/spray/pestbgone/Initialize(mapload)
	. = ..()
	reagents.add_reagent("pestbgone", volume)

/obj/item/reagent_containers/spray/windowsealant
	name = "Krak-b-gone"
	desc = "A spray bottle of silicate sealant for rapid window repair."
	icon = 'icons/obj/items_vr.dmi'
	icon_state = "windowsealant"
	item_state = "spraycan"
	possible_transfer_amounts = null
	volume = 80

/obj/item/reagent_containers/spray/windowsealant/Initialize(mapload)
	. = ..()
	reagents.add_reagent("silicate", 80)


/obj/item/reagent_containers/spray/spider/pepper
	name = "venom spray"
	desc = "A leather sack filled with venom and rigged  with bones to turn its contents in a spray."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "spiderspray"
	item_state = "pepperspray"
	possible_transfer_amounts = null
	volume = 15

/obj/item/reagent_containers/spray/spider/pepper/Initialize(mapload)
	. = ..()
	reagents.add_reagent("condensedcapsaicin_v", volume)

