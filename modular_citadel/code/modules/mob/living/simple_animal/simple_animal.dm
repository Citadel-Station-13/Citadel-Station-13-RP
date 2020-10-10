/mob/living/simple_animal
	var/ai_override = 0


/*
Right, so, blurb. If you need to force a mob AI to on or off, use ai_inactive.
ai_override is there for when you put a person into a mob, because if they log out, the proc will normally reset them to whatever the initial value was.
+1 will force the AI to become enabled after a logout.
-1 will force the AI to stay disabled after a logout.
0 will just pass.
*/
/mob/living/simple_animal/Logout()
	. = ..()
	if(ai_override == 1)
		ai_inactive = 0 //Forces the AI to be enabled.
	if(ai_override == -1)
		ai_inactive = 1 //Forces the AI to be disabled.

