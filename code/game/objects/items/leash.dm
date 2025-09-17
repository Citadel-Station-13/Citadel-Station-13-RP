/atom/movable/screen/alert/leash_dom
	name = "Leash Holder"
	desc = "You're holding a leash, with someone on the end."
	icon_state = "leash_master"

/atom/movable/screen/alert/leash_dom/Click()
	var/obj/item/leash/owner = master
	owner.unleash()

/atom/movable/screen/alert/leash_pet
	name = "Leashed"
	desc = "You're on the hook now!"
	icon_state = "leash_pet"

/atom/movable/screen/alert/leash_pet/Click()
	var/obj/item/leash/owner = master
	owner.struggle_leash()

///// OBJECT /////
//The leash object itself
//The component variables are used for hooks, used later.
/obj/item/leash
	name = "leash"
	desc = "A simple tether that can easily be hooked onto a collar. Usually used to keep pets nearby."
	icon = 'icons/obj/leash.dmi'
	icon_state = "leash"
	item_state = "leash"
	throw_range = 4
	slot_flags = SLOT_BELT
	damage_force = 1
	throw_force = 1
	w_class = WEIGHT_CLASS_SMALL
	var/mob/living/leash_pet = null //Variable to store our pet later
	var/mob/living/leash_master = null //And our master too
	var/leash_length = 2
	var/leash_flexibility = 2

/obj/item/leash/Destroy()
	// Just in case
	clear_leash()
	return ..()

/obj/item/leash/process()
	if(!leash_pet)
		return
	if(!is_wearing_collar(leash_pet)) //The pet has slipped their collar and is not the pet anymore.
		leash_pet.visible_message(
			"<span class='warning'>[leash_pet] has slipped out of their collar!</span>",
			"<span class='warning'>You have slipped out of your collar!</span>"
		)
		clear_leash()

	if(!leash_pet || !leash_master) //If there is no pet, there is no dom. Loop breaks.
		clear_leash()

//Called when someone is clicked with the leash
/obj/item/leash/melee_override(atom/target, mob/user, intent, zone, efficiency, datum/event_args/actor/actor)
	if(!ismob(target))
		return ..()
	. = TRUE
	//mob/living/carbon/C, mob/living/user, attackchain_flags, damage_multiplier) //C is the target, user is the one with the leash
	var/is_simple_animal = FALSE
	var/mob/living/carbon/C = target
	if(!istype(C))
		if(isanimal(target))
			is_simple_animal = TRUE
		else
			return
	if(!user.IsAdvancedToolUser())
		return
	if (!is_wearing_collar(C))
		to_chat(user, "<span class='notice'>[C] needs a collar before you can attach a leash to it.</span>")
		return
	if(C.alerts["leashed"]) //If the pet is already leashed, do not leash them. For the love of god.
		// If they re-click, remove the leash
		if (C == leash_pet && user == leash_master)
			unleash()
		else
			// Dear god not the double leashing
			to_chat(user, "<span class='notice'>[C] has already been leashed.</span>")
		return

	if (C == user)
		to_chat(user, "<span class='notice'>You cannot leash yourself!</span>")
		return

	var/leashtime = 35
	if(!is_simple_animal && C.handcuffed)
		leashtime = 5

	C.visible_message("<span class='danger'>\The [user] is attempting to put the leash on \the [C]!</span>", "<span class='danger'>\The [user] tries to put a leash on you</span>")
	add_attack_logs(user,C,"Leashed (attempt)")
	if(!do_mob(user, C, leashtime)) //do_mob adds a progress bar, but then we also check to see if they have a collar
		return

	C.visible_message("<span class='danger'>\The [user] puts a leash on \the [C]!</span>", "<span class='danger'>The leash clicks onto your collar!</span>")

	leash_pet = C //Save pet reference for later
	leash_pet.add_modifier(/datum/modifier/leash)
	leash_pet.throw_alert("leashed", /atom/movable/screen/alert/leash_pet, new_master = src) //Is the leasher
	RegisterSignal(leash_pet, COMSIG_MOVABLE_MOVED, PROC_REF(on_pet_move))
	to_chat(leash_pet, "<span class='danger'>You have been leashed!</span>")
	leash_master = user //Save dom reference for later
	leash_master.throw_alert("leash", /atom/movable/screen/alert/leash_dom, new_master = src)//Has now been leashed
	RegisterSignal(leash_master, COMSIG_MOVABLE_MOVED, PROC_REF(on_master_move))

	START_PROCESSING(SSobj, src)

//Called when the leash is used in hand
//Tugs the pet closer
/obj/item/leash/attack_self(mob/living/user)
	if(!leash_pet) //No pet, no tug.
		return
	//Yank the pet. Yank em in close.
	apply_tug_mob_to_mob(leash_pet, leash_master, 1)

/obj/item/leash/proc/on_master_move()
	SIGNAL_HANDLER

	//Make sure the dom still has a pet
	if(!leash_master || !leash_pet)
		return
	addtimer(CALLBACK(src, PROC_REF(after_master_move)), 0.2 SECONDS)

/obj/item/leash/proc/after_master_move()
	//If the master moves, pull the pet in behind
	//Also, the timer means that the distance check for master happens before the pet, to prevent both from proccing.
	if(!leash_master || !leash_pet) //Just to stop error messages
		return
	apply_tug_mob_to_mob(leash_pet, leash_master, leash_length)

	//Knock the pet over if they get further behind. Shouldn't happen too often.
	sleep(3) //This way running normally won't just yank the pet to the ground.
	if(!leash_master || !leash_pet) //Just to stop error messages. Break the loop early if something removed the master
		return
	if(get_dist(leash_pet, leash_master) >= leash_length + leash_flexibility && !leash_pet.incapacitated(INCAPACITATION_STUNNED))
		leash_pet.visible_message(
			"<span class='warning'>[leash_pet] is pulled to the ground by their leash!</span>",
			"<span class='warning'>You are pulled to the ground by your leash!</span>"
		)
		leash_pet.apply_effect(1, WEAKEN, 0)

	//This code is to check if the pet has gotten too far away, and then break the leash.
	sleep(3) //Wait to snap the leash
	if(!leash_master || !leash_pet) //Just to stop error messages
		return
	if(get_dist(leash_pet, leash_master) > leash_length + 2*leash_flexibility)
		leash_pet.visible_message(
			"<span class='warning'>The leash snaps free from [leash_pet]'s collar!</span>",
			"<span class='warning'>Your leash pops from your collar!</span>"
		)
		leash_pet.apply_effect(1, STUN, 0)
		leash_pet.adjustOxyLoss(5)
		clear_leash()

/obj/item/leash/proc/on_pet_move()
	SIGNAL_HANDLER
	//This should only work if there is a pet and a master.
	//This is here pretty much just to stop the console from flooding with errors
	if(!leash_master || !leash_pet)
		return

	//If the pet gets too far away, they get tugged back
	addtimer(CALLBACK(src, PROC_REF(after_pet_move)), 0.3 SECONDS) //A short timer so the pet kind of bounces back after they make the step

/obj/item/leash/proc/after_pet_move()
	if(!leash_master || !leash_pet)
		return
	for(var/i in (leash_length+1) to get_dist(leash_pet, leash_master)) // Move the pet to a minimum of the leashes length tiles away from the master, so the pet trails behind them.
		step_towards(leash_pet, leash_master)

/obj/item/leash/dropped(mob/user)
	 //Drop the leash, and the leash effects stop
	. = ..()
	if(!leash_pet || !leash_master) //There is no pet. Stop this silliness
		return
	//Dropping procs any time the leash changes slots. So, we will wait a tick and see if the leash was actually dropped
	addtimer(CALLBACK(src, PROC_REF(drop_effects), user), 1)

/obj/item/leash/proc/drop_effects(mob/user)
	SIGNAL_HANDLER
	if(src in leash_master.get_held_items())
		return  //Dom still has the leash as it turns out. Cancel the proc.
	leash_master.visible_message("<span class='notice'>\The [leash_master] drops \the [src].</span>", "<span class='notice'>You drop \the [src].</span>")
	//DOM HAS DROPPED LEASH. PET IS FREE. SCP HAS BREACHED CONTAINMENT.
	clear_leash()

/obj/item/leash/proc/clear_leash()
	leash_pet?.clear_alert("leashed")
	leash_pet?.remove_a_modifier_of_type(/datum/modifier/leash)
	if(leash_pet)
		UnregisterSignal(leash_pet, COMSIG_MOVABLE_MOVED)
	leash_pet = null

	leash_master?.clear_alert("leash")
	if(leash_master)
		UnregisterSignal(leash_master, COMSIG_MOVABLE_MOVED)
	leash_master = null

	STOP_PROCESSING(SSobj, src)

/obj/item/leash/proc/struggle_leash()
	leash_pet.visible_message("<span class='danger'>\The [leash_pet] is attempting to unhook their leash!</span>", "<span class='danger'>You attempt to unhook your leash</span>")
	add_attack_logs(leash_master,leash_pet,"Self-unleash (attempt)")

	if(!do_mob(leash_pet, leash_pet, 35))
		return

	to_chat(leash_pet, "<span class='danger'>You have been released!</span>")
	clear_leash()

/obj/item/leash/proc/unleash()
	leash_pet.visible_message("<span class='danger'>\The [leash_master] is attempting to remove the leash on \the [leash_pet]!</span>", "<span class='danger'>\The [leash_master] tries to remove leash from you</span>")
	add_attack_logs(leash_master,leash_pet,"Unleashed (attempt)")

	if(!do_mob(leash_master, leash_pet, 5))
		return

	to_chat(leash_pet, "<span class='danger'>You have been released!</span>")
	clear_leash()

/obj/item/leash/proc/is_wearing_collar(var/mob/living/carbon/human/human)
	if (!istype(human))
		var/mob/living/simple_mob/animal/passive/dog/doggy = human
		if(istype(doggy))
			return TRUE
		return FALSE
	for (var/obj/item/clothing/worn in human._get_all_slots())
		if (istype(worn, /obj/item/clothing/accessory/collar) || (locate(/obj/item/clothing/accessory/collar) in worn.accessories))
			return TRUE
	return FALSE

/datum/modifier/leash
	name = "Leash"

// Utility functions
/obj/item/proc/apply_tug_mob_to_mob(mob/living/carbon/tug_pet, mob/living/carbon/tug_master, distance = 2)
	apply_tug_position(tug_pet, tug_pet.x, tug_pet.y, tug_master.x, tug_master.y, distance)

/obj/item/proc/apply_tug_mob_to_object(mob/living/carbon/tug_pet, obj/tug_master, distance = 2)
	apply_tug_position(tug_pet, tug_pet.x, tug_pet.y, tug_master.x, tug_master.y, distance)

/obj/item/proc/apply_tug_object_to_mob(obj/tug_pet, mob/living/carbon/tug_master, distance = 2)
	apply_tug_position(tug_pet, tug_pet.x, tug_pet.y, tug_master.x, tug_master.y, distance)

// TODO: improve this for bigger distances, where it's easy to hide behind something and break the tugging
/obj/item/proc/apply_tug_position(tug_pet, tug_pet_x, tug_pet_y, tug_master_x, tug_master_y, distance = 2)
	if(tug_pet_x > tug_master_x + distance)
		step(tug_pet, WEST, 1) //"1" is the speed of movement. We want the tug to be faster than their slow current walk speed.
		if(tug_pet_y > tug_master_y)//Check the other axis, and tug them into alignment so they are behind the master
			step(tug_pet, SOUTH, 1)
		if(tug_pet_y < tug_master_y)
			step(tug_pet, NORTH, 1)
	if(tug_pet_x < tug_master_x - distance)
		step(tug_pet, EAST, 1)
		if(tug_pet_y > tug_master_y)
			step(tug_pet, SOUTH, 1)
		if(tug_pet_y < tug_master_y)
			step(tug_pet, NORTH, 1)
	if(tug_pet_y > tug_master_y + distance)
		step(tug_pet, SOUTH, 1)
		if(tug_pet_x > tug_master_x)
			step(tug_pet, WEST, 1)
		if(tug_pet_x < tug_master_x)
			step(tug_pet, EAST, 1)
	if(tug_pet_y < tug_master_y - distance)
		step(tug_pet, NORTH, 1)
		if(tug_pet_x > tug_master_x)
			step(tug_pet, WEST, 1)
		if(tug_pet_x < tug_master_x)
			step(tug_pet, EAST, 1)

/obj/item/leash/cable
	name = "cable leash"
	desc = "A simple tether that can easily be hooked onto a collar. This one is made from wiring cable."
	icon = 'icons/obj/leash.dmi'
	icon_state = "cable"

/obj/item/leash/cable/attackby(obj/item/W, mob/user as mob)
	if(istype(W,/obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/C = W
		if(src.leash_length > 3)
			to_chat(user,"<span class='warning'>\the [src] is already as long as you can make it.</span>")
			return
		if(C.get_amount() < 2)
			to_chat(user,"<span class='warning'>You need at least two coils of wire to add them to \the [src].</span>")
			return
		C.use(2)
		src.leash_length++
		src.visible_message("<span class='notice'>[user] lengthens \the [src].</span>", "<span class='notice'>You lengthen \the [src].</span>")
	else if(W.is_wirecutter())
		if(src.leash_length <= 1) //Probably should be fixed if it's below 1, but just a safety it doesn't go negative for infinite wire
			to_chat(user,"<span class='warning'>\the [src] is already as short as it can get.</span>")
			return
		src.leash_length--
		new /obj/item/stack/cable_coil(user.loc, 2)
		src.visible_message("<span class='notice'>[user] cuts \the [src] shorter.</span>", "<span class='notice'>You cut \the [src] shorter.</span>", "<span class='notice'>You hear something being snipped.</span>")


/datum/crafting_recipe/leash
	name = "Cable Leash"
	result = /obj/item/leash/cable
	reqs = list(/obj/item/stack/cable_coil = 5) //1 for the handle/clip, 4 for the two tiles distance
	time = 60
	category = CAT_CLOTHING
