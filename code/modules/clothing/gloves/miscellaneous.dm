/obj/item/clothing/gloves/captain
	desc = "Regal blue gloves, with a nice gold trim. Swanky."
	name = "Facility Director's gloves"
	icon_state = "captain"
	item_state_slots = list(slot_r_hand_str = "blue", slot_l_hand_str = "blue")

/obj/item/clothing/gloves/cyborg
	desc = "beep boop borp"
	name = "cyborg gloves"
	icon_state = "black"
	item_state = "r_hands"
	siemens_coefficient = 1.0

/obj/item/clothing/gloves/forensic
	desc = "Specially made gloves for forensic technicians. The luminescent threads woven into the material stand out under scrutiny."
	name = "forensic gloves"
	icon_state = "forensic"
	item_state = "black"
	permeability_coefficient = 0.05

	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/gloves/swat
	desc = "These tactical gloves are somewhat fire and impact-resistant."
	name = "\improper SWAT Gloves"
	icon_state = "swat"
	item_state = "swat"
	siemens_coefficient = 0.50
	permeability_coefficient = 0.05
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/gloves/combat //Combined effect of SWAT gloves and insulated gloves
	desc = "These tactical gloves are somewhat fire and impact resistant."
	name = "combat gloves"
	icon_state = "swat"
	item_state = "swat"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/gloves/combat/advanced //punchy combat glubbs
	name = "advanced combat gloves"
	desc = "These advanced tactical gloves are fire and impact resistant, with the addition of weighted knuckles and durable synthetics."
	force = 5
	punch_force = 5
	armor = list(melee = 30, bullet = 10, laser = 10, energy = 15, bomb = 20, bio = 0, rad = 0)

/obj/item/clothing/gloves/sterile
	name = "sterile gloves"
	desc = "Sterile gloves."
	icon_state = "latex"
	item_state_slots = list(slot_r_hand_str = "white", slot_l_hand_str = "white")
	siemens_coefficient = 1.0 //thin latex gloves, much more conductive than fabric gloves (basically a capacitor for AC)
	permeability_coefficient = 0.01
	germ_level = 0
	fingerprint_chance = 25
	drop_sound = 'sound/items/drop/rubber.ogg'
	pickup_sound = 'sound/items/pickup/rubber.ogg'
//	var/balloonPath = /obj/item/latexballon

//TODO: Make inflating gloves a thing
/*/obj/item/clothing/gloves/sterile/proc/Inflate(/mob/living/carbon/human/user)
	user.visible_message("<span class='notice'>\The [src] expands!</span>")
	qdel(src)*/

/obj/item/clothing/gloves/sterile/latex
	name = "latex gloves"
	desc = "Sterile latex gloves."

/obj/item/clothing/gloves/sterile/nitrile
	name = "nitrile gloves"
	desc = "Sterile nitrile gloves"
	icon_state = "nitrile"
	item_state = "nitrile"

/obj/item/clothing/gloves/botanic_leather
	desc = "These leather work gloves protect against thorns, barbs, prickles, spikes and other harmful objects of floral origin."
	name = "botanist's leather gloves"
	icon_state = "leather"
	item_state_slots = list(slot_r_hand_str = "lightbrown", slot_l_hand_str = "lightbrown")
	permeability_coefficient = 0.05
	siemens_coefficient = 0.75 //thick work gloves
	drop_sound = 'sound/items/drop/leather.ogg'
	pickup_sound = 'sound/items/pickup/leather.ogg'

/obj/item/clothing/gloves/duty
	desc = "These brown duty gloves are made from a durable synthetic."
	name = "work gloves"
	icon_state = "work"
	item_state = "wgloves"
	armor = list(melee = 10, bullet = 10, laser = 10, energy = 5, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/gloves/tactical
	desc = "These brown tactical gloves are made from a durable synthetic, and have hardened knuckles."
	name = "tactical gloves"
	icon_state = "work"
	item_state = "wgloves"
	force = 5
	punch_force = 3
	siemens_coefficient = 0.75
	permeability_coefficient = 0.05
	armor = list(melee = 30, bullet = 10, laser = 10, energy = 15, bomb = 20, bio = 0, rad = 0)

/obj/item/clothing/gloves/vox
	desc = "These bizarre gauntlets seem to be fitted for... bird claws?"
	name = "insulated gauntlets"
	icon_state = "gloves-vox"
	item_state = "gloves-vox"
	flags = PHORONGUARD
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	species_restricted = list(SPECIES_VOX)
	drop_sound = 'sound/items/drop/metalboots.ogg'
	pickup_sound = 'sound/items/pickup/toolbox.ogg'

	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/gloves/knuckledusters
	name = "knuckle dusters"
	desc = "A pair of brass knuckles. Generally used to enhance the user's punches."
	icon_state = "knuckledusters"
	matter = list("brass" = 500)
	attack_verb = list("punched", "beaten", "struck")
	flags = THICKMATERIAL	// Stops rings from increasing hit strength
	siemens_coefficient = 1
	fingerprint_chance = 100
	overgloves = 1
	force = 5
	punch_force = 5
	drop_sound = 'sound/items/drop/metalboots.ogg'
	pickup_sound = 'sound/items/pickup/toolbox.ogg'

/obj/item/clothing/gloves/ranger
	var/glovecolor = "white"
	name = "ranger gloves"
	desc = "The gloves of the Rangers are the least memorable part. They're not even insulated in the show, so children \
	don't try and take apart a toaster with inadequate protection. They only serve to complete the fancy outfit."
	icon = 'icons/obj/clothing/ranger.dmi'
	icon_state = "ranger_gloves"

/obj/item/clothing/gloves/ranger/Initialize(mapload)
	. = ..()
	if(icon_state == "ranger_gloves")
		name = "[glovecolor] ranger gloves"
		icon_state = "[glovecolor]_ranger_gloves"

/obj/item/clothing/gloves/ranger/black
	glovecolor = "black"

/obj/item/clothing/gloves/ranger/pink
	glovecolor = "pink"

/obj/item/clothing/gloves/ranger/green
	glovecolor = "green"

/obj/item/clothing/gloves/ranger/cyan
	glovecolor = "cyan"

/obj/item/clothing/gloves/ranger/orange
	glovecolor = "orange"

/obj/item/clothing/gloves/ranger/yellow
	glovecolor = "yellow"

/obj/item/clothing/gloves/swat/para //Combined effect of SWAT gloves and insulated gloves
	desc = "PARA gloves"
	name = "PMD issued gloves, stamped with protective seals and spells."
	icon_state = "para_ert_gloves"
	item_state = "para_ert_gloves"
	action_button_name = "Enable Glove Sigils"

	var/blessed = FALSE

/obj/item/clothing/gloves/swat/para/attack_self(mob/user as mob)
	if(user.mind.isholy && !blessed)
		blessed = TRUE
		siemens_coefficient = 0
		to_chat(user, "<font color=#4F49AF>You repeat the incantations etched into the gloves.</font>")
	else
		blessed = FALSE
		siemens_coefficient = 0.5
		to_chat(user, "<font color=#4F49AF>You dispel the incantations eteched into the gloves for now.</font>")

	if(!user.mind.isholy)
		to_chat(user, "<font color='red'>You're not sure what language this is.</font>")

/obj/item/clothing/gloves/bountyskin
	name = "bounty hunter skinsuit (gloves)"
	desc = "These gloves were originally integrated into the bounty hunter skinsuit. Later iterations were made removable for practicality."
	icon_state = "bountyskin"

/* Full port pending. Some of these are nuts.

/obj/item/clothing/gloves/fingerless/pugilist
	name = "armwraps"
	desc = "A series of armwraps. Makes you pretty keen to start punching people."
	icon_state = "armwraps"
	body_parts_covered = ARMS
	cold_protection = ARMS
	strip_delay = 300 //you can't just yank them off
	obj_flags = UNIQUE_RENAME
	/// did you ever get around to wearing these or no
	var/wornonce = FALSE
	///Extra damage through the punch.
	var/enhancement = 0 //it's a +0 to your punches because it isn't magical
	///extra wound bonus through the punch (MAYBE DON'T BE GENEROUS WITH THIS)
	var/wound_enhancement = 0
	/// do we give the flavortext for wearing them
	var/silent = FALSE
	///Main trait added by the gloves to the user on wear.
	var/inherited_trait = TRAIT_NOGUNS //what are you, dishonoroable?
	///Secondary trait added by the gloves to the user on wear.
	var/secondary_trait = TRAIT_FEARLESS //what are you, a coward?

/obj/item/clothing/gloves/fingerless/pugilist/equipped(mob/user, slot)
	. = ..()
	if(slot == SLOT_GLOVES)
		wornonce = TRUE
		if((HAS_TRAIT(user, TRAIT_NOPUGILIST)))
			to_chat(user, "<span class='danger'>What purpose is there to don the weapons of pugilism if you're already well-practiced in martial arts? Mixing arts is blasphemous!</span>")
			return
		use_buffs(user, TRUE)

/obj/item/clothing/gloves/fingerless/pugilist/dropped(mob/user)
	. = ..()
	if(wornonce)
		wornonce = FALSE
		if((HAS_TRAIT(user, TRAIT_NOPUGILIST)))
			return
		use_buffs(user, FALSE)

/obj/item/clothing/gloves/fingerless/pugilist/proc/use_buffs(mob/user, buff)
	if(buff) // tarukaja
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			ADD_TRAIT(H, TRAIT_PUGILIST, GLOVE_TRAIT)
			ADD_TRAIT(H, inherited_trait, GLOVE_TRAIT)
			ADD_TRAIT(H, secondary_trait, GLOVE_TRAIT)
			H.dna.species.punchdamagehigh += enhancement
			H.dna.species.punchdamagelow += enhancement
			H.dna.species.punchwoundbonus += wound_enhancement
			if(!silent)
				to_chat(H, "<span class='notice'>With [src] on your arms, you feel ready to punch things.</span>")
	else // dekaja
		REMOVE_TRAIT(user, TRAIT_PUGILIST, GLOVE_TRAIT)
		REMOVE_TRAIT(user, inherited_trait, GLOVE_TRAIT)
		REMOVE_TRAIT(user, secondary_trait, GLOVE_TRAIT)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.dna.species.punchdamagehigh -= enhancement
			H.dna.species.punchdamagelow -= enhancement
			H.dna.species.punchwoundbonus -= wound_enhancement
			H.dna?.species?.attack_sound_override = null
		if(!silent)
			to_chat(user, "<span class='warning'>With [src] off of your arms, you feel less ready to punch things.</span>")

/obj/item/clothing/gloves/fingerless/pugilist/crafted
	unique_reskin = list("Short" = "armwraps",
						"Extended" = "armwraps_extended"
						)

/obj/item/clothing/gloves/fingerless/pugilist/crafted/reskin_obj(mob/M)
	. = ..()
	if(icon_state == "armwraps_extended")
		item_state = "armwraps_extended"
	else
		return

/obj/item/clothing/gloves/fingerless/pugilist/chaplain
	name = "armwraps of unyielding resolve"
	desc = "A series of armwraps, soaked in holy water. Makes you pretty keen to smite evil magic users."
	resistance_flags = FIRE_PROOF | ACID_PROOF
	enhancement = 2 //It is not magic that makes you punch harder, but force of will. Trust me.
	secondary_trait = TRAIT_ANTIMAGIC
	var/chaplain_spawnable = TRUE

/obj/item/clothing/gloves/fingerless/pugilist/chaplain/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/anti_magic, TRUE, TRUE, FALSE, null, null, FALSE)

/obj/item/clothing/gloves/fingerless/pugilist/magic
	name = "armwraps of mighty fists"
	desc = "A series of armwraps. Makes you pretty keen to go adventuring and punch dragons."
	resistance_flags = FIRE_PROOF | ACID_PROOF //magic items are harder to damage with energy this is a dnd joke okay?
	enhancement = 1 //They're +1!

/obj/item/clothing/gloves/fingerless/pugilist/hungryghost
	name = "armwraps of the hungry ghost"
	desc = "A series of blackened, bloodstained armwraps stitched with strange geometric symbols. Makes you pretty keen to commit horrible acts against the living through bloody carnage."
	icon_state = "narsiearmwraps"
	item_state = "narsiearmwraps"
	resistance_flags = FIRE_PROOF | ACID_PROOF
	armor = list("melee" = 10, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 35, "rad" = 0, "fire" = 50, "acid" = 50)
	enhancement = 3
	secondary_trait = TRAIT_KI_VAMPIRE

/obj/item/clothing/gloves/fingerless/pugilist/brassmountain
	name = "armbands of the brass mountain"
	desc = "A series of scolding hot brass armbands. Makes you pretty keen to bring the light to the unenlightened through unmitigated violence."
	icon_state = "ratvararmwraps"
	item_state = "ratvararmwraps"
	resistance_flags = FIRE_PROOF | ACID_PROOF
	armor = list("melee" = 10, "bullet" = 0, "laser" = -10, "energy" = 0, "bomb" = 0, "bio" = 35, "rad" = 0, "fire" = 50, "acid" = 50)
	enhancement = 4 //The artifice of Ratvar is unmatched except when it is.
	secondary_trait = TRAIT_STRONG_GRABBER

/obj/item/clothing/gloves/fingerless/pugilist/rapid
	name = "Bands of the North Star"
	desc = "The armbands of a deadly martial artist. Makes you pretty keen to put an end to evil in an extremely violent manner."
	icon_state = "rapid"
	item_state = "rapid"
	enhancement = 10 //omae wa mou shindeiru
	wound_enhancement = 10
	var/warcry = "AT"
	secondary_trait = TRAIT_NOSOFTCRIT //basically extra health

/obj/item/clothing/gloves/fingerless/pugilist/rapid/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, GLOVE_TRAIT)

/obj/item/clothing/gloves/fingerless/pugilist/rapid/Touch(atom/target, proximity = TRUE)
	if(!isliving(target))
		return

	var/mob/living/M = loc
	M.SetNextAction(CLICK_CD_RAPID)
	if(warcry)
		M.say("[warcry]", ignore_spam = TRUE, forced = TRUE)

	return NO_AUTO_CLICKDELAY_HANDLING | ATTACK_IGNORE_ACTION

/obj/item/clothing/gloves/fingerless/pugilist/rapid/AltClick(mob/user)
	var/input = stripped_input(user,"What do you want your battlecry to be? Max length of 6 characters.", ,"", 7)
	if(input)
		warcry = input

/obj/item/clothing/gloves/fingerless/pugilist/hug
	name = "Hugs of the North Star"
	desc = "The armbands of a humble friend. Makes you pretty keen to go let everyone know how much you appreciate them!"
	icon_state = "rapid"
	item_state = "rapid"
	enhancement = 0
	secondary_trait = TRAIT_PACIFISM //You are only here to hug and be friends!

/obj/item/clothing/gloves/fingerless/pugilist/hug/Touch(mob/target, proximity = TRUE)
	if(!isliving(target))
		return

	var/mob/living/M = loc

	if(M.a_intent != INTENT_HELP)
		return FALSE
	if(target.stat != CONSCIOUS) //Can't hug people who are dying/dead
		return FALSE
	else
		M.SetNextAction(CLICK_CD_RAPID)

	return NO_AUTO_CLICKDELAY_HANDLING | ATTACK_IGNORE_ACTION

/obj/item/clothing/gloves/fingerless/ablative
	name = "ablative armwraps"
	desc = "Armwraps made out of a highly durable, reflective metal. Has the side effect of absorbing shocks."
	siemens_coefficient = 0
	icon_state = "ablative_armwraps"
	item_state = "ablative_armwraps"
	block_parry_data = /datum/block_parry_data/ablative_armwraps
	var/wornonce = FALSE

/obj/item/clothing/gloves/fingerless/ablative/proc/get_component_parry_data(datum/source, parrying_method, datum/parrying_item_mob_or_art, list/backup_items, list/override)
	if(parrying_method && !(parrying_method == UNARMED_PARRY))
		return
	override[src] = ITEM_PARRY

/obj/item/clothing/gloves/fingerless/ablative/equipped(mob/user, slot)
	. = ..()
	if(current_equipped_slot == SLOT_GLOVES)
		RegisterSignal(user, COMSIG_LIVING_ACTIVE_PARRY_START, .proc/get_component_parry_data)
		wornonce = TRUE

/obj/item/clothing/gloves/fingerless/ablative/dropped(mob/user)
	. = ..()
	if(wornonce)
		UnregisterSignal(user, COMSIG_LIVING_ACTIVE_PARRY_START)
		wornonce = FALSE

/obj/item/clothing/gloves/fingerless/ablative/can_active_parry(mob/user)
	var/mob/living/carbon/human/H = user
	if(!istype(H))
		return FALSE
	return src == H.gloves

/obj/item/clothing/gloves/fingerless/ablative/on_active_parry(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, list/block_return, parry_efficiency, parry_time)
	. = ..()
	if(parry_efficiency > 0)
		owner.visible_message("<span class='warning'>[owner] deflects \the [object] with their armwraps!</span>")

/datum/block_parry_data/ablative_armwraps
	parry_stamina_cost = 4
	parry_attack_types = ATTACK_TYPE_UNARMED | ATTACK_TYPE_PROJECTILE | ATTACK_TYPE_TACKLE | ATTACK_TYPE_THROWN | ATTACK_TYPE_MELEE
	parry_flags = NONE

	parry_time_windup = 0
	parry_time_spindown = 0
	parry_time_active = 7.5

	parry_time_perfect = 1
	parry_time_perfect_leeway = 7.5
	parry_imperfect_falloff_percent = 20
	parry_efficiency_perfect = 100
	parry_time_perfect_leeway_override = list(
		TEXT_ATTACK_TYPE_MELEE = 1
	)

	parry_efficiency_considered_successful = 0.01
	parry_efficiency_to_counterattack = INFINITY	// no auto counter
	parry_max_attacks = INFINITY
	parry_failed_cooldown_duration = 1.5 SECONDS
	parry_failed_stagger_duration = 1.5 SECONDS
	parry_cooldown = 0

/obj/item/clothing/gloves/fingerless/pugilist/mauler
	name = "mauler gauntlets"
	desc = "Plastitanium gauntlets coated in a thick nano-weave carbon material and implanted with nanite injectors that boost the wielder's strength six-fold."
	icon_state = "mauler_gauntlets"
	item_state = "mauler_gauntlets"
	transfer_prints = FALSE
	body_parts_covered = ARMS|HANDS
	cold_protection = ARMS|HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	armor = list("melee" = 30, "bullet" = 30, "laser" = 10, "energy" = 10, "bomb" = 55, "bio" = 15, "rad" = 15, "fire" = 80, "acid" = 50)
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	strip_delay = 80
	enhancement = 12 // same as the changeling gauntlets but without changeling utility
	wound_enhancement = 12
	silent = TRUE
	inherited_trait = TRAIT_CHUNKYFINGERS // your fingers are fat because the gloves are
	secondary_trait = TRAIT_MAULER // commit table slam

/obj/item/clothing/gloves/fingerless/pugilist/mauler/equipped(mob/user, slot)
	. = ..()
	if(slot == SLOT_GLOVES)
		wornonce = TRUE
		if((HAS_TRAIT(user, TRAIT_NOPUGILIST)))
			return
		use_mauls(user, TRUE)

/obj/item/clothing/gloves/fingerless/pugilist/mauler/dropped(mob/user)
	. = ..()
	if(wornonce)
		wornonce = FALSE
		if((HAS_TRAIT(user, TRAIT_NOPUGILIST)))
			return
		use_mauls(user, FALSE)

/obj/item/clothing/gloves/fingerless/pugilist/mauler/proc/use_mauls(mob/user, maul)
	if(maul)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.dna?.species?.attack_sound_override = 'sound/weapons/mauler_punch.ogg'
			if(silent)
				to_chat(H, "<span class='danger'>You feel prickles around your wrists as [src] cling to them - strength courses through your veins!</span>")

/obj/item/clothing/gloves/tackler
	name = "gripper gloves"
	desc = "Special gloves that manipulate the blood vessels in the wearer's hands, granting them the ability to launch headfirst into walls."
	icon_state = "tackle"
	item_state = "tackle"
	transfer_prints = TRUE
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	resistance_flags = NONE
	//custom_premium_price = PRICE_EXPENSIVE
	/// For storing our tackler datum so we can remove it after
	var/datum/component/tackler
	/// See: [/datum/component/tackler/var/stamina_cost]
	var/tackle_stam_cost = 25
	/// See: [/datum/component/tackler/var/base_knockdown]
	var/base_knockdown = 1 SECONDS
	/// See: [/datum/component/tackler/var/range]
	var/tackle_range = 4
	/// See: [/datum/component/tackler/var/min_distance]
	var/min_distance = 0
	/// See: [/datum/component/tackler/var/speed]
	var/tackle_speed = 1
	/// See: [/datum/component/tackler/var/skill_mod]
	var/skill_mod = 1

/obj/item/clothing/gloves/tackler/equipped(mob/user, slot)
	. = ..()
	if(!ishuman(user))
		return
	switch(slot) // I didn't like how it looked
		if(SLOT_GLOVES)
			var/mob/living/carbon/human/H = user
			tackler = H.AddComponent(/datum/component/tackler, stamina_cost=tackle_stam_cost, base_knockdown = base_knockdown, range = tackle_range, speed = tackle_speed, skill_mod = skill_mod, min_distance = min_distance)
		else
			qdel(tackler) // Only wearing it!

/obj/item/clothing/gloves/tackler/dropped(mob/user)
	. = ..()
	if(tackler)
		qdel(tackler)

/obj/item/clothing/gloves/tackler/dolphin
	name = "dolphin gloves"
	desc = "Sleek, aerodynamic gripper gloves that are less effective at actually performing takedowns, but more effective at letting the user sail through the hallways and cause accidents."
	icon_state = "tackledolphin"
	item_state = "tackledolphin"

	tackle_stam_cost = 15
	base_knockdown = 0.5 SECONDS
	tackle_range = 5
	tackle_speed = 2
	min_distance = 2
	skill_mod = -2

/obj/item/clothing/gloves/tackler/combat
	name = "gorilla gloves"
	desc = "Premium quality combative gloves, heavily reinforced to give the user an edge in close combat tackles, though they are more taxing to use than normal gripper gloves. Fireproof to boot!"
	icon_state = "combat"
	item_state = "blackgloves"

	tackle_stam_cost = 35
	base_knockdown = 1.5 SECONDS
	tackle_range = 5
	skill_mod = 3

	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE
	strip_mod = 1.2 // because apparently black gloves had this

/obj/item/clothing/gloves/tackler/combat/goliath
	name = "goliath gloves"
	desc = "Rudimentary tackling gloves. The goliath hide makes it great for grappling with targets, while also being fireproof."
	icon = 'icons/obj/mining.dmi'
	icon_state = "goligloves"
	item_state = "goligloves"

	tackle_stam_cost = 25
	base_knockdown = 1 SECONDS
	tackle_range = 5
	tackle_speed = 2
	min_distance = 2
	skill_mod = 1

/obj/item/clothing/gloves/tackler/combat/insulated
	name = "guerrilla gloves"
	desc = "Superior quality combative gloves, good for performing tackle takedowns as well as absorbing electrical shocks."
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	strip_mod = 1.5 // and combat gloves had this??

/obj/item/clothing/gloves/tackler/combat/insulated/infiltrator
	name = "insidious guerrilla gloves"
	desc = "Specialized combat gloves for carrying people around. Transfers tactical kidnapping and tackling knowledge to the user via the use of nanochips."
	icon_state = "infiltrator"
	item_state = "infiltrator"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	resistance_flags = FIRE_PROOF | ACID_PROOF
	var/carrytrait = TRAIT_QUICKER_CARRY

/obj/item/clothing/gloves/tackler/combat/insulated/infiltrator/equipped(mob/user, slot)
	. = ..()
	if(slot == SLOT_GLOVES)
		ADD_TRAIT(user, carrytrait, GLOVE_TRAIT)

/obj/item/clothing/gloves/tackler/combat/insulated/infiltrator/dropped(mob/user)
	. = ..()
	REMOVE_TRAIT(user, carrytrait, GLOVE_TRAIT)

/obj/item/clothing/gloves/tackler/rocket
	name = "rocket gloves"
	desc = "The ultimate in high risk, high reward, perfect for when you need to stop a criminal from fifty feet away or die trying. Banned in most Spinward gridiron football and rugby leagues."
	icon_state = "tacklerocket"
	item_state = "tacklerocket"

	tackle_stam_cost = 50
	base_knockdown = 2 SECONDS
	tackle_range = 10
	min_distance = 7
	tackle_speed = 6
	skill_mod = 7

/obj/item/clothing/gloves/tackler/offbrand
	name = "improvised gripper gloves"
	desc = "Ratty looking fingerless gloves wrapped with sticky tape. Beware anyone wearing these, for they clearly have no shame and nothing to lose."
	icon_state = "fingerless"
	item_state = "fingerless"

	tackle_stam_cost = 30
	base_knockdown = 1.75 SECONDS
	min_distance = 2
	skill_mod = -1
*/

/obj/item/clothing/gloves/bracer
	name = "bone bracers"
	desc = "For when you're expecting to get slapped on the wrist. Offers modest protection to your arms."
	icon_state = "bracers"
	body_parts_covered = ARMS
	cold_protection = HANDS
	heat_protection = HANDS
	armor = list("melee" = 15, "bullet" = 5, "laser" = 5, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 15, "acid" = 0)

/obj/item/clothing/gloves/hasie
	name = "Hasie fingerless gloves"
	desc = "Fashioned from flexible, creamy white leather, one of these gloves has been dyed red. This duality provides the perfect asymmetric flair when paired with the matching Hasie skirt."
	icon_state = "hasie"
	fingerprint_chance = 100

/obj/item/clothing/gloves/utility_fur_gloves
	name = "Utility Fur Gloves"
	desc = "Warm fur gloves to match the Utility Fur coat."
	icon_state = "furug"
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
