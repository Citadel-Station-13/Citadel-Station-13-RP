//////////////////////////////////////////
// People's Republic of Adhomai (PRA) Firearms
///////////////////////////////////////////
/* Notes on PRA Firearms:
The People's Republic of Adhomai (PRA) is a authoritarian socialist regime reminiscent of the Stalin era Soviet Union.
The creation of the PRA was a result of the rapid social changes on Adhomai brought about by contact with aliens namely humans.
Despite the successes of the counter revolutions they are still the largest and most advanced Tajara nation. Though they are
signifcantly behind human nations when it comes to energy weapons they aren't far behind in terms of ballistics.
They also share idealogical and economic connections to the Interplanetary Worker's League one of the most powerful
members of the Orion Confederation, who have greatly influenced their weapons development. PRA weapons therefore
are heavily influenced by Soviet futurism and other depictions of future soviet/socialist states.*/

///////////////////
//One Handed
///////////////////

/obj/item/gun/projectile/ballistic/colt/taj
	name = "Adhomai Pistol"
	desc = "The Adar'Mazy pistol, produced by the Hadii-Wrack group. This pistol is the primary sidearm for low ranking officers and \
	officals in the People's Republic of Adhomai."
	icon = 'icons/content/factions/tajara/items/guns/taj_colt.dmi'
	inhand_icon = 'icons/content/factions/tajara/items/guns/taj_colt.dmi'
	icon_state = "gun"
	render_use_legacy_by_default = FALSE


/obj/item/gun/projectile/ballistic/deagle/taj
	name = "Adhomai Hand Cannon"
	desc = "The Nal'dor heavy pistol, a powerful Hadii-Wrack group handcannon that has gained an infamous reputation through its use by \
	Commissars of the People's Republic of Adhomai."
	icon = 'icons/content/factions/tajara/items/guns/taj_deagle.dmi'
	inhand_icon = 'icons/content/factions/tajara/items/guns/taj_deagle.dmi'
	render_use_legacy_by_default = FALSE

///////////////////
//Two Handed
///////////////////

/obj/item/gun/projectile/ballistic/automatic/automat/taj
	name = "Adhomai automat"
	desc = "The Hadii-Wrack Avtomat, is an aging internal magazine automatic rifle of the People's Republic of Adhomai's Grand People's Army \
	whose long and storied service life is coming to an end as it is phased out in favor of more modern automatics."
	icon = 'icons/content/factions/tajara/items/guns/taj_automat.dmi'
	inhand_icon = 'icons/content/factions/tajara/items/guns/taj_automat.dmi'
	wielded_item_state = "automat-wielded"
	render_use_legacy_by_default = FALSE

/obj/item/gun/projectile/ballistic/automatic/k25/taj
	name = "Tajara Service Rifle"
	desc = "The Hadii-Wrack Type 19 Avtomat, a licensed copy of the Interplanetary Worker's League K25 service rifle and new standard battle rifle \
	of the People's Republic of Adhomai. The firearm has become a symbol of the growing collaboration between the Worker's League and People's Republic \
	a cooperation that unsettles many with their nominal superiors in the Orion Confederation and Confederate Commonwealth."
	icon = 'icons/content/factions/tajara/items/guns/taj_k25.dmi'
	inhand_icon = 'icons/content/factions/tajara/items/guns/taj_k25.dmi'
	wielded_item_state = "k25-wielded"
	render_use_legacy_by_default = FALSE

///////////////////
//Energy
///////////////////

/obj/item/gun/projectile/energy/frontier/taj
	name = "Adhomai crank laser"
	desc = "The \"Icelance\" crank charged laser rifle, produced by the Hadii-Wrack group for the People's Republic of Adhomai's Grand People's Army."
	icon = 'icons/content/factions/tajara/items/guns/taj_frontier.dmi'
	inhand_icon = 'icons/content/factions/tajara/items/guns/taj_frontier.dmi'
	icon_state = "phaser"
	item_state = "phaser"
	wielded_item_state = "phaser-taj"
	charge_cost = POWER_CELL_CAPACITY_WEAPON / 3
	phase_power = POWER_CELL_CAPACITY_WEAPON / 3

	projectile_type = /obj/projectile/beam/midlaser


	firemodes = list()

/obj/item/gun/projectile/energy/frontier/taj/on_attack_hand(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	if(!clickchain.performer.inventory.count_empty_hands())
		return
	var/mob/user = clickchain.performer
	if(recharging)
		return
	. |= CLICKCHAIN_DID_SOMETHING
	recharging = 1
	update_icon()
	user.visible_message("<span class='notice'>[user] begins to turn the crank of \the [src].</span>", \
						"<span class='notice'>You begins to turn the crank of \the [src].</span>")
	while(recharging)
		if(!do_after(user, 10, src))
			break
		playsound(get_turf(src),'sound/items/change_drill.ogg',25,1)
		if(obj_cell_slot?.cell?.give(phase_power) < phase_power)
			break

	recharging = 0
	update_icon()
