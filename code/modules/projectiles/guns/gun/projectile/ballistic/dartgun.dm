/obj/item/gun/projectile/ballistic/dartgun
	name = "dart gun"
	desc = "Zeng-Hu Pharmaceutical's entry into the arms market, the Z-H P Artemis is a gas-powered dart gun capable of delivering chemical cocktails swiftly across short distances."
	description_info = "The dart gun is capable of storing three beakers. In order to use the dart gun, you must first use it in-hand to open its mixing UI. The dart-gun will only draw from beakers with mixing enabled. If multiple are enabled, the gun will draw from them in equal amounts."
	description_antag = "The dart gun is silenced, but cannot pierce thick clothing such as armor or space-suits, and thus is better for use against soft targets, or commonly exposed areas of the body."
	icon_state = "dartgun-empty"
	base_icon_state = "dartgun"
	item_state = null
	origin_tech = list(TECH_COMBAT = 7, TECH_MATERIAL = 6, TECH_BIO = 5, TECH_MAGNET = 2, TECH_ILLEGAL = 3)

	caliber = /datum/ammo_caliber/dart
	fire_sound = 'sound/weapons/empty.ogg'
	fire_sound_text = "a metallic click"
	recoil = 0
	silenced = 1
	magazine_preload = /obj/item/ammo_magazine/chemdart
	magazine_restrict = /obj/item/ammo_magazine/chemdart
	magazine_auto_eject = FALSE
	var/default_magazine_casing_count = 5
	var/track_magazine = 1

	var/list/beakers = list() //All containers inside the gun.
	var/list/mixing = list() //Containers being used for mixing.
	var/max_beakers = 3
	var/dart_reagent_amount = 15
	var/container_type = /obj/item/reagent_containers/glass/beaker
	var/list/starting_chems = null

/obj/item/gun/projectile/ballistic/dartgun/Initialize(mapload)
	. = ..()
	if(starting_chems)
		for(var/chem in starting_chems)
			var/obj/B = new container_type(src)
			B.reagents.add_reagent(chem, 60)
			beakers += B
	update_icon()

/obj/item/gun/projectile/ballistic/dartgun/update_icon_state()
	. = ..()
	if(!magazine)
		icon_state = "[base_icon_state]-empty"
		return 1
	if(track_magazine)
		if(magazine.get_amount_remaining() == 0)
			icon_state = "[base_icon_state]-0"
		else if(magazine.get_amount_remaining() > default_magazine_casing_count)
			icon_state = "[base_icon_state]-[default_magazine_casing_count]"
		else
			icon_state = "[base_icon_state]-[magazine.get_amount_remaining()]"
		return 1
	else
		icon_state = "[base_icon_state]"

/obj/item/gun/projectile/ballistic/dartgun/consume_next_projectile(datum/gun_firing_cycle/cycle)
	. = ..()
	var/obj/projectile/bullet/chemdart/dart = .
	if(istype(dart))
		fill_dart(dart)

/obj/item/gun/projectile/ballistic/dartgun/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/reagent_containers/glass))
		if(!istype(I, container_type))
			to_chat(user, "<font color=#4F49AF>[I] doesn't seem to fit into [src].</font>")
			return
		if(beakers.len >= max_beakers)
			to_chat(user, "<font color=#4F49AF>[src] already has [max_beakers] beakers in it - another one isn't going to fit!</font>")
			return
		if(!user.attempt_insert_item_for_installation(I, src))
			return
		var/obj/item/reagent_containers/glass/beaker/B = I
		beakers += B
		to_chat(user, "<font color=#4F49AF>You slot [B] into [src].</font>")
		updateUsrDialog()
		return CLICKCHAIN_DO_NOT_PROPAGATE
	return ..()

//fills the given dart with reagents
/obj/item/gun/projectile/ballistic/dartgun/proc/fill_dart(var/obj/projectile/bullet/chemdart/dart)
	if(mixing.len)
		var/mix_amount = dart.reagent_amount/mixing.len
		for(var/obj/item/reagent_containers/glass/beaker/B in mixing)
			B.reagents.trans_to_obj(dart, mix_amount)

/obj/item/gun/projectile/ballistic/dartgun/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	user.set_machine(src)
	var/dat = "<b>[src] mixing control:</b><br><br>"

	if (beakers.len)
		var/i = 1
		for(var/obj/item/reagent_containers/glass/beaker/B in beakers)
			dat += "Beaker [i] contains: "
			if(B.reagents?.total_volume)
				for(var/datum/reagent/R in B.reagents.get_reagent_datums())
					dat += "<br>    [B.reagents.reagent_volumes[R.id]] units of [R.name], "
				if (check_beaker_mixing(B))
					dat += "<A href='?src=\ref[src];stop_mix=[i]'><font color='green'>Mixing</font></A> "
				else
					dat += "<A href='?src=\ref[src];mix=[i]'><font color='red'>Not mixing</font></A> "
			else
				dat += "nothing."
			dat += " \[<A href='?src=\ref[src];eject=[i]'>Eject</A>\]<br>"
			i++
	else
		dat += "There are no beakers inserted!<br><br>"

	if(magazine)
		if(magazine.get_amount_remaining())
			dat += "The dart cartridge has [magazine.get_amount_remaining()] shots remaining."
		else
			dat += "<font color='red'>The dart cartridge is empty!</font>"
		dat += " \[<A href='?src=\ref[src];eject_cart=1'>Eject</A>\]"

	user << browse(HTML_SKELETON(dat), "window=dartgun")
	onclose(user, "dartgun", src)

/obj/item/gun/projectile/ballistic/dartgun/proc/check_beaker_mixing(var/obj/item/B)
	if(!mixing || !beakers)
		return 0
	for(var/obj/item/M in mixing)
		if(M == B)
			return 1
	return 0

/obj/item/gun/projectile/ballistic/dartgun/Topic(href, href_list)
	if(..()) return 1
	src.add_fingerprint(usr)
	if(href_list["stop_mix"])
		var/index = text2num(href_list["stop_mix"])
		if(index <= beakers.len)
			for(var/obj/item/M in mixing)
				if(M == beakers[index])
					mixing -= M
					break
	else if (href_list["mix"])
		var/index = text2num(href_list["mix"])
		if(index <= beakers.len)
			mixing += beakers[index]
	else if (href_list["eject"])
		var/index = text2num(href_list["eject"])
		if(index <= beakers.len)
			if(beakers[index])
				var/obj/item/reagent_containers/glass/beaker/B = beakers[index]
				to_chat(usr, "You remove [B] from [src].")
				mixing -= B
				beakers -= B
				B.loc = get_turf(src)
	else if (href_list["eject_cart"])
		var/datum/event_args/actor/actor = new(usr)
		user_clickchain_unload(actor)
	src.updateUsrDialog()
	return

///Variants of the Dartgun and Chemdarts.///

/obj/item/gun/projectile/ballistic/dartgun/research
	name = "prototype dart gun"
	desc = "Zeng-Hu Pharmaceutical's entry into the arms market, the Z-H P Artemis is a gas-powered dart gun capable of delivering chemical cocktails swiftly across short distances. This one seems to be an early model with an NT stamp."
	description_info = "The dart gun is capable of storing two beakers. In order to use the dart gun, you must first use it in-hand to open its mixing UI. The dart-gun will only draw from beakers with mixing enabled. If multiple are enabled, the gun will draw from them in equal amounts."
	icon_state = "dartgun_sci-empty"
	base_icon_state = "dartgun_sci"
	magazine_preload = /obj/item/ammo_magazine/chemdart/small
	magazine_restrict = /obj/item/ammo_magazine/chemdart
	default_magazine_casing_count = 3
	max_beakers = 2
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 4, TECH_BIO = 4, TECH_MAGNET = 2, TECH_ILLEGAL = 1)

/obj/item/gun/projectile/ballistic/dartgun/tranq
	name = "tranquilizer gun"
	desc = "A gas-powered dart gun designed by the National Armory of Gaia. This gun is used primarily by United Federation special forces for Tactical Espionage missions. Don't forget your bandana."
	icon = 'icons/vore/custom_guns_vr.dmi'
	icon_state = "tranqgun"
	item_state = null

	fire_sound = 'sound/weapons/empty.ogg'
	fire_sound_text = "a metallic click"
	recoil = 0
	silenced = 1
	magazine_preload = /obj/item/ammo_magazine/chemdart
	magazine_restrict = /obj/item/ammo_magazine/chemdart
	magazine_auto_eject = FALSE
