// HONK mecha are similar in speed and robustness to Gygaxes.

/datum/category_item/catalogue/technology/honker
	name = "Exosuit - H.O.N.K."

	desc = "Utilized with shocking effectiveness during the Prank War of 2476, the H.O.N.K. mech was commissioned by former \
	Honktifex Maximus Pierrot LXIX. Utilizing advanced technology for its time, these mecha were constructed utilizing the extremely rare \
	alloy Vaudium. Viewed by external observers as a simple curiosity, the H.O.N.K. mech's ability to inflict widespread 'hilarity' was not \
	realized until the design was made public some decades later. After less than two years on the open market, harsh sanctions and bans on \
	production were levied across at least thirty six Galactic sectors. In spite of this production moratorium, experts in Robotics may sometimes \
	ignore the warnings and fabricate these suits when asked. This is generally considered to be a poor decision.There is some dispute regarding \
	exactly what H.O.N.K. stands for. The most likely suggestion is generallly accepted to be: 'Hilariously Overpowered Noise Kreator'"
	value = CATALOGUER_REWARD_HARD

/mob/living/simple_mob/mechanical/mecha/combat/honker
	name = "H.O.N.K."
	desc = "The H.O.N.K. mecha is sometimes crafted by deranged Roboticists with a grudge, and is illegal in thirty six different sectors."
	catalogue_data = list(/datum/category_item/catalogue/technology/honker)
	icon_state = "honker"
	movement_cooldown = 1
	wreckage = /obj/structure/loot_pile/mecha/honker

	maxHealth = 250
	armor = list(
				"melee"		= 25,
				"bullet"	= 20,
				"laser"		= 30,
				"energy"	= 15,
				"bomb"		= 0,
				"bio"		= 100,
				"rad"		= 100
				)

	projectiletype = /obj/item/projectile/bullet/honker/lethal

	ai_holder_type = /datum/ai_holder/simple_mob/ranged/aggressive

/mob/living/simple_mob/mechanical/mecha/combat/honker/manned
	pilot_type = /mob/living/simple_mob/humanoid/clown/commando/ranged // Carries a banana gun.


// A stronger variant.

/datum/category_item/catalogue/technology/cluwne
	name = "Exosuit - C.L.U.W.N.E."

	desc = "As the unending battle over Vaudium wages to this day, it should come as no surprise that both \
	Clowns and Mimes continue to iterate on their unique forms of military technology. The C.L.U.W.N.E. is the \
	successor to the H.O.N.K. mech. Utilizing similar design philosophy and based off of the same chassis, the \
	C.L.U.W.N.E. is significantly more armored and durable, addressing several vulnerabilities in the original H.O.N.K. \
	design. Demonstrably effective, these mecha are frequently deployed on the front lines of the conflict, and may rarely be \
	dispatched off-planet to support Clown Commando teams. Due to the immense amount of Vaudium required to fabricate a \
	single C.L.U.W.N.E. mech, their mass production remains untenable. Even if it were, Clown Planet guards the mech's schematics \
	jealously. It is currently assumed that the mecha's designation stands for 'Combative Laughter Unit With New Equipment', though \
	this theory is widely disputed."
	value = CATALOGUER_REWARD_HARD

/mob/living/simple_mob/mechanical/mecha/combat/honker/cluwne
	name = "C.L.U.W.N.E."
	desc = "The C.L.U.W.N.E. mecha is an up-armored cousin of the H.O.N.K. mech. Still in service on the borders of the Clown Planet, this unit is not typically found elsewhere."
	catalogue_data = list(/datum/category_item/catalogue/technology/cluwne)
	icon = 'icons/mecha/mecha_vr.dmi'
	icon_state = "cluwne"
	wreckage = /obj/structure/loot_pile/mecha/honker/cluwne

	maxHealth = 400
	deflect_chance = 25
	has_repair_droid = TRUE
	armor = list(
				"melee"		= 40,
				"bullet"	= 40,
				"laser"		= 50,
				"energy"	= 35,
				"bomb"		= 20,
				"bio"		= 100,
				"rad"		= 100
				)

	projectiletype = /obj/item/projectile/bullet/honker/lethal/heavy
