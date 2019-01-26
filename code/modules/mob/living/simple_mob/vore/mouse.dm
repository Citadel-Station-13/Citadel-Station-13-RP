//Override file
/mob/living/simple_animal/mouse
	no_vore = TRUE //Mice can't eat others due to the amount of bugs caused by it.

/mob/living/simple_animal/mouse/attack_hand(mob/living/hander)
	src.get_scooped(hander) //For one-click mouse scooping under any conditions. They knew what they were getting into!
