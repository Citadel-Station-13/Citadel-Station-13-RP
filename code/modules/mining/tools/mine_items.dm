/******************************Lantern*******************************/

/obj/item/flashlight/lantern
	name = "lantern"
	icon_state = "lantern"
	desc = "A mining lantern."
	brightness_on = 6			// luminosity when on
	light_color = "#ff9933" // A slight yellow/orange color.
	light_wedge = LIGHT_OMNI
	worth_intrinsic = 45

/*****************************Pickaxe********************************/

/obj/item/pickaxe
	name = "mining drill"
	desc = "The most basic of mining drills, for short excavations and small mineral extractions."
	icon = 'icons/obj/items.dmi'
	slot_flags = SLOT_BELT
	damage_force = 15.0
	throw_force = 4.0
	icon_state = "pickaxe"
	item_state = "jackhammer"
	w_class = WEIGHT_CLASS_BULKY
	materials_base = list(MAT_STEEL = 3750)
	worth_intrinsic = 75
	suit_storage_class = SUIT_STORAGE_CLASS_HARDWEAR
	var/digspeed = 40 //moving the delay to an item var so R&D can make improved picks. --NEO
	var/sand_dig = FALSE
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	attack_verb = list("hit", "pierced", "sliced", "attacked")
	var/drill_sound = 'sound/weapons/Genhit.ogg'
	var/drill_verb = "drilling"
	damage_mode = DAMAGE_MODE_SHARP
	var/active = 1

	var/excavation_amount = 200
	var/destroy_artefacts = FALSE // some mining tools will destroy artefacts completely while avoiding side-effects.

/obj/item/pickaxe/bone
	name = "bone pickaxe"
	icon_state = "bpickaxe"
	item_state = "bpickaxe"
	digspeed = 30
	origin_tech = list(TECH_MATERIAL = 1)
	desc = "A sturdy pick fashioned from some animal's bone, wound with powerful sinew."

/obj/item/pickaxe/bronze
	name = "bronze pickaxe"
	icon_state = "brpickaxe"
	item_state = "brpickaxe"
	digspeed = 30
	origin_tech = list(TECH_MATERIAL = 1)
	desc = "A primitive pickaxe made of bronze, and a handle of bone."

/obj/item/pickaxe/silver
	name = "silver pickaxe"
	icon_state = "spickaxe"
	item_state = "spickaxe"
	digspeed = 30
	origin_tech = list(TECH_MATERIAL = 3)
	desc = "This makes no metallurgic sense."

/obj/item/pickaxe/drill
	name = "advanced mining drill" // Can dig sand as well!
	icon_state = "handdrill"
	item_state = "jackhammer"
	digspeed = 30
	origin_tech = list(TECH_MATERIAL = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	desc = "Yours is the drill that will pierce through the rock walls."
	drill_verb = "drilling"
	sand_dig = TRUE
	worth_intrinsic = 125

/obj/item/pickaxe/jackhammer
	name = "sonic jackhammer"
	icon_state = "jackhammer"
	item_state = "jackhammer"
	digspeed = 20 //faster than drill, but cannot dig
	origin_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_ENGINEERING = 2)
	desc = "Cracks rocks with sonic blasts, perfect for killing cave lizards."
	drill_verb = "hammering"
	worth_intrinsic = 250

/obj/item/pickaxe/gold
	name = "golden pickaxe"
	icon_state = "gpickaxe"
	item_state = "gpickaxe"
	digspeed = 20
	origin_tech = list(TECH_MATERIAL = 4)
	desc = "This makes no metallurgic sense."
	drill_verb = "picking"

/obj/item/pickaxe/plasmacutter
	name = "plasma cutter"
	icon_state = "plasmacutter"
	item_state = "gun"
	w_class = WEIGHT_CLASS_NORMAL //it is smaller than the pickaxe
	damage_type = DAMAGE_TYPE_BURN
	digspeed = 20 //Can slice though normal walls, all girders, or be used in reinforced wall deconstruction/ light thermite on fire
	origin_tech = list(TECH_MATERIAL = 4, TECH_PHORON = 3, TECH_ENGINEERING = 3)
	desc = "A rock cutter that uses bursts of hot plasma. You could use it to cut limbs off of xenos! Or, you know, mine stuff."
	drill_verb = "cutting"
	drill_sound = 'sound/items/Welder.ogg'
	damage_mode = DAMAGE_MODE_SHARP | DAMAGE_MODE_EDGE
	worth_intrinsic = 175

/obj/item/pickaxe/diamond
	name = "diamond pickaxe"
	icon_state = "dpickaxe"
	item_state = "dpickaxe"
	digspeed = 10
	origin_tech = list(TECH_MATERIAL = 6, TECH_ENGINEERING = 4)
	desc = "A pickaxe with a diamond pick head."
	drill_verb = "picking"

/obj/item/pickaxe/diamonddrill // When people ask about the badass leader of the mining tools, they are talking about ME!
	name = "diamond mining drill"
	icon_state = "diamonddrill"
	item_state = "jackhammer"
	digspeed = 5 //Digs through walls, girders, and can dig up sand
	origin_tech = list(TECH_MATERIAL = 6, TECH_POWER = 4, TECH_ENGINEERING = 5)
	desc = "Yours is the drill that will pierce the heavens!"
	drill_verb = "drilling"
	sand_dig = TRUE
	worth_intrinsic = 350

/obj/item/pickaxe/borgdrill
	name = "enhanced sonic jackhammer"
	icon_state = "jackhammer"
	item_state = "jackhammer"
	digspeed = 15
	desc = "Cracks rocks with sonic blasts. This one seems like an improved design."
	drill_verb = "hammering"
	sand_dig = TRUE

/obj/item/pickaxe/icepick //Cannot actually lobotomize people. Yet.
	name = "icepick"
	desc = "A simple icepick, for all your digging, climbing, and lobotomizing needs."
	slot_flags = SLOT_BELT
	damage_force = 12
	throw_force = 15 //Discount shuriken.
	icon_state = "icepick"
	item_state = "spickaxe" //im lazy fuck u
	w_class = WEIGHT_CLASS_SMALL
	materials_base = list(MAT_STEEL = 2750, MAT_TITANIUM = 2000)
	digspeed = 25 //More expensive than a diamond pick, a lot smaller but decently slower.
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	attack_verb = list("mined", "pierced", "stabbed", "attacked")
	drill_verb = "picking"
	worth_intrinsic = 75

//Snowflake drill that works like a chainsaw! How fun. Honestly they should probably all work like this or something. I dunno. Might be a fun mining overhaul later.
/obj/item/pickaxe/tyrmalin
	name = "\improper Tyrmalin excavator"
	desc = "A mining drill built from scrap parts, often found on Tyrmalin mining operations. No two are alike."
	icon_state = "goblindrill"
	item_state = "goblindrill"
	digspeed = 25
	destroy_artefacts = TRUE
	var/max_fuel = 100
	active = 0
	var/jam_chance = 15
	worth_intrinsic = 75

/obj/item/pickaxe/tyrmalin/Initialize(mapload)
	. = ..()
	digspeed = rand(10, 50) // let's go gambling!
	if (digspeed > 25)
		desc += pick(" This one has a cracked engine block...",
					 " Seems like it got damaged in shipping...",
					 " There's a worrying grinding noise in the gearbox...",
					 " The drill head's barely intact...",
					 " You hear an incessant knocking coming from the engine...")
	var/datum/reagent_holder/R = new/datum/reagent_holder(max_fuel)
	reagents = R
	R.my_atom = src
	R.add_reagent("fuel", max_fuel)
	START_PROCESSING(SSobj, src)

/obj/item/pickaxe/tyrmalin/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/pickaxe/tyrmalin/proc/turnOn(mob/user as mob)
	if(active)
		return

	to_chat(user, "You start pulling the string on \the [src].")
	//visible_message("[usr] starts pulling the string on the [src].")

	if(get_fuel() <= 0)
		if(do_after(user, 15))
			to_chat(user, "\The [src] won't start!")
		else
			to_chat(user, "You fumble with the string.")
	else
		if(do_after(user, 15))
			to_chat(user, "You start \the [src] up with a loud grinding!")
			//visible_message("[usr] starts \the [src] up with a loud grinding!")
			attack_verb = list("shredded", "ripped", "torn")
			playsound(src, 'sound/weapons/chainsaw_startup.ogg',40,1)
			damage_force = 15
			damage_mode |= DAMAGE_MODE_SHARP | DAMAGE_MODE_EDGE
			active = TRUE
			update_icon()
		else
			to_chat(user, "You fumble with the string.")

/obj/item/pickaxe/tyrmalin/proc/turnOff(mob/user as mob)
	if(!active) return
	to_chat(user, "You switch the gas nozzle on the drill, turning it off.")
	attack_verb = list("bluntly hit", "beat", "knocked")
	playsound(user, 'sound/weapons/chainsaw_turnoff.ogg',40,1)
	damage_force = 3
	damage_mode = initial(damage_mode)
	active = FALSE
	update_icon()

/obj/item/pickaxe/tyrmalin/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	if(!active)
		turnOn(user)
	else
		turnOff(user)

/obj/item/pickaxe/tyrmalin/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	if(!(clickchain_flags & CLICKCHAIN_HAS_PROXIMITY)) return
	..()
	if(active)
		playsound(src, 'sound/weapons/chainsaw_attack.ogg',40,1)
	if(target && active)
		if(get_fuel() > 0)
			reagents.remove_reagent("fuel", 1)
	if(jam_chance && active)
		if(prob(jam_chance))
			user.action_feedback(SPAN_WARNING("\The [src] jolts as it stalls out!"))
			turnOff()
		else
			return
	if (istype(target, /obj/structure/reagent_dispensers/fueltank) || istype(target, /obj/item/reagent_containers/portable_fuelcan) && get_dist(src,target) <= 1)
		to_chat(usr, "<span class='notice'>You begin filling the tank on the [src].</span>")
		if(do_after(usr, 15))
			target.reagents.trans_to_obj(src, max_fuel)
			playsound(src.loc, 'sound/effects/refill.ogg', 50, 1, -6)
			to_chat(usr, "<span class='notice'>[src] succesfully refueled.</span>")
		else
			to_chat(usr, "<span class='notice'>Don't move while you're refilling the [src].</span>")

/obj/item/pickaxe/tyrmalin/process(delta_time)
	if(!active)
		return

	if(get_fuel() > 0)
		reagents.remove_reagent("fuel", 1)
		playsound(src, 'sound/weapons/chainsaw_turnoff.ogg',15,1)
	if(get_fuel() <= 0)
		visible_message(SPAN_WARNING("\The [src] sputters to a stop!"))
		turnOff()

/obj/item/pickaxe/tyrmalin/proc/get_fuel()
	return reagents.get_reagent_amount("fuel")

/obj/item/pickaxe/tyrmalin/examine(mob/user, dist)
	. = ..()
	if(max_fuel)
		. += "<span class = 'notice'>The [src] feels like it contains roughtly [get_fuel()] units of fuel left.</span>"

/obj/item/pickaxe/tyrmalin/update_icon()
	if(active)
		icon_state = "goblindrill1"
		item_state = "goblindrill1"
	else
		icon_state = "goblindrill"
		item_state = "goblindrill"


/*****************************Shovel********************************/

/obj/item/shovel
	name = "shovel"
	desc = "A large tool for digging and moving dirt."
	icon = 'icons/obj/items.dmi'
	icon_state = "shovel"
	slot_flags = SLOT_BELT
	damage_force = 8.0
	throw_force = 4.0
	item_state = "shovel"
	w_class = WEIGHT_CLASS_NORMAL
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	materials_base = list(MAT_STEEL = 50)
	attack_verb = list("bashed", "bludgeoned", "thrashed", "whacked")
	damage_mode = DAMAGE_MODE_EDGE
	worth_intrinsic = 50
	suit_storage_class = SUIT_STORAGE_CLASS_HARDWEAR
	var/digspeed = 40

/obj/item/shovel/bone
	name = "serrated bone shovel"
	desc = "A wicked tool that cleaves through dirt just as easily as it does flesh. The design was styled after ancient tribal designs."
	icon = 'icons/obj/mining.dmi'
	icon_state = "shovel_bone"
	damage_force = 15
	throw_force = 12
	tool_speed = 0.7
	attack_verb = list("slashed", "impaled", "stabbed", "sliced")
	damage_mode = DAMAGE_MODE_SHARP | DAMAGE_MODE_EDGE

/obj/item/shovel/bronze
	name = "bronze shovel"
	desc = "A simple shovel made of bronze. Its wide head seems to be much simpler then modern shovels."
	icon = 'icons/obj/lavaland.dmi'
	icon_state = "shovel_bronze"

/obj/item/shovel/spade
	name = "spade"
	desc = "A small tool for digging and moving dirt."
	icon_state = "spade"
	item_state = "spade"
	damage_force = 5.0
	throw_force = 7.0
	w_class = WEIGHT_CLASS_SMALL

/obj/item/shovel/spade/bone
	name = "primitive spade"
	desc = "A small shove cruedly fashioned out of some beast's scapula."
	icon = 'icons/obj/mining.dmi'
	icon_state = "spade_bone"

/obj/item/shovel/spade/bronze
	name = "primitive spade"
	desc = "A small shovel made of bronze. The design seems to have some ritual purposes."
	icon = 'icons/obj/lavaland.dmi'
	icon_state = "spade_bronze"

/**********************Mining car (Crate like thing, not the rail car)**************************/

/obj/structure/closet/crate/miningcar
	desc = "A mining car. This one doesn't work on rails, but has to be dragged."
	name = "Mining car (not for rails)"
	closet_appearance = null
	icon = 'icons/obj/storage.dmi'
	icon_state = "miningcar"
	density = 1
	icon_opened = "miningcaropen"
	icon_closed = "miningcar"

/obj/structure/closet/crate/miningcar/update_icon()

// Flags.

/obj/item/stack/flag
	name = "flags"
	desc = "Some colourful flags."
	singular_name = "flag"
	icon = 'icons/obj/mining.dmi'
	amount = 10
	max_amount = 10
	zmm_flags = ZMM_MANGLE_PLANES
	suit_storage_class = SUIT_STORAGE_CLASS_SOFTWEAR | SUIT_STORAGE_CLASS_HARDWEAR

	var/upright = 0
	var/base_state

/obj/item/stack/flag/Initialize(mapload, new_amount, merge)
	. = ..()
	base_state = icon_state

/obj/item/stack/flag/blue
	name = "blue flags"
	singular_name = "blue flag"
	icon_state = "blueflag"

/obj/item/stack/flag/red
	name = "red flags"
	singular_name = "red flag"
	icon_state = "redflag"

/obj/item/stack/flag/yellow
	name = "yellow flags"
	singular_name = "yellow flag"
	icon_state = "yellowflag"

/obj/item/stack/flag/green
	name = "green flags"
	singular_name = "green flag"
	icon_state = "greenflag"

/obj/item/stack/flag/attackby(obj/item/W as obj, mob/user as mob)
	if(upright && istype(W,src.type))
		src.attack_hand(user)
	else
		..()

/obj/item/stack/flag/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	if(upright)
		upright = 0
		icon_state = base_state
		anchored = 0
		src.visible_message("<b>[user]</b> knocks down [src].")
	else
		..()

/obj/item/stack/flag/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return

	var/obj/item/stack/flag/F = locate() in get_turf(src)

	var/turf/T = get_turf(src)
	if(!T || !istype(T,/turf/simulated/mineral))
		to_chat(user, "The flag won't stand up in this terrain.")
		return

	if(F && F.upright)
		to_chat(user, "There is already a flag here.")
		return

	var/obj/item/stack/flag/newflag = new src.type(T)
	newflag.amount = 1
	newflag.upright = 1
	newflag.anchored = 1
	newflag.name = newflag.singular_name
	newflag.icon_state = "[newflag.base_state]_open"
	newflag.visible_message("<b>[user]</b> plants [newflag] firmly in the ground.")
	src.use(1)
