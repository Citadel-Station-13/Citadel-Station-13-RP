// These things get applied to slimes to do things.

/obj/item/slimepotion
	name = "slime agent"
	desc = "A flask containing strange, mysterious substances excreted by a slime."
	icon = 'icons/obj/medical/chemical.dmi'
	w_class = ITEMSIZE_TINY
	origin_tech = list(TECH_BIO = 4)

// This is actually applied to an extract, so no attack() overriding needed.
/obj/item/slimepotion/enhancer
	name = "extract enhancer agent"
	desc = "A potent chemical mix that will give a slime extract an additional two uses."
	icon_state = "potpurple"
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
		to_chat(user, "<span class='warning'>The stabilizer only works on lab-grown slimes!</span>")
		return
	if(S.stat == DEAD)
		to_chat(user, "<span class='warning'>The slime is dead!</span>")
		return
	if(S.mutation_chance == 0)
		to_chat(user, "<span class='warning'>The slime already has no chance of mutating!</span>")
		return

	to_chat(user, "<span class='notice'>You feed the slime the stabilizer. It is now less likely to mutate.</span>")
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
		to_chat(user, "<span class='warning'>The mutator only works on lab-grown slimes!</span>")
		return
	if(S.stat == DEAD)
		to_chat(user, "<span class='warning'>The slime is dead!</span>")
		return
	if(S.mutation_chance == 100)
		to_chat(user, "<span class='warning'>The slime is already guaranteed to mutate!</span>")
		return

	to_chat(user, "<span class='notice'>You feed the slime the mutator. It is now more likely to mutate.</span>")
	S.mutation_chance = clamp( S.mutation_chance + 12, 0,  100)
	playsound(src, 'sound/effects/bubbles.ogg', 50, 1)
	qdel(src)


// Makes the slime friendly forever.
/obj/item/slimepotion/docility
	name = "docility agent"
	desc = "A potent chemical mix that nullifies a slime's hunger, causing it to become docile and tame.  It might also work on other creatures?"
	icon_state = "potlightpink"
	description_info = "The target needs to be alive, not already passive, and be an animal or slime type entity."

/obj/item/slimepotion/docility/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	if(user.a_intent == INTENT_HARM)
		return ..()
	. = CLICKCHAIN_DO_NOT_PROPAGATE
	var/mob/living/simple_mob/S = target
	if(!istype(S))
		to_chat(user, "<span class='warning'>The agent only works on creatures!</span>")
		return
	if(S.stat == DEAD)
		to_chat(user, "<span class='warning'>\The [S] is dead!</span>")
		return
	if(!S.has_AI())
		to_chat(user, SPAN_WARNING( "\The [S] is too strongly willed for this to affect them.")) // Most likely player controlled.
		return

	var/datum/ai_holder/AI = S.ai_holder

	// Slimes.
	if(istype(S, /mob/living/simple_mob/slime/xenobio))
		var/mob/living/simple_mob/slime/xenobio/XS = S
		if(XS.harmless)
			to_chat(user, "<span class='warning'>The slime is already docile!</span>")
			return

		XS.pacify()
		XS.nutrition = 700
		to_chat(S, "<span class='warning'>You absorb the agent and feel your intense desire to feed melt away.</span>")
		to_chat(user, "<span class='notice'>You feed the slime the agent, removing its hunger and calming it.</span>")

	// Simple Mobs.
	else if(istype(S, /mob/living/simple_mob))
		var/mob/living/simple_mob/SM = S
		if(!(SM.mob_class & MOB_CLASS_SLIME|MOB_CLASS_ANIMAL)) // So you can't use this on Russians/syndies/hivebots/etc.
			to_chat(user, "<span class='warning'>\The [SM] only works on slimes and animals.</span>")
			return
		if(!AI.hostile)
			to_chat(user, "<span class='warning'>\The [SM] is already passive!</span>")
			return

		AI.hostile = FALSE
		to_chat(S, "<span class='warning'>You consume the agent and feel a serene sense of peace.</span>")
		to_chat(user, "<span class='notice'>You feed \the [SM] the agent, calming it.</span>")

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
		to_chat(user, "<span class='warning'>The steroid only works on lab-grown slimes!</span>")
		return
	if(S.stat == DEAD)
		to_chat(user, "<span class='warning'>The slime is dead!</span>")
		return
	if(S.is_adult) //Can't steroidify adults
		to_chat(user, "<span class='warning'>Only baby slimes can use the steroid!</span>")
		return
	if(S.cores >= 5)
		to_chat(user, "<span class='warning'>The slime already has the maximum amount of extract!</span>")
		return

	to_chat(user, "<span class='notice'>You feed the slime the steroid. It will now produce one more extract.</span>")
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
		to_chat(user, "<span class='warning'>The agent only works on lab-grown slimes!</span>")
		return
	if(S.stat == DEAD)
		to_chat(user, "<span class='warning'>The slime is dead!</span>")
		return
	if(S.unity == TRUE)
		to_chat(user, "<span class='warning'>The slime is already unified!</span>")
		return

	to_chat(user, "<span class='notice'>You feed the slime the agent. It will now be friendly to all other slimes.</span>")
	to_chat(S, "<span class='notice'>\The [user] feeds you \the [src], and you suspect that all the other slimes will be \
	your friends, at least if you don't attack them first.</span>")
	S.unify()
	playsound(src, 'sound/effects/bubbles.ogg', 50, 1)
	qdel(src)

// Makes slimes not kill (most) humanoids but still fight spiders/carp/bears/etc.
/obj/item/slimepotion/loyalty
	name = "slime loyalty agent"
	desc = "A potent chemical mix that makes an animal deeply loyal to the species of whoever applies this, and will attack threats to them."
	description_info = "The slime or other animal needs to be alive for this to work.  The slime this is applied to will have their 'faction' change to \
	the user's faction, which means the slime will attack things that are hostile to the user's faction, such as carp, spiders, and other slimes."
	icon_state = "potred"

/obj/item/slimepotion/loyalty/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	if(user.a_intent == INTENT_HARM)
		return ..()
	. = CLICKCHAIN_DO_NOT_PROPAGATE
	var/mob/living/simple_mob/S = target
	if(!istype(S))
		to_chat(user, "<span class='warning'>The agent only works on creatures!</span>")
		return
	if(!(S.mob_class & MOB_CLASS_SLIME|MOB_CLASS_ANIMAL)) // So you can't use this on Russians/syndies/hivebots/etc.
		to_chat(user, "<span class='warning'>\The [S] only works on slimes and animals.</span>")
		return
	if(S.stat == DEAD)
		to_chat(user, "<span class='warning'>The animal is dead!</span>")
		return
	if(S.faction == user.faction)
		to_chat(user, "<span class='warning'>\The [S] is already loyal to your species!</span>")
		return
	if(!S.has_AI())
		to_chat(user, SPAN_WARNING( "\The [S] is too strong-willed for this to affect them."))
		return

	var/datum/ai_holder/AI = S.ai_holder

	to_chat(user, "<span class='notice'>You feed \the [S] the agent. It will now try to murder things that want to murder you instead.</span>")
	to_chat(S, "<span class='notice'>\The [user] feeds you \the [src], and feel that the others will regard you as an outsider now.</span>")
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
		to_chat(user, "<span class='warning'>The agent only works on creatures!</span>")
		return
	if(!(S.mob_class & MOB_CLASS_SLIME|MOB_CLASS_ANIMAL)) // So you can't use this on Russians/syndies/hivebots/etc.
		to_chat(user, "<span class='warning'>\The [S] only works on slimes and animals.</span>")
		return
	if(S.stat == DEAD)
		to_chat(user, "<span class='warning'>\The [S] is dead!</span>")
		return
	if(user in S.friends)
		to_chat(user, "<span class='warning'>\The [S] is already loyal to you!</span>")
		return
	if(!S.has_AI())
		to_chat(user, SPAN_WARNING( "\The [S] is too strong-willed for this to affect them."))
		return

	var/datum/ai_holder/AI = S.ai_holder

	to_chat(user, "<span class='notice'>You feed \the [S] the agent. It will now be your best friend.</span>")
	to_chat(S, "<span class='notice'>\The [user] feeds you \the [src], and feel that \the [user] wants to be best friends with you.</span>")
	S.friends.Add(user)
	AI.lost_target() // So hostile things stop attacking people even if not hostile anymore.
	playsound(src, 'sound/effects/bubbles.ogg', 50, 1)
	qdel(src)


// Feeds the slime instantly.
/obj/item/slimepotion/feeding
	name = "slime feeding agent"
	desc = "A potent chemical mix that will instantly sediate the slime."
	description_info = "The slime needs to be alive for this to work.  It will instantly grow the slime enough to reproduce."
	icon_state = "potyellow"

/obj/item/slimepotion/feeding/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	if(user.a_intent == INTENT_HARM)
		return ..()
	. = CLICKCHAIN_DO_NOT_PROPAGATE
	var/mob/living/simple_mob/slime/xenobio/S = target
	if(!istype(S))
		to_chat(user, "<span class='warning'>The feeding agent only works on lab-grown slimes!</span>")
		return
	if(S.stat == DEAD)
		to_chat(user, "<span class='warning'>The slime is dead!</span>")
		return

	to_chat(user, "<span class='notice'>You feed the slime the feeding agent. It will now instantly reproduce.</span>")
	S.amount_grown = 10
	S.make_adult()
	S.amount_grown = 10
	S.reproduce()
	playsound(src, 'sound/effects/bubbles.ogg', 50, 1)
	qdel(src)
