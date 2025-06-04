///////////////////////////////////////////////Alchohol bottles! -Agouri //////////////////////////
//Functionally identical to regular drinks. The only difference is that the default bottle size is 100. - Darem
//Bottles now weaken and break when smashed on people's heads. - Giacom
//remember to set atom_flags = 0 on a bottle subtype to require opening, otherwise its just an open container by default -buffy

/obj/item/reagent_containers/food/drinks/bottle
	amount_per_transfer_from_this = 10
	volume = 100
	item_state = "broken_beer" //Generic held-item sprite until unique ones are made.
	damage_force = 6
	var/smash_duration = 5 //Directly relates to the 'weaken' duration. Lowered by armor (i.e. helmets)
	var/isGlass = 1 //Whether the 'bottle' is made of glass or not so that milk cartons dont shatter when someone gets hit by it

	var/obj/item/reagent_containers/glass/rag/rag = null
	var/rag_underlay = "rag"

/obj/item/reagent_containers/food/drinks/bottle/on_reagent_change()
	return // To suppress price updating. Bottles have their own price tags.

/obj/item/reagent_containers/food/drinks/bottle/Initialize(mapload)
	. = ..()
	if(isGlass)
		integrity_flags |= INTEGRITY_ACIDPROOF

/obj/item/reagent_containers/food/drinks/bottle/Destroy()
	QDEL_NULL(rag)
	return ..()

/obj/item/reagent_containers/food/drinks/bottle/drop_products(method, atom/where)
	if(rag)
		drop_product(method, rag, where)
		rag = null
	return ..()

//when thrown on impact, bottles smash and spill their contents
/obj/item/reagent_containers/food/drinks/bottle/throw_impact(atom/hit_atom, datum/thrownthing/TT)
	..()

	var/mob/M = TT.thrower
	if(isGlass && istype(M) && M.a_intent == INTENT_HARM)
		var/throw_dist = get_dist(TT.initial_turf, loc)
		if(TT.speed >= throw_speed && smash_check(throw_dist)) //not as reliable as smashing directly
			if(reagents)
				hit_atom.visible_message("<span class='notice'>The contents of \the [src] splash all over [hit_atom]!</span>")
				reagents.splash(hit_atom, reagents.total_volume)
			src.smash(loc, hit_atom)

/obj/item/reagent_containers/food/drinks/bottle/proc/smash_check(var/distance)
	if(!isGlass || !smash_duration)
		return 0

	var/list/chance_table = list(100, 95, 90, 85, 75, 55, 35) //starting from distance 0
	var/idx = max(distance + 1, 1) //since list indices start at 1
	if(idx > chance_table.len)
		return 0
	return prob(chance_table[idx])

/obj/item/reagent_containers/food/drinks/bottle/proc/smash(var/newloc, atom/against = null)
	if(ismob(loc))
		var/mob/M = loc
		M.temporarily_remove_from_inventory(src, INV_OP_FORCE | INV_OP_SHOULD_NOT_INTERCEPT | INV_OP_SILENT)

	//Creates a shattering noise and replaces the bottle with a broken_bottle
	var/obj/item/broken_bottle/B = new /obj/item/broken_bottle(newloc)
	if(prob(33))
		new/obj/item/material/shard(newloc) // Create a glass shard at the target's location!
	B.icon_state = src.icon_state

	var/icon/I = new('icons/obj/drinks.dmi', src.icon_state)
	I.Blend(B.broken_outline, ICON_OVERLAY, rand(5), 1)
	I.SwapColor(rgb(255, 0, 220, 255), rgb(0, 0, 0, 0))
	B.icon = I

	if(rag && rag.on_fire && isliving(against))
		rag.forceMove(loc)
		var/mob/living/L = against
		L.IgniteMob()

	playsound(src, "shatter", 70, 1)
	src.transfer_fingerprints_to(B)

	qdel(src)
	return B

/obj/item/reagent_containers/food/drinks/bottle/verb/smash_bottle()
	set name = "Smash Bottle"
	set category = VERB_CATEGORY_OBJECT

	var/list/things_to_smash_on = list()
	for(var/atom/A in range (1, usr))
		if(A.density && usr.Adjacent(A) && !istype(A, /mob))
			things_to_smash_on += A

	var/atom/choice = input("Select what you want to smash the bottle on.") as null|anything in things_to_smash_on
	if(!choice)
		return
	if(!(choice.density && usr.Adjacent(choice)))
		to_chat(usr, "<span class='warning'>You must stay close to your target! You moved away from \the [choice]</span>")
		return

	usr.put_in_hands(src.smash(usr.loc, choice))
	usr.visible_message("<span class='danger'>\The [usr] smashed \the [src] on \the [choice]!</span>")
	to_chat(usr, "<span class='danger'>You smash \the [src] on \the [choice]!</span>")

/obj/item/reagent_containers/food/drinks/bottle/attackby(obj/item/W, mob/user)
	if(!rag && istype(W, /obj/item/reagent_containers/glass/rag))
		insert_rag(W, user)
		return
	if(rag && istype(W, /obj/item/flame))
		rag.attackby(W, user)
		return
	..()

/obj/item/reagent_containers/food/drinks/bottle/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	if(rag)
		remove_rag(user)
	else
		..()

/obj/item/reagent_containers/food/drinks/bottle/proc/insert_rag(obj/item/reagent_containers/glass/rag/R, mob/user)
	if(!isGlass || rag)
		return
	if(user.attempt_insert_item_for_installation(R, src))
		to_chat(user, "<span class='notice'>You stuff [R] into [src].</span>")
		rag = R
		atom_flags &= ~OPENCONTAINER
		update_icon()

/obj/item/reagent_containers/food/drinks/bottle/proc/remove_rag(mob/user)
	if(!rag)
		return
	user.put_in_hands_or_drop(rag)
	rag = null
	atom_flags |= (initial(atom_flags) & OPENCONTAINER)
	update_icon()

/obj/item/reagent_containers/food/drinks/bottle/open(mob/user)
	if(rag) return
	..()

/obj/item/reagent_containers/food/drinks/bottle/update_icon()
	underlays.Cut()
	if(rag)
		var/underlay_image = image(icon='icons/obj/drinks.dmi', icon_state=rag.on_fire? "[rag_underlay]_lit" : rag_underlay)
		underlays += underlay_image
		set_light(rag.light_range, rag.light_power, rag.light_color)
	else
		set_light(0)

/obj/item/reagent_containers/food/drinks/bottle/melee_override(atom/target, mob/user, intent, zone, efficiency, datum/event_args/actor/actor)
	if(efficiency <= 0)
		return ..()
	if(!isliving(target))
		return ..()
	if(!smash_check(target))
		return ..()

	var/mob/living/L = target
	// You are going to knock someone out for longer if they are not wearing a helmet.
	var/weaken_duration = smash_duration + min(0, damage_force - L.legacy_mob_armor(zone, "melee") + 10)

	if(zone == "head" && istype(L, /mob/living/carbon/))
		user.visible_message("<span class='danger'>\The [user] smashes [src] over [L]'s head!</span>")
		if(weaken_duration)
			L.apply_effect(min(weaken_duration, 5), WEAKEN) // Never weaken more than a flash!
	else
		user.visible_message("<span class='danger'>\The [user] smashes [src] into [L]!</span>")

	//The reagents in the bottle splash all over the L, thanks for the idea Nodrak
	if(reagents)
		user.visible_message("<span class='notice'>The contents of \the [src] splash all over [L]!</span>")
		reagents.splash(L, reagents.total_volume)

	//Finally, smash the bottle. This kills (qdel) the bottle.
	var/obj/item/broken_bottle/B = smash(L.loc, L)
	user.put_in_active_hand(B)
	return TRUE

//Keeping this here for now, I'll ask if I should keep it here.
/obj/item/broken_bottle
	name = "broken bottle"
	desc = "A bottle with a sharp broken bottom."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "broken_bottle"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	damage_force = 10
	throw_force = 5
	throw_speed = 3
	throw_range = 5
	item_state = "beer"
	atom_flags = NOCONDUCT
	attack_verb = list("stabbed", "slashed", "attacked")
	damage_mode = DAMAGE_MODE_SHARP
	var/icon/broken_outline = icon('icons/obj/drinks.dmi', "broken")

/obj/item/reagent_containers/food/drinks/bottle/redeemersbrew
	name = "Redeemer's Brew"
	desc = "Just opening the top of this bottle makes you feel a bit tipsy. Not for the faint of heart."
	icon_state = "redeemersbrew"
	center_of_mass = list("x"=16, "y"=3)

/obj/item/reagent_containers/food/drinks/bottle/redeemersbrew/Initialize(mapload)
	. = ..()
	reagents.add_reagent("unathiliquor", 100)

//Small bottles
/obj/item/reagent_containers/food/drinks/bottle/small
	volume = 50
	smash_duration = 1
	atom_flags = NONE //starts closed
	rag_underlay = "rag_small"

/obj/item/reagent_containers/food/drinks/bottle/small/beer
	name = "space beer"
	desc = "Contains only water, malt and hops."
	icon_state = "beer"
	center_of_mass = list("x"=16, "y"=12)

/obj/item/reagent_containers/food/drinks/bottle/small/beer/Initialize(mapload)
	. = ..()
	reagents.add_reagent("beer", 30)

/obj/item/reagent_containers/food/drinks/bottle/small/cider
	name = "Crisp's Cider"
	desc = "Fermented apples never tasted this good."
	icon_state = "cider"
	center_of_mass = list("x"=16, "y"=12)

/obj/item/reagent_containers/food/drinks/bottle/small/cider/Initialize(mapload)
	. = ..()
	reagents.add_reagent("cider", 30)


/obj/item/reagent_containers/food/drinks/bottle/small/ale
	name = "\improper Magm-Ale"
	desc = "A true dorf's drink of choice."
	icon_state = "alebottle"
	item_state = "beer"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/bottle/small/ale/Initialize(mapload)
	. = ..()
	reagents.add_reagent("ale", 30)

/obj/item/reagent_containers/food/drinks/bottle/sake
	name = "Mono-No-Aware Luxury Sake"
	desc = "Dry alcohol made from rice, a favorite of businessmen."
	icon_state = "sakebottle"
	center_of_mass = list("x"=16, "y"=3)

/obj/item/reagent_containers/food/drinks/bottle/sake/Initialize(mapload)
	. = ..()
	reagents.add_reagent("sake", 100)

/obj/item/reagent_containers/food/drinks/bottle/champagne
	name = "Gilthari Luxury Champagne"
	desc = "For those special occassions."
	icon_state = "champagne"
	center_of_mass = list("x"=16, "y"=3)

/obj/item/reagent_containers/food/drinks/bottle/champagne/Initialize(mapload)
	. = ..()
	reagents.add_reagent("champagne", 100)

/obj/item/reagent_containers/food/drinks/bottle/peppermintschnapps
	name = "Dr. Bone's Peppermint Schnapps"
	desc = "A flavoured grain liqueur with a fresh, minty taste."
	icon_state = "schnapps_pep"
	center_of_mass = list("x"=16, "y"=3)

/obj/item/reagent_containers/food/drinks/bottle/peppermintschnapps/Initialize(mapload)
	. = ..()
	reagents.add_reagent("schnapps_pep", 100)

/obj/item/reagent_containers/food/drinks/bottle/peachschnapps
	name = "Dr. Bone's Peach Schnapps"
	desc = "A flavoured grain liqueur with a fruity peach taste."
	icon_state = "schnapps_pea"
	center_of_mass = list("x"=16, "y"=3)

/obj/item/reagent_containers/food/drinks/bottle/peachschnapps/Initialize(mapload)
	. = ..()
	reagents.add_reagent("schnapps_pea", 100)

/obj/item/reagent_containers/food/drinks/bottle/lemonadeschnapps
	name = "Dr. Bone's Lemonade Schnapps"
	desc = "A flavoured grain liqueur with a sweetish, lemon taste."
	icon_state = "schnapps_lem"
	center_of_mass = list("x"=16, "y"=3)

/obj/item/reagent_containers/food/drinks/bottle/lemonadeschnapps/Initialize(mapload)
	. = ..()
	reagents.add_reagent("schnapps_lem", 100)

/obj/item/reagent_containers/food/drinks/bottle/champagne/jericho
	name = "Le Champion's Bubbly Champagne"
	desc = "For when you need a Little Bit of the Bubbly."
	icon_state = "champagne_bottle"
	center_of_mass = list("x"=16, "y"=3)

/obj/item/reagent_containers/food/drinks/bottle/champagne/jericho/Initialize(mapload)
	. = ..()
	reagents.add_reagent("champagnejericho", 100)

/obj/item/reagent_containers/food/drinks/bottle/small/alcsassafras
	name = "CC'S Hard Root Beer"
	desc = "Doesn't matter if you're drunk when you have a horse to take you home!"
	icon_state = "sassafras_alc"
	center_of_mass = list("x"=16, "y"=12)

/obj/item/reagent_containers/food/drinks/bottle/small/alcsassafras/Initialize(mapload)
	. = ..()
	reagents.add_reagent("alcsassafras", 60)

/obj/item/reagent_containers/food/drinks/bottle/small/sarsaparilla
	name = "CC'S Homemade Sarsaparilla"
	desc = "The Cyan Cowgirl rides again!"
	icon_state = "sarsaparilla"
	center_of_mass = list("x"=16, "y"=12)

/obj/item/reagent_containers/food/drinks/bottle/small/sarsaparilla/Initialize(mapload)
	. = ..()
	reagents.add_reagent("sarsaparilla", 60)

/obj/item/reagent_containers/food/drinks/bottle/small/sassafras
	name = "CC'S Famous Root Beer"
	desc = "Feel nostalgia for a range you never rode."
	icon_state = "sassafras"
	center_of_mass = list("x"=16, "y"=12)

/obj/item/reagent_containers/food/drinks/bottle/small/sassafras/Initialize(mapload)
	. = ..()
	reagents.add_reagent("sassafras", 60)

/obj/item/reagent_containers/food/drinks/bottle/moonshine
	name = "jug of moonshine"
	desc = "This incredibly powerful alcohol can be used as a fuel, paint thinner, or social lubricant."
	icon_state = "moonshine"
	center_of_mass = list("x"=16, "y"=4)

/obj/item/reagent_containers/food/drinks/bottle/moonshine/Initialize(mapload)
	. = ..()
	reagents.add_reagent("moonshine", 100)

/obj/item/reagent_containers/food/drinks/bottle/rotgut
	name = "Throt-Throt's Select Rotgut"
	desc = "Brewed in sunless caverns, this beastly alcohol will put hair on your chest."
	icon_state = "rotgutbottle"
	center_of_mass = list("x"=5, "y"=4)

/obj/item/reagent_containers/food/drinks/bottle/rotgut/Initialize(mapload)
	. = ..()
	reagents.add_reagent("rotgut", 100)

//Tyrmalin Food Imports
/obj/item/reagent_containers/food/drinks/bottle/greenstuff
	name = "Grom's Green Stuff"
	desc = "The classic brand, direct from Goss-Aguz."
	icon_state = "greenstuffbottle"
	center_of_mass = list("x"=16, "y"=4)

/obj/item/reagent_containers/food/drinks/bottle/greenstuff/Initialize(mapload)
	. = ..()
	reagents.add_reagent("greenstuff", 100)

/obj/item/reagent_containers/food/drinks/bottle/phobos
	name = "Phobos Extra"
	desc = "Every bottle is brewed in the caustic industrial districts of Mars."
	icon_state = "phobosbottle"
	center_of_mass = list("x"=12, "y"=14)

/obj/item/reagent_containers/food/drinks/bottle/phobos/Initialize(mapload)
	. = ..()
	reagents.add_reagent("phobos", 100)

//Apidean Food Imports
/obj/item/reagent_containers/food/drinks/bottle/royaljelly
	name = "Wax-Sealed Royal Jelly"
	desc = "A expensive import from the Denebian colonies, dipped in wax found only in the Queen's chambers."
	icon_state = "royaljellybottle"
	center_of_mass = list("x"=10, "y"=8)

/obj/item/reagent_containers/food/drinks/bottle/royaljelly/Initialize(mapload)
	. = ..()
	reagents.add_reagent("royaljelly", 100)

/obj/item/reagent_containers/food/drinks/bottle/ambrosia_mead
	name = "Ambrosia Mead"
	desc = "The drink of the Gods, made by the Apidaen hives. Disclaimer: We do not worship any gods. Only our queens."
	icon_state = "ambrosia_mead"
	center_of_mass = list("x"=4, "y"=12)

/obj/item/reagent_containers/food/drinks/bottle/ambrosia_mead/Initialize(mapload)
	. = ..()
	reagents.add_reagent("mead", 100)

//Unathi Food Imports

/obj/item/reagent_containers/food/drinks/bottle/unathijuice
	name = "Hrukhza Leaf Extract"
	desc = "Hrukhza Leaf, a vital component of any Moghes drinks."
	icon_state = "hrukhzaextract"
	item_state = "carton"
	center_of_mass = list("x"=16, "y"=8)
	isGlass = FALSE

/obj/item/reagent_containers/food/drinks/bottle/unathijuice/Initialize()
	.=..()
	reagents.add_reagent("unathijuice", 100)
