//////////////////////////////////////////
// Generic Tajara Weapons
///////////////////////////////////////////
/* Notes on Tajara Firearms:
The Tajara history is more or less that a fuedal society with early 19th century technology was contacted by aliens with all their new dangerous ideas and cased \
munition firearm technology (way better then muskets). The resulting civil war was extremely devastating and no one won, as a result Tajara weapons technology is
extremely varied ranging from 19th century crude to modern and post modern automatics. */


/obj/item/gun/projectile/ballistic/contender/taj
	name = "Adhomai pocket rifle"
	desc = "A simple Adhomai Hand Cannon. Its simple design dates back to the civil war where hand cannons like it were rushed into service to counter the massive arms shortage \
	the many factions faced at the start of the war. Since then various local manufacturers have refined the design into a mainstay backup weapon of solider and civilian alike."
	icon = 'icons/content/factions/tajara/items/guns/taj_pockrifle.dmi'
	inhand_icon = 'icons/content/factions/tajara/items/guns/taj_pockrifle.dmi'
	render_use_legacy_by_default = FALSE

/obj/item/gun/projectile/ballistic/contender/taj/a44
	caliber = /datum/ammo_caliber/a44
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a44

/obj/item/gun/projectile/ballistic/contender/taj/a762
	caliber = /datum/ammo_caliber/a7_62mm
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a7_62mm

/obj/item/gun/projectile/ballistic/shotgun/pump/rifle/taj/sawn
	name = "Adhomai obrez"
	desc = "The civil war on Adhomai saw countless gun manufacturers pumping out cheap bolt action rifles. During the general chaos of the civil \
	war many of these rifles were sawn down by revolutionaries and bandits who couldn't get their hands on proper pistols. Even as technology \
	on Adhomai has moved past bolt actions these guns remain plentiful among the criminal underworld and other nefarious groups."
	icon_state = "sawnrifle"
	item_state = "sawnrifle"
	recoil = 2
	accuracy = -15
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	render_use_legacy_by_default = FALSE

/obj/item/gun/projectile/ballistic/musket/taj
	name = "Adhomian musket"
	desc = "For the Tajara, the era of black powder warfare was not all that long ago. As result many genuine Adhomian muskets both reproduction and \
	even genuine, are often seen in the hands of Tajaran civilians and weapons collectors. They are especially prominent in many Tajaran states where \
	strict firearms laws prevent the ownership of modern weapons."
	icon = 'icons/content/factions/tajara/items/guns/taj_musket.dmi'
	inhand_icon = 'icons/content/factions/tajara/items/guns/taj_musket.dmi'
	icon_state = "musket"
	item_state = "musket"
	wielded_item_state = "musket-wielded"
	render_use_legacy_by_default = FALSE


/obj/item/gun/projectile/ballistic/shotgun/doublebarrel/taj
	name = "Adhomai double-barrel"
	desc = "Shotguns were not widely adopted on Adhomai until after the civil wars. Adhomai's militaries directed the development of homemade automatics \
	and submachine guns as a solution to close quarters fighting. More recently, civilian manufacturers have begun making double barrels like these to sell \
	to wealthier hunters and merchants. With its limited capacity, shotguns like these can be found even in some of the more high-security states of Adhomai."
	icon = 'icons/content/factions/tajara/items/guns/taj_doublebarrel.dmi'
	inhand_icon = 'icons/content/factions/tajara/items/guns/taj_doublebarrel.dmi'
	icon_state = "shotgun"
	item_state = "shotgun"
	wielded_item_state = "shotgun-wielded"

	internal_magazine_preload_ammo = /obj/item/ammo_casing/a12g

/obj/item/gun/projectile/ballistic/shotgun/doublebarrel/taj/attackby(var/obj/item/A as obj, mob/user as mob)
	if(istype(A, /obj/item/surgical/circular_saw) || istype(A, /obj/item/melee/transforming/energy) || istype(A, /obj/item/pickaxe/plasmacutter))
		to_chat(user, "<span class='notice'>You begin to shorten the barrel of \the [src].</span>")
		if(get_ammo_remaining())
			// todo: what happens if it's inside a container?
			user.visible_message("<span class='danger'>The shotgun goes off!</span>", "<span class='danger'>The shotgun goes off in your face!</span>")
			start_firing_cycle_async(src, rand(0, 360), firemode = firemodes[2])
			return
		if(do_after(user, 30))	//SHIT IS STEALTHY EYYYYY
			icon_state = "sawnshotgun"
			item_state = "sawnshotgun"
			set_weight_class(WEIGHT_CLASS_NORMAL)
			damage_force = 5
			slot_flags &= ~SLOT_BACK	//you can't sling it on your back
			slot_flags |= (SLOT_BELT|SLOT_HOLSTER) //but you can wear it on your belt (poorly concealed under a trenchcoat, ideally) - or in a holster, why not.
			name = "Adhomai sawn-off shotgun"
			desc = "Omarrr's coming!"
			to_chat(user, "<span class='warning'>You shorten the barrel of \the [src]!</span>")
	else
		..()

/obj/item/gun/projectile/ballistic/shotgun/doublebarrel/sawn/taj
	name = "Adhomai sawn-off shotgun"
	desc = "The moment Tajaran criminals and bandits got their hands on shotguns, their first instincts were to cut them down like they had done for their \
	obrez rifles. They quickly earned a reputation among Tajaran authorities, and a result, it's illegal to own shotguns under a certain length almost everywhere \
	on Adhomai, an impressive feat considering how diverse in ideology its nation states are."
	icon = 'icons/content/factions/tajara/items/guns/taj_doublebarrel.dmi'
	inhand_icon = 'icons/content/factions/tajara/items/guns/taj_doublebarrel.dmi'
	icon_state = "sawnshotgun"
	item_state = "sawnshotgun"

