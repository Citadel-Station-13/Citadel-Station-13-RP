//replaces our stun baton code with /tg/station's code
/obj/item/melee/baton
	name = "stunbaton"
	desc = "A stun baton for incapacitating people with."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "stunbaton"
	item_state = "baton"
	slot_flags = SLOT_BELT
	force = 15
	sharp = 0
	edge = 0
	throw_force = 7
	flags = NOCONDUCT
	w_class = ITEMSIZE_NORMAL
	drop_sound = 'sound/items/drop/metalweapon.ogg'
	pickup_sound = 'sound/items/pickup/metalweapon.ogg'
	origin_tech = list(TECH_COMBAT = 2)
	attack_verb = list("beaten")
	var/lightcolor = "#FF6A00"
	var/stunforce = 0
	var/agonyforce = 60
	var/status = FALSE		//whether the thing is on or not
	var/obj/item/cell/bcell = null
	var/hitcost = 240
	var/use_external_power = FALSE //only used to determine if it's a cyborg baton
	var/integrated_cell = FALSE

/obj/item/melee/baton/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/melee/baton/get_cell()
	return bcell

/obj/item/melee/baton/suicide_act(mob/user)
	var/datum/gender/TU = GLOB.gender_datums[user.get_visible_gender()]
	user.visible_message("<span class='suicide'>\The [user] is putting the live [name] in [TU.his] mouth! It looks like [TU.he] [TU.is] trying to commit suicide.</span>")
	return (FIRELOSS)

/obj/item/melee/baton/loaded/Initialize(mapload)
	. = ..()
	bcell = new/obj/item/cell/device/weapon(src)
	update_icon()

/obj/item/melee/baton/proc/deductcharge(var/chrgdeductamt)
	if(status)		//Only deducts charge when it's on
		if(bcell)
			if(bcell.checked_use(chrgdeductamt))
				return 1
			else
				return 0
	return null

/obj/item/melee/baton/proc/powercheck(var/chrgdeductamt)
	if(bcell)
		if(bcell.charge < chrgdeductamt)
			status = FALSE
			update_icon()

/obj/item/melee/baton/update_icon()
	if(status)
		icon_state = "[initial(icon_state)]_active"
	else if(!bcell)
		icon_state = "[initial(icon_state)]_nocell"
	else
		icon_state = "[initial(icon_state)]"

	if(icon_state == "[initial(icon_state)]_active")
		set_light(2, 1, lightcolor)
	else
		set_light(0)

/obj/item/melee/baton/examine(mob/user)
	. = ..()
	if(bcell)
		. += "<span class='notice'>The [src] is [round(bcell.percent())]% charged.</span>"
	if(!bcell)
		. += "<span class='warning'>The [src] does not have a power source installed.</span>"

/obj/item/melee/baton/attackby(obj/item/W, mob/user)
	if(use_external_power)
		return
	if(istype(W, /obj/item/cell))
		if(istype(W, /obj/item/cell/device))
			if(!bcell)
				if(!user.attempt_insert_item_for_installation(W, src))
					return
				bcell = W
				to_chat(user, "<span class='notice'>You install a cell in [src].</span>")
				update_icon()
			else
				to_chat(user, "<span class='notice'>[src] already has a cell.</span>")
		else
			to_chat(user, "<span class='notice'>This cell is not fitted for [src].</span>")

/obj/item/melee/baton/attack_hand(mob/user as mob)
	if(user.get_inactive_held_item() == src)
		if(bcell && !integrated_cell)
			bcell.update_icon()
			user.put_in_hands(bcell)
			bcell = null
			to_chat(user, "<span class='notice'>You remove the cell from the [src].</span>")
			status = FALSE
			update_icon()
			return
		..()
	else
		return ..()

/obj/item/melee/baton/attack_self(mob/user)
	if(use_external_power)
		//try to find our power cell
		var/mob/living/silicon/robot/R = loc
		if (istype(R))
			bcell = R.cell
	if(bcell && bcell.charge > hitcost)
		status = !status
		to_chat(user, "<span class='notice'>[src] is now [status ? "on" : "off"].</span>")
		playsound(loc, "sparks", 75, 1, -1)
		update_icon()
	else
		status = 0
		if(!bcell)
			to_chat(user, "<span class='warning'>[src] does not have a power source!</span>")
		else
			to_chat(user, "<span class='warning'>[src] is out of charge.</span>")
	add_fingerprint(user)

/obj/item/melee/baton/attack(mob/M, mob/user)
	if(status && (MUTATION_CLUMSY in user.mutations) && prob(50))
		to_chat(user, "<span class='danger'>You accidentally hit yourself with the [src]!</span>")
		user.Weaken(30)
		deductcharge(hitcost)
		return
	deductcharge(hitcost)
	return ..()

/obj/item/melee/baton/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	if(isrobot(target))
		return ..()

	var/agony = agonyforce
	var/stun = stunforce
	var/obj/item/organ/external/affecting = null
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		affecting = H.get_organ(hit_zone)

	if(user.a_intent == INTENT_HARM)
		. = ..()
		//whacking someone causes a much poorer electrical contact than deliberately prodding them.
		agony *= 0.5
		stun *= 0.5
	else if(!status)
		if(affecting)
			target.visible_message("<span class='warning'>[target] has been prodded in the [affecting.name] with [src] by [user]. Luckily it was off.</span>")
		else
			target.visible_message("<span class='warning'>[target] has been prodded with [src] by [user]. Luckily it was off.</span>")
	else
		if(affecting)
			target.visible_message("<span class='danger'>[target] has been prodded in the [affecting.name] with [src] by [user]!</span>")
		else
			target.visible_message("<span class='danger'>[target] has been prodded with [src] by [user]!</span>")
		playsound(loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)

	//stun effects
	if(status)
		target.stun_effect_act(stun, agony, hit_zone, src)
		msg_admin_attack("[key_name(user)] stunned [key_name(target)] with the [src].")

		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			H.forcesay(hit_appends)
	powercheck(hitcost)

/obj/item/melee/baton/emp_act(severity)
	if(bcell)
		bcell.emp_act(severity)	//let's not duplicate code everywhere if we don't have to please.
	..()

//secborg stun baton module
/obj/item/melee/baton/robot
	hitcost = 500
	use_external_power = TRUE

//Makeshift stun baton. Replacement for stun gloves.
/obj/item/melee/baton/cattleprod
	name = "stunprod"
	desc = "An improvised stun baton."
	icon_state = "stunprod"
	item_state = "prod"
	force = 3
	throw_force = 5
	stunforce = 0
	agonyforce = 60	//same force as a stunbaton, but uses way more charge.
	hitcost = 2500
	attack_verb = list("poked")
	slot_flags = null

/obj/item/melee/baton/cattleprod/attackby(obj/item/W, mob/user)
	if(use_external_power)
		return
	if(istype(W, /obj/item/cell))
		if(!istype(W, /obj/item/cell/device))
			if(!bcell)
				if(!user.attempt_insert_item_for_installation(W, src))
					return
				bcell = W
				to_chat(user, "<span class='notice'>You install a cell in [src].</span>")
				update_icon()
			else
				to_chat(user, "<span class='notice'>[src] already has a cell.</span>")
		else
			to_chat(user, "<span class='notice'>This cell is not fitted for [src].</span>")

	if(istype(W, /obj/item/ore/bluespace_crystal))
		if(!bcell)
			var/obj/item/ore/bluespace_crystal/BSC = W
			var/obj/item/melee/baton/cattleprod/teleprod/S = new /obj/item/melee/baton/cattleprod/teleprod
			qdel(src)
			qdel(BSC)
			user.put_in_hands(S)
			to_chat(user, "<span class='notice'>You place the bluespace crystal firmly into the igniter.</span>")
		else
			user.visible_message("<span class='warning'>You can't put the crystal onto the stunprod while it has a power cell installed!</span>")

/obj/item/melee/baton/get_description_interaction()
	var/list/results = list()

	if(bcell)
		results += "[desc_panel_image("offhand")]to remove the weapon cell."
	else
		results += "[desc_panel_image("weapon cell")]to add a new weapon cell."

	results += ..()

	return results

/obj/item/melee/baton/cattleprod/teleprod
	name = "teleprod"
	desc = "An improvised stun baton with a bluespace crystal attached to the tip."
	icon_state = "teleprod"
	item_state = "prod"
	force = 3
	throw_force = 5
	stunforce = 0
	agonyforce = 60	//same force as a stunbaton, but uses way more charge.
	hitcost = 2500
	attack_verb = list("poked")
	slot_flags = null

/obj/item/melee/baton/cattleprod/teleprod/apply_hit_effect(mob/living/L, mob/living/carbon/user, shoving = FALSE)//handles making things teleport when hit
	. = ..()
	if(!. || L.anchored)
		return
	do_teleport(L, get_turf(L), 15)


// Rare version of a baton that causes lesser lifeforms to really hate the user and attack them.
/obj/item/melee/baton/shocker
	name = "shocker"
	desc = "A device that appears to arc electricity into a target to incapacitate or otherwise hurt them, similar to a stun baton.  It looks inefficent."
	description_info = "Hitting a lesser lifeform with this while it is on will compel them to attack you above other nearby targets.  Otherwise \
	it works like a regular stun baton, just less effectively."
	icon_state = "shocker"
	force = 10
	throw_force = 5
	agonyforce = 25 // Less efficent than a regular baton.
	attack_verb = list("poked")

/obj/item/melee/baton/shocker/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	..(target, user, hit_zone)
	if(status && target.has_AI())
		target.taunt(user)

// Borg version, for the lost module.
/obj/item/melee/baton/shocker/robot
	use_external_power = TRUE

/obj/item/melee/baton/stunsword
	name = "stunsword"
	desc = "Not actually sharp, this sword is functionally identical to its baton counterpart."
	icon_state = "stunsword"
	item_state = "baton"

/obj/item/melee/baton/loaded/mini
	name = "Personal Defense Baton"
	desc = "A smaller, more potent version of a hand-held tazer, one zap and the target is sure to be on the ground, and the <b>integrated</b> cell empty. Standard issue to Command staff, indentured sex workers and anyone else who might get mobbed by dissatisfied clientele. Do not lick."
	icon_state = "mini_baton"
	item_state = "mini_baton"
	w_class = ITEMSIZE_SMALL
	force = 5
	stunforce = 5
	throw_force = 2
	agonyforce = 120	//one-hit
	integrated_cell = TRUE
	hitcost = 1150

/obj/item/melee/baton/loaded/mini/Initialize(mapload)
	. = ..()
	if(!bcell)
		bcell = new/obj/item/cell/device/weapon(src)
	update_icon()

/obj/item/melee/baton/loaded/mini/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	var/mob/living/carbon/human/H
	if(ishuman(target))
		H = target
		if(!status)
			..(target, user, hit_zone)
			return
	else
		return

	powercheck(hitcost)
	if(!status)
		return

	playsound(loc, 'sound/effects/lightningshock.ogg', 50, 1, -1)
	if(prob(10))
		playsound(loc, 'sound/effects/shocked_marv.ogg', 50, 1, -1)	//Source: Home Alone 2

	var/init_px = H.pixel_x
	var/shake_dir = pick(-1, 1)
	animate(H, transform=turn(matrix(), 16*shake_dir), pixel_x=init_px + 4*shake_dir, time=1)
	animate(transform=null, pixel_x=init_px, time=6, easing=ELASTIC_EASING)

	target.stun_effect_act(stunforce, agonyforce, hit_zone, src)
	msg_admin_attack("[key_name(user)] stunned [key_name(target)] with the [src].")

	deductcharge(hitcost)
