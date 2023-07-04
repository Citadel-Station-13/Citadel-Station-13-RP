// Constantly emites radiation from the tile it's placed on.
/obj/effect/map_effect/radiation_emitter
	name = "radiation emitter"
	icon_state = "radiation_emitter"
	rad_flags = RAD_NO_CONTAMINATE | RAD_BLOCK_CONTENTS
	var/radiation_power = 200 // Bigger numbers means more radiation.
	var/radiation_falloff = RAD_FALLOFF_NORMAL

/obj/effect/map_effect/radiation_emitter/Initialize(mapload)
	START_PROCESSING(SSobj, src)
	return ..()

/obj/effect/map_effect/radiation_emitter/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/map_effect/radiation_emitter/process(delta_time)
	radiation_pulse(src, radiation_power, radiation_falloff)

/obj/effect/map_effect/radiation_emitter/strong
	radiation_power = 750

/obj/effect/map_effect/radiation_emitter/chernobyl // I need this.
	radiation_power = 2000


