//for when a badmin inevitably breaks things.
/mob/proc/ResetKeybindSignals()
	CleanupKeybindSignals()
	RegisterKeybindSignals()

//Key signals should be registered at the mob level.
/mob/proc/RegisterKeybindSignals()

/mob/proc/CleanupKeybindSignals()
