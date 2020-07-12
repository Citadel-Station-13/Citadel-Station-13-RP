/obj/item/firing_pin
	name = "electronic firing pin"
	desc = "A small authentication device, to be inserted into a firearm receiver to allow operation. NT safety regulations require all new designs to incorporate one."
	icon = 'icons/obj/device.dmi'
	icon_state = "firing_pin"
	item_state = "pen"
	w_class = WEIGHT_CLASS_TINY
	attack_verb = list("poked")
	var/fail_message = "<span class='warning'>INVALID USER.</span>"
	var/selfdestruct = 0 // Explode when user check is failed.
	var/pin_irremovable = 0 // Cannot be replaced by any pin.
	var/obj/item/gun/gun
	var/emagged = 0

/obj/item/firing_pin/Initialize(newloc)
	. = ..()
	if(istype(newloc, /obj/item/gun))
		gun = newloc

/obj/item/firing_pin/Destroy()
	if(gun)
		gun.pin = null
	return ..()

/obj/item/firing_pin/afterattack(atom/target, mob/user, proximity_flag)
	. = ..()
	if(proximity_flag)
		if(istype(target, /obj/item/gun))
			var/obj/item/gun/G = target
			if(G.no_pin_required)
				return
			if(G.pin && !(G.pin.pin_irremovable))
				G.pin.forceMove(get_turf(G))
				G.pin.gun_remove(G)
				to_chat(user, "<span class ='notice'>You remove [G]'s old pin. Rendering it unuseable in the process.</span>")
				gun_insert(user, G)
				return
			if(!G.pin)
				gun_insert(user, G)
				return
			else
				to_chat(user, "<span class ='notice'>This firearm already has a firing pin installed.</span>")

/obj/item/firing_pin/proc/gun_insert(mob/living/user, obj/item/gun/G)
	user.drop_item()
	forceMove(G)
	G.pin = src
	to_chat(user, "<span class ='notice'>You insert [src] into [G].</span>")
	return

/obj/item/firing_pin/proc/gun_remove(obj/item/gun/G)
	G.pin = null
	qdel(src)
	return

/obj/item/firing_pin/proc/pin_auth(mob/living/user)
	return TRUE

/obj/item/firing_pin/proc/auth_fail(mob/living/user)
	if(user)
		user.show_message(fail_message, 2)
	if(selfdestruct)
		if(user)
			user.show_message("<span class='danger'>SELF-DESTRUCTING...</span><br>", 2)
			to_chat(user, "<span class='userdanger'>[gun] explodes!</span>")
		explosion(get_turf(gun), -1, 0, 2, 3)
		if(gun)
			qdel(gun)

/obj/item/firing_pin/magic
	name = "magic crystal shard"
	desc = "A small enchanted shard which allows magical weapons to fire."

// Test pin, works only near firing range.
/obj/item/firing_pin/test_range
	name = "test-range firing pin"
	desc = "This safety firing pin allows weapons to be fired within proximity to a firing range."
	fail_message = "<span class='warning'>TEST RANGE CHECK FAILED.</span>"

/obj/item/firing_pin/test_range/pin_auth(mob/living/user)
	if(!istype(user))
		return FALSE
	if(istype(get_area(src), /area/rnd/research/testingrange) || istype(get_area(src), /area/security/range))
		return TRUE
	return FALSE


// Implant pin, checks for implant
/obj/item/firing_pin/implant
	name = "implant-keyed firing pin"
	desc = "This is a security firing pin which only authorizes users who are implanted with a certain device."
	fail_message = "<span class='warning'>IMPLANT CHECK FAILED.</span>"
	var/obj/item/implant/req_implant = null

/obj/item/firing_pin/implant/pin_auth(mob/living/carbon/human/user)
	if(user)
		for(var/obj/item/organ/external/E in user.organs)
			for(var/obj/item/implant/I in E.implants)
				if(I.implanted)
					if(istype(I,req_implant))
						return TRUE
	return FALSE

/obj/item/firing_pin/implant/mindshield
	name = "mindshield firing pin"
	desc = "This Security firing pin authorizes the weapon for only loyalty-implanted users."
	icon_state = "firing_pin_loyalty"
	req_implant = /obj/item/implant/loyalty

// DNA-keyed pin.
// When you want to keep your toys for yourself.
//A bit obsolete since "/obj/item/dnalockingchip" already exists. Ported from main, maybe it'll be useful in future.
/obj/item/firing_pin/dna
	name = "DNA-keyed firing pin"
	desc = "This is a DNA-locked firing pin which only authorizes one user. Attempt to fire once to DNA-link."
	icon_state = "firing_pin_dna"
	fail_message = "<span class='warning'>DNA CHECK FAILED.</span>"
	var/unique_enzymes = null

/obj/item/firing_pin/dna/afterattack(atom/target, mob/user, proximity_flag)
	. = ..()
	if(proximity_flag && iscarbon(target))
		var/mob/living/carbon/M = target
		if(M.dna && M.dna.unique_enzymes)
			unique_enzymes = M.dna.unique_enzymes
			to_chat(user, "<span class='notice'>DNA-LOCK SET.</span>")

/obj/item/firing_pin/dna/pin_auth(mob/living/carbon/user)
	if(user && user.dna && user.dna.unique_enzymes)
		if(user.dna.unique_enzymes == unique_enzymes)
			return TRUE
	return FALSE

/obj/item/firing_pin/dna/auth_fail(mob/living/carbon/user)
	if(!unique_enzymes)
		if(user && user.dna && user.dna.unique_enzymes)
			unique_enzymes = user.dna.unique_enzymes
			to_chat(user, "<span class='notice'>DNA-LOCK SET.</span>")
	else
		..()

/obj/item/firing_pin/dna/dredd
	desc = "This is a DNA-locked firing pin which only authorizes one user. Attempt to fire once to DNA-link. It has a small explosive charge on it."
	selfdestruct = TRUE

// Laser tag pins
/obj/item/firing_pin/tag
	name = "laser tag firing pin"
	desc = "A recreational firing pin, used in laser tag units to ensure users have their vests on."
	fail_message = "<span class='warning'>SUIT CHECK FAILED.</span>"
	var/obj/item/clothing/suit/suit_requirement = null
	var/tagcolor = ""

/obj/item/firing_pin/tag/pin_auth(mob/living/user)
	if(ishuman(user))
		var/mob/living/carbon/human/M = user
		if(istype(M.wear_suit, suit_requirement))
			return TRUE
	to_chat(user, "<span class='warning'>You need to be wearing [tagcolor] laser tag armor!</span>")
	return FALSE

/obj/item/firing_pin/tag/red
	name = "red laser tag firing pin"
	icon_state = "firing_pin_red"
	suit_requirement = /obj/item/clothing/suit/redtag
	tagcolor = "red"

/obj/item/firing_pin/tag/blue
	name = "blue laser tag firing pin"
	icon_state = "firing_pin_blue"
	suit_requirement = /obj/item/clothing/suit/bluetag
	tagcolor = "blue"

// Explorer Firing Pin- Prevents use on station Z-Level, so it's justifiable to give Explorers guns that don't suck.
/obj/item/firing_pin/explorer
	name = "explorer firing pin"
	desc = "A firing pin used to prevent weapon discharge on the station."
	icon_state = "firing_pin_explorer"
	fail_message = "<span class='warning'>CANNOT FIRE WHILE ON STATION.</span>"
	req_access = list(access_armory) //for toggling safety
	var/locked = 1

// This checks that the user isn't on the station Z-level.
/obj/item/firing_pin/explorer/pin_auth(mob/living/user)
	var/turf/T = get_turf(src)
	if(!locked)
		return TRUE
	if(T.z in GLOB.using_map.map_levels)
		return FALSE
	return TRUE

//Allows swiping an armoury access ID on an explorer locked gun to unlock it
/obj/item/gun/attackby(obj/item/I, mob/user)
	if((istype(I, /obj/item/card/id)) && pin)
		pin.attackby(I, user)
	else
		return ..()

/obj/item/firing_pin/explorer/attackby(obj/item/card/ID, mob/user)
	..()
	if(check_access(ID))
		locked = !locked
		to_chat(user, "<span class='warning'>You [locked ? "enable" : "disable"] the safety lock on \the [src].</span>")
	else
		to_chat(user, "<span class='warning'>Access denied.</span>")
	user.visible_message("<span class='notice'>[user] swipes \the [ID] against \the [src].</span>")

/obj/item/firing_pin/emag_act(var/remaining_charges, var/mob/user)
	if(emagged)
		to_chat(user, "<span class='notice'>It's already emagged.</span>")
		return
	emagged = 1
	to_chat(user, "<span class='notice'>You override the authentication mechanism.</span>")
	return TRUE