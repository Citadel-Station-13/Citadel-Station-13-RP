/datum/unit_test/emoting
	var/emotes_used = 0

/datum/unit_test/emoting/Run()
	var/mob/living/carbon/human/human = allocate(/mob/living/carbon/human)
	RegisterSignal(human, COMSIG_MOB_EMOTE, PROC_REF(on_emote_used))

	human.say_legacy("*shrug")
	TEST_ASSERT_EQUAL(emotes_used, 1, "Human did not shrug")

	human.say_legacy("*beep")
	TEST_ASSERT_EQUAL(emotes_used, 1, "Human beeped, when that should be restricted to silicons")

	human.setOxyLoss(140)

	TEST_ASSERT(human.stat != CONSCIOUS, "Human is somehow conscious after receiving suffocation damage")

	human.say_legacy("*shrug")
	TEST_ASSERT_EQUAL(emotes_used, 1, "Human shrugged while unconscious")

	human.say_legacy("*deathgasp")
	TEST_ASSERT_EQUAL(emotes_used, 2, "Human could not deathgasp while unconscious")

/datum/unit_test/emoting/proc/on_emote_used()
	emotes_used += 1
