//Simple borg hand.
//Limited use.
/obj/item/gripper
	name = "magnetic gripper"
	desc = "A simple grasping tool specialized in construction and engineering work."
	description_info = "Ctrl-Clicking on the gripper will drop whatever it is holding.<br>\
	Using an object on the gripper will interact with the item inside it, if it exists, instead."
	icon = 'icons/obj/device.dmi'
	icon_state = "gripper"
	item_flags = ITEM_NOBLUDGEON

	//Has a list of items that it can hold.
	var/list/can_hold = list(
		/obj/item/cell,
		/obj/item/airlock_electronics,
		/obj/item/tracker_electronics,
		/obj/item/module/power_control,
		/obj/item/stock_parts,
		/obj/item/frame,
		/obj/item/camera_assembly,
		/obj/item/tank,
		/obj/item/circuitboard,
		/obj/item/smes_coil,
		/obj/item/fuelrod/,
		/obj/item/fuel_assembly/
		)

	/// currently held item
	VAR_PRIVATE/obj/item/wrapped

	var/force_holder = null //

/obj/item/gripper/examine(mob/user)
	. = ..()
	if(wrapped)
		. += "<span class='notice'>\The [src] is holding \the [wrapped].</span>"
		. += wrapped.examine(user)

/obj/item/gripper/Destroy()
	remove_item(drop_location())
	return ..()

/obj/item/gripper/proc/insert_item(obj/item/I)
	if(QDELETED(I))
		return
	if(wrapped)
		remove_item(drop_location())
	wrapped = I
	I.forceMove(src)
	RegisterSignal(I, list(COMSIG_PARENT_QDELETING, COMSIG_MOVABLE_MOVED), .proc/unwrap_hook)

/**
 * newloc false to not move
 */
/obj/item/gripper/proc/remove_item(atom/newloc = FALSE)
	if(!wrapped)
		return
	var/obj/item/old = wrapped
	UnregisterSignal(wrapped, list(COMSIG_PARENT_QDELETING, COMSIG_MOVABLE_MOVED))
	wrapped = null
	switch(newloc)
		if(null)
			old.moveToNullspace()
		if(FALSE)
		else
			old.forceMove(newloc)

/obj/item/gripper/proc/unwrap_hook(datum/source)
	ASSERT(isitem(source))
	ASSERT(source == wrapped)
	remove_item(FALSE)

/obj/item/gripper/proc/get_item()
	return wrapped

/obj/item/gripper/CtrlClick(mob/user)
	drop_item()

/obj/item/gripper/omni
	name = "omni gripper"
	desc = "A strange grasping tool that can hold anything a human can, but still maintains the limitations of application its more limited cousins have."
	icon_state = "gripper-omni"

	can_hold = list(/obj/item) // Testing and Event gripper.

// VEEEEERY limited version for mining borgs. Basically only for swapping cells and upgrading the drills.
/obj/item/gripper/miner
	name = "drill maintenance gripper"
	desc = "A simple grasping tool for the maintenance of heavy drilling machines."
	icon_state = "gripper-mining"

	can_hold = list(
	/obj/item/cell,
	/obj/item/stock_parts
	)

/obj/item/gripper/security
	name = "security gripper"
	desc = "A simple grasping tool for corporate security work."
	icon_state = "gripper-sec"

	can_hold = list(
	/obj/item/paper,
	/obj/item/paper_bundle,
	/obj/item/pen,
	/obj/item/sample,
	/obj/item/forensics/sample_kit,
	/obj/item/tape_recorder,
	/obj/item/barrier_tape_roll,
	/obj/item/uv_light
	)

/obj/item/gripper/paperwork
	name = "paperwork gripper"
	desc = "A simple grasping tool for clerical work."

	can_hold = list(
		/obj/item/clipboard,
		/obj/item/paper,
		/obj/item/paper_bundle,
		/obj/item/card/id,
		/obj/item/book,
		/obj/item/newspaper
		)

/obj/item/gripper/medical
	name = "medical gripper"
	desc = "A simple grasping tool for medical work."

	can_hold = list(
		/obj/item/reagent_containers/glass,
		/obj/item/storage/pill_bottle,
		/obj/item/reagent_containers/pill,
		/obj/item/reagent_containers/blood,
		/obj/item/stack/material/phoron,
		/obj/item/implant,
		/obj/item/nif
		)

/obj/item/gripper/research //A general usage gripper, used for toxins/robotics/xenobio/etc
	name = "scientific gripper"
	icon_state = "gripper-sci"
	desc = "A simple grasping tool suited to assist in a wide array of research applications."

	can_hold = list(
		/obj/item/cell,
		/obj/item/stock_parts,
		/obj/item/mmi,
		/obj/item/robot_parts,
		/obj/item/borg/upgrade,
		/obj/item/flash, //to build borgs,
		/obj/item/disk,
		/obj/item/circuitboard,
		/obj/item/reagent_containers/glass,
		/obj/item/assembly/prox_sensor,
		/obj/item/healthanalyzer, //to build medibots,
		/obj/item/slime_cube,
		/obj/item/slime_crystal,
		/obj/item/disposable_teleporter/slime,
		/obj/item/slimepotion,
		/obj/item/slime_extract,
		/obj/item/reagent_containers/food/snacks/monkeycube,
		/obj/item/nif

		)

/obj/item/gripper/circuit
	name = "circuit assembly gripper"
	icon_state = "gripper-circ"
	desc = "A complex grasping tool used for working with circuitry."

	can_hold = list(
		/obj/item/cell/device,
		/obj/item/electronic_assembly,
		/obj/item/assembly/electronic_assembly,
		/obj/item/clothing/under/circuitry,
		/obj/item/clothing/gloves/circuitry,
		/obj/item/clothing/glasses/circuitry,
		/obj/item/clothing/shoes/circuitry,
		/obj/item/clothing/head/circuitry,
		/obj/item/clothing/ears/circuitry,
		/obj/item/clothing/suit/circuitry,
		/obj/item/implant/integrated_circuit,
		/obj/item/integrated_circuit

		)

/obj/item/gripper/service //Used to handle food, drinks, and seeds.
	name = "service gripper"
	icon_state = "gripper"
	desc = "A simple grasping tool used to perform tasks in the service sector, such as handling food, drinks, and seeds."

	can_hold = list(
		/obj/item/reagent_containers, //simplifies a lot of redundant categorization and spaghetti with reagents
		/obj/item/glass_extra,
		/obj/item/seeds,
		/obj/item/grown,
		/obj/item/tray,
		/obj/item/plantspray,
		/obj/item/reagent_containers/glass,
		/obj/item/reagent_containers/food/drinks,
		/obj/item/storage/box/wings
		)

/obj/item/gripper/gravekeeper	//Used for handling grave things, flowers, etc.
	name = "grave gripper"
	icon_state = "gripper"
	desc = "A specialized grasping tool used in the preparation and maintenance of graves."

	can_hold = list(
		/obj/item/seeds,
		/obj/item/grown,
		/obj/item/material/gravemarker
		)

/obj/item/gripper/no_use/organ
	name = "organ gripper"
	icon_state = "gripper-flesh"
	desc = "A specialized grasping tool used to preserve and manipulate organic material."

	can_hold = list(
		/obj/item/organ
		)

/obj/item/gripper/no_use/organ/Entered(var/atom/movable/AM)
	..()
	if(istype(AM, /obj/item/organ))
		var/obj/item/organ/O = AM
		O.preserve(GRIPPER_TRAIT)

/obj/item/gripper/no_use/organ/Exited(var/atom/movable/AM)
	..()
	if(istype(AM, /obj/item/organ))
		var/obj/item/organ/O = AM
		O.unpreserve(GRIPPER_TRAIT)

/obj/item/gripper/no_use/organ/robotics
	name = "robotics organ gripper"
	icon_state = "gripper-flesh"
	desc = "A specialized grasping tool used in robotics work."

	can_hold = list(
		/obj/item/organ/external,
		/obj/item/organ/internal/brain, //to insert into MMIs,
		/obj/item/organ/internal/cell,
		/obj/item/organ/internal/eyes/robot
		)

/obj/item/gripper/no_use/mech
	name = "exosuit gripper"
	icon_state = "gripper-mech"
	desc = "A large, heavy-duty grasping tool used in construction of mechs."

	can_hold = list(
		/obj/item/mecha_parts/part,
		/obj/item/mecha_parts/micro/part,
		/obj/item/mecha_parts/mecha_equipment,
		/obj/item/mecha_parts/mecha_tracking
		)

/obj/item/gripper/no_use //Used when you want to hold and put items in other things, but not able to 'use' the item

/obj/item/gripper/no_use/attack_self(mob/user as mob)
	return

/obj/item/gripper/no_use/loader //This is used to disallow building with metal.
	name = "sheet loader"
	desc = "A specialized loading device, designed to pick up and insert sheets of materials inside machines."
	icon_state = "gripper-sheet"

	can_hold = list(
		/obj/item/stack/material
		)

/obj/item/gripper/attack_self(mob/user as mob)
	if(wrapped)
		return wrapped.attack_self(user)
	return ..()

/obj/item/gripper/attackby(var/obj/item/O, var/mob/user)
	if(wrapped) // We're interacting with the item inside. If you can hold a cup with 2 fingers and stick a straw in it, you could do that with a gripper and another robotic arm.
		var/resolved = wrapped.attackby(O, user)
		if(!resolved && wrapped && O)
			O.afterattack(wrapped,user,1)
		return resolved
	return ..()

/obj/item/gripper/verb/drop_item()
	set name = "Drop Item"
	set desc = "Release an item from your magnetic gripper."
	set category = "Robot Commands"

	if(!wrapped)
		return

	to_chat(usr, "<span class='danger'>You drop \the [wrapped].</span>")
	remove_item(drop_location())

/obj/item/gripper/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(wrapped) 	//The force of the wrapped obj gets set to zero during the attack() and afterattack().
		force_holder = wrapped.force
		wrapped.force = 0
		wrapped.attack(M,user)
		M.attackby(wrapped, user)	//attackby reportedly gets procced by being clicked on, at least according to Anewbe.
		return 1
	return 0

/obj/item/gripper/afterattack(var/atom/target, var/mob/living/user, proximity, params)
	if(!proximity)
		return // This will prevent them using guns at range but adminbuse can add them directly to modules, so eh.


	if(wrapped) //Already have an item.
		//Pass the attack on to the target. This might delete/relocate wrapped.
		var/resolved = target.attackby(wrapped, user)
		if(!resolved && wrapped && target)
			wrapped.afterattack(target,user,1)
		//wrapped's force was set to zero.  This resets it to the value it had before.
		if(wrapped)
			wrapped.force = force_holder
		force_holder = null

	else if(istype(target,/obj/item)) //Check that we're not pocketing a mob.

		//...and that the item is not in a container.
		if(!isturf(target.loc))
			return

		var/obj/item/I = target

		if(I.anchored)
			to_chat(user,"<span class='notice'>You are unable to lift \the [I] from \the [I.loc].</span>")
			return

		//Check if the item is blacklisted.
		var/grab = 0
		for(var/typepath in can_hold)
			if(istype(I,typepath))
				grab = 1
				break

		//We can grab the item, finally.
		if(grab)
			to_chat(user, "You collect \the [I].")
			insert_item(I)
			return
		else
			to_chat(user, "<span class='danger'>Your gripper cannot hold \the [target].</span>")

	else if(istype(target,/obj/machinery/power/apc))
		var/obj/machinery/power/apc/A = target
		if(A.opened)
			if(A.cell)

				insert_item(A.cell)
				A.cell.add_fingerprint(user)
				A.cell.update_icon()
				A.cell = null

				A.charging = 0
				A.update_icon()

				user.visible_message("<span class='danger'>[user] removes the power cell from [A]!</span>", "You remove the power cell.")

	else if(istype(target,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/A = target
		if(A.opened)
			if(A.cell)
				insert_item(A.cell)
				A.cell.add_fingerprint(user)
				A.cell.update_icon()
				A.updateicon()
				A.cell = null

				user.visible_message("<span class='danger'>[user] removes the power cell from [A]!</span>", "You remove the power cell.")

//TODO: Matter decompiler.
/obj/item/matter_decompiler

	name = "matter decompiler"
	desc = "Eating trash, bits of glass, or other debris will replenish your stores."
	icon = 'icons/obj/device.dmi'
	icon_state = "decompiler"

	//Metal, glass, wood, plastic.
	var/datum/matter_synth/metal = null
	var/datum/matter_synth/glass = null
	var/datum/matter_synth/wood = null
	var/datum/matter_synth/plastic = null

/obj/item/matter_decompiler/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	return

/obj/item/matter_decompiler/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, proximity, params)

	if(!proximity) return //Not adjacent.

	//We only want to deal with using this on turfs. Specific items aren't important.
	var/turf/T = get_turf(target)
	if(!istype(T))
		return

	//Used to give the right message.
	var/grabbed_something = 0

	for(var/mob/M in T)
		if(istype(M,/mob/living/simple_mob/animal/passive/lizard) || istype(M,/mob/living/simple_mob/animal/passive/mouse))
			src.loc.visible_message("<span class='danger'>[src.loc] sucks [M] into its decompiler. There's a horrible crunching noise.</span>","<span class='danger'>It's a bit of a struggle, but you manage to suck [M] into your decompiler. It makes a series of visceral crunching noises.</span>")
			new/obj/effect/debris/cleanable/blood/splatter(get_turf(src))
			qdel(M)
			if(wood)
				wood.add_charge(2000)
			if(plastic)
				plastic.add_charge(2000)
			return

		else if(istype(M,/mob/living/silicon/robot/drone) && !M.client)

			var/mob/living/silicon/robot/D = src.loc

			if(!istype(D))
				return

			to_chat(D, "<span class='danger'>You begin decompiling [M].</span>")

			if(!do_after(D,50))
				to_chat(D, "<span class='danger'>You need to remain still while decompiling such a large object.</span>")
				return

			if(!M || !D) return

			to_chat(D, "<span class='danger'>You carefully and thoroughly decompile [M], storing as much of its resources as you can within yourself.</span>")
			qdel(M)
			new/obj/effect/debris/cleanable/blood/oil(get_turf(src))

			if(metal)
				metal.add_charge(15000)
			if(glass)
				glass.add_charge(15000)
			if(wood)
				wood.add_charge(2000)
			if(plastic)
				plastic.add_charge(1000)
			return
		else
			continue

	for(var/obj/W in T)
		//Different classes of items give different commodities.
		if(istype(W,/obj/item/cigbutt))
			if(plastic)
				plastic.add_charge(500)
		else if(istype(W,/obj/effect/spider/spiderling))
			if(wood)
				wood.add_charge(2000)
			if(plastic)
				plastic.add_charge(2000)
		else if(istype(W,/obj/item/light))
			var/obj/item/light/L = W
			if(L.status >= 2) //In before someone changes the inexplicably local defines. ~ Z
				if(metal)
					metal.add_charge(250)
				if(glass)
					glass.add_charge(250)
			else
				continue
		else if(istype(W,/obj/effect/decal/remains/robot))
			if(metal)
				metal.add_charge(2000)
			if(plastic)
				plastic.add_charge(2000)
			if(glass)
				glass.add_charge(1000)
		else if(istype(W,/obj/item/trash))
			if(metal)
				metal.add_charge(1000)
			if(plastic)
				plastic.add_charge(3000)
		else if(istype(W,/obj/effect/debris/cleanable/blood/gibs/robot))
			if(metal)
				metal.add_charge(2000)
			if(glass)
				glass.add_charge(2000)
		else if(istype(W,/obj/item/ammo_casing))
			if(metal)
				metal.add_charge(1000)
		else if(istype(W,/obj/item/material/shard/shrapnel))
			if(metal)
				metal.add_charge(1000)
		else if(istype(W,/obj/item/material/shard))
			if(glass)
				glass.add_charge(1000)
		else if(istype(W,/obj/item/reagent_containers/food/snacks/grown))
			if(wood)
				wood.add_charge(4000)
		else if(istype(W,/obj/item/pipe))
			// This allows drones and engiborgs to clear pipe assemblies from floors.
		else
			continue

		qdel(W)
		grabbed_something = 1

	if(grabbed_something)
		to_chat(user, "<span class='notice'>You deploy your decompiler and clear out the contents of \the [T].</span>")
	else
		to_chat(user, "<span class='danger'>Nothing on \the [T] is useful to you.</span>")
	return

//PRETTIER TOOL LIST.
/mob/living/silicon/robot/drone/installed_modules()

	if(weapon_lock)
		to_chat(src, "<span class='danger'>Weapon lock active, unable to use modules! Count:[weaponlock_time]</span>")
		return

	if(!module)
		module = new /obj/item/robot_module/drone(src)

	var/dat = "<HEAD><TITLE>Drone modules</TITLE></HEAD><BODY>\n"
	dat += {"
	<B>Activated Modules</B>
	<BR>
	Module 1: [module_state_1 ? "<A HREF=?src=\ref[src];mod=\ref[module_state_1]>[module_state_1]<A>" : "No Module"]<BR>
	Module 2: [module_state_2 ? "<A HREF=?src=\ref[src];mod=\ref[module_state_2]>[module_state_2]<A>" : "No Module"]<BR>
	Module 3: [module_state_3 ? "<A HREF=?src=\ref[src];mod=\ref[module_state_3]>[module_state_3]<A>" : "No Module"]<BR>
	<BR>
	<B>Installed Modules</B><BR><BR>"}


	var/tools = "<B>Tools and devices</B><BR>"
	var/resources = "<BR><B>Resources</B><BR>"

	for (var/O in module.modules)

		var/module_string = ""

		if (!O)
			module_string += text("<B>Resource depleted</B><BR>")
		else if(activated(O))
			module_string += text("[O]: <B>Activated</B><BR>")
		else
			module_string += text("[O]: <A HREF=?src=\ref[src];act=\ref[O]>Activate</A><BR>")

		if((istype(O,/obj/item) || istype(O,/obj/item)) && !(istype(O,/obj/item/stack/cable_coil)))
			tools += module_string
		else
			resources += module_string

	dat += tools

	if (emagged)
		if (!module.emag)
			dat += text("<B>Resource depleted</B><BR>")
		else if(activated(module.emag))
			dat += text("[module.emag]: <B>Activated</B><BR>")
		else
			dat += text("[module.emag]: <A HREF=?src=\ref[src];act=\ref[module.emag]>Activate</A><BR>")

	dat += resources

	src << browse(dat, "window=robotmod")
