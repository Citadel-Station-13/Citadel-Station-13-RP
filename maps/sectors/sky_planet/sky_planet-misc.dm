//Overmap

/obj/overmap/entity/visitable/sector/skyplanet
	name = "Lythios 43a"	// Name of the location on the overmap.
	desc = "A planet with harsh conditions and acid lakes and rain on the ground, but with condition in the sky that makes it livable."
	scanner_desc =  @{"[i]Stellar Body[/i]: Lythios 43a - Sky planet
[i]Class[/i]: P-Class Planet, with breathable air over cloud level.
[i]Habitability[/i]: Weak : Ground level impossible. Settlements in high atltitude, on Sky-Rigs
[i]Population[/i]: 500
[i]Controlling Goverment[/i]: Previously : Various small defunct corporations. Now : SDF (limited), haddi's folley goverment (Limited)
[b]Relationship with NT[/b]: Nanotrasen Client Government, NT asset was authorised to land, Tajaran SDF outpost given to NT.
[b]Relevant Contracts[/b]: Dangerous Wildlife Control, System Self Defence Assistance."}
	icon_state = "globe"
	color = "#bfff00"
	known = TRUE
	in_space = 0

	initial_generic_waypoints = list(
		"skyplanet_voidline_pad1",
		"skyplanet_voidline_pad2",
		"skyplanet_voidline_pad3",
		"skyplanet_voidline_pad4",
		"skyplanet_voidline_pad5",
		"skyplanet_voidline_pad6",
		"skyplanet_excursion_dock",
		"skyplanet_excursion2_dock",
		"skyplanet_excursion3_dock",
		"skyplanet_excursion4_dock",
		"skyplanet_civvie_dock",
		"skyplanet_civvie2_dock",
		"skyplanet_civvie3_dock",
		"skyplanet_civvie4_dock",
		"skyplanet_hammerhead_dock",

		)

	initial_restricted_waypoints = list(
		"Red Comet Racing Shuttle" = list ("voidline_redcomet"),
		"Bonnethead Racing Shuttle" = list ("voidline_bonnethead"),
		"Udang Pari-pari Racing Shuttle" = list ("voidline_udang"),
		"Arrowhead Racing Shuttle" = list ("voidline_arrowhead"),
		)

//Turfs

/turf/simulated/open/skyplanet
	name = "the sky"
	desc = "It's the sky! Be careful! Falling from that would be lethal !"
	icon = 'icons/turf/sky.dmi'
	icon_state = "sky"
	color = "#ffeab0"
	turf_path_danger = TURF_PATH_DANGER_FALL
	can_build_into_floor = TRUE
	allow_gas_overlays = FALSE
	mz_flags = MZ_OPEN_BOTH
	initial_gas_mix = ATMOSPHERE_ID_SKYPLANET

/turf/simulated/open/skyplanet/Initialize(mapload)
	. = ..()
	icon = 'icons/turf/sky.dmi'
	icon_state = "sky"
	color = "#ffeab0"
	ASSERT(!isnull(below()))

/turf/simulated/open/skyplanet/Entered(atom/movable/mover)
	..()
	if(mover.movement_type & MOVEMENT_GROUND)
		mover.fall()

// Called when thrown object lands on this turf.
/turf/simulated/open/skyplanet/throw_landed(atom/movable/AM, datum/thrownthing/TT)
	. = ..()
	if(AM.movement_type & MOVEMENT_GROUND)
		AM.fall()

/turf/simulated/open/skyplanet/examine(mob/user, distance, infix, suffix)
	. = ..()
	if(distance <= 2)
		var/depth = 1
		for(var/turf/T = below(); (istype(T) && T.is_open()); T = T.below())
			depth += 1
		to_chat(user, "It is about [depth] level\s deep.")

/turf/simulated/open/skyplanet/is_plating()
	return FALSE

/turf/simulated/open/skyplanet/hides_underfloor_objects()
	return FALSE

/turf/simulated/open/skyplanet/is_space()
	return below()?.is_space()

/turf/simulated/open/skyplanet/is_open()
	return TRUE

/turf/simulated/open/skyplanet/is_solid_structure()
	return locate(/obj/structure/lattice, src)	// Counts as solid structure if it has a lattice (same as space)

/turf/simulated/open/skyplanet/is_safe_to_enter(mob/living/L)
	if(L.can_fall())
		if(!locate(/obj/structure/stairs) in below())
			return FALSE
	return ..()

// Straight copy from space.
/turf/simulated/open/skyplanet/attackby(obj/item/C as obj, mob/user as mob)
	if (istype(C, /obj/item/stack/rods))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			return
		var/obj/item/stack/rods/R = C
		if (R.use(1))
			to_chat(user, "<span class='notice'>Constructing support lattice ...</span>")
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			new /obj/structure/lattice(src)
		return

	if (istype(C, /obj/item/stack/tile/floor))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			var/obj/item/stack/tile/floor/S = C
			if (S.get_amount() < 1)
				return
			qdel(L)
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			S.use(1)
			ChangeTurf(/turf/simulated/floor, flags = CHANGETURF_INHERIT_AIR)
			return
		else
			to_chat(user, "<span class='warning'>The plating is going to need some support.</span>")

	// To lay cable.
	if(istype(C, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/coil = C
		coil.turf_place(src, user)


//landmarks

/obj/effect/shuttle_landmark/skyplanet/westrig1
	name = "NT Outpost Hyades - West Rig 1"
	landmark_tag = "skyplanet_excursion_dock"
	docking_controller = "westrig1_dock"
	base_turf = /turf/simulated/floor/reinforced/outdoors
	base_area = /area/sector/sky_planet/sky

/obj/effect/shuttle_landmark/skyplanet/southrig1
	name = "NT Outpost Hyades - South Rig 1"
	landmark_tag = "skyplanet_excursion2_dock"
	docking_controller = "southrig1_dock"
	base_turf = /turf/simulated/floor/reinforced/outdoors
	base_area = /area/sector/sky_planet/sky

/obj/effect/shuttle_landmark/skyplanet/westrig2
	name = "NT Outpost Hyades - West Rig 2"
	landmark_tag = "skyplanet_excursion3_dock"
	docking_controller = "westrig2_dock"
	base_turf = /turf/simulated/floor/reinforced/outdoors
	base_area = /area/sector/sky_planet/sky

/obj/effect/shuttle_landmark/skyplanet/southrig3
	name = "NT Outpost Hyades - South Rig 3"
	landmark_tag = "skyplanet_excursion4_dock"
	docking_controller = "southrig3_dock"
	base_turf = /turf/simulated/floor/reinforced/outdoors
	base_area = /area/sector/sky_planet/sky

/obj/effect/shuttle_landmark/skyplanet/northrig2
	name = "NT Outpost Hyades - North Rig 2"
	landmark_tag = "skyplanet_civvie_dock"
	docking_controller = "northrig2_dock"
	base_turf = /turf/simulated/floor/reinforced/outdoors
	base_area = /area/sector/sky_planet/sky

/obj/effect/shuttle_landmark/skyplanet/northrig3
	name = "NT Outpost Hyades - North Rig 3"
	landmark_tag = "skyplanet_civvie2_dock"
	docking_controller = "northrig3_dock"
	base_turf = /turf/simulated/floor/reinforced/outdoors
	base_area = /area/sector/sky_planet/sky

/obj/effect/shuttle_landmark/skyplanet/eastrig1
	name = "NT Outpost Hyades - East Rig 1"
	landmark_tag = "skyplanet_civvie3_dock"
	docking_controller = "eastrig1_dock"
	base_turf = /turf/simulated/floor/reinforced/outdoors
	base_area = /area/sector/sky_planet/sky

/obj/effect/shuttle_landmark/skyplanet/eastrig3
	name = "NT Outpost Hyades - East Rig 3"
	landmark_tag = "skyplanet_civvie4_dock"
	docking_controller = "eastrig3_dock"
	base_turf = /turf/simulated/floor/reinforced/outdoors
	base_area = /area/sector/sky_planet/sky

/obj/effect/shuttle_landmark/skyplanet/northrig2/hammerhead
	name = "NT Outpost Hyades - North Rig 2 (Hammerhead)"
	landmark_tag = "skyplanet_hammerhead_dock"
	docking_controller = "northrig2_dock"
	base_turf = /turf/simulated/floor/reinforced/outdoors
	base_area = /area/sector/sky_planet/sky

//voidline

/obj/effect/shuttle_landmark/skyplanet/voidline/redcomet
	name = "Voidline Rig - Red Comet Pad"
	landmark_tag = "voidline_redcomet"
	base_turf = /turf/simulated/floor/reinforced
	base_area = /area/sector/sky_planet/racing_station/dock
	docking_controller = "voidline_redcomet_dock"

/obj/effect/shuttle_landmark/skyplanet/voidline/bonnethead
	name = "Voidline Rig - Bonnethead Pad"
	landmark_tag = "voidline_bonnethead"
	base_turf = /turf/simulated/floor/reinforced
	base_area = /area/sector/sky_planet/racing_station/dock
	docking_controller = "voidline_bonnethead_dock"

/obj/effect/shuttle_landmark/skyplanet/voidline/udang
	name = "Voidline Rig - Udang Pari-pari Pad"
	landmark_tag = "voidline_udang"
	base_turf = /turf/simulated/floor/reinforced
	base_area = /area/sector/sky_planet/racing_station/dock
	docking_controller = "voidline_udang_dock"

/obj/effect/shuttle_landmark/skyplanet/voidline/arrowhead
	name = "Voidline Rig - Arrowhead Pad"
	landmark_tag = "voidline_arrowhead"
	base_turf = /turf/simulated/floor/reinforced
	base_area = /area/sector/sky_planet/racing_station/dock
	docking_controller = "voidline_arrowhead_dock"

//Public

/obj/effect/shuttle_landmark/skyplanet/voidline
	name = "Voidline Rig - pad 1"
	landmark_tag = "skyplanet_voidline_pad1"
	base_turf = /turf/simulated/floor/reinforced
	base_area = /area/sector/sky_planet/sky

/obj/effect/shuttle_landmark/skyplanet/voidline2
	name = "Voidline Rig - pad 2"
	landmark_tag = "skyplanet_voidline_pad2"
	base_turf = /turf/simulated/floor/reinforced
	base_area = /area/sector/sky_planet/sky

/obj/effect/shuttle_landmark/skyplanet/voidline3
	name = "Voidline Rig - pad 3"
	landmark_tag = "skyplanet_voidline_pad3"
	base_turf = /turf/simulated/floor/reinforced
	base_area = /area/sector/sky_planet/sky

/obj/effect/shuttle_landmark/skyplanet/voidline4
	name = "Voidline Rig - pad 4"
	landmark_tag = "skyplanet_voidline_pad4"
	base_turf = /turf/simulated/floor/reinforced
	base_area = /area/sector/sky_planet/sky

/obj/effect/shuttle_landmark/skyplanet/voidline5
	name = "Voidline Rig - pad 5"
	landmark_tag = "skyplanet_voidline_pad5"
	base_turf = /turf/simulated/floor/reinforced
	base_area = /area/sector/sky_planet/sky

/obj/effect/shuttle_landmark/skyplanet/voidline6
	name = "Voidline Rig - pad 6"
	landmark_tag = "skyplanet_voidline_pad6"
	base_turf = /turf/simulated/floor/reinforced
	base_area = /area/sector/sky_planet/sky

//mobs

/datum/category_item/catalogue/fauna/cultist/mad
	name = "Cultists - Lost"
	desc = "Understanding the mind of such fellow of cults is a fascinating, yet hard research. \
	Many tried, many failed, some saw success, other gave up. And some crashed."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/humanoid/cultist/mad
	name = "Crazed Intiate"
	desc = "A Novice Amongst his betters, and the victim of experiment, he seems to have fully embraced his faith, and let all logic leave is mind. He is hurt."
	icon_state = "initiate"
	icon_living = "initiate"
	maxHealth = 50
	health = 50
	catalogue_data = list(/datum/category_item/catalogue/fauna/cultist/mad)

	status_flags = 0

	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"

	harm_intent_damage = 5
	legacy_melee_damage_lower = 25	//Ritual Knife
	legacy_melee_damage_upper = 25
	attack_sharp = 1
	attack_edge = 1
	attacktext = list("slashed", "stabbed")
	armor_legacy_mob = list(melee = 50, bullet = 30, laser = 50, energy = 80, bomb = 25, bio = 100, rad = 100)	//Armor Rebalanced for Cult Robes.
	attack_sound = 'sound/weapons/rapidslice.ogg'
	movement_base_speed = 10 / 4

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/melee

	say_list_type = /datum/say_list/madcultist


/datum/say_list/madcultist
	speak = list(
		"I AM FINE. I AM NOT MAD. YOU ARE MAD. YOU SHALL DIE.",
		"I PRAYED. HE RESPONDED. HE MADE YOU CRASH. HE LOVES ME.",
		"I WILL BE ONE WITH HIM."
		)

/mob/living/simple_mob/humanoid/cultist/mad/death()
	new /obj/effect/decal/remains/human (src.loc)
	..(null,"lets out a horrified scream of pleasure as his body crumbles away. He will finaly be released.")
	ghostize()
	qdel(src)

//Dragoon

/datum/category_item/catalogue/fauna/dragoon/green
	name = "Creature - Green dragoon"
	desc = "A flying beast, with smooth scales, that shines a bit. \
	It got flat teeths, eats mushrooms, and seems to be flying with powerfull wings. \
	They live above the cloud level, in caves. Green Dragoon are passive."
	value = CATALOGUER_REWARD_MEDIUM

/datum/category_item/catalogue/fauna/dragoon/blue
	name = "Creature - Blue dragoon"
	desc = "A flying beast, with smooth scales, that shines a bit. \
	It got sharpened teeths, and seems to be flying with powerfull wings. \
	They live above the cloud level, in caves, and often hunt for food."
	value = CATALOGUER_REWARD_MEDIUM

/datum/category_item/catalogue/fauna/dragoon/yellow
	name = "Creature - Yellow dragoon"
	desc = "A flying beast, with smooth scales, that shines a bit. \
	It got sharpened teeths, and seems to be flying with powerfull wings. \
	They live above the cloud level, but also get down to the grounds. They are able to drink acid."
	value = CATALOGUER_REWARD_HARD

/datum/category_item/catalogue/fauna/dragoon/red
	name = "Creature - Red dragoon"
	desc = "A flying beast, with smooth scales, that shines a bit. \
	It got sharpened teeths, and seems to be flying with powerfull wings. \
	They live above the cloud level, but also get down to the grounds. \
	They are able to drink acid, and are highly dangerous."
	value = CATALOGUER_REWARD_SUPERHARD


/mob/living/simple_mob/aggressive/dragoon
	name = "Green dragoon"
	desc = "A flying lizard, quite fast, thats fly aboves cloud."
	catalogue_data = list(/datum/category_item/catalogue/fauna/dragoon/green)

	icon_living = "green-dragoon"
	icon_state = "green-dragoon"
	icon = 'icons/mob/64x64.dmi'

	attacktext = list("mauled")

	iff_factions = MOB_IFF_FACTION_MUTANT

	maxHealth = 100
	health = 100

	response_help  = "pets"
	response_disarm = "gently moves aside"
	response_harm   = "swats"

	meat_amount = 1
	bone_amount = 1

	hovering = TRUE
	softfall = TRUE
	parachuting = TRUE
	movement_base_speed = 6.66

	legacy_melee_damage_lower = 5
	legacy_melee_damage_upper = 5

	base_pixel_x = -16

	randomized = TRUE
	mod_min = 90
	mod_max = 140

//BLUE DRAGOON

/mob/living/simple_mob/aggressive/dragoon/blue
	name = "Blue dragoon"
	desc = "A flying lizard, quite fast, thats fly aboves cloud. Sharpen teeths are visible."
	catalogue_data = list(/datum/category_item/catalogue/fauna/dragoon/blue)

	icon_living = "blue-dragoon"
	icon_state = "blue-dragoon"
	icon = 'icons/mob/64x64.dmi'

	attacktext = list("mauled")

	iff_factions = MOB_IFF_FACTION_MUTANT

	maxHealth = 100
	health = 100

	meat_amount = 1
	bone_amount = 1

	hovering = TRUE
	softfall = TRUE
	parachuting = TRUE
	movement_base_speed = 6.66

	legacy_melee_damage_lower = 10
	legacy_melee_damage_upper = 10

	base_pixel_x = -16

	randomized = TRUE
	mod_min = 90
	mod_max = 140

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/melee/dragoon/blue

// Activate Noms!
/datum/ai_holder/polaris/simple_mob/melee/dragoon/blue
	hostile = TRUE
	can_breakthrough = TRUE
	violent_breakthrough = TRUE

// YELLOW DRAGOON

/mob/living/simple_mob/aggressive/dragoon/yellow
	name = "Yellow dragoon"
	desc = "A flying lizard, quite fast, thats fly aboves cloud. Sharpen teeths are visible. This one had also hard scales on its back."
	catalogue_data = list(/datum/category_item/catalogue/fauna/dragoon/yellow)

	icon_living = "yellow-dragoon"
	icon_state = "yellow-dragoon"
	icon = 'icons/mob/64x64.dmi'

	attacktext = list("mauled")

	iff_factions = MOB_IFF_FACTION_MUTANT

	maxHealth = 200
	health = 200

	meat_amount = 1
	bone_amount = 1

	hovering = TRUE
	softfall = TRUE
	parachuting = TRUE
	movement_base_speed = 6.66

	legacy_melee_damage_lower = 10
	legacy_melee_damage_upper = 10

	base_pixel_x = -16

	randomized = TRUE
	mod_min = 90
	mod_max = 140

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/ranged/dragoon/yellow

	projectiletype = /obj/projectile/energy/acid
	base_attack_cooldown = 12
	projectilesound = 'sound/effects/splat.ogg'
	attack_sound = 'sound/mobs/biomorphs/spitter_attack.ogg'
	movement_sound = 'sound/mobs/biomorphs/spitter_move.ogg'

// Activate Noms!
/datum/ai_holder/polaris/simple_mob/ranged/dragoon/yellow
	hostile = TRUE
	can_breakthrough = TRUE
	violent_breakthrough = TRUE
	pointblank = TRUE
	firing_lanes = TRUE
	conserve_ammo = TRUE

//Red Dragoon

/mob/living/simple_mob/aggressive/dragoon/red
	name = "Red dragoon"
	desc = "A flying lizard, quite fast, thats fly aboves cloud. Sharpen teeths are visible. This one had also hard scales on its back."
	catalogue_data = list(/datum/category_item/catalogue/fauna/dragoon/red)

	icon_living = "red-dragoon"
	icon_state = "red-dragoon"
	icon = 'icons/mob/64x64.dmi'

	attacktext = list("mauled")

	iff_factions = MOB_IFF_FACTION_MUTANT

	maxHealth = 300
	health = 300

	meat_amount = 1
	bone_amount = 1

	hovering = TRUE
	softfall = TRUE
	parachuting = TRUE
	movement_base_speed = 6.66

	legacy_melee_damage_lower = 10
	legacy_melee_damage_upper = 10

	base_pixel_x = -16

	randomized = TRUE
	mod_min = 90
	mod_max = 140

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/ranged/dragoon/yellow

	projectiletype = /obj/projectile/energy/plasmastun
	base_attack_cooldown = 12
	projectilesound = 'sound/effects/splat.ogg'
	attack_sound = 'sound/mobs/biomorphs/spitter_attack.ogg'
	movement_sound = 'sound/mobs/biomorphs/spitter_move.ogg'

/obj/item/paper/pamphlet/voidlinedebut
	name = "Voidline shuttle race"
	desc = "A letter describing the voidline race."
	info = "2542-01-01 Welcome to the Voildline Racing club, organisers of the Voidline shuttle race. This competition sees crews of 4 shuttles (or more) with the same specs fight for first place, in a systeme wide race. It is a competition that need skills and courage ! Our 4 shuttles, the trusty Arrowhead, the Teshari made Red Comet, the skrell made Udang and the Bonnethead will only show their might with the help of their crews."

/obj/item/paper/pamphlet/voidlineend
	name = "Voidline shuttle race cancelation - use of shuttle"
	desc = "A letter describing the voidline race cancelations."
	info = "2543-02-16, The SDF ordered a blockade of the planet. While I started to love seeing the clouds and the first edition of the voidline race being sucess, I admit that I will defend the choice of the SDF : the pirates, mercs, and now the situation in Base Town Ltet'Datri, is making the place more and more like a Hellhole.The club will remain active, has a open organisation. The Shuttle are legaly still ours, but I will authorise their use for races, and emergencies.Ah. And since Nanotrasen, Occulum, Vey-med, Hephatus, the SDF sponsoried the canceled second edition, I guess they also have the right to use the shuttles too.-Club Owner Flavio Cochran Briotar"

/obj/item/paper/pamphlet/arrowhead
	name = "Arrowhead note"
	desc = "A letter saying where the the 4th racing shuttle is."
	info = "2543-02-20, We had too sell the Arrowhead. Its win during the first edition made us secure a nice deal with the FTU, Enough offer us a good plan for the futur.I heard they would put the shuttle to rent, maybe for some VIPs.The rest of our shuttle will stay here. Legally, they can be freely used by wannabe racers."
