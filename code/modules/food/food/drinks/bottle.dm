///////////////////////////////////////////////Alchohol bottles! -Agouri //////////////////////////
//Functionally identical to regular drinks. The only difference is that the default bottle size is 100. - Darem
//Bottles now weaken and break when smashed on people's heads. - Giacom
//remember to set atom_flags = 0 on a bottle subtype to require opening, otherwise its just an open container by default -buffy

/obj/item/reagent_containers/food/drinks/bottle
	amount_per_transfer_from_this = 10
	volume = 100
	item_state = "broken_beer" //Generic held-item sprite until unique ones are made.
	force = 6
	var/smash_duration = 5 //Directly relates to the 'weaken' duration. Lowered by armor (i.e. helmets)
	var/isGlass = 1 //Whether the 'bottle' is made of glass or not so that milk cartons dont shatter when someone gets hit by it

	var/obj/item/reagent_containers/glass/rag/rag = null
	var/rag_underlay = "rag"

/obj/item/reagent_containers/food/drinks/bottle/on_reagent_change()
	return // To suppress price updating. Bottles have their own price tags.

/obj/item/reagent_containers/food/drinks/bottle/Initialize(mapload)
	. = ..()
	if(isGlass) unacidable = 1

/obj/item/reagent_containers/food/drinks/bottle/Destroy()
	if(rag)
		rag.forceMove(src.loc)
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
	set category = "Object"

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

/obj/item/reagent_containers/food/drinks/bottle/attack_self(mob/user)
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

/obj/item/reagent_containers/food/drinks/bottle/melee_mob_hit(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	. = ..()
	var/mob/living/L = target
	if(!istype(L))
		return
	if(user.a_intent != INTENT_HARM)
		return
	if(!smash_check(1))
		return //won't always break on the first hit

	// You are going to knock someone out for longer if they are not wearing a helmet.
	var/weaken_duration = smash_duration + min(0, force - L.run_mob_armor(target_zone, "melee") + 10)

	if(target_zone == "head" && istype(L, /mob/living/carbon/))
		user.visible_message("<span class='danger'>\The [user] smashes [src] over [L]'s head!</span>")
		if(weaken_duration)
			L.apply_effect(min(weaken_duration, 5), WEAKEN, blocked) // Never weaken more than a flash!
	else
		user.visible_message("<span class='danger'>\The [user] smashes [src] into [L]!</span>")

	//The reagents in the bottle splash all over the L, thanks for the idea Nodrak
	if(reagents)
		user.visible_message("<span class='notice'>The contents of \the [src] splash all over [L]!</span>")
		reagents.splash(L, reagents.total_volume)

	//Finally, smash the bottle. This kills (qdel) the bottle.
	var/obj/item/broken_bottle/B = smash(L.loc, L)
	user.put_in_active_hand(B)

//Keeping this here for now, I'll ask if I should keep it here.
/obj/item/broken_bottle
	name = "broken bottle"
	desc = "A bottle with a sharp broken bottom."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "broken_bottle"
	hitsound = 'sound/weapons/bladeslice.ogg'
	force = 10
	throw_force = 5
	throw_speed = 3
	throw_range = 5
	item_state = "beer"
	atom_flags = NOCONDUCT
	attack_verb = list("stabbed", "slashed", "attacked")
	sharp = 1
	edge = 0
	var/icon/broken_outline = icon('icons/obj/drinks.dmi', "broken")

/obj/item/reagent_containers/food/drinks/bottle/gin
	name = "Griffeater Gin"
	desc = "A bottle of high quality gin, produced in Alpha Centauri."
	icon_state = "ginbottle"
	center_of_mass = list("x"=16, "y"=4)

/obj/item/reagent_containers/food/drinks/bottle/gin/Initialize(mapload)
	. = ..()
	reagents.add_reagent("gin", 100)

/obj/item/reagent_containers/food/drinks/bottle/whiskey
	name = "Uncle Git's Special Reserve"
	desc = "A premium single-malt whiskey, gently matured inside the tunnels of a nuclear shelter."
	icon_state = "whiskeybottle"
	center_of_mass = list("x"=16, "y"=3)

/obj/item/reagent_containers/food/drinks/bottle/whiskey/Initialize(mapload)
	. = ..()
	reagents.add_reagent("whiskey", 100)

/obj/item/reagent_containers/food/drinks/bottle/specialwhiskey
	name = "Special Blend Whiskey"
	desc = "Just when you thought regular station whiskey was good... This silky, amber goodness has to come along and ruin everything."
	icon_state = "whiskeybottle2"
	center_of_mass = list("x"=16, "y"=3)

/obj/item/reagent_containers/food/drinks/bottle/specialwhiskey/Initialize(mapload)
	. = ..()
	reagents.add_reagent("specialwhiskey", 100)

/obj/item/reagent_containers/food/drinks/bottle/vodka
	name = "Tunguska Triple Distilled"
	desc = "Aah, vodka. Prime choice of drink and fuel by Russians worldwide."
	icon_state = "vodkabottle"
	center_of_mass = list("x"=17, "y"=3)

/obj/item/reagent_containers/food/drinks/bottle/vodka/Initialize(mapload)
	. = ..()
	reagents.add_reagent("vodka", 100)

/obj/item/reagent_containers/food/drinks/bottle/tequila
	name = "Caccavo Guaranteed Quality Tequila"
	desc = "Made from premium petroleum distillates, pure thalidomide and other fine quality ingredients!"
	icon_state = "tequilabottle"
	center_of_mass = list("x"=16, "y"=3)

/obj/item/reagent_containers/food/drinks/bottle/tequila/Initialize(mapload)
	. = ..()
	reagents.add_reagent("tequila", 100)

/obj/item/reagent_containers/food/drinks/bottle/bottleofnothing
	name = "Bottle of Nothing"
	desc = "A bottle filled with nothing"
	icon_state = "bottleofnothing"
	center_of_mass = list("x"=17, "y"=5)

/obj/item/reagent_containers/food/drinks/bottle/bottleofnothing/Initialize(mapload)
	. = ..()
	reagents.add_reagent("nothing", 100)

/obj/item/reagent_containers/food/drinks/bottle/patron
	name = "Wrapp Artiste Patron"
	desc = "Silver laced tequila, served in space night clubs across the galaxy."
	icon_state = "patronbottle"
	center_of_mass = list("x"=16, "y"=6)

/obj/item/reagent_containers/food/drinks/bottle/patron/Initialize(mapload)
	. = ..()
	reagents.add_reagent("patron", 100)

/obj/item/reagent_containers/food/drinks/bottle/rum
	name = "Captain Pete's Cuban Spiced Rum"
	desc = "This isn't just rum, oh no. It's practically Cuba in a bottle."
	icon_state = "rumbottle"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/reagent_containers/food/drinks/bottle/rum/Initialize(mapload)
	. = ..()
	reagents.add_reagent("rum", 100)

/obj/item/reagent_containers/food/drinks/bottle/whiterum
	name = "Captain Pete's Cuban White Rum"
	desc = "A milky, white alternative to Cuban Spiced! Tastes like coconut."
	icon_state = "whiterumbottle"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/reagent_containers/food/drinks/bottle/whiterum/Initialize(mapload)
	. = ..()
	reagents.add_reagent("whiterum", 100)

/obj/item/reagent_containers/food/drinks/bottle/holywater
	name = "Flask of Holy Water"
	desc = "A flask of the chaplain's holy water."
	icon_state = "holyflask"
	center_of_mass = list("x"=17, "y"=10)

/obj/item/reagent_containers/food/drinks/bottle/holywater/Initialize(mapload)
	. = ..()
	reagents.add_reagent("holywater", 100)

/obj/item/reagent_containers/food/drinks/bottle/vermouth
	name = "Goldeneye Vermouth"
	desc = "Sweet, sweet dryness~"
	icon_state = "vermouthbottle"
	center_of_mass = list("x"=17, "y"=3)

/obj/item/reagent_containers/food/drinks/bottle/vermouth/Initialize(mapload)
	. = ..()
	reagents.add_reagent("vermouth", 100)

/obj/item/reagent_containers/food/drinks/bottle/kahlua
	name = "Robert Robust's Coffee Liqueur"
	desc = "A widely known, Mexican coffee-flavoured liqueur. In production since 1936."
	icon_state = "kahluabottle"
	center_of_mass = list("x"=17, "y"=3)

/obj/item/reagent_containers/food/drinks/bottle/kahlua/Initialize(mapload)
	. = ..()
	reagents.add_reagent("kahlua", 100)

/obj/item/reagent_containers/food/drinks/bottle/goldschlager
	name = "College Girl Goldschlager"
	desc = "Because they are the only ones who will drink 100 proof cinnamon schnapps."
	icon_state = "goldschlagerbottle"
	center_of_mass = list("x"=15, "y"=3)

/obj/item/reagent_containers/food/drinks/bottle/goldschlager/Initialize(mapload)
	. = ..()
	reagents.add_reagent("goldschlager", 100)

/obj/item/reagent_containers/food/drinks/bottle/cognac
	name = "Chateau De Baton Premium Cognac"
	desc = "A sweet and strongly alchoholic drink, made after numerous distillations and years of maturing."
	icon_state = "cognacbottle"
	center_of_mass = list("x"=16, "y"=6)

/obj/item/reagent_containers/food/drinks/bottle/cognac/Initialize(mapload)
	. = ..()
	reagents.add_reagent("cognac", 100)

/obj/item/reagent_containers/food/drinks/bottle/wine
	name = "Crab Cove Merlot"
	desc = "Cheap red cooking wine pretending to be drinkable."
	icon_state = "winebottle"
	center_of_mass = list("x"=16, "y"=4)

/obj/item/reagent_containers/food/drinks/bottle/wine/Initialize(mapload)
	. = ..()
	reagents.add_reagent("wine", 100)

/obj/item/reagent_containers/food/drinks/bottle/whitewine
	name = "Crab Cove Sauvignon Blanc"
	desc = "White wine that's oddly better than the company's red variant."
	icon_state = "whitewinebottle"
	center_of_mass = list("x"=16, "y"=4)

/obj/item/reagent_containers/food/drinks/bottle/whitewine/Initialize(mapload)
	. = ..()
	reagents.add_reagent("whitewine", 100)

/obj/item/reagent_containers/food/drinks/bottle/bitters
	name = "Rattison's Bitters"
	desc = "The best thing to bitters you're going to get in this sector."
	icon_state = "bittersbottle"
	center_of_mass = list("x"=16, "y"=4)

/obj/item/reagent_containers/food/drinks/bottle/bitters/Initialize(mapload)
	. = ..()
	reagents.add_reagent("bitters", 100)


/obj/item/reagent_containers/food/drinks/bottle/absinthe
	name = "Jailbreaker Verte"
	desc = "One sip of this and you just know you're gonna have a good time."
	icon_state = "absinthebottle"
	center_of_mass = list("x"=16, "y"=6)

/obj/item/reagent_containers/food/drinks/bottle/absinthe/Initialize(mapload)
	. = ..()
	reagents.add_reagent("absinthe", 100)

/obj/item/reagent_containers/food/drinks/bottle/melonliquor
	name = "Emeraldine Melon Liquor"
	desc = "A bottle of 46 proof Emeraldine Melon Liquor. Sweet and light."
	icon_state = "alco-green" //Placeholder.
	center_of_mass = list("x"=16, "y"=6)

/obj/item/reagent_containers/food/drinks/bottle/melonliquor/Initialize(mapload)
	. = ..()
	reagents.add_reagent("melonliquor", 100)

/obj/item/reagent_containers/food/drinks/bottle/bluecuracao
	name = "Miss Blue Curacao"
	desc = "A fruity, exceptionally azure drink. Does not allow the imbiber to use the fifth magic."
	icon_state = "alco-blue" //Placeholder.
	center_of_mass = list("x"=16, "y"=6)

/obj/item/reagent_containers/food/drinks/bottle/bluecuracao/Initialize(mapload)
	. = ..()
	reagents.add_reagent("bluecuracao", 100)

/obj/item/reagent_containers/food/drinks/bottle/victory_gin
	name = "Victory Gin"
	desc = "An oily Tajara liquor similar to gin. Bottled at one of the countless distilleries on Adhomai."
	icon_state = "victorygin"
	center_of_mass = list("x"=16, "y"=4)

/obj/item/reagent_containers/food/drinks/bottle/victory_gin/Initialize(mapload)
	. = ..()
	reagents.add_reagent("victory_gin", 100)

/obj/item/reagent_containers/food/drinks/bottle/messa_mead
	name = "Messa's Mead"
	desc = "A sweet liquor from Adhomai. Orginally considered a drink of the Tajaran nobility improved technology has made this honey and root based liqour available all across Adhomai and the even the stars beyond."
	icon_state = "messamead"
	center_of_mass = list("x"=16, "y"=4)

/obj/item/reagent_containers/food/drinks/bottle/messa_mead/Initialize(mapload)
	. = ..()
	reagents.add_reagent("messa_mead", 100)


/obj/item/reagent_containers/food/drinks/bottle/grenadine
	name = "Briar Rose Grenadine Syrup"
	desc = "Sweet and tangy, a bar syrup used to add color or flavor to drinks."
	icon_state = "grenadinebottle"
	center_of_mass = list("x"=16, "y"=6)

/obj/item/reagent_containers/food/drinks/bottle/grenadine/Initialize(mapload)
	. = ..()
	reagents.add_reagent("grenadine", 100)

/obj/item/reagent_containers/food/drinks/bottle/cola
	name = "\improper Space Cola"
	desc = "Cola. in space"
	icon_state = "colabottle"
	center_of_mass = list("x"=16, "y"=6)

/obj/item/reagent_containers/food/drinks/bottle/cola/Initialize(mapload)
	. = ..()
	reagents.add_reagent("cola", 100)

/obj/item/reagent_containers/food/drinks/bottle/space_up
	name = "\improper Space-Up"
	desc = "Tastes like a hull breach in your mouth."
	icon_state = "space-up_bottle"
	center_of_mass = list("x"=16, "y"=6)

/obj/item/reagent_containers/food/drinks/bottle/space_up/Initialize(mapload)
	. = ..()
	reagents.add_reagent("space_up", 100)

/obj/item/reagent_containers/food/drinks/bottle/space_mountain_wind
	name = "\improper Space Mountain Wind"
	desc = "Blows right through you like a space wind."
	icon_state = "space_mountain_wind_bottle"
	center_of_mass = list("x"=16, "y"=6)

/obj/item/reagent_containers/food/drinks/bottle/space_mountain_wind/Initialize(mapload)
	. = ..()
	reagents.add_reagent("spacemountainwind", 100)

/obj/item/reagent_containers/food/drinks/bottle/pwine
	name = "Warlock's Velvet"
	desc = "What a delightful packaging for a surely high quality wine! The vintage must be amazing!"
	icon_state = "pwinebottle"
	center_of_mass = list("x"=16, "y"=4)

/obj/item/reagent_containers/food/drinks/bottle/pwine/Initialize(mapload)
	. = ..()
	reagents.add_reagent("pwine", 100)

/obj/item/reagent_containers/food/drinks/bottle/redeemersbrew
	name = "Redeemer's Brew"
	desc = "Just opening the top of this bottle makes you feel a bit tipsy. Not for the faint of heart."
	icon_state = "redeemersbrew"
	center_of_mass = list("x"=16, "y"=3)

/obj/item/reagent_containers/food/drinks/bottle/redeemersbrew/Initialize(mapload)
	. = ..()
	reagents.add_reagent("unathiliquor", 100)

//////////////////////////JUICES AND STUFF ///////////////////////

/obj/item/reagent_containers/food/drinks/bottle/orangejuice
	name = "Orange Juice"
	desc = "Full of vitamins and deliciousness!"
	icon_state = "orangejuice"
	item_state = "carton"
	center_of_mass = list("x"=16, "y"=7)
	isGlass = 0

/obj/item/reagent_containers/food/drinks/bottle/orangejuice/Initialize(mapload)
	. = ..()
	reagents.add_reagent("orangejuice", 100)

/obj/item/reagent_containers/food/drinks/bottle/applejuice
	name = "Apple Juice"
	desc = "Squeezed, pressed and ground to perfection!"
	icon_state = "applejuice"
	item_state = "carton"
	center_of_mass = list("x"=16, "y"=7)
	isGlass = 0

/obj/item/reagent_containers/food/drinks/bottle/applejuice/Initialize(mapload)
	. = ..()
	reagents.add_reagent("applejuice", 100)

/obj/item/reagent_containers/food/drinks/bottle/milk
	name = "Large Milk Carton"
	desc = "It's milk. This carton's large enough to serve your biggest milk drinkers."
	icon_state = "milk"
	item_state = "carton"
	center_of_mass = list("x"=16, "y"=9)
	isGlass = 0

/obj/item/reagent_containers/food/drinks/bottle/milk/Initialize(mapload)
	. = ..()
	reagents.add_reagent("milk", 100)

/obj/item/reagent_containers/food/drinks/bottle/cream
	name = "Milk Cream"
	desc = "It's cream. Made from milk. What else did you think you'd find in there?"
	icon_state = "cream"
	item_state = "carton"
	center_of_mass = list("x"=16, "y"=8)
	isGlass = 0

/obj/item/reagent_containers/food/drinks/bottle/cream/Initialize(mapload)
	. = ..()
	reagents.add_reagent("cream", 100)

/obj/item/reagent_containers/food/drinks/bottle/tomatojuice
	name = "Tomato Juice"
	desc = "Well, at least it LOOKS like tomato juice. You can't tell with all that redness."
	icon_state = "tomatojuice"
	item_state = "carton"
	center_of_mass = list("x"=16, "y"=8)
	isGlass = 0

/obj/item/reagent_containers/food/drinks/bottle/tomatojuice/Initialize(mapload)
	. = ..()
	reagents.add_reagent("tomatojuice", 100)

/obj/item/reagent_containers/food/drinks/bottle/limejuice
	name = "Lime Juice"
	desc = "Sweet-sour goodness."
	icon_state = "limejuice"
	item_state = "carton"
	center_of_mass = list("x"=16, "y"=8)
	isGlass = 0

/obj/item/reagent_containers/food/drinks/bottle/limejuice/Initialize(mapload)
	. = ..()
	reagents.add_reagent("limejuice", 100)

/obj/item/reagent_containers/food/drinks/bottle/lemonjuice
	name = "Lemon Juice"
	desc = "Sweet-sour goodness. Minus the sweet."
	icon_state = "lemonjuice"
	item_state = "carton"
	center_of_mass = list("x"=16, "y"=8)
	isGlass = 0

/obj/item/reagent_containers/food/drinks/bottle/lemonjuice/Initialize(mapload)
	. = ..()
	reagents.add_reagent("lemonjuice", 100)

/obj/item/reagent_containers/food/drinks/bottle/coconutmilk
	name = "Coconut Milk"
	desc = "A carton of NutClarity brand coconut milk."
	icon_state = "milkbox"
	item_state = "carton"
	center_of_mass = list("x"=16, "y"=8)
	isGlass = 0

/obj/item/reagent_containers/food/drinks/bottle/coconutmilk/Initialize(mapload)
	. = ..()
	reagents.add_reagent("coconutmilk", 100)

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

/obj/item/reagent_containers/food/drinks/bottle/royaljelly/Initialize(mapload)
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
