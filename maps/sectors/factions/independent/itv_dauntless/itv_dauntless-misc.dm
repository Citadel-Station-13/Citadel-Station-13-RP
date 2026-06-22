
#warn below

/area/sector/itv_dauntless
	requires_power = 1
	icon_state = "purple"

/area/sector/itv_dauntless/cockpit
	name = "Dauntless - Cockpit"
/area/sector/itv_dauntless/captain
	name = "Dauntless - Captain's Quarters"
/area/sector/itv_dauntless/readyroom
	name = "Dauntless - Ready Room"
/area/sector/itv_dauntless/metingroom
	name = "Dauntless - Meeting Room"
/area/sector/itv_dauntless/forehall
	name = "Dauntless - Fore Hall"
	area_flags = AREA_RAD_SHIELDED
/area/sector/itv_dauntless/starboardcargo
	name = "Dauntless - Starboard Cargo Bay"
/area/sector/itv_dauntless/starboardhighsec
	name = "Dauntless - Starboard Secure Cargo"
/area/sector/itv_dauntless/starboarddocking
	name = "Dauntless - Starboard Docking Port"
/area/sector/itv_dauntless/portcargo
	name = "Dauntless - Port Cargo Bay"
/area/sector/itv_dauntless/porthighsec
	name = "Dauntless - Port Secure Cargo"
/area/sector/itv_dauntless/portdocking
	name = "Dauntless - Port Docking Port"
/area/sector/itv_dauntless/common
	name = "Dauntless - Common Area"
/area/sector/itv_dauntless/lockers
	name = "Dauntless - Locker Room"
/area/sector/itv_dauntless/passengersleeping
	name = "Dauntless - Passenger Sleeping Barracks"
/area/sector/itv_dauntless/showers
	name = "Dauntless - Showers"
/area/sector/itv_dauntless/restrooms
	name = "Dauntless - Restrooms"
/area/sector/itv_dauntless/afthall
	name = "Dauntless - Aft Hall"
	area_flags = AREA_RAD_SHIELDED
/area/sector/itv_dauntless/medbay
	name = "Dauntless - Medbay"
/area/sector/itv_dauntless/kitchen
	name = "Dauntless - Kitchen"
/area/sector/itv_dauntless/crew1
	name = "Dauntless - Crew Quarters - 1"
	area_flags = AREA_RAD_SHIELDED
/area/sector/itv_dauntless/crew2
	name = "Dauntless - Crew Quarters - 2"
	area_flags = AREA_RAD_SHIELDED
/area/sector/itv_dauntless/crew3
	name = "Dauntless - Crew Quarters - 3"
	area_flags = AREA_RAD_SHIELDED
/area/sector/itv_dauntless/crew4
	name = "Dauntless - Crew Quarters - 4"
	area_flags = AREA_RAD_SHIELDED
/area/sector/itv_dauntless/shuttlebay
	name = "Dauntless - Shuttle Bay"
/area/sector/itv_dauntless/starboardengi
	name = "Dauntless - Starboard Engineering"
	area_flags = AREA_RAD_SHIELDED
/area/sector/itv_dauntless/starboardsolars
	name = "Dauntless - Starboard Solars"
/area/sector/itv_dauntless/portengi
	name = "Dauntless - Port Engineering"
	area_flags = AREA_RAD_SHIELDED
/area/sector/itv_dauntless/portsolars
	name = "Dauntless - Port Solars"

// The 'Dauntless'
/obj/overmap/entity/visitable/ship/itglight
	name = "spacecraft"
	desc = "Spacefaring vessel. Friendly IFF detected."
	scanner_name = "ITG Dauntless"
	scanner_desc = @{"[i]Registration[/i]: ITG Dauntless
[i]Class[/i]: Small Cargo Frigate (Low Displacement)
[i]Transponder[/i]: Transmitting (CIV), non-hostile"
[b]Notice[/b]: May carry passengers"}
	color = "#d98c1a" //orng
	vessel_mass = 8000
	initial_generic_waypoints = list("itglight_fore", "itglight_aft", "itglight_port", "itglight_starboard", "itglight_port_dock", "itglight_starboard_dock")
	initial_restricted_waypoints = list("ITG Shuttlecraft" = list("omship_spawn_itglightshuttle"))
	fore_dir = NORTH

	skybox_icon = 'maps/sectors/factions/independent/itv_dauntless/itv_dauntless-skybox.dmi'
	skybox_icon_state = "skybox"
	skybox_pixel_x = 425
	skybox_pixel_y = 200

/obj/overmap/entity/visitable/ship/itglight/build_skybox_representation()
	..()
	if(!cached_skybox_image)
		return
	cached_skybox_image.add_overlay("glow")

/obj/machinery/photocopier/faxmachine/itglight
	department = "ITG Dauntless"
	desc = "The ship's fax machine! It's a safe assumption that most of the departments listed aren't on your ship, since the ship only has one."

/obj/item/paper/Dauntless
	name = "Notes about Dauntless"
	info = {"<font size=1>Welcome to the Ironcrest Transport Group</font><br><br>
	<h4>ITG Dauntless</h4>
	Welcome to the Dauntless, there are a few things you should know.<br><br>
	WRITE DOWN THE DOCKING CODES<br>
	You can find them in the Captain's Quarters, and on the shuttle control computers. Keep them handy, just in case.<br><br>
	<h4>DON'T OVERDO IT</h4>
	The Dauntless is FAST, but if you get her up to interstellar speeds, it's hard to slow back down again.<br><br>
	Additionally, exercise extreme caution around rocks and dust. <br>
	She has six point defense turrets, but her armor is thin, and she hasn't got any fancy shields. <br>
	She's not a combat ship, and she demands a competent pilot to treat her right.<br><br>
	Also d1a2 is best port, just saying.<br><br>
	Also the ship is 150 meters long and 92 meters wide, in case that is ever relevent."}
