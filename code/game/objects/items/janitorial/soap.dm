/datum/component/slippery/soap

/obj/item/soap
	name = "soap"
	desc = "A cheap bar of soap. Doesn't smell."
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "soap"
	atom_flags = NOCONDUCT
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = SLOT_HOLSTER
	throw_force = 0
	throw_speed = 4
	throw_range = 20

/obj/item/soap/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/slippery/soap)
	create_reagents(5)
	wet()

/obj/item/soap/proc/wet()
	reagents.add_reagent("cleaner", 5)

/obj/item/soap/pre_attack(atom/target, mob/user, clickchain_flags, list/params)
	//I couldn't feasibly  fix the overlay bugs caused by cleaning items we are wearing.
	//So this is a workaround. This also makes more sense from an IC standpoint. ~Carn
	if(user.client && (target in user.client.screen))
		to_chat(user, "<span class='notice'>You need to take that [target.name] off before cleaning it.</span>")
	else if(istype(target,/obj/effect/debris/cleanable/blood))
		to_chat(user, "<span class='notice'>You scrub \the [target.name] out.</span>")
		target.clean_blood()
		return	//Blood is a cleanable decal, therefore needs to be accounted for before all cleanable decals.
	else if(istype(target,/obj/effect/debris/cleanable))
		to_chat(user, "<span class='notice'>You scrub \the [target.name] out.</span>")
		qdel(target)
	else if(istype(target,/turf))
		to_chat(user, "<span class='notice'>You scrub \the [target.name] clean.</span>")
		var/turf/T = target
		T.clean(src, user)
	else if(istype(target,/obj/structure/sink))
		to_chat(user, "<span class='notice'>You wet \the [src] in the sink.</span>")
		wet()
	else
		to_chat(user, "<span class='notice'>You clean \the [target.name].</span>")
		target.clean_blood()
	return

/obj/item/soap/legacy_mob_melee_hook(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	if(target && user && ishuman(target) && ishuman(user) && !user.incapacitated() && user.zone_sel &&user.zone_sel.selecting == "mouth" )
		user.visible_message("<span class='danger'>\The [user] washes \the [target]'s mouth out with soap!</span>")
		playsound(src.loc, 'sound/items/soapmouth.ogg', 50, 1)
		user.setClickCooldownLegacy(DEFAULT_QUICK_COOLDOWN) //prevent spam
		return CLICKCHAIN_DO_NOT_PROPAGATE
	return ..()

/obj/item/soap/nanotrasen
	desc = "A Nanotrasen-brand bar of soap. Smells of phoron."
	icon_state = "soapnt"

/obj/item/soap/deluxe
	icon_state = "soapdeluxe"

/obj/item/soap/deluxe/Initialize(mapload)
	. = ..()
	desc = "A deluxe Waffle Co. brand bar of soap. Smells of [pick("lavender", "vanilla", "strawberry", "chocolate" ,"space")]."

/obj/item/soap/syndie
	desc = "An untrustworthy bar of soap. Smells of fear."
	icon_state = "soapsyndie"

/obj/item/soap/primitive
	desc = "Lye and fat processed into a solid state. This hand crafted bar is unscented and uneven."
	icon_state = "soapprim"
