// These things get applied to slimes to do things.

/obj/item/slimepotion
	name = "slime agent"
	desc = "A flask containing strange, mysterious substances excreted by a slime."
	icon = 'icons/obj/medical/chemical.dmi'
	w_class = ITEMSIZE_TINY
	origin_tech = list(TECH_BIO = 4)

/obj/item/slimepotion/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/slimepotion/mimic))
		to_chat(user, SPAN_NOTICE("You apply the mimic to the slime potion as it copies it's effects."))
		playsound(src, 'sound/effects/bubbles.ogg', 50, 1)
		var/newtype = src.type
		new newtype(get_turf(src))
		qdel(O)
	..()

// This is actually applied to an extract, so no attack() overriding needed.
/obj/item/slimepotion/enhancer
	name = "extract enhancer agent"
	desc = "A potent chemical mix that will give a slime extract an additional two uses."
	icon_state = "potcyan"
	description_info = "This will even work on inert slime extracts, if it wasn't enhanced before.  Extracts enhanced cannot be enhanced again."

// Makes slimes less likely to mutate.
/obj/item/slimepotion/stabilizer
	name = "slime stabilizer agent"
	desc = "A potent chemical mix that will reduce the chance of a slime mutating."
	icon_state = "potcyan"
	description_info = "The slime needs to be alive for this to work.  It will reduce the chances of mutation by 15%."

/obj/item/slimepotion/stabilizer/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	if(user.a_intent == INTENT_HARM)
		return ..()
	. = CLICKCHAIN_DO_NOT_PROPAGATE
	var/mob/living/simple_mob/slime/xenobio/S = target
	if(!istype(S))
		to_chat(user, SPAN_WARNING("The stabilizer only works on lab-grown slimes!"))
		return
	if(S.stat == DEAD)
		to_chat(user, SPAN_WARNING("The slime is dead!"))
		return
	if(S.mutation_chance == 0)
		to_chat(user, SPAN_WARNING("The slime already has no chance of mutating!"))
		return

	to_chat(user, SPAN_NOTICE("You feed the slime the stabilizer. It is now less likely to mutate."))
	S.mutation_chance = clamp( S.mutation_chance - 15, 0,  100)
	playsound(src, 'sound/effects/bubbles.ogg', 50, 1)
	qdel(src)

// The opposite, makes the slime more likely to mutate.
/obj/item/slimepotion/mutator
	name = "slime mutator agent"
	desc = "A potent chemical mix that will increase the chance of a slime mutating."
	description_info = "The slime needs to be alive for this to work.  It will increase the chances of mutation by 12%."
	icon_state = "potred"

/obj/item/slimepotion/mutator/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	if(user.a_intent == INTENT_HARM)
		return ..()
	. = CLICKCHAIN_DO_NOT_PROPAGATE
	var/mob/living/simple_mob/slime/xenobio/S = target
	if(!istype(S))
		to_chat(user, SPAN_WARNING("The mutator only works on lab-grown slimes!"))
		return
	if(S.stat == DEAD)
		to_chat(user, SPAN_WARNING("The slime is dead!"))
		return
	if(S.mutation_chance == 100)
		to_chat(user, SPAN_WARNING("The slime is already guaranteed to mutate!"))
		return

	to_chat(user, SPAN_NOTICE("You feed the slime the mutator. It is now more likely to mutate."))
	S.mutation_chance = clamp( S.mutation_chance + 12, 0,  100)
	playsound(src, 'sound/effects/bubbles.ogg', 50, 1)
	qdel(src)


// Makes the slime friendly forever.
/obj/item/slimepotion/docility
	name = "slime docility agent"
	desc = "A potent chemical mix that nullifies a slime's hunger, causing it to become docile and tame.  It might also work on other creatures?"
	icon_state = "potlightpink"
	description_info = "The target needs to be alive, not already passive, and be an animal or slime type entity."

/obj/item/slimepotion/docility/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	if(user.a_intent == INTENT_HARM)
		return ..()
	. = CLICKCHAIN_DO_NOT_PROPAGATE
	var/mob/living/simple_mob/S = target
	if(!istype(S))
		to_chat(user, SPAN_WARNING("The agent only works on creatures!"))
		return
	if(S.stat == DEAD)
		to_chat(user, SPAN_WARNING("\The [S] is dead!"))
		return
	if(!S.has_AI())
		to_chat(user, SPAN_WARNING( "\The [S] is too strongly willed for this to affect them.")) // Most likely player controlled.
		return

	var/datum/ai_holder/AI = S.ai_holder

	// Slimes.
	if(istype(S, /mob/living/simple_mob/slime/xenobio))
		var/mob/living/simple_mob/slime/xenobio/XS = S
		if(XS.harmless)
			to_chat(user, SPAN_WARNING("The slime is already docile!"))
			return

		XS.pacify()
		XS.nutrition = 700
		to_chat(S, SPAN_WARNING("You absorb the agent and feel your intense desire to feed melt away."))
		to_chat(user, SPAN_NOTICE("You feed the slime the agent, removing its hunger and calming it."))

	// Simple Mobs.
	else if(istype(S, /mob/living/simple_mob))
		var/mob/living/simple_mob/SM = S
		if(!(SM.mob_class & MOB_CLASS_SLIME|MOB_CLASS_ANIMAL)) // So you can't use this on Russians/syndies/hivebots/etc.
			to_chat(user, SPAN_WARNING("\The [SM] only works on slimes and animals."))
			return
		if(!AI.hostile)
			to_chat(user, SPAN_WARNING("\The [SM] is already passive!"))
			return

		AI.hostile = FALSE
		to_chat(S, SPAN_WARNING("You consume the agent and feel a serene sense of peace."))
		to_chat(user, SPAN_NOTICE("You feed \the [SM] the agent, calming it."))

	playsound(src, 'sound/effects/bubbles.ogg', 50, 1)
	AI.lost_target() // So hostile things stop attacking people even if not hostile anymore.
	var/newname = copytext(sanitize(input(user, "Would you like to give \the [S] a name?", "Name your new pet", S.name) as null|text),1,MAX_NAME_LEN)

	if(newname)
		S.name = newname
		S.real_name = newname
	qdel(src)


// Makes slimes make more extracts.
/obj/item/slimepotion/steroid
	name = "slime steroid agent"
	desc = "A potent chemical mix that will increase the amount of extracts obtained from harvesting a slime."
	description_info = "The slime needs to be alive and not an adult for this to work.  It will increase the amount of extracts gained by one, up to a max of five per slime.  \
	Extra extracts are not passed down to offspring when reproducing."
	icon_state = "potpurple"

/obj/item/slimepotion/steroid/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	if(user.a_intent == INTENT_HARM)
		return ..()
	. = CLICKCHAIN_DO_NOT_PROPAGATE
	var/mob/living/simple_mob/slime/xenobio/S = target
	if(!istype(S))
		to_chat(user, SPAN_WARNING("The steroid only works on lab-grown slimes!"))
		return
	if(S.stat == DEAD)
		to_chat(user, SPAN_WARNING("The slime is dead!"))
		return
	if(S.is_adult) //Can't steroidify adults
		to_chat(user, SPAN_WARNING("Only baby slimes can use the steroid!"))
		return
	if(S.cores >= 5)
		to_chat(user, SPAN_WARNING("The slime already has the maximum amount of extract!"))
		return

	to_chat(user, SPAN_NOTICE("You feed the slime the steroid. It will now produce one more extract."))
	S.cores++
	playsound(src, 'sound/effects/bubbles.ogg', 50, 1)
	qdel(src)


// Makes slimes not try to murder other slime colors.
/obj/item/slimepotion/unity
	name = "slime unity agent"
	desc = "A potent chemical mix that makes the slime feel and be seen as all the colors at once, and as a result not be considered an enemy to any other color."
	description_info = "The slime needs to be alive for this to work.  Slimes unified will not attack or be attacked by other colored slimes, and this will \
	carry over to offspring when reproducing."
	icon_state = "potpink"

/obj/item/slimepotion/unity/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	if(user.a_intent == INTENT_HARM)
		return ..()
	. = CLICKCHAIN_DO_NOT_PROPAGATE
	var/mob/living/simple_mob/slime/xenobio/S = target
	if(!istype(S))
		to_chat(user, SPAN_WARNING("The agent only works on lab-grown slimes!"))
		return
	if(S.stat == DEAD)
		to_chat(user, SPAN_WARNING("The slime is dead!"))
		return
	if(S.unity == TRUE)
		to_chat(user, SPAN_WARNING("The slime is already unified!"))
		return

	to_chat(user, SPAN_NOTICE("You feed the slime the agent. It will now be friendly to all other slimes."))
	to_chat(S, SPAN_NOTICE("\The [user] feeds you \the [src], and you suspect that all the other slimes will be \
	your friends, at least if you don't attack them first."))
	S.unify()
	playsound(src, 'sound/effects/bubbles.ogg', 50, 1)
	qdel(src)

// Makes slimes not kill (most) humanoids but still fight spiders/carp/bears/etc.
/obj/item/slimepotion/loyalty
	name = "slime loyalty agent"
	desc = "A potent chemical mix that makes an animal deeply loyal to the species of whoever applies this, and will attack threats to them."
	description_info = "The slime or other animal needs to be alive for this to work.  The slime this is applied to will have their 'faction' change to \
	the user's faction, which means the slime will attack things that are hostile to the user's faction, such as carp, spiders, and other slimes."
	icon_state = "potlightpink"

/obj/item/slimepotion/loyalty/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	if(user.a_intent == INTENT_HARM)
		return ..()
	. = CLICKCHAIN_DO_NOT_PROPAGATE
	var/mob/living/simple_mob/S = target
	if(!istype(S))
		to_chat(user, SPAN_WARNING("The agent only works on creatures!"))
		return
	if(!(S.mob_class & MOB_CLASS_SLIME|MOB_CLASS_ANIMAL)) // So you can't use this on Russians/syndies/hivebots/etc.
		to_chat(user, SPAN_WARNING("\The [S] only works on slimes and animals."))
		return
	if(S.stat == DEAD)
		to_chat(user, SPAN_WARNING("The animal is dead!"))
		return
	if(S.faction == user.faction)
		to_chat(user, SPAN_WARNING("\The [S] is already loyal to your species!"))
		return
	if(!S.has_AI())
		to_chat(user, SPAN_WARNING( "\The [S] is too strong-willed for this to affect them."))
		return

	var/datum/ai_holder/AI = S.ai_holder

	to_chat(user, SPAN_NOTICE("You feed \the [S] the agent. It will now try to murder things that want to murder you instead."))
	to_chat(S, SPAN_NOTICE("\The [user] feeds you \the [src], and feel that the others will regard you as an outsider now."))
	S.faction = user.faction
	AI.lost_target() // So hostile things stop attacking people even if not hostile anymore.
	playsound(src, 'sound/effects/bubbles.ogg', 50, 1)
	qdel(src)


// User befriends the slime with this.
/obj/item/slimepotion/friendship
	name = "slime friendship agent"
	desc = "A potent chemical mix that makes an animal deeply loyal to the the specific entity which feeds them this agent."
	description_info = "The slime or other animal needs to be alive for this to work.  The slime this is applied to will consider the user \
	their 'friend', and will never attack them.  This might also work on other things besides slimes."
	icon_state = "potlightpink"

/obj/item/slimepotion/friendship/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	if(user.a_intent == INTENT_HARM)
		return ..()
	. = CLICKCHAIN_DO_NOT_PROPAGATE
	var/mob/living/simple_mob/S = target
	if(!istype(S))
		to_chat(user, SPAN_WARNING("The agent only works on creatures!"))
		return
	if(!(S.mob_class & MOB_CLASS_SLIME|MOB_CLASS_ANIMAL)) // So you can't use this on Russians/syndies/hivebots/etc.
		to_chat(user, SPAN_WARNING("\The [S] only works on slimes and animals."))
		return
	if(S.stat == DEAD)
		to_chat(user, SPAN_WARNING("\The [S] is dead!"))
		return
	if(user in S.friends)
		to_chat(user, SPAN_WARNING("\The [S] is already loyal to you!"))
		return
	if(!S.has_AI())
		to_chat(user, SPAN_WARNING( "\The [S] is too strong-willed for this to affect them."))
		return

	var/datum/ai_holder/AI = S.ai_holder

	to_chat(user, SPAN_NOTICE("You feed \the [S] the agent. It will now be your best friend."))
	to_chat(S, SPAN_NOTICE("\The [user] feeds you \the [src], and feel that \the [user] wants to be best friends with you."))
	S.friends.Add(user)
	AI.lost_target() // So hostile things stop attacking people even if not hostile anymore.
	playsound(src, 'sound/effects/bubbles.ogg', 50, 1)
	qdel(src)


// Feeds the slime instantly.
/obj/item/slimepotion/feeding
	name = "slime feeding agent"
	desc = "A potent chemical mix that will instantly satiate the slime."
	description_info = "The slime needs to be alive for this to work.  It will instantly grow the slime enough to reproduce."
	icon_state = "potorange"

/obj/item/slimepotion/feeding/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	if(user.a_intent == INTENT_HARM)
		return ..()
	. = CLICKCHAIN_DO_NOT_PROPAGATE
	var/mob/living/simple_mob/slime/xenobio/S = target
	if(!istype(S))
		to_chat(user, SPAN_WARNING("The feeding agent only works on lab-grown slimes!"))
		return
	if(S.stat == DEAD)
		to_chat(user, SPAN_WARNING("The slime is dead!"))
		return

	to_chat(user, SPAN_NOTICE("You feed the slime the feeding agent. It will now instantly reproduce."))
	S.amount_grown = 10
	S.make_adult()
	S.amount_grown = 10
	S.reproduce()
	playsound(src, 'sound/effects/bubbles.ogg', 50, 1)
	qdel(src)

/obj/item/slimepotion/infertility
	name = "slime infertility agent"
	desc = "A potent chemical mix that will reduce the amount of offspring this slime will have."
	icon_state = "potpurple"
	description_info = "The slime needs to be alive for this to work. It will reduce the amount of slime babies by 2 (to minimum of 2)."

/obj/item/slimepotion/infertility/attack_mob(mob/living/simple_mob/slime/xenobio/M, mob/user)
	if(!istype(M))
		to_chat(user, SPAN_WARNING("The agent only works on slimes!"))
		return ..()
	if(M.stat == DEAD)
		to_chat(user, SPAN_WARNING("The slime is dead!"))
		return ..()
	if(M.split_amount <= 2)
		to_chat(user, SPAN_WARNING("The slime cannot get any less fertile!"))
		return ..()

	to_chat(user, SPAN_NOTICE("You feed the slime the infertility agent. It will now have less offspring."))
	M.split_amount = between(2, M.split_amount - 2, 6)
	playsound(src, 'sound/effects/bubbles.ogg', 50, 1)
	qdel(src)

/obj/item/slimepotion/fertility
	name = "slime fertility agent"
	desc = "A potent chemical mix that will increase the amount of offspring this slime will have."
	icon_state = "potpurple"
	description_info = "The slime needs to be alive for this to work. It will increase the amount of slime babies by 2 (to maximum of 6)."

/obj/item/slimepotion/fertility/attack_mob(mob/living/simple_mob/slime/xenobio/M, mob/user)
	if(!istype(M))
		to_chat(user, SPAN_WARNING("The agent only works on slimes!"))
		return ..()
	if(M.stat == DEAD)
		to_chat(user, SPAN_WARNING("The slime is dead!"))
		return ..()
	if(M.split_amount >= 6)
		to_chat(user, SPAN_WARNING("The slime cannot get any more fertile!"))
		return ..()

	to_chat(user, SPAN_NOTICE("You feed the slime the infertility agent. It will now have less offspring."))
	M.split_amount = between(2, M.split_amount + 2, 6)
	playsound(src, 'sound/effects/bubbles.ogg', 50, 1)
	qdel(src)

/obj/item/slimepotion/shrink
	name = "slime shrinking agent"
	desc = "A potent chemical mix that will turn adult slime into a baby one."
	icon_state = "potpurple"
	description_info = "The slime needs to be alive for this to work."

/obj/item/slimepotion/shrink/attack_mob(mob/living/simple_mob/slime/xenobio/M, mob/user)
	if(!istype(M))
		to_chat(user, SPAN_WARNING("The agent only works on slimes!"))
		return ..()
	if(M.stat == DEAD)
		to_chat(user, SPAN_WARNING("The slime is dead!"))
		return ..()
	if(!(M.is_adult))
		to_chat(user, SPAN_WARNING("The slime is already a baby!"))
		return ..()

	to_chat(user, SPAN_NOTICE("You feed the slime the shrinking agent. It is now back to being a baby."))
	M.make_baby()
	playsound(src, 'sound/effects/bubbles.ogg', 50, 1)
	qdel(src)

/obj/item/slimepotion/death
	name = "slime death agent"
	desc = "A potent chemical mix that will instantly kill a slime."
	icon_state = "potblue"
	description_info = "The slime needs to be alive for this to work."

/obj/item/slimepotion/death/attack_mob(mob/living/simple_mob/slime/xenobio/M, mob/user)
	if(!istype(M))
		to_chat(user, SPAN_WARNING("The agent only works on slimes!"))
		return ..()
	if(M.stat == DEAD)
		to_chat(user, SPAN_WARNING("The slime is already dead!"))
		return ..()

	to_chat(user, SPAN_NOTICE("You feed the slime the death agent. Its face flashes pain of betrayal before it goes still."))
	M.adjustToxLoss(500)
	playsound(src, 'sound/effects/bubbles.ogg', 50, 1)
	qdel(src)

/obj/item/slimepotion/ferality
	name = "slime ferality agent"
	desc = "A potent chemical mix that will make a slime untamable."
	icon_state = "potred"
	description_info = "The slime needs to be alive for this to work."

/obj/item/slimepotion/ferality/attack_mob(mob/living/simple_mob/slime/xenobio/M, mob/user)
	if(!istype(M))
		to_chat(user, SPAN_WARNING("The agent only works on slimes!"))
		return ..()
	if(M.stat == DEAD)
		to_chat(user, SPAN_WARNING("The slime is already dead!"))
		return ..()
	if(M.untamable && M.untamable_inherit)
		to_chat(user, SPAN_WARNING("The slime is already untamable!"))
		return ..()

	to_chat(user, SPAN_NOTICE("You feed the slime the death agent. It will now only get angrier at taming attempts."))
	M.untamable = TRUE
	M.untamable_inherit = TRUE
	playsound(src, 'sound/effects/bubbles.ogg', 50, 1)
	qdel(src)

/obj/item/slimepotion/reinvigoration
	name = "extract reinvigoration agent"
	desc = "A potent chemical mix that will create a slime of appropriate type out of an extract."
	icon_state = "potcyan"
	description_info = "This will even work on inert extracts. Extract is destroyed in process."

/obj/item/slimepotion/mimic
	name = "mimic agent"
	desc = "A potent chemical mix that will mimic effects of other slime-produced agents."
	icon_state = "potsilver"
	description_info = "Warning: avoid combining multiple doses of mimic agent."

/obj/item/slimepotion/mimic/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/slimepotion/mimic))
		to_chat(user, SPAN_WARNING("You apply the mimic to the mimic, resulting a mimic that copies a mimic that copies a mimic that copies a mimic that-"))
		var/location = get_turf(src)
		playsound(location, 'sound/weapons/gauss_shoot.ogg', 50, 1)
		var/datum/effect_system/grav_pull/s = new /datum/effect_system/grav_pull
		s.set_up(3, 3, location)
		s.start()
		qdel(O)
		qdel(src)
		return
	..()

/obj/item/slimepotion/sapience
	name = "slime sapience agent"
	desc = "A potent chemical mix that makes an animal capable of developing more advanced, sapient thought."
	description_info = "The slime or other animal needs to be alive for this to work. The development is not always immediate and may take indeterminate time before effects show."
	icon_state = "potblue"

/obj/item/slimepotion/sapience/attack_mob(mob/living/simple_mob/M, mob/user)
	if(!istype(M))
		to_chat(user, SPAN_WARNING("The agent only works on creatures!"))
		return ..()
	if(M.stat == DEAD)
		to_chat(user, SPAN_WARNING("The creature is dead!"))
		return ..()
	if(M.get_ghostrole())
		to_chat(user, SPAN_WARNING("The creature is already developing sapience."))
		return ..()
	if(!(M.mob_class && MOB_CLASS_SLIME | MOB_CLASS_ANIMAL)) //cit addition: only animals and slimes.
		to_chat(user, SPAN_WARNING("This agent doesn't seem like something this one would consume..."))
		return ..()
	//^ while we could make a justification for some other creatures like xenos - and while we could argue that sapphire extracts have
	//a place in uplifting specific creatures like xenohybrids, it probably would be a lot more complicated of a process then just a
	//single potion changing them up. Otherwise, trying to bring awareness to cult constructs or something would be a little absurd and pointless.
	if(M.ckey)
		to_chat(user, SPAN_WARNING("The creature is already sapient!"))
		return ..()

	to_chat(user, SPAN_NOTICE("You feed \the [M] the agent. It may now eventually develop proper sapience."))
	M.add_ghostrole(/datum/role/ghostrole/existing/sapient_mob/xenobio,user)
	log_and_message_admins("[key_name_admin(user)] used a sapience potion on a simple mob: [M]. [ADMIN_FLW(src)]")
	playsound(src, 'sound/effects/bubbles.ogg', 50, 1)
	qdel(src)

/obj/item/slimepotion/obedience
	name = "slime obedience agent"
	desc = "A potent chemical mix that makes slime extremely obedient."
	icon_state = "potlightpink"
	description_info = "The target needs to be alive and currently misbehaving. Effect is equivalent to very strong discipline."

/obj/item/slimepotion/obedience/attack_mob(mob/living/simple_mob/slime/xenobio/M, mob/user)
	if(!istype(M))
		to_chat(user, SPAN_WARNING("The agent only works on slimes!"))
		return ..()
	if(M.stat == DEAD)
		to_chat(user, SPAN_WARNING("The slime is dead!"))
		return ..()

	to_chat(user, SPAN_NOTICE("You feed the slime the agent. It has been disciplined, for better or worse..."))
	M.adjust_discipline(10)
	playsound(src, 'sound/effects/bubbles.ogg', 50, 1)
	qdel(src)
