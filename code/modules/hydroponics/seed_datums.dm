// Chili plants/variants.
/datum/seed/chili
	name = "chili"
	seed_name = "chili"
	display_name = "chili plants"
	kitchen_tag = "chili"
	chems = list("capsaicin" = list(3,5), "nutriment" = list(1,25))
	mutants = list("icechili")
	food_info = list(list(0, 1, "chili"), list(15 SECONDS, 1.2, "cooked chili peppers"), list(32 SECONDS, 1, "mushy chili peppers"), list(40 SECONDS, 0.9, "burnt chili peppers"))

/datum/seed/chili/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,20)
	set_trait(TRAIT_PRODUCT_ICON,"chili")
	set_trait(TRAIT_PRODUCT_COLOUR,"#ED3300")
	set_trait(TRAIT_PLANT_ICON,"bush2")
	set_trait(TRAIT_IDEAL_HEAT, 298)
	set_trait(TRAIT_IDEAL_LIGHT, 7)

/datum/seed/chili/ice
	name = "icechili"
	seed_name = "ice pepper"
	display_name = "ice-pepper plants"
	kitchen_tag = "icechili"
	mutants = null
	chems = list("frostoil" = list(3,5), "nutriment" = list(1,50))
	food_info = list(list(0, 1, "ice pepper"), list(30 SECONDS, 1.2, "cooked ice peppers"), list(60 SECONDS, 1, "melting ice peppers"), list(75 SECONDS, 0.9, "burnt ice peppers"))

/datum/seed/chili/ice/New()
	..()
	set_trait(TRAIT_MATURATION,4)
	set_trait(TRAIT_PRODUCTION,4)
	set_trait(TRAIT_PRODUCT_COLOUR,"#00EDC6")

// Berry plants/variants.
/datum/seed/berry
	name = "berries"
	seed_name = "berry"
	display_name = "berry bush"
	kitchen_tag = "berries"
	mutants = list("glowberries","poisonberries")
	chems = list("nutriment" = list(1,10), "berryjuice" = list(10,10))
	food_info = list(list(0, 1, "fresh berries"), list(20 SECONDS, 1.2, "stewed berries"), list(30 SECONDS, 1, "overcooked berry mush"), list(40 SECONDS, 0.9, "carbon with a hint of berry"))

/datum/seed/berry/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_JUICY,1)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"berry")
	set_trait(TRAIT_PRODUCT_COLOUR,"#FA1616")
	set_trait(TRAIT_PLANT_ICON,"bush")
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/berry/glow
	name = "glowberries"
	seed_name = "glowberry"
	display_name = "glowberry bush"
	mutants = null
	chems = list("nutriment" = list(1,10), MAT_URANIUM = list(3,5))
	food_info = list(list(0, 1, "glowberries"), list(20 SECONDS, 1.2, "stewed glowberries"), list(30 SECONDS, 1, "overcooked glowing mush"), list(40 SECONDS, 0.9, "radioactive charcoal"))

/datum/seed/berry/glow/New()
	..()
	set_trait(TRAIT_SPREAD,1)
	set_trait(TRAIT_BIOLUM,1)
	set_trait(TRAIT_BIOLUM_COLOUR,"#006622")
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_COLOUR,"#c9fa16")
	set_trait(TRAIT_WATER_CONSUMPTION, 3)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.25)

/datum/seed/berry/poison
	name = "poisonberries"
	seed_name = "poison berry"
	display_name = "poison berry bush"
	mutants = list("deathberries")
	chems = list("nutriment" = list(1), "toxin" = list(3,5), "poisonberryjuice" = list(10,5))
	food_info = list(list(0, 1, "spicy berries"), list(20 SECONDS, 1.2, "stewed spicy berries"), list(30 SECONDS, 1, "overcooked spicy-sweet mush"), list(40 SECONDS, 0.9, "spicy charcoal"))

/datum/seed/berry/poison/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"#6DC961")
	set_trait(TRAIT_WATER_CONSUMPTION, 3)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.25)

/datum/seed/berry/poison/death
	name = "deathberries"
	seed_name = "death berry"
	display_name = "death berry bush"
	mutants = null
	chems = list("nutriment" = list(1), "toxin" = list(3,3), "lexorin" = list(1,5))
	food_info = list(list(0, 1, "death and berries"), list(20 SECONDS, 1.2, "death and stewed berries"), list(30 SECONDS, 1, "overcooked deadly mush"), list(40 SECONDS, 0.9, "deadly charcoal"))

/datum/seed/berry/poison/death/New()
	..()
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,50)
	set_trait(TRAIT_PRODUCT_COLOUR,"#7A5454")
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.35)

// Nettles/variants.
/datum/seed/nettle
	name = "nettle"
	seed_name = "nettle"
	display_name = "nettles"
	mutants = list("deathnettle")
	chems = list("nutriment" = list(1,50), "sacid" = list(0,1))
	kitchen_tag = "nettle"
	food_info = list(list(0, 1, "peppery spinach"), list(15 SECONDS, 1.2, "cooked peppery spinach"), list(25 SECONDS, 1, "wilting, mushy spinach"), list(30 SECONDS, 0.9, "unpalatable wilted spinach"))


/datum/seed/nettle/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_STINGS,1)
	set_trait(TRAIT_PLANT_ICON,"bush5")
	set_trait(TRAIT_PRODUCT_ICON,"nettles")
	set_trait(TRAIT_PRODUCT_COLOUR,"#728A54")

/datum/seed/nettle/death
	name = "deathnettle"
	seed_name = "death nettle"
	display_name = "death nettles"
	kitchen_tag = "deathnettle"
	mutants = null
	chems = list("nutriment" = list(1,50), "pacid" = list(0,1))
	food_info = list(list(0, 1, "extra-spicy spinach"), list(30 SECONDS, 1.2, "cooked extra-spicy spinach"), list(60 SECONDS, 1, "extra-spicy mushy spinach"), list(90 SECONDS, 0.9, "extra-spicy wilted spinach"))

/datum/seed/nettle/death/New()
	..()
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_PRODUCT_COLOUR,"#8C5030")
	set_trait(TRAIT_PLANT_COLOUR,"#634941")

//Tomatoes/variants.
/datum/seed/tomato
	name = "tomato"
	seed_name = "tomato"
	display_name = "tomato plant"
	mutants = list("bluetomato","bloodtomato")
	chems = list("nutriment" = list(1,10), "tomatojuice" = list(10,10))
	kitchen_tag = "tomato"
	food_info = list(list(0, 1, "ripe tomato"), list(10 SECONDS, 1.2, "soft cooked tomato"), list(25 SECONDS, 1, "overcooked tomato"), list(30 SECONDS, 0.9, "dry, overcooked tomato"))

/datum/seed/tomato/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_JUICY,1)
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"tomato")
	set_trait(TRAIT_PRODUCT_COLOUR,"#D10000")
	set_trait(TRAIT_PLANT_ICON,"bush3")
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.25)

/datum/seed/tomato/blood
	name = "bloodtomato"
	seed_name = "blood tomato"
	display_name = "blood tomato plant"
	mutants = list("killer")
	chems = list("nutriment" = list(1,10), "blood" = list(1,5))
	splat_type = /obj/effect/debris/cleanable/blood/splatter
	food_info = list(list(0, 1, "metallic tomato"), list(15 SECONDS, 1.2, "soft, metallic cooked tomato"), list(25 SECONDS, 1, "rusty tomato"), list(30 SECONDS, 0.9, "burnt, coagulated blood"))

/datum/seed/tomato/blood/New()
	..()
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_PRODUCT_COLOUR,"#FF0000")

/datum/seed/tomato/killer
	name = "killertomato"
	seed_name = "killer tomato"
	display_name = "killer tomato plant"
	mutants = null
	can_self_harvest = 1
	has_mob_product = /mob/living/simple_mob/hostile/tomato
	food_info = list(list(0, 1, "ripe tomato"), list(10 SECONDS, 1.2, "soft cooked tomato"), list(25 SECONDS, 1, "overcooked tomato"), list(30 SECONDS, 0.9, "dry, overcooked tomato"))
	

/datum/seed/tomato/killer/New()
	..()
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_PRODUCT_COLOUR,"#A86747")

/datum/seed/tomato/blue
	name = "bluetomato"
	seed_name = "blue tomato"
	display_name = "blue tomato plant"
	mutants = list("bluespacetomato")
	chems = list("nutriment" = list(1,20), "lube" = list(1,5))
	food_info = list(list(0, 1, "ripe tomato"), list(10 SECONDS, 1.2, "soft cooked tomato"), list(25 SECONDS, 1, "overcooked tomato"), list(30 SECONDS, 0.9, "dry, overcooked tomato"))

/datum/seed/tomato/blue/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"#4D86E8")
	set_trait(TRAIT_PLANT_COLOUR,"#070AAD")

/datum/seed/tomato/blue/teleport
	name = "bluespacetomato"
	seed_name = "bluespace tomato"
	display_name = "bluespace tomato plant"
	mutants = null
	chems = list("nutriment" = list(1,20), "singulo" = list(10,5))
	food_info = list(list(0, 1, "ripe teleportomato"), list(10 SECONDS, 1.2, "soft cooked tomato"), list(25 SECONDS, 1, "overcooked tomato"), list(30 SECONDS, 0.9, "dry, overcooked tomato"))

/datum/seed/tomato/blue/teleport/New()
	..()
	set_trait(TRAIT_TELEPORTING,1)
	set_trait(TRAIT_PRODUCT_COLOUR,"#00E5FF")
	set_trait(TRAIT_BIOLUM,1)
	set_trait(TRAIT_BIOLUM_COLOUR,"#4DA4A8")

//Eggplants/varieties.
/datum/seed/eggplant
	name = "eggplant"
	seed_name = "eggplant"
	display_name = "eggplants"
	kitchen_tag = "eggplant"
	mutants = list("egg-plant")
	chems = list("nutriment" = list(1,10))
	food_info = list(list(0, 1, "raw eggplant"), list(20 SECONDS, 1.2, "tender, juicy eggplant"), list(30 SECONDS, 1, "mushy eggplant"), list(45 SECONDS, 0.9, "crusty, overcooked eggplant"))

/datum/seed/eggplant/New()
	..()
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,20)
	set_trait(TRAIT_PRODUCT_ICON,"eggplant")
	set_trait(TRAIT_PRODUCT_COLOUR,"#892694")
	set_trait(TRAIT_PLANT_ICON,"bush4")
	set_trait(TRAIT_IDEAL_HEAT, 298)
	set_trait(TRAIT_IDEAL_LIGHT, 7)

// Return of Eggy. Just makes purple eggs. If the reagents are separated from the egg production by xenobotany or RNG, it's still an Egg plant.
/datum/seed/eggplant/egg
	name = "egg-plant"
	seed_name = "egg-plant"
	display_name = "egg-plants"
	kitchen_tag = "egg-plant"
	mutants = null
	chems = list("nutriment" = list(1,5), "egg" = list(3,12))
	has_item_product = /obj/item/reagent_containers/food/snacks/egg/purple
	food_info = list(list(0, 1, "raw egg"), list(15 SECONDS, 1.2, "cooked egg"), list(25 SECONDS, 1, "overcooked egg"), list(30 SECONDS, 0.9, "burnt egg"))

//Apples/varieties.
/datum/seed/apple
	name = "apple"
	seed_name = "apple"
	display_name = "apple tree"
	kitchen_tag = "apple"
	mutants = list("poisonapple","goldapple")
	chems = list("nutriment" = list(1,10),"applejuice" = list(10,20))
	food_info = list(list(0, 1, "crispy, fresh apple"), list(10 SECONDS, 1.2, "tender, sweet apple"), list(30 SECONDS, 1, "mushy and weird apple"), list(45 SECONDS, 0.9, "unpleasantly warm baby food"))

/datum/seed/apple/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"apple")
	set_trait(TRAIT_PRODUCT_COLOUR,"#FF540A")
	set_trait(TRAIT_PLANT_ICON,"tree2")
	set_trait(TRAIT_FLESH_COLOUR,"#E8E39B")
	set_trait(TRAIT_IDEAL_LIGHT, 4)

/datum/seed/apple/poison
	name = "poisonapple"
	mutants = null
	chems = list("cyanide" = list(1,5))
	food_info = list(list(0, 1, "crispy, fresh apple"), list(10 SECONDS, 1.2, "tender, sweet apple"), list(30 SECONDS, 1, "mushy and weird apple"), list(45 SECONDS, 0.9, "unpleasantly warm baby food"))

/datum/seed/apple/gold
	name = "goldapple"
	seed_name = "golden apple"
	display_name = "gold apple tree"
	kitchen_tag = "goldapple"
	mutants = null
	chems = list("nutriment" = list(1,10), MAT_GOLD = list(1,5))
	food_info = list(list(0, 1, "tangy, fresh apple"), list(10 SECONDS, 1.2, "tender, tangy apple"), list(30 SECONDS, 1, "mushy and sour apple"), list(45 SECONDS, 0.9, "unpleasantly bitter baby food"))

/datum/seed/apple/gold/New()
	..()
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_PRODUCTION,10)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_PRODUCT_COLOUR,"#FFDD00")
	set_trait(TRAIT_PLANT_COLOUR,"#D6B44D")

//Ambrosia/varieties.
/datum/seed/ambrosia
	name = "ambrosia"
	seed_name = "ambrosia vulgaris"
	display_name = "ambrosia vulgaris"
	kitchen_tag = "ambrosia"
	mutants = list("ambrosiadeus")
	chems = list("nutriment" = list(1), "space_drugs" = list(1,8), "kelotane" = list(1,8,1), "bicaridine" = list(1,10,1), "toxin" = list(1,10))
	food_info = list(list(0, 1, "leafy, bitter spinach"), list(30 SECONDS, 1.2, "cooked bitter spinach"), list(35 SECONDS, 1, "mushy bitter spinach"), list(60 SECONDS, 0.9, "bitterness and wilted spinach"))

/datum/seed/ambrosia/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,6)
	set_trait(TRAIT_POTENCY,5)
	set_trait(TRAIT_PRODUCT_ICON,"ambrosia")
	set_trait(TRAIT_PRODUCT_COLOUR,"#9FAD55")
	set_trait(TRAIT_PLANT_ICON,"ambrosia")
	set_trait(TRAIT_IDEAL_LIGHT, 6)

/datum/seed/ambrosia/deus
	name = "ambrosiadeus"
	seed_name = "ambrosia deus"
	display_name = "ambrosia deus"
	kitchen_tag = "ambrosiadeus"
	mutants = list("ambrosiagaia")
	chems = list("nutriment" = list(1), "bicaridine" = list(1,8), "synaptizine" = list(1,8,1), "hyperzine" = list(1,10,1), "space_drugs" = list(1,10))
	food_info = list(list(0, 1, "leafy, extra-bitter spinach"), list(30 SECONDS, 1.2, "cooked, extra-bitter spinach"), list(35 SECONDS, 1, "mushy bitter spinach"), list(60 SECONDS, 0.9, "bitterness and wilted spinach"))

/datum/seed/ambrosia/deus/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"#A3F0AD")
	set_trait(TRAIT_PLANT_COLOUR,"#2A9C61")

/datum/seed/ambrosia/gaia
	name = "ambrosiagaia"
	seed_name = "ambrosia gaia"
	display_name = "ambrosia gaia"
	kitchen_tag = "ambrosiagaia"
	mutants = null
	chems = list ("earthsblood" = list(3,5), "nutriment" = list(1,3))

/datum/seed/ambrosia/gaia/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,0)
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_WATER_CONSUMPTION,6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION,6)
	set_trait(TRAIT_WEED_TOLERANCE,1)
	set_trait(TRAIT_TOXINS_TOLERANCE,1)
	set_trait(TRAIT_PEST_TOLERANCE,1)
	set_trait(TRAIT_BIOLUM,1)
	set_trait(TRAIT_BIOLUM_COLOUR,"#ffb500")
	set_trait(TRAIT_PRODUCT_COLOUR, "#ffee00")
	set_trait(TRAIT_PLANT_COLOUR,"#f3ba2b")

//Mushrooms/varieties.
/datum/seed/mushroom
	name = "mushrooms"
	seed_name = "chanterelle"
	seed_noun = "spores"
	display_name = "chanterelle mushrooms"
	mutants = list("reishi","amanita","plumphelmet")
	chems = list("nutriment" = list(1,25))
	splat_type = /obj/effect/plant
	kitchen_tag = "mushroom"
	food_info = list(list(0, 1, "earthy, fruity mushroom"), list(25 SECONDS, 1.2, "tender, fruity mushroom"), list(40 SECONDS, 1, "mushy mushroom"), list(45 SECONDS, 0.9, "an unpleasantly rubbery mass"))

/datum/seed/mushroom/New()
	..()
	set_trait(TRAIT_MATURATION,7)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_POTENCY,1)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom4")
	set_trait(TRAIT_PRODUCT_COLOUR,"#DBDA72")
	set_trait(TRAIT_PLANT_COLOUR,"#D9C94E")
	set_trait(TRAIT_PLANT_ICON,"mushroom")
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_IDEAL_HEAT, 288)
	set_trait(TRAIT_LIGHT_TOLERANCE, 6)

/datum/seed/mushroom/mold
	name = "mold"
	seed_name = "brown mold"
	display_name = "brown mold"
	mutants = null

/datum/seed/mushroom/mold/New()
	..()
	set_trait(TRAIT_SPREAD,1)
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_YIELD,-1)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom5")
	set_trait(TRAIT_PRODUCT_COLOUR,"#7A5F20")
	set_trait(TRAIT_PLANT_COLOUR,"#7A5F20")
	set_trait(TRAIT_PLANT_ICON,"mushroom9")

/datum/seed/mushroom/plump
	name = "plumphelmet"
	seed_name = "plump helmet"
	display_name = "plump helmet mushrooms"
	mutants = list("walkingmushroom","towercap")
	chems = list("nutriment" = list(2,10))
	kitchen_tag = "plumphelmet"
	food_info = list(list(0, 1, "bland, tough mushroom"), list(25 SECONDS, 1.2, "bland cooked mushroom"), list(40 SECONDS, 1, "bland, squishy mushroom"), list(45 SECONDS, 0.9, "an unpleasantly firm mass"))

/datum/seed/mushroom/plump/New()
	..()
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,0)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom10")
	set_trait(TRAIT_PRODUCT_COLOUR,"#B57BB0")
	set_trait(TRAIT_PLANT_COLOUR,"#9E4F9D")
	set_trait(TRAIT_PLANT_ICON,"mushroom2")

/datum/seed/mushroom/hallucinogenic
	name = "reishi"
	seed_name = "reishi"
	display_name = "reishi"
	mutants = list("libertycap","glowshroom")
	chems = list("nutriment" = list(1,50), "psilocybin" = list(3,5))

/datum/seed/mushroom/hallucinogenic/New()
	..()
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,15)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom11")
	set_trait(TRAIT_PRODUCT_COLOUR,"#FFB70F")
	set_trait(TRAIT_PLANT_COLOUR,"#F58A18")
	set_trait(TRAIT_PLANT_ICON,"mushroom6")

/datum/seed/mushroom/hallucinogenic/strong
	name = "libertycap"
	seed_name = "liberty cap"
	display_name = "liberty cap mushrooms"
	mutants = null
	chems = list("nutriment" = list(1), "stoxin" = list(3,3), "space_drugs" = list(1,25))

/datum/seed/mushroom/hallucinogenic/strong/New()
	..()
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_POTENCY,15)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom8")
	set_trait(TRAIT_PRODUCT_COLOUR,"#F2E550")
	set_trait(TRAIT_PLANT_COLOUR,"#D1CA82")
	set_trait(TRAIT_PLANT_ICON,"mushroom3")

/datum/seed/mushroom/poison
	name = "amanita"
	seed_name = "fly amanita"
	display_name = "fly amanita mushrooms"
	mutants = list("destroyingangel","plastic")
	chems = list("nutriment" = list(1), "amatoxin" = list(3,3), "psilocybin" = list(1,25))

/datum/seed/mushroom/poison/New()
	..()
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom")
	set_trait(TRAIT_PRODUCT_COLOUR,"#FF4545")
	set_trait(TRAIT_PLANT_COLOUR,"#E0DDBA")
	set_trait(TRAIT_PLANT_ICON,"mushroom4")

/datum/seed/mushroom/poison/death
	name = "destroyingangel"
	seed_name = "destroying angel"
	display_name = "destroying angel mushrooms"
	mutants = null
	chems = list("nutriment" = list(1,50), "amatoxin" = list(13,3), "psilocybin" = list(1,25))

/datum/seed/mushroom/poison/death/New()
	..()
	set_trait(TRAIT_MATURATION,12)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,35)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom3")
	set_trait(TRAIT_PRODUCT_COLOUR,"#EDE8EA")
	set_trait(TRAIT_PLANT_COLOUR,"#E6D8DD")
	set_trait(TRAIT_PLANT_ICON,"mushroom5")

/datum/seed/mushroom/towercap
	name = "towercap"
	seed_name = "tower cap"
	display_name = "tower caps"
	chems = list("woodpulp" = list(10,1))
	mutants = null
	has_item_product = /obj/item/stack/material/log

/datum/seed/mushroom/towercap/New()
	..()
	set_trait(TRAIT_MATURATION,15)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom7")
	set_trait(TRAIT_PRODUCT_COLOUR,"#79A36D")
	set_trait(TRAIT_PLANT_COLOUR,"#857F41")
	set_trait(TRAIT_PLANT_ICON,"mushroom8")

/datum/seed/mushroom/glowshroom
	name = "glowshroom"
	seed_name = "glowshroom"
	display_name = "glowshrooms"
	mutants = null
	chems = list("radium" = list(1,20))
	food_info = list(list(0, 1, "spicy, fruity mushroom"), list(14 SECONDS, 1.2, "tender, spicy and fruity mushroom"), list(18 SECONDS, 1, "tough, spicy mushroom"), list(22 SECONDS, 0.9, "an unpleasantly rubbery mass")) //glowshrooms are hard to cook but have a unique flavour

/datum/seed/mushroom/glowshroom/New()
	..()
	set_trait(TRAIT_SPREAD,1)
	set_trait(TRAIT_MATURATION,15)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,30)
	set_trait(TRAIT_BIOLUM,1)
	set_trait(TRAIT_BIOLUM_COLOUR,"#006622")
	set_trait(TRAIT_PRODUCT_ICON,"mushroom2")
	set_trait(TRAIT_PRODUCT_COLOUR,"#DDFAB6")
	set_trait(TRAIT_PLANT_COLOUR,"#EFFF8A")
	set_trait(TRAIT_PLANT_ICON,"mushroom7")

/datum/seed/mushroom/plastic
	name = "plastic"
	seed_name = "plastellium"
	display_name = "plastellium"
	mutants = null
	chems = list("plasticide" = list(1,10))
	food_info = list(list(0, 1, "plasticky mushroom"), list(60 SECONDS, 1.2, "warm plastic"), list(120 SECONDS, 1, "burning plastic"), list(180 SECONDS, 0.9, "plastic and toxic chemicals"))

/datum/seed/mushroom/plastic/New()
	..()
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,6)
	set_trait(TRAIT_POTENCY,20)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom6")
	set_trait(TRAIT_PRODUCT_COLOUR,"#E6E6E6")
	set_trait(TRAIT_PLANT_COLOUR,"#E6E6E6")
	set_trait(TRAIT_PLANT_ICON,"mushroom10")

//Flowers/varieties
/datum/seed/flower
	name = "harebells"
	seed_name = "harebell"
	display_name = "harebells"
	kitchen_tag = "harebell"
	chems = list("nutriment" = list(1,20))
	food_info = list(list(0, 1, "slightly sweet leaves and petals"), list(10 SECONDS, 1.2, "slightly sweet leaves and petals"), list(20 SECONDS, 1, "wilting leaves and petals"), list(25 SECONDS, 0.9, "a dead plant"))

/datum/seed/flower/New()
	..()
	set_trait(TRAIT_MATURATION,7)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_PRODUCT_ICON,"flower5")
	set_trait(TRAIT_PRODUCT_COLOUR,"#C492D6")
	set_trait(TRAIT_PLANT_COLOUR,"#6B8C5E")
	set_trait(TRAIT_PLANT_ICON,"flower")
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/flower/poppy
	name = "poppies"
	seed_name = "poppy"
	display_name = "poppies"
	kitchen_tag = "poppy"
	chems = list("nutriment" = list(1,20), "bicaridine" = list(1,10))
	food_info = list(list(0, 1, "slightly sweet almonds"), list(15 SECONDS, 1.2, "sweet, nutty almond"), list(20 SECONDS, 1, "over-roasted almond"), list(25 SECONDS, 0.9, "carbonized seeds")) //poppy is good to eat :D

/datum/seed/flower/poppy/New()
	..()
	set_trait(TRAIT_POTENCY,20)
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,6)
	set_trait(TRAIT_PRODUCT_ICON,"flower3")
	set_trait(TRAIT_PRODUCT_COLOUR,"#B33715")
	set_trait(TRAIT_PLANT_ICON,"flower3")
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_WATER_CONSUMPTION, 0.5)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/flower/sunflower
	name = "sunflowers"
	seed_name = "sunflower"
	display_name = "sunflowers"
	kitchen_tag = "sunflower"
	food_info = list(list(0, 1, "bright with a hint of floral bitterness"), list(20 SECONDS, 1.2, "mild nuttiness"), list(25 SECONDS, 1, "over-roasted nuts"), list(40 SECONDS, 0.9, "burnt sunflower and sadness"))

/datum/seed/flower/sunflower/New()
	..()
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCT_ICON,"flower2")
	set_trait(TRAIT_PRODUCT_COLOUR,"#FFF700")
	set_trait(TRAIT_PLANT_ICON,"flower2")
	set_trait(TRAIT_IDEAL_LIGHT, 7)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/flower/lavender
	name = "lavender"
	seed_name = "lavender"
	display_name = "lavender"
	kitchen_tag = "lavender"
	chems = list("nutriment" = list(1,20), "bicaridine" = list(1,10))

/datum/seed/flower/lavender/New()
	..()
	set_trait(TRAIT_MATURATION,7)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_PRODUCT_ICON,"flower6")
	set_trait(TRAIT_PRODUCT_COLOUR,"#B57EDC")
	set_trait(TRAIT_PLANT_COLOUR,"#6B8C5E")
	set_trait(TRAIT_PLANT_ICON,"flower4")
	set_trait(TRAIT_IDEAL_LIGHT, 7)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.05)
	set_trait(TRAIT_WATER_CONSUMPTION, 0.5)

/datum/seed/flower/rose
	name = "rose"
	seed_name = "rose"
	display_name = "rose"
	kitchen_tag = "rose"
	mutants = list("bloodrose")
	chems = list("nutriment" = list(1,5), "stoxin" = list(0,2))

/datum/seed/flower/rose/New()
	..()
	set_trait(TRAIT_MATURATION,7)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_PRODUCT_ICON,"flowers")
	set_trait(TRAIT_PRODUCT_COLOUR,"#ce0e0e")
	set_trait(TRAIT_PLANT_COLOUR,"#6B8C5E")
	set_trait(TRAIT_PLANT_ICON,"bush5")
	set_trait(TRAIT_IDEAL_LIGHT, 7)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.1)
	set_trait(TRAIT_WATER_CONSUMPTION, 0.5)
	set_trait(TRAIT_STINGS,1)

/datum/seed/flower/rose/blood
	name = "bloodrose"
	display_name = "bleeding rose"
	mutants = null
	chems = list("nutriment" = list(1,5), "stoxin" = list(1,5), "blood" = list(0,2))

/datum/seed/flower/rose/blood/New()
	..()
	set_trait(TRAIT_IDEAL_LIGHT, 1)
	set_trait(TRAIT_PLANT_COLOUR,"#5e0303")
	set_trait(TRAIT_CARNIVOROUS,1)

//Grapes/varieties
/datum/seed/grapes
	name = "grapes"
	seed_name = "grape"
	display_name = "grapevines"
	kitchen_tag = "grapes"
	mutants = list("greengrapes")
	chems = list("nutriment" = list(1,10), "sugar" = list(1,5), "grapejuice" = list(10,10))
	food_info = list(list(0, 1, "fresh, sweet grapes"), list(10 SECONDS, 1.2, "tender, stewed grape"), list(15 SECONDS, 1, "grape mush"), list(20 SECONDS, 0.9, "unpalatable grapey mush"))

/datum/seed/grapes/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,3)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"grapes")
	set_trait(TRAIT_PRODUCT_COLOUR,"#BB6AC4")
	set_trait(TRAIT_PLANT_COLOUR,"#378F2E")
	set_trait(TRAIT_PLANT_ICON,"vine")
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/grapes/green
	name = "greengrapes"
	seed_name = "green grape"
	display_name = "green grapevines"
	mutants = null
	chems = list("nutriment" = list(1,10), "kelotane" = list(3,5), "grapejuice" = list(10,10))
	food_info = list(list(0, 1, "fresh, sweet-sour grapes"), list(10 SECONDS, 1.2, "tender, stewed grape"), list(15 SECONDS, 1, "grape mush"), list(20 SECONDS, 0.9, "unpalatable grapey mush"))

/datum/seed/grapes/green/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"42ed2f")

// Lettuce/varieties.
/datum/seed/lettuce
	name = "lettuce"
	seed_name = "lettuce"
	display_name = "lettuce"
	kitchen_tag = "cabbage"
	chems = list("nutriment" = list(1,15))
	food_info = list(list(0, 1, "leafy greens"), list(15 SECONDS, 1.2, "tender, cooked salad leaves"), list(20 SECONDS, 1, "mushy, unpleasant salad leaves"), list(25 SECONDS, 0.9, "sad dead lettuce"))

/datum/seed/lettuce/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,4)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,6)
	set_trait(TRAIT_POTENCY,8)
	set_trait(TRAIT_PRODUCT_ICON,"lettuce")
	set_trait(TRAIT_PRODUCT_COLOUR,"#A8D0A7")
	set_trait(TRAIT_PLANT_COLOUR,"#6D9C6B")
	set_trait(TRAIT_PLANT_ICON,"vine2")
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_WATER_CONSUMPTION, 8)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.13)

/datum/seed/lettuce/ice
	name = "siflettuce"
	seed_name = "glacial lettuce"
	display_name = "glacial lettuce"
	kitchen_tag = "icelettuce"
	chems = list("nutriment" = list(1,5), "paracetamol" = list(0,2))
	food_info = list(list(0, 1, "crunchy, fresh greens"), list(20 SECONDS, 1.2, "tender, cooked salad leaves"), list(22 SECONDS, 1, "mushy, unpleasant salad leaves"), list(30 SECONDS, 0.9, "sad dead lettuce"))

/datum/seed/lettuce/ice/New()
	..()
	set_trait(TRAIT_ALTER_TEMP, -5)
	set_trait(TRAIT_PRODUCT_COLOUR,"#9ABCC9")

//Wabback / varieties.
/datum/seed/wabback
	name = "whitewabback"
	seed_name = "white wabback"
	seed_noun = "nodes"
	display_name = "white wabback"
	chems = list("nutriment" = list(1,10), "protein" = list(1,5), "enzyme" = list(0,3))
	kitchen_tag = "wabback"
	mutants = list("blackwabback","wildwabback")
	has_item_product = /obj/item/stack/material/cloth
	food_info = list(list(0, 1, "bland plant matter"), list(20 SECONDS, 1.2, "mealy, cooked plant matter"), list(22 SECONDS, 1, "mushy, unpleasant plant matter"), list(30 SECONDS, 0.9, "sad dead plant"))

/datum/seed/wabback/New()
	..()
	set_trait(TRAIT_IDEAL_LIGHT, 5)
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_PRODUCTION,3)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,5)
	set_trait(TRAIT_PRODUCT_ICON,"carrot2")
	set_trait(TRAIT_PRODUCT_COLOUR,"#E6EDFA")
	set_trait(TRAIT_PLANT_ICON,"chute")
	set_trait(TRAIT_PLANT_COLOUR, "#0650ce")
	set_trait(TRAIT_WATER_CONSUMPTION, 10)
	set_trait(TRAIT_ALTER_TEMP, -1)
	set_trait(TRAIT_CARNIVOROUS,1)
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_SPREAD,1)

/datum/seed/wabback/vine
	name = "blackwabback"
	seed_name = "black wabback"
	display_name = "black wabback"
	mutants = null
	chems = list("nutriment" = list(1,3), "protein" = list(1,10), "serotrotium_v" = list(0,1))

/datum/seed/wabback/vine/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"#2E2F32")
	set_trait(TRAIT_CARNIVOROUS,2)

/datum/seed/wabback/wild
	name = "wildwabback"
	seed_name = "wild wabback"
	display_name = "wild wabback"
	mutants = list("whitewabback")
	has_item_product = null
	chems = list("nutriment" = list(1,15), "protein" = list(0,2), "enzyme" = list(0,1))

/datum/seed/wabback/wild/New()
	..()
	set_trait(TRAIT_IDEAL_LIGHT, 3)
	set_trait(TRAIT_WATER_CONSUMPTION, 7)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.1)
	set_trait(TRAIT_YIELD,5)

//Everything else
/datum/seed/peanuts
	name = "peanut"
	seed_name = "peanut"
	display_name = "peanut vines"
	kitchen_tag = "peanut"
	chems = list("nutriment" = list(1,10), "peanutoil" = list(1,3))
	food_info = list(list(0, 1, "fresh peanuts"), list(30 SECONDS, 1.2, "toasted peanuts"), list(60 SECONDS, 1, "roasted peanuts"), list(80 SECONDS, 0.9, "peanuts that have been through a coffee roaster"))

/datum/seed/peanuts/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,6)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"potato")
	set_trait(TRAIT_PRODUCT_COLOUR,"#C4AE7A")
	set_trait(TRAIT_PLANT_ICON,"bush2")
	set_trait(TRAIT_IDEAL_LIGHT, 6)

/datum/seed/vanilla
	name = "vanilla"
	seed_name = "vanilla"
	display_name = "vanilla"
	kitchen_tag = "vanilla"
	chems = list("nutriment" = list(1,10), "vanilla" = list(0,3), "sugar" = list(0, 1))
	food_info = list(list(0, 1, "vanilla pods"), list(15 SECONDS, 1.2, "toasted vanilla pods"), list(25 SECONDS, 1, "roasted vanilla pods"), list(60 SECONDS, 0.9, "vanilla and death"))

/datum/seed/vanilla/New()
	..()
	set_trait(TRAIT_MATURATION,7)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_PRODUCT_ICON,"chili")
	set_trait(TRAIT_PRODUCT_COLOUR,"#B57EDC")
	set_trait(TRAIT_PLANT_COLOUR,"#6B8C5E")
	set_trait(TRAIT_PLANT_ICON,"bush5")
	set_trait(TRAIT_IDEAL_LIGHT, 8)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.3)
	set_trait(TRAIT_WATER_CONSUMPTION, 0.5)

/datum/seed/cabbage
	name = "cabbage"
	seed_name = "cabbage"
	display_name = "cabbages"
	kitchen_tag = "cabbage"
	chems = list("nutriment" = list(1,10))
	food_info = list(list(0, 1, "cabbage leaves"), list(15 SECONDS, 1.2, "tender, cooked cabbage"), list(20 SECONDS, 1, "mushy, unpleasant cabbage leaves"), list(25 SECONDS, 0.9, "cabbage cooked very thoroughly in the heat from a signal flare"))

/datum/seed/cabbage/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,3)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"cabbage")
	set_trait(TRAIT_PRODUCT_COLOUR,"#84BD82")
	set_trait(TRAIT_PLANT_COLOUR,"#6D9C6B")
	set_trait(TRAIT_PLANT_ICON,"vine2")
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/banana
	name = "banana"
	seed_name = "banana"
	display_name = "banana tree"
	kitchen_tag = "banana"
	chems = list("banana" = list(10,10))
	food_info = list(list(0, 1, "banana"), list(15 SECONDS, 1.2, "cooked banana"), list(32 SECONDS, 1, "warm, mushy banana"), list(40 SECONDS, 0.9, "bitter carbonized sludge"))
	trash_type = /obj/item/bananapeel

/datum/seed/banana/New() //this banana for you
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_PRODUCT_ICON,"bananas")
	set_trait(TRAIT_PRODUCT_COLOUR,"#FFEC1F")
	set_trait(TRAIT_PLANT_COLOUR,"#69AD50")
	set_trait(TRAIT_PLANT_ICON,"tree4")
	set_trait(TRAIT_IDEAL_HEAT, 298)
	set_trait(TRAIT_IDEAL_LIGHT, 7)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)

/datum/seed/corn
	name = "corn"
	seed_name = "corn"
	display_name = "ears of corn"
	kitchen_tag = "corn"
	chems = list("nutriment" = list(1,10), "cornoil" = list(1,10))
	trash_type = /obj/item/corncob
	food_info = list(list(0, 1, "sweet corn"), list(10 SECONDS, 1.2, "toasted sweetcorn"), list(20 SECONDS, 1.1, "grilled sweetcorn"), list(40 SECONDS, 0.9, "burnt no-longer-sweet corn"))

/datum/seed/corn/New()
	..()
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,20)
	set_trait(TRAIT_PRODUCT_ICON,"corn")
	set_trait(TRAIT_PRODUCT_COLOUR,"#FFF23B")
	set_trait(TRAIT_PLANT_COLOUR,"#87C969")
	set_trait(TRAIT_PLANT_ICON,"corn")
	set_trait(TRAIT_IDEAL_HEAT, 298)
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)

/datum/seed/potato
	name = "potato"
	seed_name = "potato"
	display_name = "potatoes"
	kitchen_tag = "potato"
	chems = list("nutriment" = list(1,10), "potatojuice" = list(10,10))
	food_info = list(list(0, 1, "raw potato"), list(35 SECONDS, 1.2, "cooked potato and starchy goodness"), list(85 SECONDS, 1.1, "starchy okayness"), list(110 SECONDS, 0.7, "starchy badness"))

/datum/seed/potato/New()
	..()
	set_trait(TRAIT_PRODUCES_POWER,1)
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"potato")
	set_trait(TRAIT_PRODUCT_COLOUR,"#D4CAB4")
	set_trait(TRAIT_PLANT_ICON,"bush2")
	set_trait(TRAIT_WATER_CONSUMPTION, 6)

/datum/seed/onion
	name = "onion"
	seed_name = "onion"
	display_name = "onions"
	kitchen_tag = "onion"
	chems = list("nutriment" = list(1,10))
	food_info = list(list(0, 1, "sharp onion"), list(20 SECONDS, 1.2, "sweet, caramelized onion"), list(30 SECONDS, 0.9, "slightly bitter caramelized onion"), list(40 SECONDS, 0.7, "bitter, mushy onion"))

/datum/seed/onion/New()
	..()
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"onion")
	set_trait(TRAIT_PRODUCT_COLOUR,"#E0C367")
	set_trait(TRAIT_PLANT_ICON,"carrot")
	set_trait(TRAIT_WATER_CONSUMPTION, 6)

/datum/seed/soybean
	name = "soybean"
	seed_name = "soybean"
	display_name = "soybeans"
	kitchen_tag = "soybeans"
	chems = list("nutriment" = list(1,20), "soymilk" = list(10,20))
	food_info = list(list(0, 1, "fresh, grassy soybeans"), list(15 SECONDS, 1.2, "sweet and grassy soybeans with nutty undertones"), list(25 SECONDS, 1, "slightly bitter soybean and grass"), list(40 SECONDS, 0.7, "burnt grass flavoured baby food"))

/datum/seed/soybean/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,4)
	set_trait(TRAIT_PRODUCTION,4)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,5)
	set_trait(TRAIT_PRODUCT_ICON,"bean")
	set_trait(TRAIT_PRODUCT_COLOUR,"#EBE7C0")
	set_trait(TRAIT_PLANT_ICON,"stalk")

/datum/seed/wheat
	name = "wheat"
	seed_name = "wheat"
	display_name = "wheat stalks"
	kitchen_tag = "wheat"
	chems = list("nutriment" = list(1,25), "flour" = list(15,15))
	food_info = list(list(0, 1, "plain wheat"), list(30 SECONDS, 1.2, "toasted wheat"), list(35 SECONDS, 1, "roasted wheat"), list(60 SECONDS, 0.7, "burnt wheat"))

/datum/seed/wheat/New()
	..()
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,5)
	set_trait(TRAIT_PRODUCT_ICON,"wheat")
	set_trait(TRAIT_PRODUCT_COLOUR,"#DBD37D")
	set_trait(TRAIT_PLANT_COLOUR,"#BFAF82")
	set_trait(TRAIT_PLANT_ICON,"stalk2")
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/rice
	name = "rice"
	seed_name = "rice"
	display_name = "rice stalks"
	kitchen_tag = "rice"
	chems = list("nutriment" = list(1,25), "rice" = list(10,15))
	food_info = list(list(0, 0.2, "hard, raw rice"), list(30 SECONDS, 1.2, "light, fluffy rice"), list(45 SECONDS, 1, "mushy, overcooked rice"), list(60 SECONDS, 0.7, "crispy mush and burnt rice"))

/datum/seed/rice/New()
	..()
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,5)
	set_trait(TRAIT_PRODUCT_ICON,"rice")
	set_trait(TRAIT_PRODUCT_COLOUR,"#D5E6D1")
	set_trait(TRAIT_PLANT_COLOUR,"#8ED17D")
	set_trait(TRAIT_PLANT_ICON,"stalk2")
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/carrots
	name = "carrot"
	seed_name = "carrot"
	display_name = "carrots"
	kitchen_tag = "carrot"
	chems = list("nutriment" = list(1,20), "imidazoline" = list(3,5), "carrotjuice" = list(10,20))
	food_info = list(list(0, 1, "fresh, sweet carrot"), list(30 SECONDS, 1.2, "tender, cooked carrot"), list(45 SECONDS, 1.1, "firm roast carrot"), list(60 SECONDS, 0.7, "carrot mush flecked with carbon"))

/datum/seed/carrots/New()
	..()
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"carrot")
	set_trait(TRAIT_PRODUCT_COLOUR,"#FFDB4A")
	set_trait(TRAIT_PLANT_ICON,"carrot")
	set_trait(TRAIT_WATER_CONSUMPTION, 6)

/datum/seed/taro
	name = "taro"
	seed_name = "taro"
	display_name = "taro root"
	kitchen_tag = "taro"
	chems = list("nutriment" = list(1,20), "taropowder" = list(10,20))
	food_info = list(list(0, 1, "sweet potato with hints of nuttiness"), list(30 SECONDS, 1.2, "tender sweet potato with hints of vanilla and nuttiness"), list(45 SECONDS, 1, "mushy sweet potato with hints of nuttiness"), list(60 SECONDS, 0.7, "mushy overcooked potato with hints of burnt nuttiness"))

/datum/seed/taro/New()
	..()
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"carrot")
	set_trait(TRAIT_PRODUCT_COLOUR,"#858070")
	set_trait(TRAIT_PLANT_ICON,"carrot")
	set_trait(TRAIT_WATER_CONSUMPTION, 6)

/datum/seed/coconut
	name = "coconut"
	seed_name = "coconut"
	display_name = "palm tree"
	kitchen_tag = "coconut"
	chems = list("nutriment" = list(1,20), "coconutwater" = list(10,20), "coconutmilk" = list(10,20))
	food_info = list(list(0, 1, "slightly sweet coconut flesh"), list(10 SECONDS, 1.2, "tender, slightly-sweet coconut flesh"), list(25 SECONDS, 1.2, "toasted coconut"), list(40 SECONDS, 0.7, "a wad of burning rubber infused with a hint of coconut"))

/datum/seed/coconut/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_PRODUCT_ICON,"coconut")
	set_trait(TRAIT_PRODUCT_COLOUR,"#814d08")
	set_trait(TRAIT_PLANT_COLOUR,"#69AD50")
	set_trait(TRAIT_PLANT_ICON,"tree4")
	set_trait(TRAIT_IDEAL_HEAT, 298)
	set_trait(TRAIT_IDEAL_LIGHT, 7)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)

/datum/seed/weeds
	name = "weeds"
	seed_name = "weed"
	display_name = "weeds"

/datum/seed/weeds/New()
	..()
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,-1)
	set_trait(TRAIT_POTENCY,-1)
	set_trait(TRAIT_IMMUTABLE,-1)
	set_trait(TRAIT_PRODUCT_ICON,"flower4")
	set_trait(TRAIT_PRODUCT_COLOUR,"#FCEB2B")
	set_trait(TRAIT_PLANT_COLOUR,"#59945A")
	set_trait(TRAIT_PLANT_ICON,"bush6")

/datum/seed/whitebeets
	name = "whitebeet"
	seed_name = "white-beet"
	display_name = "white-beets"
	kitchen_tag = "whitebeet"
	chems = list("nutriment" = list(0,20), "sugar" = list(1,5))
	food_info = list(list(0, 1, "mild, neutral and firm beet"), list(30 SECONDS, 1.2, "tender, slightly-sweet white beet"), list(45 SECONDS, 1, "soft, slightly-sweet white beet"), list(40 SECONDS, 0.7, "squishy, rubbery and bland mush"))

/datum/seed/whitebeets/New()
	..()
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,6)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"carrot2")
	set_trait(TRAIT_PRODUCT_COLOUR,"#EEF5B0")
	set_trait(TRAIT_PLANT_COLOUR,"#4D8F53")
	set_trait(TRAIT_PLANT_ICON,"carrot2")
	set_trait(TRAIT_WATER_CONSUMPTION, 6)

/datum/seed/sugarcane
	name = "sugarcane"
	seed_name = "sugarcane"
	display_name = "sugarcanes"
	kitchen_tag = "sugarcanes"
	chems = list("sugar" = list(4,5))
	food_info = list(list(0, 1, "earthy, fresh sugarcane"), list(20 SECONDS, 1.2, "lightly-roasted sugarcane and sweetness"), list(30 SECONDS, 1, "slightly-burnt sugarcane"), list(45 SECONDS, 0.7, "tough, inedible plant matter mixed with bitterness and sweetness"))

/datum/seed/sugarcane/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,3)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"stalk")
	set_trait(TRAIT_PRODUCT_COLOUR,"#B4D6BD")
	set_trait(TRAIT_PLANT_COLOUR,"#6BBD68")
	set_trait(TRAIT_PLANT_ICON,"stalk3")
	set_trait(TRAIT_IDEAL_HEAT, 298)

/datum/seed/rhubarb
	name = "rhubarb"
	seed_name = "rhubarb"
	display_name = "rhubarb"
	kitchen_tag = "rhubarb"
	chems = list("nutriment" = list(1,15))
	food_info = list(list(0, 1, "crunchy and lip-puckeringly tart rhubarb"), list(35 SECONDS, 1.2, "soft, tender and very tart rhubarb"), list(55 SECONDS, 0.9, "mushy and sour rhubarb"), list(110 SECONDS, 0.7, "extremely sour baby food"))

/datum/seed/rhubarb/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,3)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_POTENCY,6)
	set_trait(TRAIT_PRODUCT_ICON,"stalk")
	set_trait(TRAIT_PRODUCT_COLOUR,"#FD5656")
	set_trait(TRAIT_PLANT_ICON,"stalk3")

/datum/seed/celery
	name = "celery"
	seed_name = "celery"
	display_name = "celery"
	kitchen_tag = "celery"
	chems = list("nutriment" = list(5,20))
	food_info = list(list(0, 1, "crunchy and fresh celery"), list(10 SECONDS, 1, "soft, tender celery"), list(20 SECONDS, 1, "mushy celery"), list(30 SECONDS, 0.7, "bland green mush that might've been a plant at some point"))

/datum/seed/celery/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,4)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,8)
	set_trait(TRAIT_PRODUCT_ICON,"stalk")
	set_trait(TRAIT_PRODUCT_COLOUR,"#56FD56")
	set_trait(TRAIT_PLANT_ICON,"stalk3")

/datum/seed/spineapple
	name = "spineapple"
	seed_name = "spineapple"
	display_name = "spineapple"
	kitchen_tag = "spineapple"
	chems = list("nutriment" = list(3,5), "enzyme" = list(3,5), "pineapplejuice" = list(15, 20))
	food_info = list(list(0, 1, "fresh pineapple"), list(15 SECONDS, 1.2, "sweet cooked pineapple with a hint of sourness"), list(20 SECONDS, 1, "mushy cooked pineapple"), list(30 SECONDS, 0.7, "a pineapple-flavoured sludgey mass"))

/datum/seed/spineapple/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,1)
	set_trait(TRAIT_POTENCY,13)
	set_trait(TRAIT_PRODUCT_ICON,"pineapple")
	set_trait(TRAIT_PRODUCT_COLOUR,"#FFF23B")
	set_trait(TRAIT_PLANT_COLOUR,"#87C969")
	set_trait(TRAIT_PLANT_ICON,"corn")
	set_trait(TRAIT_IDEAL_HEAT, 298)
	set_trait(TRAIT_IDEAL_LIGHT, 4)
	set_trait(TRAIT_WATER_CONSUMPTION, 8)
	set_trait(TRAIT_STINGS,1)

/datum/seed/peas
	name = "peas"
	seed_name = "peas"
	display_name = "loose peas"
	kitchen_tag = "peas"
	chems = list("nutriment" = list(1,10))
	food_info = list(list(0, 1, "fresh, sweet peas"), list(20 SECONDS, 1.2, "tender, cooked peas"), list(30 SECONDS, 0.9, "overcooked peas"), list(50 SECONDS, 0.7, "firm little balls of sadness"))

/datum/seed/peas/New()
	..()
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,20)
	set_trait(TRAIT_PRODUCT_ICON,"berry")
	set_trait(TRAIT_PRODUCT_COLOUR,"#0e9415")
	set_trait(TRAIT_PLANT_COLOUR,"#87C969")
	set_trait(TRAIT_PLANT_ICON,"bush")
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)

/datum/seed/durian
	name = "durian"
	seed_name = "durian"
	seed_noun = "pits"
	display_name = "durian"
	kitchen_tag = "durian"
	chems = list("nutriment" = list(1,5), "durianpaste" = list(1, 20))
	food_info = list(list(0, 1, "fresh custard-like fruit flavoured heavily with almond, with occasional notes of sherry"), list(20 SECONDS, 1.2, "a rich almond custard with notes of caramelized onion, sherry and cream cheese"), list(30 SECONDS, 0.9, "durian mush"), list(50 SECONDS, 0.7, "durian-flavoured dead mush"))

/datum/seed/durian/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"spinefruit")
	set_trait(TRAIT_PRODUCT_COLOUR,"#757631")
	set_trait(TRAIT_PLANT_COLOUR,"#87C969")
	set_trait(TRAIT_PLANT_ICON,"tree")
	set_trait(TRAIT_IDEAL_LIGHT, 8)
	set_trait(TRAIT_WATER_CONSUMPTION, 8)

/datum/seed/watermelon
	name = "watermelon"
	seed_name = "watermelon"
	display_name = "watermelon vine"
	kitchen_tag = "watermelon"
	chems = list("nutriment" = list(1,6), "watermelonjuice" = list(10,6))
	food_info = list(list(0, 1, "fresh, crispy and sweet watermelon"), list(15 SECONDS, 1.2, "tender, cooked watermelon"), list(25 SECONDS, 0.9, "rubbery-mushy watermelon"), list(30 SECONDS, 0.7, "rubbery-mushy watermelon lacking any sort of flavour"))

/datum/seed/watermelon/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_JUICY,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,1)
	set_trait(TRAIT_PRODUCT_ICON,"vine")
	set_trait(TRAIT_PRODUCT_COLOUR,"#3D8C3A")
	set_trait(TRAIT_PLANT_COLOUR,"#257522")
	set_trait(TRAIT_PLANT_ICON,"vine2")
	set_trait(TRAIT_FLESH_COLOUR,"#F22C2C")
	set_trait(TRAIT_IDEAL_HEAT, 298)
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)

/datum/seed/pumpkin
	name = "pumpkin"
	seed_name = "pumpkin"
	display_name = "pumpkin vine"
	kitchen_tag = "pumpkin"
	chems = list("nutriment" = list(1,6))
	food_info = list(list(0, 1, "fresh, firm pumpkin"), list(25 SECONDS, 1.2, "tender, sweet and slightly nutty pumpkin"), list(35 SECONDS, 0.9, "mushy, sad pumpkin"), list(30 SECONDS, 0.7, "a bitter, dead mush with notes of sweetness"))

/datum/seed/pumpkin/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"vine2")
	set_trait(TRAIT_PRODUCT_COLOUR,"#DBAC02")
	set_trait(TRAIT_PLANT_COLOUR,"#21661E")
	set_trait(TRAIT_PLANT_ICON,"vine2")
	set_trait(TRAIT_WATER_CONSUMPTION, 6)

/datum/seed/citrus
	name = "lime"
	seed_name = "lime"
	display_name = "lime trees"
	kitchen_tag = "lime"
	chems = list("nutriment" = list(1,20), "limejuice" = list(10,20))
	food_info = list(list(0, 1, "sweet, fresh lime"), list(30 SECONDS, 1.2, "tender stewed limes, still sweet and slightly sour"), list(40 SECONDS, 1, "stewed limes with little to no sweetness remaining"), list(60 SECONDS, 0.7, "what might have been a lime, once, before its incineration"))

/datum/seed/citrus/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_JUICY,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,15)
	set_trait(TRAIT_PRODUCT_ICON,"treefruit")
	set_trait(TRAIT_PRODUCT_COLOUR,"#3AF026")
	set_trait(TRAIT_PLANT_ICON,"tree")
	set_trait(TRAIT_FLESH_COLOUR,"#3AF026")

/datum/seed/citrus/lemon
	name = "lemon"
	seed_name = "lemon"
	display_name = "lemon trees"
	kitchen_tag = "lemon"
	chems = list("nutriment" = list(1,20), "lemonjuice" = list(10,20))
	food_info = list(list(0, 1, "fresh, sour lemon"), list(30 SECONDS, 1.2, "tender stewed lemon, still sour with sweet hints"), list(40 SECONDS, 1, "stewed, mildly sour lemon"), list(60 SECONDS, 0.7, "a lemon desecrated through a chef's neglect and carelessness"))

/datum/seed/citrus/lemon/New()
	..()
	set_trait(TRAIT_PRODUCES_POWER,1)
	set_trait(TRAIT_PRODUCT_ICON,"lemon")
	set_trait(TRAIT_PRODUCT_COLOUR,"#F0E226")
	set_trait(TRAIT_FLESH_COLOUR,"#F0E226")
	set_trait(TRAIT_IDEAL_LIGHT, 6)

/datum/seed/citrus/orange
	name = "orange"
	seed_name = "orange"
	display_name = "orange trees"
	kitchen_tag = "orange"
	chems = list("nutriment" = list(1,20), "orangejuice" = list(10,20))
	food_info = list(list(0, 1, "fresh, tasty orange"), list(30 SECONDS, 1.2, "tender stewed orange, mostly sweet"), list(40 SECONDS, 1, "stewed, mildly orange-y orange"), list(60 SECONDS, 0.7, "overcooked orange sludge"))

/datum/seed/citrus/orange/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"#FFC20A")
	set_trait(TRAIT_FLESH_COLOUR,"#FFC20A")

/datum/seed/grass
	name = "grass"
	seed_name = "grass"
	display_name = "grass"
	kitchen_tag = "grass"
	mutants = "carpet"
	chems = list("nutriment" = list(1,20))
	food_info = list(list(0, 1, "grass"), list(30 SECONDS, 1, "tender grass"), list(40 SECONDS, 0.9, "cooked grass"), list(60 SECONDS, 0.7, "overcooked grass"))

/datum/seed/grass/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,2)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_PRODUCT_ICON,"grass")
	set_trait(TRAIT_PRODUCT_COLOUR,"#09FF00")
	set_trait(TRAIT_PLANT_COLOUR,"#07D900")
	set_trait(TRAIT_PLANT_ICON,"grass")
	set_trait(TRAIT_WATER_CONSUMPTION, 0.5)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/grass/carpet
	name = "carpet"
	seed_name = "carpet"
	display_name = "carpet"
	kitchen_tag = "carpet"
	mutants = null
	chems = list("liquidcarpet" = list(5,10))
	food_info = list(list(0, 1, "carpet"), list(30 SECONDS, 1, "carpet that's been heated on the stove"), list(40 SECONDS, 0.9, "oven-roasted carpety goodness"), list(60 SECONDS, 0.7, "carpet that's been blowtorched"))

/datum/seed/grass/carpet/New()
	..()
	set_trait(TRAIT_YIELD,7)
	set_trait(TRAIT_PRODUCT_ICON,"grass")
	set_trait(TRAIT_PRODUCT_COLOUR,"#9e2500")
	set_trait(TRAIT_PLANT_COLOUR,"#ee4401")
	set_trait(TRAIT_PLANT_ICON,"grass")

/datum/seed/cocoa
	name = "cocoa"
	seed_name = "cacao"
	display_name = "cacao tree"
	kitchen_tag = "cocoa"
	chems = list("nutriment" = list(1,10), "coco" = list(4,5))
	food_info = list(list(0, 1, "bitter cocoa pods"), list(25 SECONDS, 1, "tender, not-as-bitter cocoa pods"), list(40 SECONDS, 1.1, "roasted cocoa beans"), list(60 SECONDS, 0.7, "a mix of burnt cocoa beans in cocoapod sludge, flecked with specks of burnt plant matter"))

/datum/seed/cocoa/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"treefruit")
	set_trait(TRAIT_PRODUCT_COLOUR,"#CCA935")
	set_trait(TRAIT_PLANT_ICON,"tree2")
	set_trait(TRAIT_IDEAL_HEAT, 298)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)

/datum/seed/cherries
	name = "cherry"
	seed_name = "cherry"
	seed_noun = "pits"
	display_name = "cherry tree"
	kitchen_tag = "cherries"
	chems = list("nutriment" = list(1,15), "sugar" = list(1,15), "cherryjelly" = list(10,15))
	food_info = list(list(0, 1, "fresh, tasty cherries"), list(25 SECONDS, 1.2, "stewed cherries"), list(35 SECONDS, 1, "cherry sludge"), list(60 SECONDS, 0.7, "overcooked cherry sludge"))

/datum/seed/cherries/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_JUICY,1)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"cherry")
	set_trait(TRAIT_PRODUCT_COLOUR,"#A80000")
	set_trait(TRAIT_PLANT_ICON,"tree2")
	set_trait(TRAIT_PLANT_COLOUR,"#2F7D2D")

/datum/seed/tobacco
	name = "tobacco"
	seed_name = "tobacco"
	display_name = "tobacco"
	kitchen_tag = "tobacco"
	chems = list("nicotine" = list(5,10))
	food_info = list(list(0, 1, "fresh tobacco"), list(30 SECONDS, 1, "wilting tobacco"), list(40 SECONDS, 1, "drying tobacco"), list(60 SECONDS, 1, "dried tobacco"))

/datum/seed/tobacco/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,2)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"nettles")
	set_trait(TRAIT_PRODUCT_COLOUR,"#3b2008")
	set_trait(TRAIT_PLANT_COLOUR,"#124b04")
	set_trait(TRAIT_PLANT_ICON,"bush2")

/datum/seed/kudzu
	name = "kudzu"
	seed_name = "kudzu"
	display_name = "kudzu vines"
	kitchen_tag = "kudzu"
	chems = list("nutriment" = list(1,50), "anti_toxin" = list(1,25))
	food_info = list(list(0, 1, "slightly bland spinach"), list(30 SECONDS, 1.2, "cooked, slightly bland spinach"), list(40 SECONDS, 1, "wilting bland spinach"), list(60 SECONDS, 1, "a bland spinachy sludge"))

/datum/seed/kudzu/New()
	..()
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_SPREAD,2)
	set_trait(TRAIT_PRODUCT_ICON,"treefruit")
	set_trait(TRAIT_PRODUCT_COLOUR,"#96D278")
	set_trait(TRAIT_PLANT_COLOUR,"#6F7A63")
	set_trait(TRAIT_PLANT_ICON,"vine2")
	set_trait(TRAIT_WATER_CONSUMPTION, 0.5)

/datum/seed/diona
	name = "diona"
	seed_name = "diona"
	seed_noun = "nodes"
	display_name = "replicant pods"
	can_self_harvest = 1
	apply_color_to_mob = FALSE
	has_mob_product = /mob/living/carbon/alien/diona

/datum/seed/diona/New()
	..()
	set_trait(TRAIT_IMMUTABLE,1)
	set_trait(TRAIT_ENDURANCE,8)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,10)
	set_trait(TRAIT_YIELD,1)
	set_trait(TRAIT_POTENCY,30)
	set_trait(TRAIT_PRODUCT_ICON,"diona")
	set_trait(TRAIT_PRODUCT_COLOUR,"#799957")
	set_trait(TRAIT_PLANT_COLOUR,"#66804B")
	set_trait(TRAIT_PLANT_ICON,"alien4")

/datum/seed/shand
	name = "shand"
	seed_name = "Selem's hand"
	display_name = "Selem's hand leaves"
	kitchen_tag = "shand"
	chems = list("bicaridine" = list(0,10))

/datum/seed/shand/New()
	..()
	set_trait(TRAIT_MATURATION,3)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"alien3")
	set_trait(TRAIT_PRODUCT_COLOUR,"#378C61")
	set_trait(TRAIT_PLANT_COLOUR,"#378C61")
	set_trait(TRAIT_PLANT_ICON,"tree5")
	set_trait(TRAIT_IDEAL_HEAT, 283)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/mtear
	name = "mtear"
	seed_name = "Malani's tear"
	display_name = "Malani's tear leaves"
	kitchen_tag = "mtear"
	chems = list("honey" = list(1,10), "kelotane" = list(3,5))

/datum/seed/mtear/New()
	..()
	set_trait(TRAIT_MATURATION,3)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"alien4")
	set_trait(TRAIT_PRODUCT_COLOUR,"#4CC5C7")
	set_trait(TRAIT_PLANT_COLOUR,"#4CC789")
	set_trait(TRAIT_PLANT_ICON,"bush7")
	set_trait(TRAIT_IDEAL_HEAT, 283)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/telriis
	name = "telriis"
	seed_name = "telriis"
	display_name = "telriis grass"
	kitchen_tag = "telriis"
	chems = list("pwine" = list(1,5), "nutriment" = list(1,6))

/datum/seed/telriis/New()
	..()
	set_trait(TRAIT_PLANT_ICON,"ambrosia")
	set_trait(TRAIT_PRODUCT_ICON,"ambrosia")
	set_trait(TRAIT_ENDURANCE,50)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,5)

/datum/seed/thaadra
	name = "thaadra"
	seed_name = "thaa'dra"
	display_name = "thaa'dra lichen"
	kitchen_tag = "thaadra"
	chems = list("frostoil" = list(1,5),"nutriment" = list(1,5))

/datum/seed/thaadra/New()
	..()
	set_trait(TRAIT_PLANT_ICON,"grass")
	set_trait(TRAIT_PLANT_COLOUR,"#ABC7D2")
	set_trait(TRAIT_ENDURANCE,10)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,9)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,5)

/datum/seed/jurlmah
	name = "jurlmah"
	seed_name = "jurl'mah"
	display_name = "jurl'mah reeds"
	kitchen_tag = "jurlmah"
	chems = list("serotrotium" = list(1,5),"nutriment" = list(1,5))

/datum/seed/jurlmah/New()
	..()
	set_trait(TRAIT_PLANT_ICON,"mushroom9")
	set_trait(TRAIT_ENDURANCE,12)
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_PRODUCTION,9)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,10)

/datum/seed/amauri
	name = "amauri"
	seed_name = "amauri"
	display_name = "amauri plant"
	kitchen_tag = "amauri"
	chems = list("zombiepowder" = list(1,10),"condensedcapsaicin" = list(1,5),"nutriment" = list(1,5))

/datum/seed/amauri/New()
	..()
	set_trait(TRAIT_PLANT_ICON,"bush4")
	set_trait(TRAIT_ENDURANCE,10)
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_PRODUCTION,9)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)

/datum/seed/gelthi
	name = "gelthi"
	seed_name = "gelthi"
	display_name = "gelthi plant"
	kitchen_tag = "gelthi"
	chems = list("stoxin" = list(1,5),"capsaicin" = list(1,5),"nutriment" = list(1,5))

/datum/seed/gelthi/New()
	..()
	set_trait(TRAIT_PLANT_ICON,"mushroom3")
	set_trait(TRAIT_ENDURANCE,15)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,1)

/datum/seed/vale
	name = "vale"
	seed_name = "vale"
	display_name = "vale bush"
	kitchen_tag = "vale"
	chems = list("paracetamol" = list(1,5),"dexalin" = list(1,2),"nutriment"= list(1,5))

/datum/seed/vale/New()
	..()
	set_trait(TRAIT_PLANT_ICON,"flower4")
	set_trait(TRAIT_ENDURANCE,15)
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_PRODUCTION,10)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,3)

/datum/seed/surik
	name = "surik"
	seed_name = "surik"
	display_name = "surik vine"
	kitchen_tag = "surik"
	chems = list("impedrezene" = list(1,3),"synaptizine" = list(1,2),"nutriment" = list(1,5))

/datum/seed/surik/New()
	..()
	set_trait(TRAIT_PLANT_ICON,"bush6")
	set_trait(TRAIT_ENDURANCE,18)
	set_trait(TRAIT_MATURATION,7)
	set_trait(TRAIT_PRODUCTION,7)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,3)

// Alien weeds.
/datum/seed/xenomorph
	name = "xenomorph"
	seed_name = "alien weed"
	display_name = "alien weeds"
	force_layer = 3
	chems = list(MAT_PHORON = list(1,3))

/datum/seed/xenomorph/New()
	..()
	set_trait(TRAIT_PLANT_ICON,"vine2")
	set_trait(TRAIT_IMMUTABLE,1)
	set_trait(TRAIT_PRODUCT_COLOUR,"#3D1934")
	set_trait(TRAIT_FLESH_COLOUR,"#3D1934")
	set_trait(TRAIT_PLANT_COLOUR,"#3D1934")
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,-1)
	set_trait(TRAIT_SPREAD,2)
	set_trait(TRAIT_POTENCY,50)

// Disho.
/datum/seed/disho
	name = "disho"
	seed_name = "disho"
	display_name = "disho root"
	kitchen_tag = "disho"
	chems = list("capsaicin" = list(1,3), "nutriment" = list(5,25))
	mutants = list("brickdisho, thatchdisho")
	catalog_data_grown = list(/datum/category_item/catalogue/flora/disho)

/datum/seed/disho/New()
	..()
	set_trait(TRAIT_TOXINS_TOLERANCE,     6)
	set_trait(TRAIT_PEST_TOLERANCE,       10)
	set_trait(TRAIT_WEED_TOLERANCE,       7)
	set_trait(TRAIT_MATURATION,4)
	set_trait(TRAIT_PRODUCTION,4)
	set_trait(TRAIT_YIELD,6)
	set_trait(TRAIT_POTENCY,30)
	set_trait(TRAIT_PRODUCT_ICON,"disho")
	set_trait(TRAIT_PRODUCT_COLOUR,"#514147")
	set_trait(TRAIT_PLANT_ICON,"carrot")
	set_trait(TRAIT_PLANT_COLOUR, "#514147")
	set_trait(TRAIT_PLANT_ICON,"carrot")
	set_trait(TRAIT_IDEAL_HEAT, 298)
	set_trait(TRAIT_IDEAL_LIGHT, 10)


/datum/category_item/catalogue/flora/disho
	name = "Flora - Disho"
	desc = "A hardy root plant native to the desert world of Osmon. \
	Remarkably resistant to pests, weeds and adverse enviromental conditions make it a relatively common crop on most hot worlds. \
	However, it requires high temperatures and strong lighting to grow, and as such is not as common in temperature-controlled or cold environments. . \
	Mutated varieties include the medicinal variety \"Thatch\", used to make healing poultices, and the variety \"Brick\", used to treat radiation burns."
	value = CATALOGUER_REWARD_TRIVIAL


/datum/seed/disho/brick
	name = "brickdisho"
	seed_name = "brick disho"
	display_name = "brick disho root"
	kitchen_tag = "brickdisho"
	chems = list("ethanol" = list(1,2), "nutriment" = list(1,5), "cleansalaze" = list (5,15))

/datum/seed/disho/brick/New()
	..()
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_PRODUCTION,2)
	set_trait(TRAIT_YIELD,7)
	set_trait(TRAIT_POTENCY,45)
	set_trait(TRAIT_PRODUCT_ICON,"disho")
	set_trait(TRAIT_PRODUCT_COLOUR,"#514147")
	set_trait(TRAIT_PLANT_ICON,"carrot")
	set_trait(TRAIT_PLANT_COLOUR, "#514147")
	set_trait(TRAIT_PLANT_ICON,"carrot")
	set_trait(TRAIT_IDEAL_HEAT, 334)
	set_trait(TRAIT_IDEAL_LIGHT, 10)


/datum/seed/disho/thatch
	name = "thatchdisho"
	seed_name = "thatch disho"
	display_name = "thatch disho root"
	kitchen_tag = "thatchdisho"
	chems = list("ethanol" = list(1,2), "kelotalaze" = list(5,10), "bicarilaze" = list (5,10))

/datum/seed/disho/thatch/New()
	..()
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_PRODUCTION,2)
	set_trait(TRAIT_YIELD,7)
	set_trait(TRAIT_POTENCY,45)
	set_trait(TRAIT_PRODUCT_ICON,"disho")
	set_trait(TRAIT_PRODUCT_COLOUR,"#DBD37D")
	set_trait(TRAIT_PLANT_ICON,"carrot")
	set_trait(TRAIT_PLANT_COLOUR, "#BFAF82")
	set_trait(TRAIT_PLANT_ICON,"carrot")
	set_trait(TRAIT_IDEAL_HEAT, 334)
	set_trait(TRAIT_IDEAL_LIGHT, 10)

//Ashlander Plants
/datum/seed/flower/pyrrhlea
	name = "pyrrhlea"
	seed_name = "pyrrhlea"
	display_name = "pyrrhlea"
	kitchen_tag = "pyrrhlea"
	chems = list("nutriment" = list(1,5), "kelotane" = list(1,10), "inaprovaline" = list(1,10))

/datum/seed/flower/pyrrhlea/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,2)
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_PRODUCTION,3)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_PRODUCT_ICON,"flowers")
	set_trait(TRAIT_PRODUCT_COLOUR,"#f0d74c")
	set_trait(TRAIT_PLANT_COLOUR,"#75581a")
	set_trait(TRAIT_PLANT_ICON,"bush6")
	set_trait(TRAIT_IDEAL_LIGHT, 1)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.1)
	set_trait(TRAIT_WATER_CONSUMPTION, 0.1)

/datum/seed/bentars
	name = "bentars"
	seed_name = "bentar"
	display_name = "bentars"
	kitchen_tag = "bentars"
	chems = list("sugar" = list(1,5), "anti_toxin" = list(1,10))

/datum/seed/bentars/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,2)
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_PRODUCTION,3)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"bean")
	set_trait(TRAIT_PRODUCT_COLOUR,"#9d23aa")
	set_trait(TRAIT_PLANT_COLOUR,"#53391b")
	set_trait(TRAIT_PLANT_ICON,"bush5")
	set_trait(TRAIT_IDEAL_LIGHT, 1)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.1)
	set_trait(TRAIT_WATER_CONSUMPTION, 0.1)

/datum/seed/juhtak
	name = "juhtak"
	seed_name = "juhtak"
	display_name = "juhtak"
	kitchen_tag = "juhtak"
	chems = list("nutriment" = list(1,5), "bicaridine" = list(1,10))

/datum/seed/juhtak/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,2)
	set_trait(TRAIT_MATURATION,15)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,6)
	set_trait(TRAIT_PRODUCT_ICON,"vine")
	set_trait(TRAIT_PRODUCT_COLOUR,"#7c260c")
	set_trait(TRAIT_PLANT_COLOUR,"#684f32")
	set_trait(TRAIT_PLANT_ICON,"bush7")
	set_trait(TRAIT_IDEAL_LIGHT, 1)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.1)
	set_trait(TRAIT_WATER_CONSUMPTION, 0.1)

/datum/seed/cersut
	name = "cersut"
	seed_name = "cersut"
	display_name = "cersut"
	kitchen_tag = "cersut"
	chems = list("sacid" = list(5,10))

/datum/seed/cersut/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,2)
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_PRODUCTION,4)
	set_trait(TRAIT_YIELD,6)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"leafy")
	set_trait(TRAIT_PRODUCT_COLOUR,"#e0f569")
	set_trait(TRAIT_PLANT_COLOUR,"#42222a")
	set_trait(TRAIT_PLANT_ICON,"vine2")
	set_trait(TRAIT_IDEAL_LIGHT, 1)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.1)
	set_trait(TRAIT_WATER_CONSUMPTION, 0.1)

/datum/seed/shimash
	name = "shimash"
	seed_name = "shimash"
	display_name = "shimash"
	kitchen_tag = "shimash"
	chems = list("tramadol" = list(5,10))

/datum/seed/shimash/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,4)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,6)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"spinefruit")
	set_trait(TRAIT_PRODUCT_COLOUR,"#304730")
	set_trait(TRAIT_PLANT_COLOUR,"#580505")
	set_trait(TRAIT_PLANT_ICON,"bush2")
	set_trait(TRAIT_IDEAL_LIGHT, 1)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.1)
	set_trait(TRAIT_WATER_CONSUMPTION, 0.1)

/datum/seed/pokalea
	name = "pokalea"
	seed_name = "pokalea"
	display_name = "pokalea"
	kitchen_tag = "pokalea"
	chems = list("nicotine" = list(5,10), "leporazine" = list(5,10))

/datum/seed/pokalea/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,4)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,6)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"pod")
	set_trait(TRAIT_PRODUCT_COLOUR,"#684c34")
	set_trait(TRAIT_PLANT_COLOUR,"#9aa07c")
	set_trait(TRAIT_PLANT_ICON,"tree")
	set_trait(TRAIT_IDEAL_LIGHT, 1)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.1)
	set_trait(TRAIT_WATER_CONSUMPTION, 0.1)
