// go away oldcode

/obj/item/reagent_containers/syringe/ld50_syringe
	name = "Lethal Injection Syringe"
	desc = "A syringe used for lethal injections."
	amount_per_transfer_from_this = 50
	volume = 50
	visible_name = "a giant syringe"
	time = 300

/obj/item/reagent_containers/syringe/ld50_syringe/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	if(mode == SYRINGE_DRAW && ismob(target)) // No drawing 50 units of blood at once
		to_chat(user, "<span class='notice'>This needle isn't designed for drawing blood.</span>")
		return
	if(user.a_intent == "hurt" && ismob(target)) // No instant injecting
		to_chat(user, "<span class='notice'>This syringe is too big to stab someone with it.</span>")
	..()

/obj/item/reagent_containers/syringe/inaprovaline
	name = "Syringe (inaprovaline)"
	desc = "Contains inaprovaline - used to stabilize patients."

/obj/item/reagent_containers/syringe/inaprovaline/Initialize(mapload)
	. = ..()
	reagents.add_reagent("inaprovaline", 15)

/obj/item/reagent_containers/syringe/antitoxin
	name = "Syringe (anti-toxin)"
	desc = "Contains anti-toxins."

/obj/item/reagent_containers/syringe/antitoxin/Initialize(mapload)
	. = ..()
	reagents.add_reagent("anti_toxin", 15)

/obj/item/reagent_containers/syringe/antiviral
	name = "Syringe (spaceacillin)"
	desc = "Contains antiviral agents."

/obj/item/reagent_containers/syringe/antiviral/Initialize(mapload)
	. = ..()
	reagents.add_reagent("spaceacillin", 15)

/obj/item/reagent_containers/syringe/drugs
	name = "Syringe (drugs)"
	desc = "Contains aggressive drugs meant for torture."

/obj/item/reagent_containers/syringe/drugs/Initialize(mapload)
	. = ..()
	reagents.add_reagent("space_drugs",  5)
	reagents.add_reagent("mindbreaker",  5)
	reagents.add_reagent("cryptobiolin", 5)

/obj/item/reagent_containers/syringe/ld50_syringe/choral/Initialize(mapload)
	. = ..()
	reagents.add_reagent("chloralhydrate", 50)
	mode = SYRINGE_INJECT
	update_icon()

/obj/item/reagent_containers/syringe/steroid
	name = "Syringe (anabolic steroids)"
	desc = "Contains drugs for muscle growth."

/obj/item/reagent_containers/syringe/steroid/Initialize(mapload)
	. = ..()
	reagents.add_reagent("hyperzine",10)
