/obj/structure/toilet
	name = "toilet"
	desc = "The HT-451, a torque rotation-based, waste disposal unit for small matter. This one seems remarkably clean."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "toilet00"
	density = 0
	anchored = 1
	var/open = 0			//if the lid is up
	var/cistern = 0			//if the cistern bit is open
	var/w_items = 0			//the combined w_class of all the items in the cistern
	var/mob/living/swirlie = null	//the mob being given a swirlie

/obj/structure/toilet/Initialize(mapload)
	. = ..()
	open = round(rand(0, 1))
	update_icon()

/obj/structure/toilet/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	if(swirlie)
		usr.setClickCooldownLegacy(user.get_attack_speed_legacy())
		usr.visible_message("<span class='danger'>[user] slams the toilet seat onto [swirlie.name]'s head!</span>", "<span class='notice'>You slam the toilet seat onto [swirlie.name]'s head!</span>", "You hear reverberating porcelain.")
		swirlie.adjustBruteLoss(5)
		return

	if(cistern && !open)
		if(!contents.len)
			to_chat(user, "<span class='notice'>The cistern is empty.</span>")
			return
		else
			var/obj/item/I = pick(contents)
			if(ishuman(user))
				user.put_in_hands(I)
			else
				I.forceMove(get_turf(src))
			to_chat(user, "<span class='notice'>You find \an [I] in the cistern.</span>")
			w_items -= I.w_class
			return

	open = !open
	update_icon()

/obj/structure/toilet/update_icon_state()
	icon_state = "toilet[open][cistern]"
	return ..()

/obj/structure/toilet/attackby(obj/item/I as obj, mob/living/user as mob)
	if(I.is_crowbar())
		. = CLICKCHAIN_DO_NOT_PROPAGATE
		to_chat(user, "<span class='notice'>You start to [cistern ? "replace the lid on the cistern" : "lift the lid off the cistern"].</span>")
		playsound(src, 'sound/effects/stonedoor_openclose.ogg', 50, 1)
		if(do_after(user, 30))
			user.visible_message("<span class='notice'>[user] [cistern ? "replaces the lid on the cistern" : "lifts the lid off the cistern"]!</span>", "<span class='notice'>You [cistern ? "replace the lid on the cistern" : "lift the lid off the cistern"]!</span>", "You hear grinding porcelain.")
			cistern = !cistern
			update_icon()
			return

	if(istype(I, /obj/item/grab))
		. = CLICKCHAIN_DO_NOT_PROPAGATE
		user.setClickCooldownLegacy(user.get_attack_speed_legacy(I))
		var/obj/item/grab/G = I

		if(isliving(G.affecting))
			var/mob/living/GM = G.affecting

			if(G.state>1)
				if(!GM.loc == get_turf(src))
					to_chat(user, "<span class='notice'>[GM.name] needs to be on the toilet.</span>")
					return
				if(open && !swirlie)
					user.visible_message("<span class='danger'>[user] starts to give [GM.name] a swirlie!</span>", "<span class='notice'>You start to give [GM.name] a swirlie!</span>")
					swirlie = GM
					if(do_after(user, 30, GM))
						user.visible_message("<span class='danger'>[user] gives [GM.name] a swirlie!</span>", "<span class='notice'>You give [GM.name] a swirlie!</span>", "You hear a toilet flushing.")
						if(!GM.internal)
							GM.adjustOxyLoss(5)
					swirlie = null
				else
					user.visible_message("<span class='danger'>[user] slams [GM.name] into the [src]!</span>", "<span class='notice'>You slam [GM.name] into the [src]!</span>")
					GM.adjustBruteLoss(5)
			else
				to_chat(user, "<span class='notice'>You need a tighter grip.</span>")

	if(cistern && !istype(user,/mob/living/silicon/robot)) //STOP PUTTING YOUR MODULES IN THE TOILET.
		. = CLICKCHAIN_DO_NOT_PROPAGATE
		if(I.w_class > 3)
			to_chat(user, "<span class='notice'>\The [I] does not fit.</span>")
			return
		if(w_items + I.w_class > 5)
			to_chat(user, "<span class='notice'>The cistern is full.</span>")
			return
		if(!user.attempt_insert_item_for_installation(I, src))
			return
		w_items += I.w_class
		to_chat(user, "You carefully place \the [I] into the cistern.")
		return

	return ..()
