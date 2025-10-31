/*
** /obj/overmap/entity/fluff - Gas Giants, Large Barren Asteroids, Suns, Other Scannable but Non-Landable things in Space
*/

//To-Do find some way to take images and turn them into picture backgrounds for these bodies.

/obj/random/fluff_body //A random overmap fluff POI
	name = "Random Overmap Body"
	desc = "This a random overmap body."
	icon = 'icons/modules/overmap/entity.dmi'
	icon_state = "unknown"

/obj/random/fluff_body/item_to_spawn()
	return pick(prob(30);/obj/overmap/entity/fluff/comet,
			prob(30);/obj/overmap/entity/fluff/asteroid,
			prob(20);/obj/overmap/entity/fluff/probe/allied,
			prob(14);/obj/overmap/entity/fluff/probe/neutral,
			prob(5);/obj/overmap/entity/fluff/probe/hostile)


/obj/overmap/entity/fluff //This will all get replaced
	name = "Debug World"
	desc = "You shouldn't be seeing this planet contact, contact an admin."
	scanner_desc = "If you see this something has broken, contact an admin."
	known = FALSE
	scannable = TRUE
	//What Subtype of Celestial Body it is (i.e. Asteroid, Comet, Satellite)
	var/body_type
	/// Name prior to being scanned if !known
	var/unknown_name = "unknown body"
	/// Icon_state prior to being scanned if !known
	var/unknown_state = "unknown"
	/// Name when scanned
	var/scanned_name
	/// Icon_state when scanned
	var/scanned_icon
	/// Subtype of body for added Flavor
	var/body_subtype
	/// Does this thing belong to anyone?
	var/faction
	///How do you blow it up?
	var/weaknesses
	/// Does this thing leave something behind when you blow it up?

/obj/overmap/entity/fluff/Initialize(mapload)
	. = ..()
	src.setDir(pick(list(GLOB.alldirs)))
	if(known)
		plane = ABOVE_LIGHTING_PLANE
	else
		real_appearance = image(icon, src, icon_state)
		real_appearance.override = TRUE
		name = unknown_name
		icon_state = unknown_state
		color = null
		desc = "Scan this to find out more information."

/obj/overmap/entity/fluff/get_scan_data()
	if(!known)
		known = TRUE
		name = scanned_name
		icon_state = scanned_icon
		color = initial(color)
		desc = initial(desc)
	return ..()

/obj/overmap/entity/fluff/comet //Big ball of ice
	name = "Comet"
	desc = "A ball of ice spinning through space."
	color = "#5bbbd3"
	icon_state = "comet"
	weaknesses = OVERMAP_WEAKNESS_MINING | OVERMAP_WEAKNESS_EXPLOSIVE | OVERMAP_WEAKNESS_FIRE

/obj/overmap/entity/fluff/comet/Initialize(mapload)
	. = ..()
	body_subtype=  pick("P","C","X","D","I")											//You have found a comet
	scanned_name = "Comet: [(LEGACY_MAP_DATUM).starsys_name]-[body_subtype]/[rand(1,5000)]"
	scanned_icon = "comet"
	scanner_desc = {"Designation: [scanned_name]<br>
Class: [body_subtype]-type Comet. <br>
Dimensions: [rand(1, 60)].[rand(0,9)]km x [rand(1, 30)].[rand(0,9)]km x [rand(1, 30)].[rand(0,9)]km. <br>
Notice: Automatic maneuvering is currently enforced to prevent a risk of collision.<br>"}

/obj/overmap/entity/fluff/asteroid //Big ball of rock/metal
	name = "Asteroid"
	desc = "A minor planet with negligible gravity."
	color = "#eaa17c"
	icon_state = "asteroid"
	weaknesses = OVERMAP_WEAKNESS_MINING | OVERMAP_WEAKNESS_EXPLOSIVE

/obj/overmap/entity/fluff/asteroid/Initialize(mapload) //A Minor Planet AKA an Asteroid
	. = ..()
	body_subtype=  pick("C","M","S")
	scanned_name = "Minor Planet: ([rand(100,10000)]) [(LEGACY_MAP_DATUM).starsys_name]" ///There is over 10k Asteroids of over 10km in Diameter in the Solar System
	scanned_icon = "asteroid"
	scanner_desc = {"Designation: [scanned_name]<br>
Class<: [body_subtype]-type Asteroid. <br>
Diameter: [rand(10, 100)].[rand(0,9)]km x [rand(10, 100)].[rand(0,9)]km x [rand(10, 100)].[rand(0,9)]km. <br>
Notice: Automatic maneuvering is currently enforced to prevent a risk of collision.<br>"}

/obj/overmap/entity/fluff/probe //Unmanned probes, scanning transmitting and generally clogging up space.
	name = "Unmanned Probe"
	desc = "An small unmanned probe used for automated scanning or to help transmit data."
	icon_state = "probe"
	weaknesses = OVERMAP_WEAKNESS_EXPLOSIVE | OVERMAP_WEAKNESS_FIRE | OVERMAP_WEAKNESS_EMP

/obj/overmap/entity/fluff/probe/allied //Probes owned by NT, Vey-Med, Heph other allied groups.
	name = "Allied Probe"
	desc = "An small unmanned probe used for automated scanning or to help transmit data. This one is a friend."
	color = "#007396"
	known = TRUE //Allied Probes Are on NT's Local Network and start known.
	light_power = 4
	light_range = 2.5

/obj/overmap/entity/fluff/probe/allied/Initialize(mapload)
	. = ..()
	body_subtype=  pick("Communication","Observation","Navigation","Astrological")
	faction=  pick("Nanotrasen","Vey-Med","Hephaestus")
	name = "[faction] Satellite: [(LEGACY_MAP_DATUM).starsys_name]-[rand(1,100)]"
	scanned_icon = "probe"
	scanner_desc = {"Registration: [name]<br>
Class: Artificial [body_subtype] Satellite. <br>
Notice: Damage to [faction] property may result in legal action.<br>"}

/obj/overmap/entity/fluff/probe/neutral //Probes owned by neutral corps and locals governments
	name = "Neutral Probe"
	desc = "An small unmanned probe used for automated scanning or to help transmit data. This one is neutral."
	color = "#fffffe"
	light_power = 4  ///These Satellites scan but they are not on NT's Network
	light_range = 2.5

/obj/overmap/entity/fluff/probe/neutral/Initialize(mapload)
	. = ..()
	body_subtype=  pick("Communication","Observation","Navigation","Astrological")
	faction=  pick("SDF","Occulum News","Donk Co.","Ward-Takashi GMB")
	scanned_name = "[faction] Satellite: [(LEGACY_MAP_DATUM).starsys_name]-[rand(1,100)]"
	scanned_icon = "probe"
	scanner_desc = {"Registration: [name]<br>
Class: Artificial [body_subtype] Satellite. <br>
Notice: Damage to [faction] property may result in legal action.<br>"}

/obj/overmap/entity/fluff/probe/hostile //Probes owned by hostile actors.
	name = "Unknown Probe"
	desc = "An small unmanned probe used for automated scanning or to help transmit data. This one shouldn't be here."
	color = "#FF3333"


/obj/overmap/entity/fluff/probe/hostile/Initialize(mapload)
	. = ..()
	body_subtype=  pick("Listening","Spy","Tracking")
	faction=  pick("Pirate","Mercenary", "Vox", "Hivebot")
	scanned_name = "Unregistered Satellite-[rand(1,100)]"
	scanned_icon = "probe"
	scanner_desc = {"Registration: Unknown. Potential [faction] Transmission Detected. <br>
Class: Unknown. Potential [body_subtype] Satellite.<br>
Notice: Destruction of Satellite Recommended.<br>"}
