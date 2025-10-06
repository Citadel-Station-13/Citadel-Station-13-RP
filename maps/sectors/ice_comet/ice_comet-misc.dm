// -- Datums -- //

/obj/overmap/entity/visitable/sector/ice_comet
	name = "Ice Comet Welnada"
	desc = "A gigantic ice comets."
	scanner_desc = @{"[i]Stellar Body[/i]: Welnada Giga Comet
[i]Class[/i]: Giga Comet
[i]Habitability[/i]: Limited (No atmosphere, but water)
[i]Population[/i]: 1 Science Outposts
[i]Controlling Goverment[/i]: Veymed.
[b]Relationship with NT[/b]: Allied
[b]Relevant Contracts[/b]: Light hostile encounter, from local wildlife.
[b]Notes[/b]: This small planetoid is a giga comet. Big enough to dock near it. Moving slowly, the planetoid seems to have a small sismic activity, and can produce geyser. Light gravity."}

	icon_state = "comet"
	color = "#b8e3ff"
	in_space = 1
	known = FALSE

//decoration

/obj/structure/flora/rock/geyser
	name = "Water geyser"
	desc = "A large rock"
	density = 1
	plane = MOB_PLANE
	layer = ABOVE_MOB_LAYER
	icon = 'icons/effects/water_geyser.dmi'
	icon_state = "geyser"
	randomize_size = TRUE

//New mobs

/mob/living/simple_mob/aggressive/whaleshark
	name = "Welnada Whaleshark"
	desc = "A whaleshark like creature."
	catalogue_data = list(/datum/category_item/catalogue/fauna/whaleshark)

	icon_living = "measelshark"
	icon_state = "measelshark"
	icon = 'icons/mob/shark.dmi'

	attacktext = list("mauled")

	iff_factions = MOB_IFF_FACTION_MUTANT

	maxHealth = 100
	health = 100

	response_help  = "pets"
	response_disarm = "gently moves aside"
	response_harm   = "swats"

	meat_amount = 1
	meat_type = /obj/item/reagent_containers/food/snacks/carpmeat/fish

	plane = TURF_PLANE
	layer = UNDERWATER_LAYER

	hovering = FALSE
	softfall = FALSE
	parachuting = FALSE
	movement_base_speed = 6.66

	legacy_melee_damage_lower = 5
	legacy_melee_damage_upper = 5

	base_pixel_x = -16

	randomized = TRUE
	mod_min = 90
	mod_max = 140

	var/global/list/suitable_turf_types =  list(
		/turf/simulated/floor/outdoors/beach/water,
		/turf/simulated/floor/outdoors/beach/coastline,
		/turf/simulated/floor/holofloor/beach/water,
		/turf/simulated/floor/holofloor/beach/coastline,
		/turf/simulated/floor/water
	)

/mob/living/simple_mob/aggressive/whaleshark/hostile
	name = "Welnada Shark"
	desc = "A Shark like creature, hostile."
	catalogue_data = list(/datum/category_item/catalogue/fauna/whaleshark)

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/melee/dragoon/blue
	maxHealth = 150
	health = 150


/datum/category_item/catalogue/fauna/whaleshark
	name = "Creature - Welnada Whaleshark"
	desc = "Living in the small underground sea under the ice crust, Welnada shark is very big because of the gas in the comet."
	value = CATALOGUER_REWARD_MEDIUM
