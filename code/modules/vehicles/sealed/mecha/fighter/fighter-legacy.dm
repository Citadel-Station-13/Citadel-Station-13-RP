
/obj/vehicle/sealed/mecha/fighter/play_entered_noise(var/mob/who)
	if(length(mecha_fault_stacks))
		who << sound('sound/mecha/fighter_entered_bad.ogg',volume=50)
	else
		who << sound('sound/mecha/fighter_entered.ogg',volume=50)
