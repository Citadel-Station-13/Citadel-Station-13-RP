////////////////////////////////////////////////////////////////////////////////
/// HYPOSPRAY
////////////////////////////////////////////////////////////////////////////////

/obj/item/reagent_containers/hypospray
	name = "hypospray"
	desc = "The DeForest Medical Corporation hypospray is a sterile, air-needle autoinjector for rapid administration of drugs to patients."
	icon = 'icons/obj/medical/syringe.dmi'
	item_state = "hypo"
	icon_state = "hypo"
	amount_per_transfer_from_this = 5
	unacidable = 1
	volume = 30
	possible_transfer_amounts = null
	flags = OPENCONTAINER
	slot_flags = SLOT_BELT
	drop_sound = 'sound/items/drop/gun.ogg'
	pickup_sound = 'sound/items/pickup/gun.ogg'
	preserve_item = 1
	var/filled = 0
	var/list/filled_reagents = list()
	var/hyposound	// What sound do we play on use?

/obj/item/reagent_containers/hypospray/Initialize(mapload)
	. = ..()
	if(filled)
		if(filled_reagents)
			for(var/r in filled_reagents)
				reagents.add_reagent(r, filled_reagents[r])
	update_icon()

/obj/item/reagent_containers/hypospray/attack(mob/living/M as mob, mob/user as mob)
	if(!reagents.total_volume)
		to_chat(user, "<span class='warning'>[src] is empty.</span>")
		return
	if (!istype(M))
		return

	var/mob/living/carbon/human/H = M
	if(istype(H))
		var/obj/item/organ/external/affected = H.get_organ(user.zone_sel.selecting)
		if(!affected)
			to_chat(user, "<span class='danger'>\The [H] is missing that limb!</span>")
			return
		else if(affected.robotic >= ORGAN_ROBOT)
			to_chat(user, "<span class='danger'>You cannot inject a robotic limb.</span>")
			return

		// Prototype Hypo functionality
		if(H != user && prototype)
			to_chat(user, "<span class='notice'>You begin injecting [H] with \the [src].</span>")
			to_chat(H, "<span class='danger'> [user] is trying to inject you with \the [src]!</span>")
			if(!do_after(user, 30, H))
				return
		else if(!H.stat && !prototype)
			if(H != user)
				if(H.a_intent != INTENT_HELP)
					to_chat(user, "<span class='notice'>[H] is resisting your attempt to inject them with \the [src].</span>")
					to_chat(H, "<span class='danger'> [user] is trying to inject you with \the [src]!</span>")
					if(!do_after(user, 30, H))
						return

	do_injection(H, user)
	return

// This does the actual injection and transfer.
/obj/item/reagent_containers/hypospray/proc/do_injection(mob/living/carbon/human/H, mob/living/user)
	if(!istype(H) || !istype(user))
		return FALSE

	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	to_chat(user, SPAN_NOTICE("You inject \the [H] with \the [src]."))
	to_chat(H, SPAN_WARNING( "You feel a tiny prick!"))

	if(hyposound)
		playsound(src, hyposound, 25)

	if(H.reagents)
		var/contained = reagentlist()
		var/trans = reagents.trans_to_mob(H, amount_per_transfer_from_this, CHEM_BLOOD)
		add_attack_logs(user,H,"Injected with [src.name] containing [contained], trasferred [trans] units")
		to_chat(user, SPAN_NOTICE("[trans] units injected. [reagents.total_volume] units remaining in \the [src]."))
		return TRUE
	return FALSE

//A vial-loaded hypospray. Cartridge-based!
/obj/item/reagent_containers/hypospray/vial
	name = "hypospray mkII"
	desc = "A new development from DeForest Medical, this new hypospray takes 30-unit vials as the drug supply for easy swapping."
	var/obj/item/reagent_containers/glass/beaker/vial/loaded_vial //Wow, what a name.
	volume = 0

/obj/item/reagent_containers/hypospray/vial/Initialize(mapload)
	. = ..()
	loaded_vial = new /obj/item/reagent_containers/glass/beaker/vial(src) //Comes with an empty vial
	volume = loaded_vial.volume
	reagents.maximum_volume = loaded_vial.reagents.maximum_volume

/obj/item/reagent_containers/hypospray/vial/attack_hand(mob/user as mob)
	if(user.get_inactive_held_item() == src)
		if(loaded_vial)
			reagents.trans_to_holder(loaded_vial.reagents,volume)
			reagents.maximum_volume = 0
			loaded_vial.update_icon()
			user.put_in_hands(loaded_vial)
			loaded_vial = null
			to_chat(user, "<span class='notice'>You remove the vial from the [src].</span>")
			update_icon()
			playsound(src.loc, 'sound/weapons/flipblade.ogg', 50, 1)
			return
		..()
	else
		return ..()

/obj/item/reagent_containers/hypospray/vial/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/reagent_containers/glass/beaker/vial))
		if(!loaded_vial)
			user.visible_message("<span class='notice'>[user] begins loading [W] into \the [src].</span>","<span class='notice'>You start loading [W] into \the [src].</span>")
			if(!do_after(user,30) || loaded_vial || !(W in user))
				return 0
			if(!user.attempt_insert_item_for_installation(W, src))
				return
			if(W.is_open_container())
				W.flags ^= OPENCONTAINER
				W.update_icon()
			loaded_vial = W
			reagents.maximum_volume = loaded_vial.reagents.maximum_volume
			loaded_vial.reagents.trans_to_holder(reagents,volume)
			user.visible_message("<span class='notice'>[user] has loaded [W] into \the [src].</span>","<span class='notice'>You have loaded [W] into \the [src].</span>")
			update_icon()
			playsound(src.loc, 'sound/weapons/empty.ogg', 50, 1)
		else
			to_chat(user, "<span class='notice'>\The [src] already has a vial.</span>")
	else
		..()

/obj/item/reagent_containers/hypospray/autoinjector
	name = "autoinjector"
	desc = "A rapid and safe way to administer small amounts of drugs by untrained or trained personnel."
	icon_state = "blue"
	item_state = "blue"
	amount_per_transfer_from_this = 5
	volume = 5
	filled = 1
	filled_reagents = list("inaprovaline" = 5)
	preserve_item = 0
	hyposound = 'sound/effects/hypospray.ogg'

/obj/item/reagent_containers/hypospray/autoinjector/on_reagent_change()
	..()
	update_icon()

/obj/item/reagent_containers/hypospray/autoinjector/empty
	filled = 0
	filled_reagents = list()

/obj/item/reagent_containers/hypospray/autoinjector/used/Initialize(mapload)
	. = ..()
	flags &= ~OPENCONTAINER
	icon_state = "[initial(icon_state)]0"

/obj/item/reagent_containers/hypospray/autoinjector/do_injection(mob/living/carbon/human/H, mob/living/user)
	. = ..()
	if(.) // Will occur if successfully injected.
		flags &= ~OPENCONTAINER
		update_icon()

/obj/item/reagent_containers/hypospray/autoinjector/update_icon()
	if(reagents.total_volume > 0)
		icon_state = "[initial(icon_state)]1"
	else
		icon_state = "[initial(icon_state)]0"

/obj/item/reagent_containers/hypospray/autoinjector/examine(mob/user)
	. = ..()
	if(reagents && reagents.reagent_list.len)
		. += "<span class='notice'>It is currently loaded.</span>"
	else
		. += "<span class='notice'>It is spent.</span>"

/obj/item/reagent_containers/hypospray/autoinjector/detox
	name = "autoinjector (antitox)"
	icon_state = "green"
	filled_reagents = list("anti_toxin" = 5)

// These have a 15u capacity, somewhat higher tech level, and generally more useful chems, but are otherwise the same as the regular autoinjectors.
/obj/item/reagent_containers/hypospray/autoinjector/biginjector
	name = "empty hypo"
	desc = "A refined version of the standard autoinjector, allowing greater capacity."
	icon_state = "autoinjector"
	amount_per_transfer_from_this = 15
	volume = 15
	origin_tech = list(TECH_BIO = 4)
	filled_reagents = list("inaprovaline" = 15)

/obj/item/reagent_containers/hypospray/autoinjector/biginjector/brute
	name = "trauma hypo"
	desc = "A refined version of the standard autoinjector, allowing greater capacity.  This one is made to be used on victims of \
	moderate blunt trauma."
	filled_reagents = list("bicaridine" = 15)

/obj/item/reagent_containers/hypospray/autoinjector/biginjector/burn
	name = "burn hypo"
	desc = "A refined version of the standard autoinjector, allowing greater capacity.  This one is made to be used on burn victims, \
	featuring an optimized chemical mixture to allow for rapid healing."
	filled_reagents = list("kelotane" = 7.5, "dermaline" = 7.5)

/obj/item/reagent_containers/hypospray/autoinjector/biginjector/toxin
	name = "toxin hypo"
	desc = "A refined version of the standard autoinjector, allowing greater capacity.  This one is made to counteract toxins."
	filled_reagents = list("anti_toxin" = 15)

/obj/item/reagent_containers/hypospray/autoinjector/biginjector/oxy
	name = "oxy hypo"
	desc = "A refined version of the standard autoinjector, allowing greater capacity.  This one is made to counteract oxygen \
	deprivation."
	filled_reagents = list("dexalinp" = 10, "tricordrazine" = 5)

/obj/item/reagent_containers/hypospray/autoinjector/biginjector/purity
	name = "purity hypo"
	desc = "A refined version of the standard autoinjector, allowing greater capacity.  This variant excels at \
	resolving viruses, infections, radiation, and genetic maladies."
	filled_reagents = list("spaceacillin" = 9, "arithrazine" = 5, "ryetalyn" = 1)

/obj/item/reagent_containers/hypospray/autoinjector/biginjector/pain
	name = "pain hypo"
	desc = "A refined version of the standard autoinjector, allowing greater capacity.  This one contains potent painkillers."
	filled_reagents = list("tramadol" = 15)

/obj/item/reagent_containers/hypospray/autoinjector/biginjector/organ
	name = "organ hypo"
	desc = "A refined version of the standard autoinjector, allowing greater capacity.  Organ damage is resolved by this variant."
	filled_reagents = list("alkysine" = 3, "imidazoline" = 2, "peridaxon" = 10)

/obj/item/reagent_containers/hypospray/autoinjector/biginjector/combat
	name = "combat hypo"
	desc = "A refined version of the standard autoinjector, allowing greater capacity.  This is a more dangerous and potentially \
	addictive hypo compared to others, as it contains a potent cocktail of various chemicals to optimize the recipient's combat \
	ability."
	filled_reagents = list("bicaridine" = 3, "kelotane" = 1.5, "dermaline" = 1.5, "oxycodone" = 3, "hyperzine" = 3, "tricordrazine" = 3)

/obj/item/reagent_containers/hypospray/autoinjector/biginjector/clotting
	name = "clotting agent"
	desc = "A refined version of the standard autoinjector, allowing greater capacity. This variant excels at treating bleeding wounds and internal bleeding."
	filled_reagents = list("inaprovaline" = 5, "myelamine" = 10)

/obj/item/reagent_containers/hypospray/autoinjector/biginjector/bonemed
	name = "bone repair injector"
	desc = "A refined version of the standard autoinjector, allowing greater capacity. This one excels at treating damage to bones."
	filled_reagents = list("inaprovaline" = 5, "osteodaxon" = 10)

/obj/item/reagent_containers/hypospray/autoinjector/biginjector/glucose
	name = "glucose hypo"
	desc = "A hypoinjector filled with glucose, used for critically malnourished patients and voidsuited workers."
	filled_reagents = list("glucose" = 15)

/obj/item/reagent_containers/hypospray/autoinjector/biginjector/stimm
	name = "stimm injector"
	desc = "A refined version of the standard autoinjector, allowing greater capacity. \
	This one is filled with a home-made stimulant, with some serious side-effects."
	filled_reagents = list("stimm" = 10) // More than 10u will OD.

/obj/item/reagent_containers/hypospray/autoinjector/biginjector/expired
	name = "expired injector"
	desc = "A refined version of the standard autoinjector, allowing greater capacity. \
	This one has had its contents expire a long time ago, using it now will probably make someone sick, or worse."
	filled_reagents = list("expired_medicine" = 15)

/obj/item/reagent_containers/hypospray/autoinjector/biginjector/soporific
	name = "soporific injector"
	desc = "A refined version of the standard autoinjector, allowing greater capacity. \
	This one is sometimes used by orderlies, as it has soporifics, which make someone tired and fall asleep."
	filled_reagents = list("stoxin" = 15)

/obj/item/reagent_containers/hypospray/autoinjector/biginjector/cyanide
	name = "cyanide injector"
	desc = "A refined version of the standard autoinjector, allowing greater capacity. \
	This one contains cyanide, a lethal poison. It being inside a medical autoinjector has certain unsettling implications."
	filled_reagents = list("cyanide" = 15)

/obj/item/reagent_containers/hypospray/autoinjector/biginjector/serotrotium
	name = "serotrotium injector"
	desc = "A refined version of the standard autoinjector, allowing greater capacity. \
	This one is filled with serotrotium, which causes concentrated production of the serotonin neurotransmitter in humans."
	filled_reagents = list("serotrotium" = 15)

/obj/item/reagent_containers/hypospray/autoinjector/biginjector/space_drugs
	name = "illicit injector"
	desc = "A refined version of the standard autoinjector, allowing greater capacity. \
	This one contains various illicit drugs, held inside a hypospray to make smuggling easier."
	filled_reagents = list("space_drugs" = 15)

/obj/item/reagent_containers/hypospray/autoinjector/biginjector/cryptobiolin
	name = "cryptobiolin injector"
	desc = "A refined version of the standard autoinjector, allowing greater capacity. \
	This one contains cryptobiolin, which causes confusion."
	filled_reagents = list("cryptobiolin" = 15)

/obj/item/reagent_containers/hypospray/autoinjector/biginjector/impedrezene
	name = "impedrezene injector"
	desc = "A refined version of the standard autoinjector, allowing greater capacity. \
	This one has impedrezene inside, a narcotic that impairs higher brain functioning. \
	This autoinjector is almost certainly created illegitimately."
	filled_reagents = list("impedrezene" = 15)

/obj/item/reagent_containers/hypospray/autoinjector/biginjector/mindbreaker
	name = "mindbreaker injector"
	desc = "A refined version of the standard autoinjector, allowing greater capacity. \
	This one stores the dangerous hallucinogen called 'Mindbreaker', likely put in place \
	by illicit groups hoping to hide their product."
	filled_reagents = list("mindbreaker" = 15)

/obj/item/reagent_containers/hypospray/autoinjector/biginjector/psilocybin
	name = "psilocybin injector"
	desc = "A refined version of the standard autoinjector, allowing greater capacity. \
	This has psilocybin inside, which is a strong psychotropic derived from certain species of mushroom. \
	This autoinjector likely was made by criminal elements to avoid detection from casual inspection."
	filled_reagents = list("psilocybin" = 15)

/obj/item/reagent_containers/hypospray/autoinjector/biginjector/mutagen
	name = "unstable mutagen injector"
	desc = "A refined version of the standard autoinjector, allowing greater capacity. \
	This contains unstable mutagen, which makes using this a very bad idea. It will either \
	ruin your genetic health, turn you into a Five Points violation, or both!"
	filled_reagents = list("mutagen" = 15)

/obj/item/reagent_containers/hypospray/autoinjector/biginjector/lexorin
	name = "lexorin injector"
	desc = "A refined version of the standard autoinjector, allowing greater capacity. \
	This contains lexorin, a dangerous toxin that stops respiration, and has been \
	implicated in several high-profile assassinations in the past."
	filled_reagents = list("lexorin" = 15)

/obj/item/reagent_containers/hypospray/autoinjector/biginjector/healing_nanites
	name = "medical nanite injector"
	desc = "A refined version of the standard autoinjector, allowing greater capacity. \
	The injector stores a slurry of highly advanced and specialized nanomachines designed \
	to restore bodily health from within. The nanomachines are short-lived but degrade \
	harmlessly, and cannot self-replicate in order to remain Five Points compliant."
	filled_reagents = list("healing_nanites" = 15)

/obj/item/reagent_containers/hypospray/autoinjector/biginjector/defective_nanites
	name = "defective nanite injector"
	desc = "A refined version of the standard autoinjector, allowing greater capacity. \
	The injector stores a slurry of highly advanced and specialized nanomachines that \
	are unfortunately malfunctioning, making them unsafe to use inside of a living body. \
	Because of the Five Points, these nanites cannot self-replicate."
	filled_reagents = list("defective_nanites" = 15)

/obj/item/reagent_containers/hypospray/autoinjector/biginjector/contaminated
	name = "contaminated injector"
	desc = "A refined version of the standard autoinjector, allowing greater capacity. \
	The hypospray contains a viral agent inside, as well as a liquid substance that encourages \
	the growth of the virus inside."
	filled_reagents = list("virusfood" = 15)

/obj/item/reagent_containers/hypospray/autoinjector/biginjector/contaminated/do_injection(mob/living/carbon/human/H, mob/living/user)
	. = ..()
	if(.) // Will occur if successfully injected.
		infect_mob_random_lesser(H)
		add_attack_logs(user, H, "Infected \the [H] with \the [src], by \the [user].")

/obj/item/reagent_containers/hypospray/autoinjector/biginjector/neuratrextate
	name = "neuratrextate injector"
	desc = "A refined version of the standard autoinjector, allowing greater capacity. \
	The hypospray contains a potent compound of immunosuppressants and antipsychotics \
	designed to be rapidly delivered to victims of CRS in case of emergency."
	filled_reagents = list("neuratrextate" = 15)

//Hjorthorn's Drug Injectors
/obj/item/reagent_containers/hypospray/glukoz
	name = "Tizzy"
	desc = "A colorful plastic autoinjector – it’s well past its expiry date. This one is quite scuffed and is largely illegible. A sticker reading ‘50% OFF!’ is peeling off the side."
	icon_state = "tizzy"
	amount_per_transfer_from_this = 20
	volume = 20
	filled = 1
	flags = OPENCONTAINER
	origin_tech = list(TECH_BIO = 4, TECH_ILLEGAL = 3)
	filled_reagents = list("impedrezene" = 15, "toxin" = 5)
	preserve_item = 0
	var/closed = 1

/obj/item/reagent_containers/hypospray/glukoz/on_reagent_change()
	..()
	update_icon()
/obj/item/reagent_containers/hypospray/glukoz/empty
	filled = 0
	filled_reagents = list()

/obj/item/reagent_containers/hypospray/glukoz/used/Initialize(mapload)
	. = ..()
	flags &= ~OPENCONTAINER

	icon_state = "[initial(icon_state)]_used"

/obj/item/reagent_containers/hypospray/glukoz/attack_self(mob/user)
	. = ..()
	if (closed)
		closed = 0
		playsound(loc,"canopen", rand(10,50), 1)
		to_chat(user, "<span class='notice'>You open [src] with an audible pop!</span>")
		update_icon()
	else
		return

/obj/item/reagent_containers/hypospray/glukoz/attack(mob/living/H as mob, mob/user as mob)
	if(closed)
		to_chat(user, "<span class='notice'>You can't use [src] until you open it!</span>")
		return
	if(!filled)
		to_chat(user, "<span class='notice'>This [src] is empty!</span>")
		return
	if(!closed)
		do_injection(H, user)
		return

/obj/item/reagent_containers/hypospray/glukoz/do_injection(mob/living/carbon/human/H, mob/living/user)
	. = ..()
	if(.) // Will occur if successfully injected.
		flags &= ~OPENCONTAINER
		to_chat(user, "<span class='notice'>You jab the [src] needle into your skin!</span>")
		icon_state = "[initial(icon_state)]_used"
		filled = 0
		filled_reagents = list()

/obj/item/reagent_containers/hypospray/glukoz/update_icon()
	if(closed)
		icon_state = "[initial(icon_state)]_closed"
	else
		icon_state = "[initial(icon_state)]_ready"

/obj/item/reagent_containers/hypospray/glukoz/examine(mob/user)
	. = ..()
	if(reagents && reagents.reagent_list.len)
		. += "<span class='notice'>It is currently loaded.</span>"
	else
		. += "<span class='notice'>It is spent.</span>"

//Glukoz Brand Injectors:
/obj/item/reagent_containers/hypospray/glukoz/viraplus
	name = "Viraplus"
	desc = "A colorful plastic autoinjector. This one depicts a virus getting shot by a beam."
	icon_state = "viraplus"
	filled_reagents = list("corophizine" = 15, "toxin" = 5)

/obj/item/reagent_containers/hypospray/glukoz/pyrholidon
	name = "Pyrholidon"
	desc = "A plain steel autoinjector with a worn label. ‘Experimental: use only to treat acute radiation poisoning. Side effects include may include feelings of euphoria, and bleeding from the eyes and nose.’"
	icon_state = "pyrholidon"
	filled_reagents = list("space_drugs" = 10, "arithrazine" = 10)

/obj/item/reagent_containers/hypospray/glukoz/oxyduo
	name = "OxyDuo"
	desc = "A colorful plastic autoinjector. ‘10% more opiate than leading competitors!’"
	icon_state = "oxyduo"
	filled_reagents = list("oxycodone" = 15, "toxin" = 5)

/obj/item/reagent_containers/hypospray/glukoz/numplus
	name = "Numplus"
	desc = "A colorful plastic autoinjector. This one depicts a stick figure gripping its knee in pain."
	icon_state = "numplus"
	filled_reagents = list("tramadol" = 15, "toxin" = 5)

/obj/item/reagent_containers/hypospray/glukoz/multibuzz
	name = "Multibuzz"
	desc = "A colorful plastic autoinjector. ‘Our premium blend of narcotics is guaranteed to ease tension!’"
	icon_state = "multibuzz"
	filled_reagents = list("mindbreaker" = 10, "paroxetine" = 10)

/obj/item/reagent_containers/hypospray/glukoz/medcon
	name = "Medcon"
	desc = "A colorful plastic autoinjector. ‘Intended for emergency use only. One dose relieves pain and fights internal bleeding.’"
	icon_state = "medcon"
	filled_reagents = list("myelamine" = 15, "oxycodone" = 5)

/obj/item/reagent_containers/hypospray/glukoz/hypnogamma
	name = "Hypnogamma"
	desc = "A colorful plastic autoinjector. ‘Our premium blend of performance enhancers will help you rise to the occasion.’"
	icon_state = "hypnogamma"
	filled_reagents = list("hyperzine" = 5, "methylphenidate" = 15)

/obj/item/reagent_containers/hypospray/glukoz/hangup
	name = "Hangup"
	desc = "A colorful plastic autoinjector. ‘The only hangover cure that really works!’"
	icon_state = "hangup"
	filled_reagents = list("ethylredoxrazine" = 15, "toxin" = 5)

/obj/item/reagent_containers/hypospray/glukoz/fuckit
	name = "FUCK!T"
	desc = "A colorful steel autoinjector with a menacing aura. ‘A LAST RESORT YOU CAN COUNT ON! Danger: amphetamines are highly addictive. Use only in times of extreme duress.’"
	icon_state = "fuckit"
	amount_per_transfer_from_this = 60
	volume = 60
	filled_reagents = list("stimm" = 40, "oxycodone" = 20)

/obj/item/reagent_containers/hypospray/glukoz/downer
	name = "Downer"
	desc = "A colorful plastic autoinjector. ‘For when you’ve got too much on your mind!’"
	icon_state = "downer"
	filled_reagents = list("cryptobiolin" = 20)

/obj/item/reagent_containers/hypospray/glukoz/certaphil
	name = "Certaphil"
	desc = "A colorful plastic autoinjector. ‘Clinical trials have proven Certaphil to be the market’s leading sleep aid. Please use responsibly.’"
	icon_state = "cosbytrine"
	filled_reagents = list("stoxin" = 20)

/obj/item/reagent_containers/hypospray/glukoz/assisticide
	name = "Assisticide"
	desc = "A plain steel autoinjector with large warning label. ‘Please consult with your doctor before deciding if Assisticide is right for you. Please use responsibly.’"
	icon_state = "assisticide"
	filled_reagents = list("chloralhydrate" = 20)

/obj/item/reagent_containers/hypospray/glukoz/ankh
	name = "Ankh"
	desc = "A plain brass autoinjector with an esoteric label. ‘Take a day trip to the Field of Reeds.’"
	icon_state = "ankh"
	filled_reagents = list("zombiepowder" = 20)
