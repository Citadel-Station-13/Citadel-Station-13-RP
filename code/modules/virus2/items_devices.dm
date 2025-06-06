///////////////ANTIBODY SCANNER///////////////

/obj/item/antibody_scanner
	name = "antibody scanner"
	desc = "Scans living beings for antibodies in their blood."
	icon_state = "health"
	w_class = WEIGHT_CLASS_SMALL
	item_state = "electronic"

/obj/item/antibody_scanner/legacy_mob_melee_hook(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	if(user.a_intent == INTENT_HARM)
		return ..()
	. = CLICKCHAIN_DO_NOT_PROPAGATE
	if(!iscarbon(target))
		report("Scan aborted: Incompatible target.", user)
		return

	var/mob/living/carbon/C = target
	if (istype(C,/mob/living/carbon/human/))
		var/mob/living/carbon/human/H = C
		if(!H.should_have_organ(O_HEART))
			report("Scan aborted: The target does not have blood.", user)
			return

	if(!C.antibodies.len)
		report("Scan Complete: No antibodies detected.", user)
		return

	if ((MUTATION_CLUMSY in user.mutations) && prob(50))
		// I was tempted to be really evil and rot13 the output.
		report("Antibodies detected: [reverse_text(antigens2string(C.antibodies))]", user)
	else
		report("Antibodies detected: [antigens2string(C.antibodies)]", user)

/obj/item/antibody_scanner/proc/report(var/text, mob/user as mob)
	to_chat(user, "<font color=#4F49AF>\[icon2html(thing = src, target = user)] \The [src] beeps,</font> \"<font color=#4F49AF>[text]</font>\"")

///////////////VIRUS DISH///////////////

/obj/item/virusdish
	name = "virus dish"
	icon = 'icons/obj/items.dmi'
	icon_state = "implantcase-b"
	worth_intrinsic = 35
	var/datum/disease2/disease/virus2 = null
	var/growth = 0
	var/basic_info = null
	var/info = 0
	var/analysed = 0

/obj/item/virusdish/random
	name = "virus sample"

	/// the worth of the contained random virus
	var/worth_contained_virus = 250

/obj/item/virusdish/random/Initialize(mapload)
	. = ..()
	virus2 = new /datum/disease2/disease
	virus2.makerandom()
	growth = rand(5, 50)

/obj/item/virusdish/random/get_containing_worth(flags)
	. = ..()
	if(flags & GET_WORTH_DETECTING_PRICE)
		. += worth_contained_virus

/obj/item/virusdish/attackby(var/obj/item/W as obj,var/mob/living/carbon/user as mob)
	if(istype(W,/obj/item/hand_labeler) || istype(W,/obj/item/reagent_containers/syringe))
		return
	..()
	if(prob(50))
		to_chat(user, "<span class='danger'>\The [src] shatters!</span>")
		if(virus2.infectionchance > 0)
			for(var/mob/living/carbon/target in view(1, get_turf(src)))
				if(airborne_can_reach(get_turf(src), get_turf(target)))
					infect_virus2(target, src.virus2)
		qdel(src)

/obj/item/virusdish/examine(mob/user, dist)
	. = ..()
	if(basic_info)
		. += "[basic_info] : <a href='?src=\ref[src];info=1'>More Information</a>"

/obj/item/virusdish/Topic(href, href_list)
	. = ..()
	if(.) return 1

	if(href_list["info"])
		usr << browse(info, "window=info_\ref[src]")
		return 1

/obj/item/ruinedvirusdish
	name = "ruined virus sample"
	icon = 'icons/obj/items.dmi'
	icon_state = "implantcase-b"
	desc = "The bacteria in the dish are completely dead."

/obj/item/ruinedvirusdish/attackby(var/obj/item/W as obj,var/mob/living/carbon/user as mob)
	if(istype(W,/obj/item/hand_labeler) || istype(W,/obj/item/reagent_containers/syringe))
		return ..()

	if(prob(50))
		to_chat(user, "\The [src] shatters!")
		qdel(src)

///////////////GNA DISK///////////////

/obj/item/diseasedisk
	name = "blank GNA disk"
	icon = 'icons/obj/cloning.dmi'
	icon_state = "datadisk0"
	w_class = WEIGHT_CLASS_TINY
	var/datum/disease2/effectholder/effect = null
	var/list/species = null
	var/stage = 1
	var/analysed = 1

/obj/item/diseasedisk/premade/Initialize(mapload)
	. = ..()
	name = "blank GNA disk (stage: [stage])"
	effect = new /datum/disease2/effectholder
	effect.effect = new /datum/disease2/effect/invisible
	effect.stage = stage
