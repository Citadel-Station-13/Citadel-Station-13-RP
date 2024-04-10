//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * a datum to hold vocabulary used by AIs to communicate.
 */
/datum/ai_lexicon
	/// escalation drop: when something goes away after being yelled at
	var/list/escalation_say_drop
	/// escalation stage 1: warn
	var/list/escalation_say_1
	/// escalation stage 2: threaten
	var/list/escalation_say_2
	/// escalation: when someone does an annoying but harmless action like pulling
	var/list/escalation_annoyance

	/// played when they start to threaten (stage 2) a target
	/// this is not played if we are directly going to combat!
	var/escalation_lock_sound
	/// played when all threaten (stage 2) locks are dropped
	/// this is not played if we are in combat!
	var/escalation_drop_sound

	/// engagement
	var/list/engagement_say

	/// random visible emotes while idle; this is fully parsed through mob emote.
	//  todo: currently unimplemented; conversation system is not in.
	var/list/idle_emote_visible
	/// random audible emotes while idle; this is fully parsed through mob emote.
	//  todo: currently unimplemented; conversation system is not in.
	var/list/idle_emote_audible
	/// random say's while idle; this is fully parsed through mob say.
	//  todo: currently unimplemented; conversation system is not in.
	var/list/idle_say

	/// help maint
	var/list/networking_call_for_help
	/// coming to help
	var/list/networking_call_responding
	/// don't care, didn't ask
	var/list/networking_call_busy
	/// i need a medical bag!
	/// this fires regardless of if there's a medic; it just makes no sense to have this
	/// for solo mobs.
	var/list/networking_call_for_medic
	/// someone died in range
	/// * this can be a list of 2 elements; the name of the dead person will be
	/// * injected in between the two if we know the name.
	var/list/networking_call_man_down

/datum/ai_lexicon/mercenary
	escalation_say_drop = list(
		"That's what I thought.",
		"Smart choice.",
	)
	escalation_say_1 = list(
		"Oi. Private property. Shoo.",
		"Get outta here!",
		"Private property! Out!",
	)
	escalation_say_2 = list(
		"Last warning! Get out!",
		"Last warning.",
		"I'm warning you!",
	)
	escalation_annoyance = list(
		"Get outta here, clown.",
		"Hands off!",
		"Don't try that again.",
		"You're pushing your luck.",
	)

	escalation_lock_sound = 'sound/weapons/TargetOn.ogg'
	escalation_drop_sound = 'sound/weapons/TargetOff.ogg'

	engagement_say = list(
		"Don't say I didn't warn you.",
		"Get 'em!",
		"Engaging hostiles.",
	)

	idle_emote_visible = list(
		"looks around suspiciously.",
		"taps his foot.",
		"looks around",
		"fidgets with their gun.",
		"rummages around in their pockets.",
	)
	idle_emote_audible = list(
		"coughs.",
		"sneezes.",
	)
	idle_say = list(
		"Most boring job in the frontier...",
		"Any of you see anything recently?",
		"I need a break...",
		"Anyone else smell that?",
	)

	networking_call_for_help = list(
		"I need some help down here!",
		"There's too many of them! Get over here!",
		"I need reinforcements!",
	)
	networking_call_responding = list(
		"Responding!",
		"On our way!",
		"Hang tight, we're on our way.",
		"10-4.",
	)
	networking_call_busy = list(
		"We're held down over here!",
		"Can't make it over yet.",
		"Hang in there, we've got our own problems.",
	)
	networking_call_man_down = list(
		"Man down!",
		"You'll pay for that!",
		list("Shit! They got ", "!"),
		list("They got ", "! Get down here!"),
	)
	networking_call_for_medic = list(
		"I'm hit!",
		"I need a medic!",
	)
